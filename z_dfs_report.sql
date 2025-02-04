-- DROP FUNCTION adempiere.z_dfs_report(int4, int4, int4, int4, date, date, varchar, int4);

CREATE OR REPLACE FUNCTION adempiere.z_dfs_report(clientidx integer, orgidx integer, orgdepoidx integer, farmidx integer, datefromx date, datetox date, statusx character varying, useridx integer)
 RETURNS TABLE(ad_client_id integer, ad_org_id integer, orgdepoid integer, m_warehouse_id integer, datedoc date, organization character varying, createddate timestamp without time zone, createdby character varying, completedate timestamp without time zone, completeby character varying, documentdate date, timeslotstart time without time zone, documentno character varying, deskripsi character varying, warehouse numeric, c_project_id numeric, birdage_day numeric, birdage_week numeric, light numeric, water numeric, temp_min numeric, temp_max numeric, humidity numeric, abw numeric, uniformity numeric, docstatus character varying, koreksi character varying, z_good_issue_id numeric, z_good_receipt_id numeric, deskripsi_line character varying, m_product_id numeric, warehouse_storage numeric, qty numeric, c_uom_id numeric, ad_user_id numeric, waktu timestamp without time zone, statusval character, dfs_awal character varying, diff_date integer)
 LANGUAGE plpgsql
AS $function$
DECLARE 
    rec_dfs              record;
   	rec_test			 record;
   	rec_name			 record;
  
BEGIN 
    -- Function untuk Reportview DFS
    -- By : VK 
    -- Date : 5 April 2024

	-- modified by: Gilbert
	-- date: 1 August 2024
    SET SCHEMA 'adempiere';


