   -- DROP FUNCTION adempiere.z_insert_dfs_tampung(int4, int4, int4, int4, timestamp, timestamp, varchar, int4);

CREATE OR REPLACE FUNCTION adempiere.z_insert_dfs_tampung(clientidx integer, orgidx integer, orgdepoidx integer, farmidx integer, datefromx timestamp without time zone, datetox timestamp without time zone, statusx character varying, useridx integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE 

BEGIN
	-- modified by: Gilbert
	-- Date: 1 August 2024
    set schema 'adempiere';
    
   delete from adempiere.z_tbl_dfs_tampung
   where ad_client_id = clientidx
   and ad_org_id	  = orgidx
   AND m_warehouse_id	  = farmidx
   and ad_user_id	 = useridx;
  
  insert into adempiere.z_tbl_dfs_tampung
  (
  select
  clientidx,
  orgidx,
  orgdepoid,
  datedoc,
  useridx,
  organization,
  createddate,
  createdby,
  completedate,
  completeby,
  documentdate,
  timeslotstart,
  documentno,
  deskripsi,
  warehouse,
  c_project_id,
  birdage_day,
  birdage_week,
  light,
  water,
  temp_min,
  temp_max,
  humidity,
  abw,
  uniformity,
  docstatus,
  koreksi,
  z_good_issue_id,
  z_good_receipt_id,
  deskripsi_line,
  m_product_id,
  warehouse_storage,
  qty,
  c_uom_id,
  current_timestamp,
  statusval,
	dfs_awal,
	diff_date
  
  from adempiere.z_dfs_report(clientidx::integer, orgidx::integer, orgdepoidx::integer, farmidx::integer, datefromx::date, datetox::date, statusx::CHAR, useridx::integer)
  );
 end;
$function$
;
