-- drop function z_harga_pl_lb(int[])

create or replace function z_harga_pl_lb(
	org_id int[]
)

returns table (
	validfrom date,
	documentno varchar(155),
	breakvalue numeric,
	pricelist_penjualan_lb varchar(155),
	documentstatus varchar(155)
)

language plpgsql
as $function$

declare
	rec_loop record;
	all_null_rows BOOLEAN := FALSE;

begin
	drop table if exists parentorg;
	create temp table parentorg as (
		select 
			ao.ad_org_id,
			aoin.parent_org_id
		from ad_org ao
		join ad_orginfo aoin on ao.ad_org_id = aoin.ad_org_id
	);

	drop table if exists depotable;
	create temp table depotable as (
		select
			zhg.ad_client_id,
		    po.parent_org_id,
		    zhg.ad_org_id,
			date(zhg.z_doc_in) as validfrom,
			zhg.documentno as documentno,
			zgb.breakvalue as breakvalue,
			mpv.name as pricelist_penjualan_lb,
			zhg.docstatus as documentstatus
		from z_harga_garansi zhg
		join z_garansi_beli zgb on zhg.z_harga_garansi_id = zgb.z_harga_garansi_id
		join parentorg po on zhg.ad_org_id = po.ad_org_id
		join M_PriceList_Version mpv on zhg.z_pricelistvr_pembelian_lb_id = mpv.m_pricelist_version_id
		where zhg.ad_org_id = any(org_id)
	);
	
	for rec_loop in
		select * from depotable
	loop
--		check if the fields in each row are null
		if rec_loop.validfrom IS NULL AND
           rec_loop.documentno IS NULL AND
           rec_loop.breakvalue IS NULL AND
           rec_loop.pricelist_penjualan_lb IS NULL AND
           rec_loop.documentstatus IS NULL THEN
           all_null_rows := TRUE;
		else 
--			return the current row fields
			validfrom := rec_loop.validfrom;
			documentno := rec_loop.documentno;
			breakvalue := rec_loop.breakvalue;
			pricelist_penjualan_lb := rec_loop.pricelist_penjualan_lb;
			documentstatus := rec_loop.documentstatus;

			return next;
		end if;
	end loop;
			
	if all_null_rows then
		drop table if exists parenttable;
		create temp table parenttable as (
			select
				zhg.ad_client_id,
			    po.parent_org_id,
			    zhg.ad_org_id,
				date(zhg.z_doc_in) as validfrom,
				zhg.documentno as documentno,
				zgb.breakvalue as breakvalue,
				mpv.name as pricelist_penjualan_lb,
				zhg.docstatus as documentstatus
			from z_harga_garansi zhg
			join z_garansi_beli zgb on zhg.z_harga_garansi_id = zgb.z_harga_garansi_id
			join parentorg po on zhg.ad_org_id = po.ad_org_id
			join M_PriceList_Version mpv on zhg.z_pricelistvr_pembelian_lb_id = mpv.m_pricelist_version_id
			where po.parent_org_id = any(org_id)
		);
	
		for rec_loop in
			select * from parenttable
		loop
			validfrom := rec_loop.validfrom;
			documentno := rec_loop.documentno;
			breakvalue := rec_loop.breakvalue;
			pricelist_penjualan_lb := rec_loop.pricelist_penjualan_lb;
			documentstatus := rec_loop.documentstatus;

			return next;
		end loop;
	end if;
		
end;
$function$;


select * from z_harga_pl_lb($P{org_id});

-- testing paramenter =  '{1001306, 1001307, 1001433}'