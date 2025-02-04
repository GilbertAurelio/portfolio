DROP FUNCTION z_ikb_active_rent_contracts(integer,integer,TIMESTAMP,integer);

CREATE OR REPLACE FUNCTION adempiere.z_ikb_active_rent_contracts(
    client_idx INTEGER,
    organization_idx INTEGER,
    date_to TIMESTAMP,
    b_partner_idx INTEGER
)
RETURNS TABLE(    
    "No." INTEGER,
    "No. Pol" VARCHAR(255),
    "Status (Own/Rent)" VARCHAR(50),
    "Code" VARCHAR(255),
    "Name" VARCHAR(255),
    "Date Start" DATE,
    "Date End" DATE,
    "Months" INTEGER,
    "Months_<=12" INTEGER,
    "Months_13_24" INTEGER,
    "Months_25_36" INTEGER,
    "Months_>36" INTEGER,
    "Remaining Months" INTEGER,
    "Remaining_<=12" INTEGER,
    "Remaining_13_24" INTEGER,
    "Remaining_25_36" INTEGER,
    "Remaining_>36" INTEGER,
    "Actual" DATE,
    "Target" DATE,
    "Contract" VARCHAR(50),
    "Invoice" VARCHAR(50)
)
LANGUAGE plpgsql
AS $function$
DECLARE
    rec_far RECORD;
    target_date DATE;
    counter INTEGER := 0;
BEGIN
    FOR rec_far IN (
        WITH project_data AS (
            SELECT 
                aa.serno::VARCHAR(255) AS "No. Pol",
                CASE 
                    WHEN aa.isowned = 'Y' THEN 'Own'
                    ELSE 'Rent'
                END::VARCHAR(50) AS "Status (Own/Rent)",
                cb.value::VARCHAR(255) AS "Code",
                cb.name::VARCHAR(255) AS "Name",
                  cp.datecontract::DATE AS "Date Start",
                cp.datefinish::DATE AS "Date End",
                cp.plannedQty AS "Months",
                cp.plannedQty - (DATE_PART('year', AGE(date_to, cp.datecontract)) * 12 +
                        DATE_PART('month', AGE(date_to, cp.datecontract)))::INTEGER AS "Remaining Months",
                ci.dateinvoiced AS "Actual",
                ROW_NUMBER() OVER (PARTITION BY cp.c_project_id ORDER BY ci.dateinvoiced DESC) AS rn
            FROM 
                adempiere.c_project cp 
            INNER JOIN 
                adempiere.a_asset aa ON cp.a_asset_id = aa.a_asset_id
            LEFT JOIN 
                adempiere.c_bpartner cb ON cp.c_bpartner_id = cb.c_bpartner_id
            LEFT JOIN 
                adempiere.c_invoice ci ON ci.c_project_id = cp.c_project_id AND ci.docstatus = 'CO' AND ci.c_doctypetarget_id = 1000462
            WHERE 
                cp.ad_client_id = client_idx
                AND cp.ad_org_id = organization_idx
                AND cp.docstatus = 'CO'
                AND (date_to IS NULL OR cp.created <= date_to)
                AND (b_partner_idx IS NULL OR cp.c_bpartner_id = b_partner_idx)
        )
        SELECT 
            pd."No. Pol",
            pd."Status (Own/Rent)",
            pd."Code",
            pd."Name",
            pd."Date Start",
            pd."Date End",
            pd."Months",
            pd."Remaining Months",
            pd."Actual"
        FROM 
            project_data pd
        WHERE
            pd.rn = 1
    ) LOOP
        counter := counter + 1;
        "No." := counter;

        "No. Pol" := rec_far."No. Pol";
        "Status (Own/Rent)" := rec_far."Status (Own/Rent)";
        "Code" := rec_far."Code";
        "Name" := rec_far."Name";
        "Date Start" := rec_far."Date Start";
        "Date End" := rec_far."Date End";
        "Months" := rec_far."Months";
        "Remaining Months" := rec_far."Remaining Months";
        "Actual" := rec_far."Actual";
        target_date := (DATE_TRUNC('month', NOW()) + (EXTRACT(day FROM rec_far."Date Start") - 1) * INTERVAL '1 day')::DATE;
        "Target" := target_date;

        IF rec_far."Months" <= 12 THEN
            "Months_<=12" := rec_far."Months";
        ELSE
            "Months_<=12" := NULL;
        END IF;

        IF rec_far."Months" > 12 AND rec_far."Months" <= 24 THEN
            "Months_13_24" := rec_far."Months";
        ELSE
            "Months_13_24" := NULL;
        END IF;

        IF rec_far."Months" > 24 AND rec_far."Months" <= 36 THEN
            "Months_25_36" := rec_far."Months";
        ELSE
            "Months_25_36" := NULL;
        END IF;

        IF rec_far."Months" > 36 THEN
            "Months_>36" := rec_far."Months";
        ELSE
            "Months_>36" := NULL;
        END IF;

        IF rec_far."Remaining Months" <= 12 THEN
            "Remaining_<=12" := rec_far."Remaining Months";
        ELSE
            "Remaining_<=12" := NULL;
        END IF;

        IF rec_far."Remaining Months" > 12 AND rec_far."Remaining Months" <= 24 THEN
            "Remaining_13_24" := rec_far."Remaining Months";
        ELSE 
            "Remaining_13_24" := NULL;
        END IF;

        IF rec_far."Remaining Months" > 24 AND rec_far."Remaining Months" <= 36 THEN
            "Remaining_25_36" := rec_far."Remaining Months";
        ELSE
            "Remaining_25_36" := NULL;
        END IF;

        IF rec_far."Remaining Months" > 36 THEN
            "Remaining_>36" := rec_far."Remaining Months";
        ELSE
            "Remaining_>36" := NULL;
        END IF;

        IF rec_far."Date End" <= date_to THEN
            "Contract" := 'WARNING RENEW CONTRACT';
        ELSE
            "Contract" := 'OK';
        END IF;

        IF rec_far."Actual" < target_date THEN
            "Invoice" := 'WARNING LATE INVOICE';
        ELSE
            "Invoice" := 'OK';
        END IF;

        RETURN NEXT;
    END LOOP;
