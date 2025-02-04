SELECT DISTINCT
name AS branch_name,
m_warehouse_id,
z_hen_house,
z_end_of_week_of_age,
z_week,
z_percent_left_to_amortize,
periode,

z_number_females_in_per_flock,
z_inventory_value_of_flock,
z_depletion_and_amortization,
z_depletion,
z_amortization,
salvage_value_of_female,
percent_salvage_value_of_male,
adjust_salvage_value,
growing_cost,
value_to_be_amortize,

round(((z_percent_left_to_amortize/100) * value_to_be_amortize),2) as value_left_to_be_amortized,


(round(((z_percent_left_to_amortize/100) * value_to_be_amortize),2))+adjust_salvage_value as inventory_value_female,

z_layout

from
(SELECT DISTINCT
mw.name,
mw.m_warehouse_id,
henhouse.z_hen_house,
wa.z_end_of_week_of_age,
wa.z_week,
wa.z_percent_left_to_amortize as z_percent_left_to_amortize,
COALESCE((SELECT bt.branchtype FROM adempiere.z_rs_depl_cpjf bt WHERE bt.z_hen_house = henhouse.z_hen_house LIMIT 1),'') branchtype,
COALESCE((SELECT cg.categoryname FROM adempiere.z_rs_depl_cpjf cg WHERE cg.z_hen_house = henhouse.z_hen_house LIMIT 1),'') categoryname,
COALESCE((SELECT br.breed FROM adempiere.z_rs_depl_cpjf br WHERE br.z_hen_house = henhouse.z_hen_house LIMIT 1),'') breed,


coalesce((select coalesce(zdv.ad_client_id,0)
from z_rs_depl_cpjf zdv where zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as AD_Client_ID,

coalesce((select coalesce(zdv.ad_org_id,0)
from z_rs_depl_cpjf zdv where zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as AD_Org_ID,

(select coalesce(cp.name,null)
from z_rs_depl_cpjf zdv
inner join adempiere.c_period cp on cp.c_period_id = zdv.c_period_id
where zdv.z_week = wa.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid

and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID})
LIMIT 1 ) as periode,


coalesce((select coalesce(zdv.z_value_to_be_amortized,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_value_to_be_amortized,

coalesce((select coalesce(zdv.z_value_left_to_amortize,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_value_left_to_amortize,

coalesce((select coalesce(zdv.z_female_salvage_value,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_female_salvage_value,

coalesce((select coalesce (zdv.z_inventory_value_per_female,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = amortize.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_inventory_value_per_female,

coalesce((select coalesce(zdv.z_number_females_in_per_flock,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = wa.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_number_females_in_per_flock,

coalesce((select coalesce(zdv.z_inventory_value_of_flock,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = wa.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_inventory_value_of_flock,

coalesce((select coalesce(zdv.z_depletion_and_amortization,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = wa.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_depletion_and_amortization,

coalesce((select coalesce(zdv.z_depletion,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = wa.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_depletion,

coalesce((select coalesce(zdv.z_amortization,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = wa.z_week and zdv.z_hen_house = henhouse.z_hen_house
AND zdv.batchid = wofp.batchid
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_amortization,

cast((select z_salvage_value_of_female from Z_Salvage_Value_PSGP psgp WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname limit 1)as decimal (10,2))
as salvage_value_of_female,

cast((select z_salvage_value_of_male from Z_Salvage_Value_PSGP psgp WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname limit 1)as decimal (10,2))
as percent_salvage_value_of_male,
         cast((select z_salvage_value_of_female from Z_Salvage_Value_PSGP psgp
        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
            AND psgp.ad_org_id = $P{AD_Org_ID}
        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2))
        +
         cast((select z_salvage_value_of_male from Z_Salvage_Value_PSGP psgp
        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
            AND psgp.ad_org_id = $P{AD_Org_ID}
        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2))
        as adjust_salvage_value,

cast((select coalesce (z_total_cost_at_wp,0) from z_rs_wp1_cpjf zwop
where  zwop.z_hen_house = henhouse.z_hen_house AND zwop.batchid = wofp.batchid) /
(select coalesce (z_qty_female_wp ,0) from z_rs_wp1_cpjf zwop
where  zwop.z_hen_house = henhouse.z_hen_house AND zwop.batchid = wofp.batchid) as decimal (10,2))
as Growing_Cost,

(cast((select coalesce (z_total_cost_at_wp,0) from z_rs_wp1_cpjf zwop
where  zwop.z_hen_house = henhouse.z_hen_house AND zwop.batchid = wofp.batchid) /
(select coalesce (z_qty_female_wp ,0) from z_rs_wp1_cpjf zwop
where  zwop.z_hen_house = henhouse.z_hen_house AND zwop.batchid = wofp.batchid) as decimal (10,2)))

-

        (cast((select z_salvage_value_of_female from Z_Salvage_Value_PSGP psgp
        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
            AND psgp.ad_org_id = $P{AD_Org_ID}
        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2))
        +
         cast((select z_salvage_value_of_male from Z_Salvage_Value_PSGP psgp
        INNER JOIN adempiere.c_year yer ON psgp.c_year_id = yer.c_year_id
        WHERE psgp.branchtype = amortize.branchtype AND psgp.categoryname = amortize.categoryname
            AND psgp.ad_org_id = $P{AD_Org_ID}
        AND yer.fiscalyear = ((SELECT (RIGHT(z_wp_date,4)) FROM adempiere.z_rs_wp1_cpjf xx WHERE xx.z_hen_house = wofp.z_hen_house AND xx.z_farm_name = wofp.z_farm_name AND xx.batchid = wofp.batchid)::int - 1) ::TEXT)as decimal (10,2)))

as Value_to_be_amortize,

coalesce((select coalesce(zdv.z_layout,0)
from z_rs_depl_cpjf zdv where  zdv.z_week = wa.z_week and zdv.z_hen_house = henhouse.z_hen_house AND zdv.batchid = wofp.batchid
and zdv.ad_client_id = $P{AD_Client_ID} and zdv.ad_org_id = $P{AD_Org_ID}
and zdv.c_period_id in (select c_period_id from c_period where c_period_id between $P{PeriodFrom_ID} and $P{PeriodTo_ID}) LIMIT 1),0) as z_layout


from adempiere.z_rs_depl_cpjf amortize
inner join (SELECT *, left(m_warehouse.value,3) AS penghubung FROM adempiere.m_warehouse)mw on mw.penghubung = amortize.z_farm_code
LEFT JOIN adempiere.z_rs_wp1_cpjf wofp ON amortize.z_hen_house = wofp.z_hen_house AND amortize.z_farm_name = wofp.z_farm_name AND amortize.batchid = wofp.batchid
RIGHT JOIN adempiere.z_week_amortize wa ON amortize.ad_client_id = wa.ad_client_id AND wa.categoryname = amortize.categoryname
AND wa.branch_name IS NULL
AND wa.categoryname = $P{CategoryName}
INNER JOIN (SELECT value AS z_hen_house,
                $P{M_Warehouse_ID} AS ware
                from M_Locator
                where M_Locator.M_Warehouse_ID=(select mw1.m_warehouse_id
                from m_warehouse mw1
                where left(mw1.value,3) = (select left(mw.value,3)
                                                    from m_warehouse mw
                                                    where mw.m_warehouse_id = $P{M_Warehouse_ID})
                AND LOWER(mw1.name) LIKE '%kandang')) henhouse ON henhouse.ware = mw.m_warehouse_id AND amortize.z_hen_house = henhouse.z_hen_house


WHERE mw.M_Warehouse_ID = $P{M_Warehouse_ID}
AND (CASE WHEN (SELECT value as z_hen_house FROM M_Locator WHERE value =
$P{z_hen_house} LIMIT 1) IS NOT NULL
            THEN henhouse.z_hen_house = $P{z_hen_house}
            ELSE 1 = 1
    END)
AND (CASE WHEN (SELECT batchid FROM z_rs_wp1_cpjf WHERE batchid =
$P{BatchID} LIMIT 1) IS NOT NULL
            THEN wofp.batchid = $P{BatchID}
            ELSE wofp.batchid = (SELECT batchid FROM z_rs_wp1_cpjf WHERE z_hen_house = wofp.z_hen_house AND ad_org_id = $P{AD_Org_ID} ORDER BY z_year DESC LIMIT 1)
    END)
order by henhouse.z_hen_house,wa.z_week) as a