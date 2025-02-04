-- select function

--drop function z_ltp_bp_rv_s(int, int, int, int,timestamp without time zone,char);

CREATE OR REPLACE FUNCTION z_ltp_bp_rv_s(
    clientidx INT,
    parentorgidx INT,
    depoidx INT,
    prodcatidx INT,
    validfromx TIMESTAMP WITHOUT TIME ZONE,
    isactivex CHAR
)
RETURNS TABLE (
    ad_client_id INTEGER,
    org_type_id INT,
    org_level VARCHAR(155),
    parent_org_id INT,
    depoid INT,
    depo_name varchar(155),
    orgname VARCHAR(155),
    pricelist_name VARCHAR(155),
    pricelist_v_name VARCHAR(155),
    z_type VARCHAR(155),
    validfrom TIMESTAMP WITHOUT TIME ZONE,
    m_product_id INTEGER,
    prod_name varchar(155),
    listprice NUMERIC,
    isactive CHAR,
    prodcat_id INTEGER,
    prodcat_name varchar(155)
)
LANGUAGE plpgsql
AS $function$
DECLARE
    rec_loop RECORD; -- Declare a record for looping through query results
BEGIN
    -- Temporary table creation
    DROP TABLE IF EXISTS FilteredData;
    CREATE TEMP TABLE FilteredData AS (
        SELECT 
            mp.ad_client_id AS ad_client_id,
            ao.ad_orgtype_id AS org_type_id,
            ao.name AS org_level,
            aoin.parent_org_id AS org_id_1,
            mpp.ad_org_id AS org_id_2,
            org.name AS orgname,

            mpl.name AS pricelist_name,
            mpv.name AS pricelist_v_name,
            mpl.z_type AS z_type,
            date(mpv.validfrom) AS validfrom, 
            mp.m_product_id AS m_product_id,
			mp.name as prod_name,
            mpp.pricelist AS listprice,
            mpp.isactive AS isactive,
            mp.m_product_category_id AS prodcat_id,
            mpc.name AS prodcat_name,
            ROW_NUMBER() OVER (
			    PARTITION BY mp.m_product_id, mpp.ad_org_id, mpl.z_type, COALESCE(depoidx, 0)
			    ORDER BY date(mpv.validfrom) DESC
			) AS rn
        FROM m_product mp
		JOIN m_productprice mpp ON mp.m_product_id = mpp.m_product_id
		JOIN M_PriceList_Version mpv ON mpp.m_pricelist_version_id = mpv.m_pricelist_version_id
        JOIN m_pricelist mpl ON mpv.m_pricelist_id = mpl.m_pricelist_id
        JOIN m_product_category mpc ON mp.m_product_category_id = mpc.m_product_category_id
        JOIN ad_org org ON mpp.ad_org_id = org.ad_org_id 
        JOIN ad_orginfo aoin ON mpp.ad_org_id = aoin.ad_org_id
        JOIN ad_orgtype ao ON aoin.ad_orgtype_id = ao.ad_orgtype_id 
        WHERE mp.ad_client_id = clientidx
        AND (CASE WHEN parentorgidx IS NOT NULL THEN
                CASE WHEN ao.name ILIKE 'PT' AND aoin.parent_org_id IS NULL THEN
                    mpp.ad_org_id = parentorgidx 
                ELSE aoin.parent_org_id = parentorgidx 
                END
            ELSE TRUE END)
        AND (
		    depoidx IS NULL 
		    OR (
		        CASE 
		            WHEN ao.name ILIKE 'PT' AND aoin.parent_org_id IS NULL THEN
		                aoin.parent_org_id = depoidx 
		            ELSE mpp.ad_org_id = depoidx 
		        END
		    )
		)
        AND (CASE WHEN prodcatidx IS NOT NULL THEN mpc.m_product_category_id = prodcatidx ELSE 1=1 END)
        AND (CASE WHEN validfromx IS NOT NULL THEN date(mpv.validfrom) <= validfromx ELSE 1=1 END)
        AND (CASE WHEN isactivex IS NOT NULL THEN mp.isactive LIKE isactivex ELSE 1=1 END)
    );

    DROP TABLE IF EXISTS DeduplicatedData;
    CREATE TEMP TABLE DeduplicatedData AS (
        SELECT 
			s.ad_client_id,
            s.org_type_id,
            s.org_level,
			CASE 
                WHEN s.org_level ILIKE 'PT' AND s.org_id_1 IS NULL THEN s.org_id_2
                ELSE s.org_id_1 
            END AS parent_org_id,
            CASE 
                WHEN s.org_level ILIKE 'PT' AND s.org_id_1 IS NULL THEN s.org_id_1
                ELSE s.org_id_2 
            END AS depoid,
            s.orgname,
           	s.pricelist_name,
            s.pricelist_v_name,
           	s.z_type,
            s.validfrom,
            s.m_product_id,
			s.prod_name,
            s.listprice,
           	s.isactive,
            s.prodcat_id,
            s.prodcat_name,
            s.rn
        FROM FilteredData s
        WHERE s.rn = 1 -- Keep only the closest date (or latest date <= the input date)
    );
	