END;
$function$;

drop table if exists adempiere.z_tbl_ikb_active_rent_contracts;

CREATE TABLE adempiere.z_tbl_ikb_active_rent_contracts (
    "No." INTEGER,
    "No. Pol" VARCHAR(255),
    "Status (Own/Rent)" VARCHAR(50),
    "Code" VARCHAR(255),
    "Name" VARCHAR(255),
    "Date Start" DATE,
    "Date End" DATE,
    "Months" INTEGER,
    "Months_<=12" INTEGER,
    "Months_13_24" INTEGER,
    "Months_25_36" INTEGER,
    "Months_>36" INTEGER,
    "Remaining Months" INTEGER,
    "Remaining_<=12" INTEGER,
    "Remaining_13_24" INTEGER,
    "Remaining_25_36" INTEGER,
    "Remaining_>36" INTEGER,
    "Actual" DATE,
    "Target" DATE,
    "Contract" VARCHAR(50),
    "Invoice" VARCHAR(50),
    "ad_client_id" INTEGER,
    "ad_org_id" INTEGER,
    "date_to" DATE,
    "c_bpartner_id" INTEGER,
    "ad_user_id" INTEGER,
    "Timestamp" TIMESTAMP
);

DROP FUNCTION IF EXISTS adempiere.z_insert_ikb_active_rent_contracts;


CREATE OR REPLACE FUNCTION adempiere.z_insert_ikb_active_rent_contracts(
    client_idx INTEGER,
    organization_idx INTEGER,
    date_to TIMESTAMP,
    b_partner_idx INTEGER,
    user_id INTEGER
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
    rec RECORD;
BEGIN
    
    DELETE FROM adempiere.z_tbl_ikb_active_rent_contracts;

    
    FOR rec IN
        SELECT * FROM adempiere.z_ikb_active_rent_contracts(client_idx, organization_idx, date_to, b_partner_idx)
    LOOP
        INSERT INTO adempiere.z_tbl_ikb_active_rent_contracts (
            "No.", "No. Pol", "Status (Own/Rent)", "Code", "Name", "Date Start", "Date End", 
            "Months", "Months_<=12", "Months_13_24", "Months_25_36", "Months_>36", 
            "Remaining Months", "Remaining_<=12", "Remaining_13_24", "Remaining_25_36", 
            "Remaining_>36", "Actual", "Target", "Contract", "Invoice", "ad_client_id", "ad_org_id","date_to" ,"c_bpartner_id" ,"ad_user_id", "Timestamp"
        ) VALUES (
            rec."No.", rec."No. Pol", rec."Status (Own/Rent)", rec."Code", rec."Name", rec."Date Start", 
            rec."Date End", rec."Months", rec."Months_<=12", rec."Months_13_24", rec."Months_25_36", 
            rec."Months_>36", rec."Remaining Months", rec."Remaining_<=12", rec."Remaining_13_24", 
            rec."Remaining_25_36", rec."Remaining_>36", rec."Actual", rec."Target", rec."Contract", 
            rec."Invoice",client_idx, organization_idx, date_to, b_partner_idx, user_id, current_timestamp
        );
    END LOOP;
END;
$function$;


select * from adempiere.z_ikb_active_rent_contracts(1000006, 1001083, '2024-07-06'::timestamp, 1024539);

SELECT adempiere.z_insert_ikb_active_rent_contracts(1000006, 1001083, '2024-07-06'::timestamp, 1024539, 1);

select * from adempiere.z_tbl_ikb_active_rent_contracts;