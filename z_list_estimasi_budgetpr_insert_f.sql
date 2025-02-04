drop function z_list_estimasi_budgetpr_insert_f(int, int, int, int)

create or replace function z_list_estimasi_budgetpr_insert_f(
	clientidx integer, 
	orgidx integer, 
	costcenteridx integer,
	usrid integer
)

returns void
language plpgsql

as $function$

begin
	-- Function (insert) untuk Reportview List Estimasi Budget PR By: Gilbert 05/09/24
	delete from z_list_estimasi_budgetpr_tbl
	where ad_client_id = clientidx;
--	and ad_org_id= orgidx
--	and costcenterid = costcenteridx;
	
	insert into z_list_estimasi_budgetpr_tbl (
		select
		ad_client_id, 
	 	ad_org_id, 
	 	orgname, 
	 	pr_no,
	 	documentdate,
	 	capex,
	 	costcenterid, 
	 	costcentername, 
	 	amount,
       	usrid,
		current_timestamp 
		
		from z_list_estimasi_budgetpr_select_f(clientidx::integer, orgidx::integer, costcenteridx::integer)
	);
end;
$function$
;