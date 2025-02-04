-- select
 DROP FUNCTION adempiere.z_srti_select_f(int4, int4, timestamp, timestamp, int4, int4);

CREATE OR REPLACE FUNCTION adempiere.z_srti_select_f(
	clientidx integer, 
	ad_org_idx integer, 
	datefromx timestamp without time zone, 
	datetox timestamp without time zone, 
	customer_codex integer, 
	product_valx integer
)

 RETURNS TABLE(
 	c_order_id integer,
	ad_client_id integer,
	ad_org_id integer,
	documentno varchar(255),
	dateordered varchar(255),
	do_date varchar(255),
	do_doc varchar(255),
	invoice_date varchar(255),
	invoice_date_param timestamp,
	invoice_doc varchar(255),
	c_bpartner_id integer,
	bpartner varchar(255),
	bpgroup varchar(225),
	c_bpartner_location_id integer,
	bpartner_location varchar(255),
	bpartnershipto varchar(255),
	invoicelocation varchar(255),
	m_warehouse_id integer,
	warehouse varchar(255),
	user1_id integer,
	cost_center varchar(255),
	product_value varchar(255),
	m_product_id integer,
	product varchar(255),
	linenetamt numeric,
	taxamt numeric,
	docstatus varchar(255),
	c_doctypetarget_id integer,
	doctype varchar(255),
	qty integer,
	uom varchar(255),
	datepromised varchar(255),
	listprice numeric, 
	netprice numeric,
	diskon numeric,
	grossamt numeric,
	discountamt numeric,
	no_faktur_pajak varchar(255)
)
 	
 LANGUAGE plpgsql
AS $function$

declare 
	rec_loop record;
	
