DROP FUNCTION IF EXISTS get_amortization_report(int, int, int, int, int, varchar, varchar, varchar, varchar);

CREATE OR REPLACE FUNCTION get_amortization_report(
    p_ad_client_id INT,
    p_ad_org_id INT,
    p_period_from_id INT,
    p_period_to_id INT,
    p_warehouse_id INT,
    p_hen_house VARCHAR(255),
    p_batch_id varchar(255),
    p_branch_type VARCHAR(255),
    p_category_name VARCHAR(255)
)
RETURNS TABLE (
    name VARCHAR(255),
    m_warehouse_id INT,
    z_hen_house VARCHAR(255),
    z_end_of_week_of_age INT,
    z_week INT,
    z_percent_left_to_amortize FLOAT,
    branchtype VARCHAR(255),
    categoryname VARCHAR(255),
    breed VARCHAR(255),
    ad_client_id INT,
    ad_org_id INT,
    periode VARCHAR(255),
    z_value_to_be_amortized INT,
    z_value_left_to_amortize INT,
    z_female_salvage_value INT,
    z_inventory_value_per_female INT,
    z_number_females_in_per_flock INT,
    z_inventory_value_of_flock INT,
    z_depletion_and_amortization INT,
    z_depletion INT,
    z_amortization INT,
    salvage_value_of_female INT,
    percent_salvage_value_of_male INT,
    adjust_salvage_value INT,
    growing_cost INT,
    value_to_be_amortize INT,
    z_date_chick_in VARCHAR(255),
    nama_pt VARCHAR(255)
) AS $$

declare
	rec_far record;
