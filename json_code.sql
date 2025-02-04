--drop function z_injectpr_cperpfb_json();


CREATE OR REPLACE FUNCTION z_injectpr_cperpfb_json()
RETURNS table (injectpr_cperpfb json) 
language plpgsql   
AS $function$

declare
	rec_loop record;
	timeline_json JSONB;

BEGIN
	drop table if exists prpotable;
	create temp table prpotable
	as (select *
		from pr_po_reportview prpo
		where prpo.datedoc::date = '2024-07-20'
        or prpo.dateordered::date = '2024-07-20'
        or prpo.movementdate::date = '2024-07-20'
	);



	
	drop table if exists td2;
	create temp table td2
	as (select
			prpo.warehouseaddress as warehouseaddress,
            ao.value as departmentcode,
            prpo.comp_name as comp_name,
--			divisionName,
--			depcdRequest,
            mw.name as warehousename,
            mpc.name as equipmenttype,
            cb.value as employeenumber,
--			projectNo (skip)
            mw.m_warehouse_id as warehouseid,
            mr.priorityrule as urgency,
            prpo.datedoc as requestdate,
            ac.name as client,
            cj.name as departmentname,
            ao.value as companycode,
            mr.created as created,
            cd."name" as doctype,
            CASE 
                WHEN mr.documentno LIKE '%PR%' THEN SUBSTR(mr.documentno, 3)
                ELSE mr.documentno
            END AS prID,
            prpo.plant as plant,
--			divisionCode
            TRIM(SUBSTR(prpo.comp_name, INSTR(prpo.comp_name, '_') + 1)) as ouccdrequest,
            mr.processed as isprocessed,
--			timeline
			mr.created as pr_date,
			co.created as po_date,
			mi.created as gr_date,
			prpo.req_no as pr_Num,
			ar.name as position,
			au.email as userEmail,
			prpo.m_product_id,
			mr.m_requisition_id,
			co.c_order_id,
			mi.m_inout_id,
			mp.ad_org_id
			FROM prpotable prpo 
	        join ad_user au on au.ad_user_id = prpo.ad_user_id 
	        join ad_user_roles aur on aur.ad_user_id = au.ad_user_id 
	        join ad_role ar on ar.ad_role_id = aur.ad_role_id 
	        join c_bpartner cb on au.c_bpartner_id = cb.c_bpartner_id 
	        join c_job cj on cj.c_job_id = au.c_job_id
	        join ad_org ao on ao.ad_org_id = prpo.ad_org_id 
	        join m_warehouse mw on mw.ad_org_id = prpo.ad_org_id 
	        join c_doctype cd on prpo.c_doctype_id = cd.c_doctype_id 
	        join m_product mp on mp.m_product_id = prpo.m_product_id 
	        join m_product_category mpc on mpc.m_product_category_id  = mp.m_product_category_id 
	        join ad_client ac on ac.ad_client_id = prpo.ad_client_id 
			join M_Requisition mr on prpo.req_no = mr.documentno
			left join c_order co on co.documentno = prpo.po_no
			left join m_inout mi on mi.documentno = prpo.gr_no 		
		);
		
	
	drop table if exists temp_data;
	create temp table temp_data
	as (SELECT
			prpo.material_no as productSKU,
			mr.description as notes,
			prpo.req_qty as quantity,
			prpo.uomsimbol as productUOM,
--			productPackage
			prpo.material_name as productName,
			prpo.pr_price as productPrice,
			prpo.purchase_group as productCategory,
			mrl.created as pr_tl_date,
			col.created as po_tl_date,
			mil.created as gr_tl_date,
			mr.m_requisition_id
        FROM prpotable prpo 
		join td2 on td2.pr_Num = prpo.req_no
		join M_Requisition mr on prpo.req_no = mr.documentno
		join m_requisitionline mrl on td2.m_requisition_id = mrl.m_requisition_id 
		join c_orderline col on td2.c_order_id = col.c_order_id 
		join m_inoutline mil on td2.m_inout_id = mil.m_inout_id 
        );

	for rec_loop in (select
						pr_data.warehouseaddress,
						pr_data.departmentcode,
        				pr_data.comp_name,
--						"divisionName": "",
--			        	"depcdRequest": "",
						pr_data.warehousename,
				        pr_data.equipmenttype,
				        pr_data.employeenumber,
--						"projectNo": "",
				        pr_data.warehouseid,
				        pr_data.urgency,
				        pr_data.requestdate,
				        pr_data.client,
				        pr_data.departmentname,
				        pr_data.companycode,
				        pr_data.created,
				        pr_data.doctype,
				        pr_data.prID,
				        pr_data.plant,
--						"divisionCode": "",
				        pr_data.ouccdrequest,
				        pr_data.isprocessed,
						pr_data.pr_date,
						pr_data.po_date,
						pr_data.gr_date,
						pr_data.pr_Num,
						(SELECT json_agg(row_to_json(tbl))
				         FROM (SELECT 
				                 temp_data.productSKU AS "productSKU",
				                 'https://e-comdiv.cp.co.id:8447/material_img/ecat/' || temp_data.productSKU || '/' || temp_data.productSKU || '.jpg' AS "productImage",
				                 temp_data.notes AS "notes",
				                 temp_data.quantity AS "quantity",
				                 temp_data.productUOM AS "productUOM",
				                 temp_data.productName AS "productName",
				                 temp_data.productPrice AS "productPrice",
				                 temp_data.productCategory AS "productCategory"
				               FROM temp_data
				               WHERE pr_data.m_requisition_id = temp_data.m_requisition_id) AS tbl) AS detail,
						pr_data.position,
						pr_data.userEmail,
						(select json_agg(row_to_json(tbl3))
						from (select distinct
								temp_data.productSKU as "productSKU",
								temp_data.productName as "productName",
								
								jsonb_build_array(
								    jsonb_build_object('date', pr_data.pr_date, 'status', 'PR Placed'),
								    CASE 
								        WHEN pr_data.po_date IS NOT NULL THEN 
								            jsonb_build_object('date', pr_data.po_date, 'status', 'PO Placed')
								        ELSE 
								            NULL
								    END,
								    CASE 
								        WHEN pr_data.gr_date IS NOT NULL THEN 
								            jsonb_build_object('date', pr_data.gr_date, 'status', 'GR Completed')
								        ELSE 
								            NULL
								    END
								) AS timeline		
							from temp_data
							where pr_data.m_requisition_id = temp_data.m_requisition_id) as tbl3) as productTimeline							
					from td2 pr_data)
	
	loop
		timeline_json := jsonb_build_array(
							jsonb_build_object('date', rec_loop.pr_date, 'status', 'PR Placed'),
            CASE 
                WHEN rec_loop.po_date IS NOT NULL THEN 
                    jsonb_build_object('date', rec_loop.po_date, 'status', 'PO Placed')
                ELSE 
                    NULL
            END,
            CASE 
                WHEN rec_loop.gr_date IS NOT NULL THEN 
                    jsonb_build_object('date', rec_loop.gr_date, 'status', 'GR Completed')
                ELSE 
                    NULL
            END
        );
	
		
		injectpr_cperpfb := json_build_object(
			'warehouseAddress', rec_loop.warehouseaddress,
	        'departmentCode', rec_loop.departmentcode,
	        'companyName', rec_loop.comp_name,
-- 			"divisionName": "",
--        	"depcdRequest": "",
	        'warehouseName', rec_loop.warehousename,
	        'equipmentType', rec_loop.equipmenttype,
	        'employeeNumber', rec_loop.employeenumber,
--			"projectNo": "",
	        'warehouseID', rec_loop.warehouseid,
	        'urgency', rec_loop.urgency,
	        'requestDate', rec_loop.requestdate,
	        'client', rec_loop.client,
	        'departmentName', rec_loop.departmentname,
	        'companyCode', rec_loop.companycode,
	        'created', rec_loop.created,
	        'docType', rec_loop.doctype,
	        'prID', rec_loop.prID,
	        'plantId', rec_loop.plant,
--			"divisionCode": "",
	        'ouccdRequest', rec_loop.ouccdrequest,
	        'isProcessed', rec_loop.isprocessed,
			'timeline', timeline_json,
			'prNum', rec_loop.pr_Num,
			'detail', rec_loop.detail,
			'position', rec_loop.position,
			'useremail', rec_loop.userEmail,
			'productTimeline', rec_loop.productTimeline
		);
		return next;
	end loop;
	
		