FOR rec_dfs IN (SELECT
				zdt.ad_client_id,
				aoin.parent_org_id AS ad_org_id,
				zdt.ad_org_id AS orgdepoid,
				zdt.m_warehouse_id,
				zdt.datedoc,
				
				ao.name AS organization,
				zdt.created AS createddate,
				date(zdt.datedoc) AS documentdate,
				cast(zdt.timeslotstart AS time) AS documenttime,
				zdt.documentno AS documentno,
				zdt.description AS deskripsi,
				zdt.m_warehouse_id AS warehouse,
				zdt.c_project_id AS chickcyclename,
				zdt.z_bird_age AS birdageday,
				zdt.z_bird_age_week AS birdageweek,
				zdt.z_light_hour AS light,
				zdt.z_water_litre AS water,
				zdt.z_temp_min AS temp_min,
				zdt.z_temp_max AS temp_max,
				zdt.z_humidity AS humidity,
				zdt.z_avg_body_weight AS abw,
				zdt.z_uniformity AS uniformity,
				zdt.docstatus AS docstatus,
				zdt.iskoreksi AS koreksi,
				zdi.z_good_issue_id AS goodsissueno,
				zdi.z_good_receipt_id AS goodsreceiptid,
				zdi.description AS deskripsi_line,
				zdi.m_product_id AS product,
				zdi.m_warehouse_id AS warehouse_storage,
				zdi.qty AS qty,
				zdi.c_uom_id AS uom,
				zdt.z_daily_transaction_id AS record_id,
				zdt.createdby AS createdby,
				zdt2.documentno as dfs_awal,
				date(zdt.created) - date(zdt.datedoc) as diff_date

				
				FROM adempiere.z_daily_transaction zdt 
				INNER JOIN adempiere.z_dfs_inout zdi ON zdt.z_daily_transaction_id = zdi.z_daily_transaction_id
				INNER JOIN ad_org ao ON zdt.ad_org_id = ao.ad_org_id
				INNER JOIN adempiere.ad_orginfo aoin ON zdt.ad_org_id = aoin.ad_org_id
				LEFT JOIN z_daily_transaction zdt2 ON zdt.z_referencedfs_id = zdt2.z_daily_transaction_id
				
--				WHERE aoin.parent_org_id = 1001791
				
				WHERE zdt.ad_client_id = clientidx
				AND aoin.parent_org_id = orgidx
				AND (CASE WHEN orgdepoidx IS NOT NULL
						  THEN zdt.ad_org_id = orgdepoidx
						  ELSE 1 = 1
					END)				
				AND (CASE WHEN farmidx IS NOT NULL
						  THEN zdt.m_warehouse_id = farmidx
						  ELSE 1 = 1
					END)
				AND zdt.datedoc BETWEEN datefromx AND datetox
--				AND (CASE WHEN statusx IS NOT NULL
--						  THEN zdt.docstatus = statusx
--						  ELSE 1 = 1
--					END)
				
				
				--WHERE zdt.ad_org_id = 1001492
				--AND zdt.m_warehouse_id = 1022224
				--AND zdt.datedoc BETWEEN '2022-06-01' AND '2022-06-28'
				--AND zdt.docstatus = 'CO'
				)

    LOOP 
	 ad_client_id 		:= rec_dfs.ad_client_id;
	 ad_org_id			:= rec_dfs.ad_org_id;
	 orgdepoid			:= rec_dfs.orgdepoid;
	 m_warehouse_id		:= rec_dfs.m_warehouse_id;
	 datedoc			:= rec_dfs.datedoc;
    organization 	:= rec_dfs.organization;
   	createddate	 	:= rec_dfs.createddate;
   	documentdate 	:= rec_dfs.documentdate;
   	timeslotstart	:= rec_dfs.documenttime;
   	documentno		:= rec_dfs.documentno;
   	deskripsi		:= rec_dfs.deskripsi;
   	warehouse		:= rec_dfs.warehouse;
   	c_project_id	:= rec_dfs.chickcyclename;
   	birdage_day		:= rec_dfs.birdageday;
   	birdage_week	:= rec_dfs.birdageweek;
   	light			:= rec_dfs.light;
   	water			:= rec_dfs.water;
   	temp_min		:= rec_dfs.temp_min;
   	temp_max		:= rec_dfs.temp_max;
   	humidity		:= rec_dfs.humidity;
   	abw				:= rec_dfs.abw;
   	uniformity		:= rec_dfs.uniformity;
   	docstatus		:= rec_dfs.docstatus;
   	koreksi			:= rec_dfs.koreksi;
   	z_good_issue_id	:= rec_dfs.goodsissueno;
   	z_good_receipt_id	:= rec_dfs.goodsreceiptid;
    deskripsi_line	:= rec_dfs.deskripsi_line;
   	M_Product_ID	:= rec_dfs.product;
   	warehouse_storage	:= rec_dfs.warehouse_storage;
   	qty				:= rec_dfs.qty;
   	C_UOM_ID				:= rec_dfs.uom;
    ad_user_id		:= useridx;
   	waktu			:= current_timestamp;
	
	
	dfs_awal := null;
	diff_date := null;
	
	    
   
	SELECT ac.updated, au.name , cb."name" AS name2 INTO rec_test
	FROM ad_changelog ac
	JOIN ad_user au
	ON au.ad_user_id = ac.updatedby 
	LEFT JOIN c_bpartner cb 
	ON au.c_bpartner_id = cb.c_bpartner_id 
	WHERE ac.record_id = rec_dfs.record_id
	AND ac.ad_table_id = (SELECT ad_table_id  FROM ad_table WHERE tablename ilike 'z_daily_transaction')
	AND ac.newvalue::text ~~ 'CO'::text
	LIMIT 1;
	
	SELECT au.name, cb.name AS name2 INTO rec_name
	FROM ad_user au LEFT JOIN c_bpartner cb 
	ON au.c_bpartner_id = cb.c_bpartner_id 
	WHERE au.ad_user_id = rec_dfs.createdby;
	
	completedate		:= rec_test.updated;
	IF rec_test.name2 != NULL
		THEN completeby	:= rec_test.name2;
	ELSE completeby := rec_test.name;
	END IF;

	IF rec_name.name2 != NULL
		THEN createdby := rec_name.name2;
	ELSE createdby := rec_name.name;
	END IF;
		
--	statusval := 
	IF rec_dfs.docstatus  = 'CO'
		THEN statusval := 'Y';
		ELSE statusval := 'N';
	END IF;

--  tambah column dfs awal, date dfs awal, diff date
	if koreksi = 'Y' 
		then
		dfs_awal := rec_dfs.dfs_awal;
		diff_date := rec_dfs.diff_date;

	end if;
		
   
    RETURN NEXT;
    END LOOP;
   
END;
$function$
;
