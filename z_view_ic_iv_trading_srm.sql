--drop function z_view_ic_iv_trading_srm();

create or replace function z_view_ic_iv_trading_srm()

returns table (
	ad_client_id integer,
	ad_org_id integer,
	c_bpartner_id integer,
	vendor_code varchar(155),
	vendor_name varchar(155),
	company_code varchar(155),
	company_name varchar(155),
	ic_no varchar(155),
	dateinvoiced timestamp without time zone,
	z_fakturpajakno varchar(155),
	payment_term varchar(155),
	order_reference varchar(155),
	iv_no varchar(155),
	qtyinvoiced numeric,
	priceactual numeric,
	taxamt numeric,
	grandtotal numeric
)

language plpgsql
as $function$
declare rec_loop record;

begin

	drop table if exists viewheader;
	create temp table viewheader as (
		select
			cd.c_doctype_id ,
			cd.name as doctype,
			ci.docstatus,
			ci.ad_client_id,
			ci.ad_org_id,
			ci.c_bpartner_id,
			cb.value as vendor_code,
			cb.name as vendor_name,
			cb.value as company_code,
			cb.name as company_name,
			ci.documentno as ic_no,
			ci.dateinvoiced,
			ci.z_fakturpajakno,
			ci.c_paymentterm_id,
			cp.name as payment_term,
			ci.m_pricelist_id
		from c_invoice ci
		join c_bpartner cb on cb.c_bpartner_id = ci.c_bpartner_id
		join ad_org ao on ao.ad_org_id = ci.ad_org_id 
		join c_doctype cd on cd.c_doctype_id = ci.c_doctype_id 
		join c_paymentterm cp on cp.c_paymentterm_id = ci.c_paymentterm_id 
		where ci.docstatus ilike 'CO'
		and cd.name ilike '%trading%'
		and ci.documentno ilike 'IC%'
	);

	drop table if exists viewdetail;
	create temp table viewdetail as (
		select
			ci.ad_org_id,
			ci.poreference as order_reference,
			ci.documentno as iv_no,
			cil.qtyinvoiced,
			cil.priceactual,
			cil.taxamt,
			ci.grandtotal,
			ci.m_pricelist_id
		from c_invoice ci
		join C_InvoiceLine cil on ci.c_invoice_id = cil.c_invoice_id
		where ci.documentno ilike 'IV%'
	);
	
	for rec_loop in
		select
			h.c_doctype_id ,
			h.doctype,
			h.docstatus,
			h.ad_client_id,
			h.ad_org_id,
			h.c_bpartner_id,
			h.vendor_code,
			h.vendor_name,
			h.company_code,
			h.company_name,
			h.ic_no,
			h.dateinvoiced,
			h.z_fakturpajakno,
			h.c_paymentterm_id,
			h.payment_term,
			d.order_reference,
			d.iv_no,
			d.qtyinvoiced,
			d.priceactual,
			d.taxamt,
			d.grandtotal
		from viewheader h
		join viewdetail d on h.m_pricelist_id = d.m_pricelist_id
	loop 	
		ad_client_id := rec_loop.ad_client_id;
		ad_org_id := rec_loop.ad_org_id;
		c_bpartner_id := rec_loop.c_bpartner_id;
		vendor_code := rec_loop.vendor_code;
		vendor_name := rec_loop.vendor_name;
		company_code := rec_loop.company_code;
		company_name := rec_loop.company_name;
		ic_no := rec_loop.ic_no;
		dateinvoiced := rec_loop.dateinvoiced;
		z_fakturpajakno := rec_loop.z_fakturpajakno;
		payment_term := rec_loop.payment_term;
		order_reference := rec_loop.order_reference;
		iv_no := rec_loop.iv_no;
		qtyinvoiced := rec_loop.qtyinvoiced;
		priceactual := rec_loop.priceactual;
		taxamt := rec_loop.taxamt;
		grandtotal := rec_loop.grandtotal;
	
		return next;
	end loop;
	
end;
$function$;