--		RETURN QUERY
--		select json_build_object(
--	       	'warehouseAddress', pr_data.warehouseaddress,
--	        'departmentCode', pr_data.departmentcode,
--	        'companyName', pr_data.comp_name,
----		 	"divisionName": "",
----        	"depcdRequest": "",
--	        'warehouseName', pr_data.warehousename,
--	        'equipmentType', pr_data.equipmenttype,
--	        'employeeNumber', pr_data.employeenumber,
----			"projectNo": "",
--	        'warehouseID', pr_data.warehouseid,
--	        'urgency', pr_data.urgency,
--	        'requestDate', pr_data.requestdate,
--	        'client', pr_data.client,
--	        'departmentName', pr_data.departmentname,
--	        'companyCode', pr_data.companycode,
--	        'created', pr_data.created,
--	        'docType', pr_data.doctype,
--	        'prID', pr_data.prID,
--	        'plantId', pr_data.plant,
----			"divisionCode": "",
--	        'ouccdRequest', pr_data.ouccdrequest,
--	        'isProcessed', pr_data.isprocessed,
--			'timeline', 
--			    jsonb_build_array(
--			        jsonb_build_object(
--			            'date', pr_data.pr_date,
--			            'status', 'PR Placed'
--			        )
--			    ) || 
--			    CASE 
--			        WHEN pr_data.po_date IS NOT NULL THEN 
--			            jsonb_build_array(
--			                jsonb_build_object(
--			                    'date', pr_data.po_date,
--			                    'status', 'PO Placed'
--			                )
--			            )
--			        ELSE 
--			            '[]'::jsonb  -- Use an empty JSONB array instead of '{}'
--			    END || 
--			    CASE 
--			        WHEN pr_data.gr_date IS NOT NULL THEN 
--			            jsonb_build_array(
--			                jsonb_build_object(
--			                    'date', pr_data.gr_date,
--			                    'status', 'GR Placed'
--			                )
--			            )
--			        ELSE 
--			            '[]'::jsonb  -- Use an empty JSONB array instead of '{}'
--			    END,
--			'prNum', pr_data.pr_Num,
--			(select row_to_json(detail)
--					from (select 
--							t2.productSKU as productSKU,
--							t2.productImage as productImage,
--							t2.notes as notes,
--							t2.quantity as quantity,
--							t2.productUOM as productUOM,
--				--			productPackage
--							t2.productName as productName,
--							t2.productPrice as productPrice,
--							t2.productCategory as productCategory
--							from temp_data t2
--							where t2.m_requisition_id = pr_data.m_requisition_id) as detail
--			),
--			'position', pr_data.position,
--			'useremail', pr_data.userEmail
----			'productTimeline', jsonb_agg(
----				jsonb_build_object(
----					'productSKU', productSKU,
----					'productName', productName,
----					'timeline', 
----						jsonb_build_array(
----					        jsonb_build_object(
----					            'date', pr_data.pr_tl_date,
----					            'status', 'Product Requested'
----					        )
----					    ) || 
----					    CASE 
----					        WHEN pr_data.po_date IS NOT NULL THEN 
----					            jsonb_build_array(
----					                jsonb_build_object(
----					                    'date', pr_data.po_tl_date,
----					                    'status', 'Product Ordered'
----					                )
----					            )
----					        ELSE 
----					            '[]'::jsonb  -- Use an empty JSONB array instead of '{}'
----					    END || 
----					    CASE 
----					        WHEN pr_data.gr_date IS NOT NULL THEN 
----					            jsonb_build_array(
----					                jsonb_build_object(
----					                    'date', pr_data.gr_tl_date,
----					                    'status', 'Product Accepted'
----					                )
----					            )
----					        ELSE 
----					            '[]'::jsonb  -- Use an empty JSONB array instead of '{}'
----					    END
----				)
----			)
--    ) as injectpr_cperpfb
--    from td2 as pr_data
--	GROUP BY pr_data.warehouseaddress, pr_data.departmentcode, pr_data.comp_name, 
--             pr_data.warehousename, pr_data.equipmenttype, pr_data.employeenumber, 
--             pr_data.warehouseid, pr_data.urgency, pr_data.requestdate, 
--             pr_data.client, pr_data.departmentname, pr_data.companycode, 
--             pr_data.created, pr_data.doctype, pr_data.prID, pr_data.plant, 
--             pr_data.ouccdrequest, pr_data.isprocessed, pr_data.pr_Num, 
--             pr_data.position, pr_data.userEmail, pr_data.pr_date, pr_data.po_date, pr_data.gr_date;
END;
$function$