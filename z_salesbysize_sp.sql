-- DROP FUNCTION adempiere.z_salesbysize_sp(int4, int4, int4, int4);

CREATE OR REPLACE FUNCTION adempiere.z_salesbysize_sp(clientx integer, orgx integer, periodex integer, orgtypeidx integer)
 RETURNS TABLE(qtyekor numeric, qtykg numeric, abw numeric, gross numeric, discamt numeric, netamt numeric, pctkg numeric, avgprice numeric)
 LANGUAGE plpgsql
AS $function$
DECLARE 
	counter 				NUMERIC;
	rec_datapims 		RECORD;
	typeorgval			varchar;
   startdateperiod	DATE;
  	orgtype				varchar;
	qtykgall				NUMERIC;

BEGIN 
		-- Function untuk SP Report Sales By Size Created by : Linda 07 Sep 2022
		-- UPDATED BY : Linda 05 Jun 2023 RM#10518
		-- UPDATED BY : Albert 22 Jan 2025 RM#14673
		SET SCHEMA 'adempiere';
	
		SELECT aot.name INTO typeorgval
		FROM adempiere.ad_orginfo aoin 
		INNER JOIN adempiere.ad_orgtype aot ON aoin.ad_orgtype_id = aot.ad_orgtype_id 
		WHERE aoin.ad_client_id = clientx
		AND aoin.ad_org_id = orgx;	
	
	 	SELECT aot.name INTO orgtype
		FROM adempiere.ad_orgtype aot 
		WHERE aot.ad_client_id = clientx
		AND aot.ad_orgtype_id = orgtypeidx;	
	
		SELECT cp.startdate INTO startdateperiod FROM adempiere.c_period cp WHERE cp.c_period_id = periodex;
	
		SELECT SUM(zdp.realqtykg) INTO qtykgall
		FROM adempiere.z_data_pims zdp
		WHERE zdp.clientid = clientx
		AND (CASE WHEN typeorgval LIKE 'PT'
					 THEN zdp.orginvid = orgx
					 ELSE zdp.orgsppaid = orgx
			  END)
		AND zdp.docstatussppa = 'CO'
		AND zdp.c_period_id = periodex
      AND (CASE WHEN (orgtype IS NOT NULL AND orgtype NOT LIKE 'PT')
					 THEN zdp.orgtypesppaid = orgtypeidx
					 ELSE 1 = 1
			  END);	
	
		DROP TABLE IF EXISTS pims ;
		CREATE TEMPORARY TABLE pims 
		AS (SELECT 
			zdp.clientid,
			zdp.orginvid,
			zdp.orgsppaid,
			zdp.nosppa,
			zdp.c_period_id,
			zdp.orgtypesppaid,
			SUM(zdp.realqtyekor) AS qtyekor,
			SUM(zdp.realqtykg) AS qtykg,
			SUM(zdp.gross) AS gross,
			SUM(zdp.discountamt) AS discamt,
			SUM(zdp.grandtotal) AS netamt,
			ci.z_cndn_type AS cndntype
			FROM adempiere.z_data_pims zdp 
			INNER JOIN adempiere.c_bpartner cb ON zdp.c_bpartner_id = cb.c_bpartner_id 
			INNER JOIN adempiere.c_bp_group cbg ON cb.c_bp_group_id = cbg.c_bp_group_id 
			LEFT JOIN adempiere.c_invoice ci ON ci.documentno = zdp.noinvcndnkorek AND ci.ad_client_id = zdp.clientid
			WHERE zdp.clientid = clientx
		   AND (CASE WHEN typeorgval LIKE 'PT'
						 THEN zdp.orginvid = orgx
						 ELSE zdp.orgsppaid = orgx
				  END)
		   AND zdp.c_period_id = periodex
		   AND zdp.docstatussppa = 'CO'
		   AND UPPER(cbg.name) NOT LIKE '%RPHU%'
			GROUP BY zdp.clientid, zdp.orginvid, zdp.orgsppaid, zdp.c_period_id, zdp.nosppa, zdp.orgtypesppaid, ci.z_cndn_type);
		
		DROP TABLE IF EXISTS pimslast ;
		CREATE TEMPORARY TABLE pimslast 
		AS (SELECT 
			zdp.clientid,
			zdp.orginvid,
			zdp.orgsppaid,
			zdp.nosppa,
			zdp.c_period_id,
			zdp.orgtypesppaid,
			SUM(zdp.realqtyekor) AS qtyekor,
			SUM(zdp.realqtykg) AS qtykg,
			SUM(zdp.gross) AS gross,
			SUM(zdp.discountamt) AS discamt,
			SUM(zdp.grandtotal) AS netamt
			FROM adempiere.z_data_pims zdp 
			INNER JOIN adempiere.c_bpartner cb ON zdp.c_bpartner_id = cb.c_bpartner_id 
			INNER JOIN adempiere.c_bp_group cbg ON cb.c_bp_group_id = cbg.c_bp_group_id 
			INNER JOIN adempiere.c_period cp ON zdp.c_period_id = cp.c_period_id 
			WHERE zdp.clientid = clientx
		   AND (CASE WHEN typeorgval LIKE 'PT'
						 THEN zdp.orginvid = orgx
						 ELSE zdp.orgsppaid = orgx
				  END)
		   AND cp.startdate < startdateperiod
		   AND zdp.docstatussppa = 'CO'
		   AND UPPER(cbg.name) NOT LIKE '%RPHU%'
			GROUP BY zdp.clientid, zdp.orginvid, zdp.orgsppaid, zdp.c_period_id, zdp.nosppa, zdp.orgtypesppaid);		
		
		DROP TABLE IF EXISTS pimsdata ;
		CREATE TEMPORARY TABLE pimsdata 
		AS (SELECT
			pims.clientid,
			pims.orginvid,
			pims.orgsppaid,
			pims.nosppa,
			pims.c_period_id,
			COALESCE(pims.qtyekor,0) AS qtyekor,
			COALESCE(pims.qtykg,0) AS qtykg,
			(CASE WHEN pims.cndntype = 'BLB' 
					THEN COALESCE(pims.qtyekor,0)
					ELSE (COALESCE(pims.qtyekor,0) + COALESCE(pimslast.qtyekor,0))
			END) AS qtyekorabw,
			(CASE WHEN pims.cndntype = 'BLB' 
					THEN COALESCE(pims.qtykg,0)
					ELSE (COALESCE(pims.qtykg,0) + COALESCE(pimslast.qtykg,0))
			END) AS qtykgabw,
			pims.gross,
			pims.discamt,
			pims.netamt,
			pims.orgtypesppaid
			FROM pims
			LEFT JOIN pimslast ON pims.nosppa = pimslast.nosppa);			
	
		FOR counter IN 1 .. 24
		LOOP  
		qtyekor 	:= 0;
		qtykg 	:= 0;
