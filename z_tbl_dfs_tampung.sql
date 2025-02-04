-- adempiere.z_tbl_dfs_tampung definition

-- Drop table

-- DROP TABLE adempiere.z_tbl_dfs_tampung;

CREATE TABLE adempiere.z_tbl_dfs_tampung (
	ad_client_id numeric(10) DEFAULT NULL::numeric NULL,
	ad_org_id numeric(10) DEFAULT NULL::numeric NULL,
	orgdepoid numeric NULL,
	datedoc date NULL,
	ad_user_id numeric(10) DEFAULT NULL::numeric NULL,
	organization varchar NULL,
	createddate timestamp NULL,
	createdby varchar NULL,
	completedate timestamp NULL,
	completeby varchar NULL,
	documentdate date NULL,
	timeslotstart time NULL,
	documentno varchar NULL,
	deskripsi varchar NULL,
	m_warehouse_id numeric(10) NULL,
	c_project_id numeric(10) NULL,
	birdage_day numeric(10) NULL,
	birdage_week numeric(10) NULL,
	light numeric(10) NULL,
	water numeric(10) NULL,
	temp_min numeric(10) NULL,
	temp_max numeric(10) NULL,
	humidity numeric(10) NULL,
	abw numeric(10) NULL,
	uniformity numeric(10) NULL,
	docstatus varchar NULL,
	koreksi varchar NULL,
	z_good_issue_id numeric(10) NULL,
	z_good_receipt_id numeric(10) NULL,
	deskripsi_line varchar NULL,
	m_product_id numeric(10) NULL,
	warehouse_storage numeric(10) NULL,
	qty numeric(10) NULL,
	c_uom_id numeric(10) NULL,
	waktu timestamp NULL,
	statusval bpchar NULL,
	dfs_awal varchar NULL,
	diff_date numeric(10) NULL
);