begin
	for rec_loop in (
		SELECT co.c_order_id,
		    co.ad_client_id,
		    ao2.ad_org_id,
		    co.documentno,
			TO_CHAR(co.dateordered :: date,'DD-MM-YYYY') as dateordered,
			TO_CHAR(io.movementdate ::date,'DD-MM-YYYY') as do_date,
		    io.documentno as do_doc,
			TO_CHAR(ic.dateinvoiced :: DATE,'DD-MM-YYYY') as invoice_date,
			date(ic.dateinvoiced) as invoice_date_param,
			ic.documentno as invoice_doc,
			co.c_bpartner_id,
		    cb.name AS bpartner,
		    cbg.name AS bpgroup,
		    co.bill_location_id AS c_bpartner_location_id,
		    cbl.name AS bpartner_location,
		    cb2.name AS bpartnershipto,
		    cbl2.name AS invoicelocation,
		    co.m_warehouse_id,
		    mw.name AS warehouse,
		    co.user1_id,
		    ce.name AS cost_center,
			mp.value as product_value,
		    col.m_product_id,
		        CASE
		            WHEN mp.name IS NULL THEN '-'::character varying
		            ELSE mp.name
		        END AS product,
		    col.linenetamt,
		    col.taxamt,
		    co.docstatus,
		    co.c_doctypetarget_id,
		    cd.name AS doctype,
		--    ( SELECT cp.c_period_id
		--           FROM adempiere.c_period cp
		--             JOIN adempiere.ad_org ao ON ao.ad_org_id = co.ad_org_id
		--             JOIN adempiere.ad_orginfo aof ON aof.ad_org_id = ao.ad_org_id
		--             JOIN adempiere.ad_org ao2 ON ao2.ad_org_id = aof.parent_org_id
		--          WHERE cp.ad_client_id = co.ad_client_id AND cp.ad_org_id = ao2.ad_org_id AND co.datepromised >= cp.startdate AND co.datepromised <= cp.enddate) AS c_period_id,
		        CASE
		            WHEN cd.name::text = ANY (ARRAY['SO DOC FS'::character varying::text, 'SO DOC FS Trading'::character varying::text, 'SO HE'::character varying::text, 'SO NPS'::character varying::text, 'SO DOC EXPORT'::character varying::text, 'SO Local'::character varying::text]) THEN col.qtyentered
		            WHEN cd.name::text = ANY (ARRAY['SO VMD'::character varying::text, 'SO NONHE'::character varying::text, 'SO OTHERS'::character varying::text]) THEN col.qtyentered2
		            WHEN cd.name::text = 'SO SPPA'::text THEN col.z_qty_kg
		            ELSE col.qtyentered2
		        END AS qty,
		    cu.name AS uom,
		    TO_CHAR(co.datepromised :: date,'DD-MM-YYYY') as datepromised,
		    col.pricelist AS listprice,
		    col.priceentered AS netprice,
		    col.discountamt AS diskon,
		    col.pricelist * col.qtyentered AS grossamt,
		    col.discountamt * col.qtyentered AS discountamt,
			fp.z_no_fakturpajak as no_faktur_pajak
		   FROM adempiere.c_order co
		     LEFT JOIN adempiere.c_orderline col ON col.c_order_id = co.c_order_id
		     JOIN adempiere.c_doctype cd ON cd.c_doctype_id = co.c_doctypetarget_id
		     JOIN adempiere.c_bpartner cb ON cb.c_bpartner_id = co.c_bpartner_id
		     LEFT JOIN adempiere.c_bp_group cbg ON cbg.c_bp_group_id = cb.c_bp_group_id
		     JOIN adempiere.c_bpartner cb2 ON cb2.c_bpartner_id = co.bill_bpartner_id
		     JOIN adempiere.c_bpartner_location cbl ON cbl.c_bpartner_location_id = co.c_bpartner_location_id
		     JOIN adempiere.c_bpartner_location cbl2 ON cbl2.c_bpartner_location_id = co.bill_location_id
		     JOIN adempiere.m_warehouse mw ON mw.m_warehouse_id = co.m_warehouse_id
		     JOIN adempiere.c_elementvalue ce ON ce.c_elementvalue_id = co.user1_id
		     LEFT JOIN adempiere.m_product mp ON mp.m_product_id = col.m_product_id
		     LEFT JOIN adempiere.c_uom cu ON cu.c_uom_id =
		        CASE
		            WHEN cd.name::text = ANY (ARRAY['SO FEED'::character varying::text, 'SO VMD'::character varying::text, 'SO NONHE'::character varying::text, 'SO OTHERS'::character varying::text]) THEN col.x_uom_id
		            ELSE col.c_uom_id
		        end
		     join ad_org ao on ao.ad_org_id = co.ad_org_id
		   	 JOIN ad_orginfo aof ON aof.ad_org_id = ao.ad_org_id
		   	 JOIN ad_org ao2 ON ao2.ad_org_id = aof.parent_org_id
		   	 left join adempiere.M_InOut io on io.c_order_id = co.c_order_id
			 left join adempiere.C_Invoice ic on ic.c_order_id = co.c_order_id
			 left join adempiere. Z_FakturPajak_Header fp on fp.Z_FakturPajak_Header_ID = ic.z_fakturpajak_header_id
		  WHERE (co.c_doctypetarget_id IN ( SELECT cdd.c_doctype_id
		           FROM adempiere.c_doctype cdd
		          WHERE cdd.name::text = ANY (ARRAY['SO DOC FS'::character varying::text, 'SO DOC FS Trading'::character varying::text, 'SO DOC PS Trading'::character varying::text, 'SO HE'::character varying::text, 'SO NONHE'::character varying::text, 'SO SPPA'::character varying::text, 'SO NPS'::character varying::text, 'SO FEED'::character varying::text, 'SO VMD'::character varying::text, 'SO Others'::character varying::text, 'SO DOC PS'::character varying::text, 'SO DOC EXPORT'::character varying::text, 'SO Local'::character varying::text])))
		  and co.ad_client_id = clientidx
		AND (CASE WHEN ad_org_idx is not null THEN ao2.ad_org_id = ad_org_idx ELSE 1 = 1 END)
		and (case when datefromx is not null then date(ic.dateinvoiced) >= datefromx else 1=1 end)
		and (case when datetox is not null then date(ic.dateinvoiced) <= datetox else 1=1 end)
		and (case when customer_codex is not null then co.c_bpartner_id = customer_codex else 1=1 end)
		and (case when product_valx is not null then col.m_product_id = product_valx else 1=1 end)
		  ORDER BY co.documentno
	)
	
	loop
		c_order_id := rec_loop.c_order_id;
		ad_client_id := rec_loop.ad_client_id;
		ad_org_id := rec_loop.ad_org_id;
		documentno := rec_loop.documentno;
		dateordered := rec_loop.dateordered;
		do_date := rec_loop.do_date;
		do_doc := rec_loop.do_doc;
		invoice_date := rec_loop.invoice_date;
		invoice_date_param := rec_loop.invoice_date_param;
		invoice_doc := rec_loop.invoice_doc;
		c_bpartner_id := rec_loop.c_bpartner_id;
		bpartner := rec_loop.bpartner;
		bpgroup := rec_loop.bpgroup;
		c_bpartner_location_id := rec_loop.c_bpartner_location_id;
		bpartner_location := rec_loop.bpartner_location;
		bpartnershipto := rec_loop.bpartnershipto;
		invoicelocation := rec_loop.invoicelocation;
		m_warehouse_id := rec_loop.m_warehouse_id;
		warehouse := rec_loop.warehouse;
		user1_id := rec_loop.user1_id;
		cost_center := rec_loop.cost_center;
		product_value := rec_loop.product_value;
		m_product_id := rec_loop.m_product_id;
		product := rec_loop.product;
		linenetamt := rec_loop.linenetamt;
		taxamt := rec_loop.taxamt;
		docstatus := rec_loop.docstatus;
		c_doctypetarget_id := rec_loop.c_doctypetarget_id;
		doctype := rec_loop.doctype;
		qty := rec_loop.qty;
		uom := rec_loop.uom;
		datepromised := rec_loop.datepromised;
		listprice := rec_loop.listprice;
		netprice := rec_loop.netprice;
		diskon := rec_loop.diskon;
		grossamt := rec_loop.grossamt;
		discountamt := rec_loop.discountamt;
		no_faktur_pajak := rec_loop.no_faktur_pajak;
		
		return next;
	end loop;
	