--		abw 		:= 0;
		gross		:= 0;
		discamt 	:= 0;
		netamt 	:= 0;
 		pctkg 	:= 0;
 		avgprice :=	0;	
 			FOR rec_datapims IN (SELECT SUM(datatbl.qtyekor) AS qtyekor,
										SUM(datatbl.qtykg) AS qtykg,
										SUM(datatbl.gross) AS gross,
										SUM(datatbl.discamt) AS discamt,
										SUM(datatbl.netamt) AS netamt
 										FROM (SELECT
												pimsdata.clientid,
												pimsdata.orginvid,
												pimsdata.orgsppaid,
												pimsdata.nosppa,
												pimsdata.c_period_id,
												SUM(pimsdata.qtyekor) AS qtyekor,
												SUM(pimsdata.qtykg) AS qtykg,
												(CASE WHEN SUM(pimsdata.qtyekorabw) = 0 
														THEN 0
														ELSE (SUM(pimsdata.qtykgabw) / SUM(pimsdata.qtyekorabw))
												END) AS realabw,
												SUM(pimsdata.gross) AS gross,
												SUM(pimsdata.discamt) AS discamt,
												SUM(pimsdata.netamt) AS netamt,
												pimsdata.orgtypesppaid
												FROM pimsdata
												GROUP BY pimsdata.clientid, pimsdata.orginvid, pimsdata.orgsppaid, pimsdata.nosppa, pimsdata.c_period_id, pimsdata.orgtypesppaid) AS datatbl
										WHERE (CASE WHEN (counter = 1) 
													THEN ROUND(datatbl.realabw,2) < 0.8
                                     WHEN (counter = 2) 
                                     	THEN ROUND(datatbl.realabw,2) >= 0.8 AND ROUND(datatbl.realabw,2) < 0.9
                                     WHEN (counter = 3) 
                                     	THEN ROUND(datatbl.realabw,2) >= 0.9 AND ROUND(datatbl.realabw,2) < 1
                                     WHEN (counter = 4) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1 AND ROUND(datatbl.realabw,2) < 1.1 
                                     WHEN (counter = 5) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1.1 AND ROUND(datatbl.realabw,2) < 1.2 
                                     WHEN (counter = 6) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1.2 AND ROUND(datatbl.realabw,2) < 1.3 
                                     WHEN (counter = 7) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1.3 AND ROUND(datatbl.realabw,2) < 1.4 
                                     WHEN (counter = 8) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1.4 AND ROUND(datatbl.realabw,2) < 1.5 
                                     WHEN (counter = 9) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1.5 AND ROUND(datatbl.realabw,2) < 1.6 
                                     WHEN (counter = 10) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1.6 AND ROUND(datatbl.realabw,2) < 1.7 
                                     WHEN (counter = 11) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1.7 AND ROUND(datatbl.realabw,2) < 1.8
                                     WHEN (counter = 12) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1.8 AND ROUND(datatbl.realabw,2) < 1.9 
                                     WHEN (counter = 13) 
                                     	THEN ROUND(datatbl.realabw,2) >= 1.9 AND ROUND(datatbl.realabw,2) < 2
                                     WHEN (counter = 14) 
                                     	THEN ROUND(datatbl.realabw,2) >= 2 AND ROUND(datatbl.realabw,2) < 2.1
                                     WHEN (counter = 15) 
                                     	THEN ROUND(datatbl.realabw,2) >= 2.1 AND ROUND(datatbl.realabw,2) < 2.2
                                     WHEN (counter = 16) 
                                     	THEN ROUND(datatbl.realabw,2) >= 2.2 AND ROUND(datatbl.realabw,2) < 2.3
                                     WHEN (counter = 17) 
                                     	THEN ROUND(datatbl.realabw,2) >= 2.3 AND ROUND(datatbl.realabw,2) < 2.4
                                     WHEN (counter = 18) 
                                     	THEN ROUND(datatbl.realabw,2) >= 2.4 AND ROUND(datatbl.realabw,2) < 2.5
                                     WHEN (counter = 19) 
                                     	THEN ROUND(datatb l.realabw,2) >= 2.5 AND ROUND(datatbl.realabw,2) < 2.6
									 WHEN (counter = 20) 
                                     	THEN ROUND(datatbl.realabw,2) >= 2.6 AND ROUND(datatbl.realabw,2) < 2.7
                                     WHEN (counter = 21) 
                                     	THEN ROUND(datatbl.realabw,2) >= 2.7 AND ROUND(datatbl.realabw,2) < 2.8
									 WHEN (counter = 22) 
                                     	THEN ROUND(datatbl.realabw,2) >= 2.8 AND ROUND(datatbl.realabw,2) < 2.9
									 WHEN (counter = 23) 
                                     	THEN ROUND(datatbl.realabw,2) >= 2.9 AND ROUND(datatbl.realabw,2) < 3
									 WHEN (counter = 24)  
                                     	THEN ROUND(datatbl.realabw,2) >= 3 
                                ELSE TRUE 
                                END)
                           AND (CASE WHEN (orgtype IS NOT NULL AND orgtype NOT LIKE 'PT')
												 THEN datatbl.orgtypesppaid = orgtypeidx
												 ELSE 1 = 1
											END))												
			LOOP  
			qtyekor 	:= COALESCE(rec_datapims.qtyekor,0);
			qtykg 	:= COALESCE(rec_datapims.qtykg,0);
--			abw 		:= COALESCE(rec_pims.abw,0);
			IF qtyekor <> 0
				THEN abw := qtykg / qtyekor;
				ELSE abw := 0;
			END IF;
			gross		:= COALESCE(rec_datapims.gross,0);
			discamt 	:= COALESCE(rec_datapims.discamt,0);
			netamt 	:= COALESCE(rec_datapims.netamt,0);
		
-- 		pctkg 	:= 
			IF COALESCE(qtykgall,0) <> 0
				THEN pctkg := qtykg / COALESCE(qtykgall,0);
				ELSE pctkg := 0;
			END IF;			
-- 		avgprice :=	0;	
			IF qtykg <> 0
				THEN avgprice := netamt / qtykg;
				ELSE avgprice := 0;
			END IF;	
			END LOOP;
 	
		RETURN NEXT;
		END LOOP; 			
END; 
$function$
;
