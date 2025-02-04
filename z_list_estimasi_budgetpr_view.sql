drop view z_list_estimasi_budgetpr_view;

-- Function (view) untuk Reportview List Estimasi Budget PR By: Gilbert 05/09/24

create or replace view z_list_estimasi_budgetpr_view
as select 
	alias.ad_client_id,
	alias.ad_org_id,
	alias.orgname, 
	alias.pr_no,
	alias.documentdate,
	alias.capex,
	alias.costcenterid, 
	alias.costcentername, 
	alias.amount,
	alias.ad_user_id,
	alias.waktu

	from z_list_estimasi_budgetpr_tbl alias;
	
