 DROP FUNCTION z_list_estimasi_budgetpr_select_f(int4, int4, int4);

CREATE OR REPLACE FUNCTION z_list_estimasi_budgetpr_select_f(
	clientidx integer, 
	orgidx integer, 
	costcenteridx integer
)
	
 RETURNS TABLE(
 	ad_client_id integer, 
 	ad_org_id integer, 
 	orgname character varying, 
 	pr_no character varying,
 	documentdate date,
 	capex character varying,
 	costcenterid integer, 
 	costcentername character varying, 
 	amount integer
-- 	estrealbudget numeric, 
 )
 LANGUAGE plpgsql
AS $function$

declare
	rec_budget record;
begin
		-- Function (select) untuk Reportview List Estimasi Budget PR By: Gilbert 05/09/24

	DROP TABLE IF EXISTS tblreqouts;
	CREATE TEMPORARY TABLE tblreqouts
	AS (SELECT 
		mreq.ad_client_id,
		mreq.ad_org_id,
		ao.name AS orgname,
		mreq.documentno as pr_no,
		date(mreq.datedoc) as documentdate,
		mreq.iscapex as capex,
		mreq.user1_id AS costcenterid,
		cev.name AS costcentername,
		TO_CHAR(mreq.datedoc,'YYYY') AS yeardoc,
		mreql.linenetamt AS amount,
		cy.c_year_id
		FROM adempiere.m_requisition mreq
		JOIN adempiere.m_requisitionline mreql ON mreq.m_requisition_id = mreql.m_requisition_id
		LEFT JOIN adempiere.c_orderline ordl ON mreql.c_orderline_id = ordl.c_orderline_id 
		LEFT JOIN adempiere.c_order ord ON ordl.c_order_id = ord.c_order_id 
		LEFT JOIN adempiere.c_elementvalue cev ON mreq.user1_id = cev.c_elementvalue_id 
		LEFT JOIN adempiere.ad_org ao ON mreq.ad_org_id = ao.ad_org_id 
		LEFT JOIN adempiere.c_year cy ON cy.ad_org_id = mreq.ad_org_id AND cy.fiscalyear = TO_CHAR(mreq.datedoc,'YYYY')
		WHERE mreq.iscapex = 'Y'
		AND mreq.docstatus = 'CO' -- tidak samadengan dr n void 
		AND mreql.isactive = 'Y'
		AND (mreql.c_orderline_id IS NULL OR (ord.docstatus NOT IN ('CO','CL')))
		AND mreq.documentno::text <> '%DOM%'::TEXT);
		
	DROP TABLE IF EXISTS tblpoouts;
	CREATE TEMPORARY TABLE tblpoouts
	AS (SELECT 
		ord.ad_client_id,
		ord.ad_org_id,
		ao.name AS orgname,
		mreq.documentno as pr_no,
		date(mreq.datedoc) as documentdate,
		mreq.iscapex as capex,
		ord.user1_id AS costcenterid,
		cev.name AS costcentername,
		TO_CHAR(ord.dateordered,'YYYY') AS yeardoc,
		ordl.linenetamt AS amount,
		cy.c_year_id
		FROM adempiere.c_order ord 
		INNER JOIN adempiere.c_orderline ordl ON ord.c_order_id = ordl.c_order_id 
		LEFT JOIN adempiere.m_matchpo mmp ON ordl.c_orderline_id = mmp.c_orderline_id 
				  AND (CASE WHEN mmp.m_inoutline_id IS NULL AND mmp.c_invoiceline_id IS NOT NULL 
				  			THEN 1 = 0
				  			ELSE 1 = 1
				  	   END)
		LEFT JOIN adempiere.m_inoutline miol ON mmp.m_inoutline_id = miol.m_inoutline_id 
		LEFT JOIN adempiere.m_inout mio ON miol.m_inout_id = mio.m_inout_id 
		LEFT JOIN adempiere.m_requisitionline mreql ON ordl.c_orderline_id = mreql.c_orderline_id 
		LEFT JOIN adempiere.m_requisition mreq ON mreql.m_requisition_id = mreq.m_requisition_id
		LEFT JOIN adempiere.c_elementvalue cev ON ord.user1_id = cev.c_elementvalue_id 
		LEFT JOIN adempiere.ad_org ao ON ord.ad_org_id = ao.ad_org_id 
		LEFT JOIN adempiere.c_year cy ON cy.ad_org_id = ord.ad_org_id AND cy.fiscalyear = TO_CHAR(ord.dateordered,'YYYY')
		WHERE ord.docstatus = 'CO'
		AND ordl.isactive = 'Y'
		AND mreq.iscapex = 'Y'
		AND (CASE WHEN ( SELECT sum(mmo.qty) AS sum
			             FROM m_matchpo mmo
			             JOIN m_inoutline mie ON mmo.m_inoutline_id = mie.m_inoutline_id
			             JOIN m_inout mit ON mie.m_inout_id = mit.m_inout_id
			             WHERE mmo.c_orderline_id = ordl.c_orderline_id
			             HAVING sum(mmo.qty) <> 0::numeric) < ordl.qtyordered 
				  THEN 1 = 1
				  WHEN ord.docstatus = 'CL' AND mio.documentno IS NULL 
				  THEN 1 = 1
				  WHEN mio.documentno IS NULL 
				  THEN 1 = 1
				  ELSE 1 = 0
			END));

			
	
		for rec_budget in (
			select 
				tblreq.ad_client_id,
			 	tblreq.ad_org_id,
			 	tblreq.orgname,
			 	tblreq.pr_no,
			 	tblreq.documentdate,
			 	tblreq.capex,
			 	tblreq.costcenterid,
			 	tblreq.costcentername,
			 	tblreq.amount
			from tblreqouts tblreq
			WHERE (CASE WHEN clientidx IS NOT NULL
				   			   THEN tblreq.ad_client_id = clientidx
				   			   ELSE 1 = 1
				   		  END)
				   AND (CASE WHEN orgidx IS NOT NULL
				   			 THEN tblreq.ad_org_id= orgidx
				   			 ELSE 1 = 1
				   		END)
				   AND (CASE WHEN costcenteridx IS NOT NULL
				   			 THEN tblreq.costcenterid = costcenteridx
				   			 ELSE 1 = 1
				   		END)     
			
			union

			select 
				tpo.ad_client_id,
			 	tpo.ad_org_id,
			 	tpo.orgname,
			 	tpo.pr_no,
			 	tpo.documentdate,
			 	tpo.capex,
			 	tpo.costcenterid,
			 	tpo.costcentername,
			 	tpo.amount
			from tblpoouts tpo
			r
			WHERE (CASE WHEN clientidx IS NOT NULL
				   			   THEN tpo.ad_client_id = clientidx
				   			   ELSE 1 = 1
				   		  END)
				   AND (CASE WHEN orgidx IS NOT NULL
				   			 THEN tpo.ad_org_id= orgidx
				   			 ELSE 1 = 1
				   		END)
				   AND (CASE WHEN costcenteridx IS NOT NULL
				   			 THEN tpo.costcenterid = costcenteridx
				   			 ELSE 1 = 1
				   		END)  
		)
	
		loop
	    	ad_client_id := rec_budget.ad_client_id;
		 	ad_org_id := rec_budget.ad_org_id;
		 	orgname := rec_budget.orgname;
		 	pr_no := rec_budget.pr_no;
		 	documentdate := rec_budget.documentdate;
		 	capex := rec_budget.capex;
		 	costcenterid := rec_budget.costcenterid;
		 	costcentername := rec_budget.costcentername;
		 	amount := rec_budget.amount;
			
			return next;
		end loop;
end;
$function$
;