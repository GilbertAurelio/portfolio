drop table z_list_estimasi_budgetpr_tbl;

-- Function (table) untuk Reportview List Estimasi Budget PR By: Gilbert 05/09/24

create table z_list_estimasi_budgetpr_tbl (
	ad_client_id numeric(10) DEFAULT NULL::numeric NULL,
    ad_org_id numeric(10) DEFAULT NULL::numeric NULL,
    orgname varchar null, 
	pr_no varchar null,
	documentdate date null,
	capex varchar null,
	costcenterid numeric(10) null, 
	costcentername varchar null, 
	amount numeric(10) null,
    ad_user_id numeric(10) NULL,
	waktu timestamp NULL
);

