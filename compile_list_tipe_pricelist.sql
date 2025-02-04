-- select function

-- DROP FUNCTION adempiere.z_list_tipe_pricelist_select_f(int4, int4, int4, int4, varchar, bpchar);

CREATE OR REPLACE FUNCTION adempiere.z_list_tipe_pricelist_select_f(clientidx integer, orgidx integer, orgdepoidx integer, z_pr_pcscf_idx integer, z_typex character varying, isactivex character)
 RETURNS TABLE(ad_client_id integer, ad_org_id integer, depoid integer, depo character varying, z_pr_pcscf_id integer, pricelist_name character varying, pricelist_v_name character varying, z_type character varying, validfrom date, product integer, listprice numeric, isactive character)
 LANGUAGE plpgsql
AS $function$

declare
	rec_ltp record;
begin

	drop table if exists temp2;
	create temp table temp2 as (
		select 
		categoryname as cgname 
		from Z_PR_PCSCF zpr
		join Z_Parameter_Reporting zpar on zpar.z_parameter_reporting_id = zpr.z_parameter_reporting_id
		where zpr.categoryname is not null 
		and zpr.categoryname like '\%%'
		and (case when z_pr_pcscf_idx is not null then zpr.z_pr_pcscf_id = z_pr_pcscf_idx else 1=1 end)
	);
	
	drop table if exists temp1;
	create temp table temp1 as (select
		 mp.ad_client_id as ad_client_id,
        aoin.parent_org_id as ad_org_id,
		mp.ad_org_id as depoid_extra,
        org.ad_org_id as depoid,
        org.name as depo,
        mp.name as pricelist_name,
        mpv.name as pricelist_v_name,
        mp.z_type as z_type,
        date(mpv.validfrom) as validfrom,
        pp.m_product_id as product,
        pp.pricelist as listprice,
        mp.isactive as isactive
        from M_PriceList mp
        join M_PriceList_Version mpv on mpv.m_pricelist_id = mp.m_pricelist_id
        join ad_org org on mp.ad_org_id = org.ad_org_id 
        join ad_orginfo aoin on org.ad_org_id = aoin.ad_org_id
        join M_ProductPrice pp on pp.m_pricelist_version_id = mpv.m_pricelist_version_id
		join temp2 on mp.name ilike temp2.cgname
	);
	
	
	if orgdepoidx is not null then 
		for rec_ltp in (select
		temp1.ad_client_id,
        temp1.ad_org_id,
		temp1.depoid_extra,
        temp1.depoid,
        temp1.depo,
        temp1.pricelist_name,
        temp1.pricelist_v_name,
        temp1.z_type,
        temp1.validfrom,
        temp1.product,
        temp1.listprice,
        temp1.isactive
        from temp1
        where temp1.ad_client_id = clientidx
		and temp1.ad_org_id = orgidx
		and temp1.depoid = orgdepoidx
		and (case when z_typex is not null then temp1.z_type = z_typex else 1=1 end)
		and (case when isactivex is not null then temp1.isactive = isactivex else 1=1 end)

		)
	
		loop
	        ad_client_id := rec_ltp.ad_client_id;
			ad_org_id := rec_ltp.ad_org_id;
			depoid := rec_ltp.depoid;
	        depo := rec_ltp.depo;
			z_pr_pcscf_id := z_pr_pcscf_idx;
	        pricelist_name := rec_ltp.pricelist_name;
	        pricelist_v_name := rec_ltp.pricelist_v_name;
	        z_type := rec_ltp.z_type;
	        validfrom := rec_ltp.validfrom;
	        product := rec_ltp.product;
	        listprice := rec_ltp.listprice;
	        isactive := rec_ltp.isactive;
			
			return next;
		end loop;
	
	else 
	
		for rec_ltp in (select
			temp1.ad_client_id,
	        temp1.ad_org_id,
			temp1.depoid_extra,
	        temp1.depoid,
	        temp1.depo,
	        temp1.pricelist_name,
	        temp1.pricelist_v_name,
	        temp1.z_type,
	        temp1.validfrom,
	        temp1.product,
	        temp1.listprice,
	        temp1.isactive
	        from temp1
	        where temp1.ad_client_id = clientidx
			and (case when temp1.ad_org_id is not null then temp1.ad_org_id = orgidx else temp1.depoid_extra = orgidx end)
			and (case when z_typex is not null then temp1.z_type = z_typex else 1=1 end)
			and (case when isactivex is not null then temp1.isactive = isactivex else 1=1 end)
		)
	
		loop
	        ad_client_id := rec_ltp.ad_client_id;
			if rec_ltp.ad_org_id is not null then
				ad_org_id := rec_ltp.ad_org_id;
				depoid := rec_ltp.depoid;
			else 
				ad_org_id := rec_ltp.depoid_extra;
				depoid := rec_ltp.depoid_extra;
			end if;
	        depo := rec_ltp.depo;
			z_pr_pcscf_id := z_pr_pcscf_idx;
	        pricelist_name := rec_ltp.pricelist_name;
	        pricelist_v_name := rec_ltp.pricelist_v_name;
	        z_type := rec_ltp.z_type;
	        validfrom := rec_ltp.validfrom;
	        product := rec_ltp.product;
	        listprice := rec_ltp.listprice;
	        isactive := rec_ltp.isactive;
			
			return next;
		end loop;
	end if;