BEGIN
    FOR rec_far IN (
    	SELECT tabel.*,
				(SELECT description FROM adempiere.ad_org organ WHERE organ.ad_org_id = p_ad_org_id LIMIT 1) AS nama_pt
				from (
            		SELECT DISTINCT
				        mw.name,
				        mw.m_warehouse_id,
				        henhouse.z_hen_house,
				        amortize.z_end_of_week_of_age,
				        amortize.z_week,
				        round(amortize.z_percent_left_to_amortize, 2) as z_percent_left_to_amortize,


				        COALESCE((SELECT bt.branchtype FROM adempiere.z_rs_depl_cpjf bt WHERE bt.z_hen_house = henhouse.z_hen_house LIMIT 1),'') branchtype, --1
				        COALESCE((SELECT cg.categoryname FROM adempiere.z_rs_depl_cpjf cg WHERE cg.z_hen_house = henhouse.z_hen_house LIMIT 1),'') categoryname, --1
				        COALESCE((SELECT br.breed FROM adempiere.z_rs_depl_cpjf br WHERE br.z_hen_house = henhouse.z_hen_house LIMIT 1),'') breed, --1
				
				
				        coalesce((select coalesce(zdv.ad_client_id,0) --2
				        from z_rs_depl_cpjf zdv where zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as AD_Client_ID,
				
				        coalesce((select coalesce(zdv.ad_org_id,0)--2
				        from z_rs_depl_cpjf zdv where zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as AD_Org_ID,
				
				        (select coalesce(cp.name,null)
				        from z_rs_depl_cpjf zdv
				        inner join adempiere.c_period cp on cp.c_period_id = zdv.c_period_id
				        where zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id)
				        LIMIT 1) as periode,
				
				
				        coalesce((select coalesce(zdv.z_value_to_be_amortized,0)
				        from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as z_value_to_be_amortized,
				
				        coalesce((select coalesce(zdv.z_value_left_to_amortize,0) --2
				        from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as z_value_left_to_amortize,
				
				        coalesce((select coalesce(zdv.z_female_salvage_value,0)--2
				        from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as z_female_salvage_value,
				
				        coalesce((select coalesce (zdv.z_inventory_value_per_female,0)--2
				        from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as z_inventory_value_per_female,
				
				        coalesce((select coalesce(zdv.z_number_females_in_per_flock,0)--2
				        from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as z_number_females_in_per_flock,
				
				        coalesce((select coalesce(zdv.z_inventory_value_of_flock,0)--2
				        from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as z_inventory_value_of_flock,
				
				        coalesce((select coalesce(zdv.z_depletion_and_amortization,0)--2
				        from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as z_depletion_and_amortization,
				
				        coalesce((select coalesce(zdv.z_depletion,0)--2
				        from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as z_depletion,
				
				        coalesce((select coalesce(zdv.z_amortization,0)--2
				        from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
				        and zdv.ad_client_id = p_ad_client_id and zdv.ad_org_id = p_ad_org_id
				        and zdv.c_period_id in (select c_period_id from c_period where c_period_id between p_period_from_id and p_period_to_id) LIMIT 1),0) as z_amortization,
				
				        cast((select z_salvage_value_of_female from Z_Salvage_Value_PSGP psgp --3
				        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
				        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
				        AND psgp.ad_org_id = p_ad_org_id
				        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2))
				        as salvage_value_of_female,
				
				        cast((select z_salvage_value_of_male from Z_Salvage_Value_PSGP psgp --3
				        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
				        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
				        AND psgp.ad_org_id = p_ad_org_id
				        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2))
				        as percent_salvage_value_of_male,
				
				         cast((select z_salvage_value_of_female from Z_Salvage_Value_PSGP psgp --3
				        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
				        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
				        AND psgp.ad_org_id = p_ad_org_id
				        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2))
				        +
				         cast((select z_salvage_value_of_male from Z_Salvage_Value_PSGP psgp --3
				        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
				        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
				        AND psgp.ad_org_id = p_ad_org_id
				        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2))
				        as adjust_salvage_value,
				
				        cast((select coalesce (z_total_cost_at_wp,0) from z_rs_wp1_cpjf zwop --4
				        where  zwop.z_hen_house = henhouse.z_hen_house AND zwop.batchid = wofp.batchid) /
				        (select coalesce (z_qty_female_wp ,0) from z_rs_wp1_cpjf zwop
				        where  zwop.z_hen_house = henhouse.z_hen_house AND  zwop.batchid = wofp.batchid) as decimal (10,2))
				        as Growing_Cost,
				
				
				        cast((select coalesce (z_total_cost_at_wp,0) from z_rs_wp1_cpjf zwop -- Growing_Cost
				        where  zwop.z_hen_house = henhouse.z_hen_house AND zwop.batchid = wofp.batchid) /
				        (select coalesce (z_qty_female_wp ,0) from z_rs_wp1_cpjf zwop
				        where  zwop.z_hen_house = henhouse.z_hen_house AND zwop.batchid = wofp.batchid) as decimal (10,2))
				
				        -
				
				        (cast((select z_salvage_value_of_female from Z_Salvage_Value_PSGP psgp -- (adjust_salvage_value)
				        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
				        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
				        AND psgp.ad_org_id = p_ad_org_id
				        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2))
				        +
				         cast((select z_salvage_value_of_male from Z_Salvage_Value_PSGP psgp 
				        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
				        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
				        AND psgp.ad_org_id = p_ad_org_id
				        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2)))
				        as Value_to_be_amortize,
				
				        wofp.z_date_chick_in
				
				        from adempiere.z_rs_depl_cpjf amortize
				        inner join (SELECT *, left(m_warehouse.value,3) AS penghubung FROM adempiere.m_warehouse)mw on mw.penghubung = amortize.z_farm_code
				        LEFT JOIN adempiere.z_rs_wp1_cpjf wofp ON amortize.z_hen_house = wofp.z_hen_house
				        INNER JOIN (SELECT value AS z_hen_house,
				                        p_warehouse_id AS ware
				                        from M_Locator
				                        where M_Locator.M_Warehouse_ID=(select mw1.m_warehouse_id
				                        from m_warehouse mw1
				                        where left(mw1.value,3) = (select left(mw.value,3)
				                                                            from m_warehouse mw
				                                                            where mw.m_warehouse_id = p_warehouse_id)
				                        AND LOWER(mw1.name) LIKE '%kandang')) henhouse ON henhouse.ware = mw.m_warehouse_id AND amortize.z_hen_house = henhouse.z_hen_house
				
				
				        WHERE mw.M_Warehouse_ID = p_warehouse_id
				        AND (CASE WHEN (SELECT value as z_hen_house FROM M_Locator WHERE value =
				        p_hen_house LIMIT 1) IS NOT NULL
				                    THEN henhouse.z_hen_house = p_hen_house
				                    ELSE 1 = 1
				            END)
				       AND (CASE WHEN (SELECT batchid FROM z_rs_wp1_cpjf WHERE batchid = p_batch_id LIMIT 1) IS NOT NULL
				            THEN wofp.batchid = p_batch_id
				            ELSE wofp.batchid = (SELECT zrwc.batchid FROM z_rs_wp1_cpjf zrwc WHERE zrwc.z_hen_house = wofp.z_hen_house AND zrwc.ad_org_id = p_ad_org_id ORDER BY zrwc.z_year DESC LIMIT 1)
				    		END)
				        order by henhouse.z_hen_house,amortize.z_week
         )tabel
        WHERE
        tabel.branchtype LIKE (CASE WHEN p_branch_type IS NOT NULL THEN p_branch_type ELSE '%' END)
        AND tabel.categoryname LIKE (CASE WHEN p_category_name IS NOT NULL THEN p_category_name ELSE '%' END)
    ) loop
       	name := rec_far.name;
	    m_warehouse_id := rec_far.m_warehouse_id;
	    z_hen_house := rec_far.z_hen_house;
	    z_end_of_week_of_age := rec_far.z_end_of_week_of_age;
	    z_week := rec_far.z_week;
	    z_percent_left_to_amortize := rec_far.z_percent_left_to_amortize;
	    branchtype := rec_far.branchtype; 
	    categoryname := rec_far.categoryname;
	    breed := rec_far.breed; 
	    ad_client_id := rec_far.ad_client_id;
	    ad_org_id := rec_far.ad_org_id;
	    periode := rec_far.periode; 
	    z_value_to_be_amortized := rec_far.z_value_to_be_amortized;
	    z_value_left_to_amortize := rec_far.z_value_left_to_amortize;
	    z_female_salvage_value := rec_far.z_female_salvage_value;
	    z_inventory_value_per_female := rec_far.z_inventory_value_per_female;
	    z_number_females_in_per_flock := rec_far.z_number_females_in_per_flock;
	    z_inventory_value_of_flock := rec_far.z_inventory_value_of_flock;
	    z_depletion_and_amortization := rec_far.z_depletion_and_amortization;
	    z_depletion := rec_far.z_depletion;
	    z_amortization := rec_far.z_amortization;
	    salvage_value_of_female := rec_far.salvage_value_of_female;
	    percent_salvage_value_of_male := rec_far.percent_salvage_value_of_male;
	    adjust_salvage_value := rec_far.adjust_salvage_value;
	    growing_cost := rec_far.growing_cost;
	    value_to_be_amortize := rec_far.value_to_be_amortize;
	    z_date_chick_in := rec_far.z_date_chick_in;
	    nama_pt := rec_far.nama_pt;
      	
	   return next;
    END LOOP;
END;

$$ LANGUAGE plpgsql;