--	drop table if exists setOrg;
--	create temp table setOrg as (
--		select
--		d.ad_client_id,
--        d.org_type_id,
--        d.org_level,
--		d.parent_org_id,
--		d.depoid,
--		CASE 
--		    WHEN d.depoid = ao.ad_org_id THEN ao.name 
--		    ELSE NULL
--		END AS depo_name,
--		d.orgname,
--       	d.pricelist_name,
--        d.pricelist_v_name,
--       	d.z_type,
--        d.validfrom,
--        d.m_product_id,
--		d.prod_name,
--        d.listprice,
--       	d.isactive,
--        d.prodcat_id,
--        d.prodcat_name,
--        d.rn
--		from DeduplicatedData d
--		join ad_org ao on ao.ad_org_id = d.depoid
--	);

    -- Loop through the filtered and deduplicated data
    FOR rec_loop IN 
        SELECT 
            t.ad_client_id,
            t.org_type_id,
            t.org_level,
            t.parent_org_id,
			t.depoid,
--			t.depo_name,
            t.orgname,
            t.pricelist_name,
            t.pricelist_v_name,
            t.z_type,
            t.validfrom,
            t.m_product_id,
			t.prod_name,
            t.listprice,
            t.isactive,
            t.prodcat_id,
			t.prodcat_name,
			t.rn
        FROM DeduplicatedData t
        ORDER BY t.validfrom DESC
    LOOP
        -- Assign values to output table columns
        ad_client_id := rec_loop.ad_client_id;
        org_type_id := rec_loop.org_type_id;
        org_level := rec_loop.org_level;
        parent_org_id := rec_loop.parent_org_id;
        depoid := rec_loop.depoid;
		depo_name := CASE 
                WHEN depoid IS NOT NULL THEN rec_loop.orgname 
                ELSE NULL 
             END;
        orgname := rec_loop.orgname;
        pricelist_name := rec_loop.pricelist_name;
        pricelist_v_name := rec_loop.pricelist_v_name;
        z_type := rec_loop.z_type;
        validfrom := rec_loop.validfrom;
        m_product_id := rec_loop.m_product_id;
		prod_name := rec_loop.prod_name;
        listprice := rec_loop.listprice;
        isactive := rec_loop.isactive;
        prodcat_id := rec_loop.prodcat_id;
		prodcat_name := rec_loop.prodcat_name;

        -- Emit the row
        RETURN NEXT;
    END LOOP;

END;
$function$;


-- insert function

--drop function z_list_tipe_pricelist_by_product_reportview_insert(int, int, int, int,timestamp without time zone,char, int);

create or replace function z_list_tipe_pricelist_by_product_reportview_insert(
	clientidx int,
	parentorgidx int,
	depoidx int,
	prodcatidx int,
	validfromx timestamp,
	isactivex char,
	usrid int
)

returns void
language plpgsql
as $function$

begin
	delete from z_list_tipe_pricelist_by_product_reportview_tbl
	where ad_client_id = clientidx;
	
	insert into z_list_tipe_pricelist_by_product_reportview_tbl (
		select
			ad_client_id,
			org_type_id,
			org_level,
			parent_org_id,
			depoid,
			depo_name,
			orgname,
			pricelist_name,
			pricelist_v_name,
			z_type,
			validfrom,
			m_product_id,
			listprice,
			isactive,
			prodcat_id,
			prodcat_name,
			usrid,
			current_timestamp 
			
		from z_ltp_bp_rv_s(
			clientidx::int,
			parentorgidx::int,
			depoidx::int,
			prodcatidx::int,
			validfromx::timestamp,
			isactivex::char
		)
	);
end;

$function$;


-- table function

--drop table z_list_tipe_pricelist_by_product_reportview_tbl;

create table z_list_tipe_pricelist_by_product_reportview_tbl (
	ad_client_id numeric(10) DEFAULT NULL::numeric NULL,
	org_type_id numeric(10) DEFAULT NULL::numeric NULL,
	org_level varchar null,
	parent_org_id numeric(10) NULL,
	depoid numeric(10) NULL,
	depo_name varchar null,
	orgname varchar null,
	pricelist_name varchar null,
	pricelist_v_name varchar null,
	z_type varchar null,
	validfrom timestamp null,
	m_product_id numeric(10) NULL,
	listprice numeric(10) NULL,
	isactive bpchar(1) default 'Y'::bpchar null,
	prodcat_id numeric(10) NULL,
	prodcat_name varchar null,
	ad_user_id numeric(10) null,
	waktu timestamp null
)


-- view function

--drop view z_ltp_by_product_rv_view;

create or replace view z_ltp_by_product_rv_view
as select 
	alias.ad_client_id,
	alias.org_type_id,
	alias.org_level,
	alias.parent_org_id,
	alias.depoid,
	alias.depo_name,
	alias.orgname,
	alias.pricelist_name,
	alias.pricelist_v_name,
	alias.z_type,
	alias.validfrom,
	alias.m_product_id,
	alias.listprice,
	alias.isactive,
	alias.prodcat_id,
	alias.prodcat_name,
	alias.ad_user_id,
	alias.waktu
	from z_list_tipe_pricelist_by_product_reportview_tbl alias;