end;
$function$
;


-- insert

 DROP FUNCTION adempiere.z_srti_insert_f(int4, int4, timestamp, timestamp, int4, int4, int4);

CREATE OR REPLACE FUNCTION adempiere.z_srti_insert_f(clientidx integer, ad_org_idx integer, datefromx timestamp without time zone, datetox timestamp without time zone, customer_codex integer, product_valx integer, usrid integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

begin
-- Function untuk reportview Sales Report Tanindo Intertraco by: Gilbert 18/09/24

	delete from z_srti_tbl
	where ad_client_id = clientidx;

	 
	insert into z_srti_tbl (
		select
			c_order_id,
			ad_client_id,
			ad_org_id,
			documentno,
			dateordered,
			do_date,
			do_doc,
			invoice_date,
			invoice_date_param,
			invoice_doc,
			c_bpartner_id,
			bpartner,
			bpgroup,
			c_bpartner_location_id,
			bpartner_location,
			bpartnershipto,
			invoicelocation,
			m_warehouse_id,
			warehouse,
			user1_id,
			cost_center,
			product_value,
			m_product_id,
			product,
			linenetamt,
			taxamt,
			docstatus,
			c_doctypetarget_id,
			doctype,
			qty,
			uom,
			datepromised,
			listprice,
			netprice,
			diskon,
			grossamt,
			discountamt,
			no_faktur_pajak,
	       	usrid,
			current_timestamp 
		
		from z_srti_select_f(clientidx::integer, ad_org_idx::integer, datefromx::date, datetox::date, customer_codex::integer, product_valx::integer)
	);
end;
$function$
;


-- table

-- adempiere.z_srti_tbl definition

-- Drop table

 DROP TABLE adempiere.z_srti_tbl;

CREATE TABLE adempiere.z_srti_tbl (
	c_order_id numeric null,
	ad_client_id numeric(10) DEFAULT NULL::numeric NULL,
	ad_org_id numeric(10) DEFAULT NULL::numeric NULL,
	documentno varchar null,
	dateordered varchar null,
	do_date varchar null,
	do_doc varchar null,
	invoice_date varchar null,
	invoice_date_param timestamp null,
	invoice_doc varchar null,
	c_bpartner_id numeric null,
	bpartner varchar null,
	bpgroup varchar null,
	c_bpartner_location_id numeric null,
	bpartner_location varchar null,
	bpartnershipto varchar null,
	invoicelocation varchar null,
	m_warehouse_id numeric null,
	warehouse varchar null,
	user1_id numeric null,
	cost_center varchar null,
	product_value varchar null,
	m_product_id numeric null,
	product varchar null,
	linenetamt numeric,
	taxamt numeric,
	docstatus varchar null,
	c_doctypetarget_id numeric null,
	doctype varchar null,
	qty numeric null,
	uom varchar null,
	datepromised varchar null,
	listprice numeric null,
	netprice numeric null,
	diskon numeric null,
	grossamt numeric null,
	discountamt numeric null,
	no_faktur_pajak varchar null,
	ad_user_id numeric(10) NULL,
	waktu timestamp NULL
);

-- view

-- adempiere.z_srti_view source

drop view z_srti_view;

CREATE OR REPLACE VIEW adempiere.z_srti_view
AS SELECT 
	alias.c_order_id,
	alias.ad_client_id,
	alias.ad_org_id,
	alias.documentno,
	alias.dateordered,
	alias.do_date,
	alias.do_doc,
	alias.invoice_date,
	alias.invoice_date_param,
	alias.invoice_doc,
	alias.c_bpartner_id,
	alias.bpartner,
	alias.bpgroup,
	alias.c_bpartner_location_id,
	alias.bpartner_location,
	alias.bpartnershipto,
	alias.invoicelocation,
	alias.m_warehouse_id,
	alias.warehouse,
	alias.user1_id,
	alias.cost_center,
	alias.product_value,
	alias.m_product_id,
	alias.product,
	alias.linenetamt,
	alias.taxamt,
	alias.docstatus,
	alias.c_doctypetarget_id,
	alias.doctype,
	alias.qty,
	alias.uom,
	alias.datepromised,
	alias.listprice,
	alias.netprice,
	alias.diskon,
	alias.grossamt,
	alias.discountamt,
	alias.no_faktur_pajak,
    alias.ad_user_id,
    alias.waktu
   FROM z_srti_tbl alias;