end;
$function$
;





-- insert function


-- DROP FUNCTION adempiere.z_list_tipe_pricelist_insert_f(int4, int4, int4, int4, varchar, bpchar, int4);

CREATE OR REPLACE FUNCTION adempiere.z_list_tipe_pricelist_insert_f(clientidx integer, orgidx integer, orgdepoidx integer, z_pr_pcscf_idx integer, z_typex character varying, isactivex character, usrid integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

begin
	delete from z_list_tipe_pricelist_tbl
	where ad_client_id = clientidx;
--    and ad_org_id = orgidx
--    and depoid = orgdepoidx;
--    and z_pr_pcscf_id = z_pr_pcscf_idx
--    and z_type = z_typex
--    and isactive = isactivex;
	
	insert into z_list_tipe_pricelist_tbl (
		select
		ad_client_id,
        ad_org_id,
        depoid,
        depo,
		z_pr_pcscf_id,
        pricelist_name,
        pricelist_v_name,
        z_type,
        validfrom,
        product,
        listprice,
        isactive,
       	usrid,
		current_timestamp 
		
		from z_list_tipe_pricelist_select_f(clientidx::int, orgidx::int, orgdepoidx::int, z_pr_pcscf_idx::int, z_typex::varchar(255), isactivex::char)
	);
end;
$function$
;



-- function table

-- adempiere.z_list_tipe_pricelist_tbl definition

-- Drop table

-- DROP TABLE adempiere.z_list_tipe_pricelist_tbl;

CREATE TABLE adempiere.z_list_tipe_pricelist_tbl (
	ad_client_id numeric(10) DEFAULT NULL::numeric NULL,
	ad_org_id numeric(10) DEFAULT NULL::numeric NULL,
	depoid numeric(10) NULL,
	depo varchar NULL,
	z_pr_pcscf_id numeric(10) NULL,
	pricelist_name varchar NULL,
	pricelist_v_name varchar NULL,
	z_type varchar NULL,
	validfrom date NULL,
	product numeric(10) NULL,
	listprice numeric(10) NULL,
	isactive bpchar(1) DEFAULT 'Y'::bpchar NULL,
	ad_user_id numeric(10) NULL,
	waktu timestamp NULL
);





-- function view

-- adempiere.z_list_tipe_pricelist_view source

-- drop view adempiere.z_list_tipe_pricelist_view

CREATE OR REPLACE VIEW adempiere.z_list_tipe_pricelist_view
AS SELECT alias.ad_client_id,
    alias.ad_org_id,
    alias.depoid,
    alias.depo,
    alias.z_pr_pcscf_id,
    alias.pricelist_name,
    alias.pricelist_v_name,
    alias.z_type,
    alias.validfrom,
    alias.product,
    alias.listprice,
    alias.isactive,
    alias.ad_user_id,
    alias.waktu
   FROM z_list_tipe_pricelist_tbl alias;


