SELECT tabel.*, 1 orderkey -- non_trading, layer, bpsold
FROM
(
    SELECT
    (select name from c_period cp where c_period_id = $P{C_Period_ID}) as periodname,
    (select name from ad_org ao where ad_org_id = $P{AD_Org_ID}) as orgname,
    (select name from ad_org ao where ao.ad_org_id = $P{z_unit_ID}) as unitname,
    COALESCE($P{BranchType},'') AS brachtype,
    COALESCE($P{CategoryName},'') AS categoryname,
    COALESCE($P{Breed},'') breed,
    COALESCE($P{SexLine},'') sexline,
    *,

    (farm_z_depl_cost_doc_breeder +
    farm_z_depl_transportation_doc +
    farm_z_depl_feed_used +
    farm_z_depl_transportation_feed +
    farm_z_depl_medicine_used +
    farm_z_depl_direct_labor +
    farm_z_depl_farm_overhead +
    farm_z_depl_repair_maintenance +
    farm_z_depl_depreciation) AS persen_depletion_of_flockgrowing_cost,

    (farm_z_depl_cost_doc_breeder_year +
    farm_z_depl_transportation_doc_year +
    farm_z_depl_feed_used_year +
    farm_z_depl_transportation_feed_year +
    farm_z_depl_medicine_used_year +
    farm_z_depl_direct_labor_year +
    farm_z_depl_farm_overhead_year +
    farm_z_depl_repair_maintenance_year +
    farm_z_depl_depreciation_year) AS persen_depletion_of_flockgrowing_cost_ytd,

    1 AS penanda_data

    FROM
    (
    SELECT
    SUM(COALESCE(z_fp_feed_used,0)) AS farm_z_fp_feed_used ,
    SUM(COALESCE(z_fp_transportation_feed,0)) AS  farm_z_fp_transportation_feed,
    SUM(COALESCE(z_fp_vaccine_medicine_used,0)) AS farm_z_fp_vaccine_medicine_used,
    SUM(COALESCE(z_fp_direct_labor,0)) AS farm_z_fp_direct_labor,
    SUM(COALESCE(z_fp_farm_overhead,0)) AS farm_z_fp_farm_overhead,
    SUM(COALESCE(z_fp_repair_maintenance,0)) AS  farm_z_fp_repair_maintenance,
    SUM(COALESCE(z_fp_depreciation,0)) AS  farm_z_fp_depreciation,
    SUM(COALESCE(z_depl_cost_doc_breeder,0)) AS  farm_z_depl_cost_doc_breeder,
    SUM(COALESCE(z_depl_transportation_doc,0)) AS  farm_z_depl_transportation_doc,
    SUM(COALESCE(z_depl_feed_used,0)) AS  farm_z_depl_feed_used,
    SUM(COALESCE(z_depl_transportation_feed,0)) AS farm_z_depl_transportation_feed ,
    SUM(COALESCE(z_depl_medicine_used,0)) AS  farm_z_depl_medicine_used,
    SUM(COALESCE(z_depl_direct_labor,0)) AS  farm_z_depl_direct_labor,
    SUM(COALESCE(z_depl_farm_overhead,0)) AS  farm_z_depl_farm_overhead,
    SUM(COALESCE(z_depl_repair_maintenance,0)) AS farm_z_depl_repair_maintenance ,
    SUM(COALESCE(z_depl_depreciation,0)) AS farm_z_depl_depreciation ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGSx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS,0)) END
    AS farm_z_Total_Qty_to_produce_EGGS ,

    SUM(COALESCE(z_Cost_produce_Eggs,0)) AS farm_z_Cost_produce_Eggs ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_hex,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he,0))*-1) END
    AS farm_z_qty_non_he ,

    (SUM(COALESCE(z_income_from_non_he,0))*-1) AS farm_z_income_from_non_he ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_hex,0))
    ELSE SUM(COALESCE(z_qty_produce_he,0)) END
    AS farm_z_qty_produce_he ,

    SUM(COALESCE(z_cost_produce_he,0)) AS farm_z_cost_produce_he ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_beginx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin,0)) END
    AS farm_z_qty_he_inventory_farm_begin ,

    SUM(COALESCE(z_he_inventory_farm_begin,0)) AS farm_z_he_inventory_farm_begin ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farmx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm,0)) END
    AS farm_z_qty_he_from_farm ,

    SUM(COALESCE(z_cost_he_from_farm,0)) AS farm_z_cost_he_from_farm ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farmx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm,0)) END
    AS farm_z_qty_he_available_farm ,

    SUM(COALESCE(z_he_available_in_farm,0)) AS farm_z_he_available_in_farm ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliatex,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate,0))*-1) END
    AS farm_z_qty_he_sales_to_affiliate ,

    (SUM(COALESCE(z_he_sales_to_affiliate,0))*-1) AS farm_z_he_sales_to_affiliate ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transferx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer,0)) END
    AS farm_z_qty_he_ending_bef_transfer ,

    SUM(COALESCE(z_he_ending_bef_transfer_out,0)) AS farm_z_he_ending_bef_transfer_out ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_outx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out,0))*-1) END
    AS farm_z_qty_he_used_transfer_out ,

    (SUM(COALESCE(z_he_used_transfer_out,0))*-1) AS farm_z_he_used_transfer_out ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_farmx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_farm,0)) END
    AS farm_z_qty_he_ending_farm ,

    SUM(COALESCE(z_he_ending_farm,0)) AS farm_z_he_ending_farm ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qtyx,0))
    ELSE SUM(COALESCE(z_qty,0)) END
    AS farm_z_qty ,

    SUM(COALESCE(z_sales_he,0)) AS farm_z_sales_he,
    SUM(COALESCE(z_fp_feed_used_year,0)) AS farm_z_fp_feed_used_year ,
    SUM(COALESCE(z_fp_transportation_feed_year,0)) AS farm_z_fp_transportation_feed_year ,
    SUM(COALESCE(z_fp_vaccine_medicine_used_year,0)) AS farm_z_fp_vaccine_medicine_used_year ,
    SUM(COALESCE(z_fp_direct_labor_year,0)) AS farm_z_fp_direct_labor_year ,
    SUM(COALESCE(z_fp_farm_overhead_year,0)) AS farm_z_fp_farm_overhead_year ,
    SUM(COALESCE(z_fp_repair_maintenance_year,0)) AS farm_z_fp_repair_maintenance_year ,
    SUM(COALESCE(z_fp_depreciation_year,0)) AS farm_z_fp_depreciation_year ,
    SUM(COALESCE(z_depl_cost_doc_breeder_year,0)) AS farm_z_depl_cost_doc_breeder_year ,
    SUM(COALESCE(z_depl_transportation_doc_year,0)) AS farm_z_depl_transportation_doc_year ,
    SUM(COALESCE(z_depl_feed_used_year,0)) AS farm_z_depl_feed_used_year ,
    SUM(COALESCE(z_depl_transportation_feed_year,0)) AS farm_z_depl_transportation_feed_year ,
    SUM(COALESCE(z_depl_medicine_used_year,0)) AS farm_z_depl_medicine_used_year ,
    SUM(COALESCE(z_depl_direct_labor_year,0)) AS farm_z_depl_direct_labor_year ,
    SUM(COALESCE(z_depl_farm_overhead_year,0)) AS farm_z_depl_farm_overhead_year ,
    SUM(COALESCE(z_depl_repair_maintenance_year,0)) AS farm_z_depl_repair_maintenance_year ,
    SUM(COALESCE(z_depl_depreciation_year,0)) AS farm_z_depl_depreciation_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_yearx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_year,0)) END
    AS farm_z_Total_Qty_to_produce_EGGS_year ,

    SUM(COALESCE(z_Cost_produce_Eggs_year,0)) AS farm_z_Cost_produce_Eggs_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he_year,0))*-1) END
    AS farm_z_qty_non_he_year ,

    (SUM(COALESCE(z_income_from_non_he_year,0))*-1) AS farm_z_income_from_non_he_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_produce_he_yearx,0))*-1)
    ELSE SUM(COALESCE(z_qty_produce_he_year,0)) END
    AS farm_z_qty_produce_he_year ,

    SUM(COALESCE(z_cost_produce_he_year,0)) AS farm_z_cost_produce_he_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_year,0)) END
    AS farm_z_qty_he_inventory_farm_begin_year ,

    SUM(COALESCE(z_he_inventory_farm_begin_year,0)) AS farm_z_he_inventory_farm_begin_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm_year,0)) END
    AS farm_z_qty_he_from_farm_year ,

    SUM(COALESCE(z_cost_he_from_farm_year,0)) AS farm_z_cost_he_from_farm_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm_year,0)) END
    AS farm_z_qty_he_available_farm_year ,

    SUM(COALESCE(z_he_available_in_farm_year,0)) AS farm_z_he_available_in_farm_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_year,0))*-1) END
    AS farm_z_qty_he_sales_to_affiliate_year ,

    (SUM(COALESCE(z_he_sales_to_affiliate_year,0))*-1) AS farm_z_he_sales_to_affiliate_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transfer_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer_year,0)) END
    AS farm_z_qty_he_ending_bef_transfer_year ,

    SUM(COALESCE(z_he_ending_bef_transfer_out_year,0)) AS farm_z_he_ending_bef_transfer_out_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_year,0))*-1) END
    AS farm_z_qty_he_used_transfer_out_year ,

    (SUM(COALESCE(z_he_used_transfer_out_year,0))*-1) AS farm_z_he_used_transfer_out_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_farm_year,0)) END
    AS farm_z_qty_he_ending_farm_year ,

    SUM(COALESCE(z_he_ending_farm_year,0)) AS farm_z_he_ending_farm_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_yearx,0))
    ELSE SUM(COALESCE(z_qty_year,0)) END
    AS farm_z_qty_year ,

    SUM(COALESCE(z_sales_he_year,0)) AS farm_z_sales_he_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_h1_year,0)) END
    AS farm_z_qty_he_inventory_farm_begin_h1_year  ,

    SUM(COALESCE(z_he_inventory_farm_begin_h1_year,0)) AS farm_z_he_inventory_farm_begin_h1_year ,
    SUM(COALESCE(z_qty_he_ending_farm_h1_year,0)) AS farm_z_qty_he_ending_farm_h1_year ,
    SUM(COALESCE(z_he_ending_farm_h1_year,0)) AS farm_z_he_ending_farm_h1_year,
    SUM(COALESCE(z_fp_feed_used_h1_year,0)) as farm_z_fp_feed_used_h1_year,
    SUM(COALESCE(z_fp_transportation_feed_h1_year,0)) as farm_z_fp_transportation_feed_h1_year,
    SUM(COALESCE(z_fp_vaccine_medicine_used_h1_year,0)) as farm_z_fp_vaccine_medicine_used_h1_year,
    SUM(COALESCE(z_fp_direct_labor_h1_year,0)) as farm_z_fp_direct_labor_h1_year,
    SUM(COALESCE(z_fp_farm_overhead_h1_year,0)) as farm_z_fp_farm_overhead_h1_year,
    SUM(COALESCE(z_fp_repair_maintenance_h1_year,0)) as farm_z_fp_repair_maintenance_h1_year,
    SUM(COALESCE(z_fp_depreciation_h1_year,0)) as farm_z_fp_depreciation_h1_year,
    SUM(COALESCE(z_depl_cost_doc_breeder_h1_year,0)) as farm_z_depl_cost_doc_breeder_h1_year,
    SUM(COALESCE(z_depl_transportation_doc_h1_year,0)) as farm_z_depl_transportation_doc_h1_year,
    SUM(COALESCE(z_depl_feed_used_h1_year,0)) as farm_z_depl_feed_used_h1_year,
    SUM(COALESCE(z_depl_transportation_feed_h1_year,0)) as farm_z_depl_transportation_feed_h1_year,
    SUM(COALESCE(z_depl_medicine_used_h1_year,0)) as farm_z_depl_medicine_used_h1_year,
    SUM(COALESCE(z_depl_direct_labor_h1_year,0)) as farm_z_depl_direct_labor_h1_year,
    SUM(COALESCE(z_depl_farm_overhead_h1_year,0)) as farm_z_depl_farm_overhead_h1_year,
    SUM(COALESCE(z_depl_repair_maintenance_h1_year,0)) as farm_z_depl_repair_maintenance_h1_year,
    SUM(COALESCE(z_depl_depreciation_h1_year,0)) as farm_z_depl_depreciation_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_h1_yearx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_h1_year,0)) END
    as farm_z_Total_Qty_to_produce_EGGS_h1_year,

    SUM(COALESCE(z_Cost_produce_Eggs_h1_year,0)) as farm_z_Cost_produce_Eggs_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_h1_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he_h1_year,0))*-1) END
    as farm_z_qty_non_he_h1_year,

    (SUM(COALESCE(z_income_from_non_he_h1_year,0))*-1) as farm_z_income_from_non_he_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_he_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_produce_he_h1_year,0)) END
    as farm_z_qty_produce_he_h1_year,

    SUM(COALESCE(z_cost_produce_he_h1_year,0)) as farm_z_cost_produce_he_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm_h1_year,0)) END
    as farm_z_qty_he_from_farm_h1_year,

    SUM(COALESCE(z_cost_he_from_farm_h1_year,0)) as farm_z_cost_he_from_farm_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm_h1_year,0)) END
    as farm_z_qty_he_available_farm_h1_year,

    SUM(COALESCE(z_he_available_in_farm_h1_year,0)) as farm_z_he_available_in_farm_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_h1_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_h1_year,0))*-1) END
    as farm_z_qty_he_sales_to_affiliate_h1_year,

    (SUM(COALESCE(z_he_sales_to_affiliate_h1_year,0))*-1) as farm_z_he_sales_to_affiliate_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transfer_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer_h1_year,0)) END
    as farm_z_qty_he_ending_bef_transfer_h1_year,

    SUM(COALESCE(z_he_ending_bef_transfer_out_h1_year,0)) as farm_z_he_ending_bef_transfer_out_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_h1_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_h1_year,0))*-1) END
    as farm_z_qty_he_used_transfer_out_h1_year,

    (SUM(COALESCE(z_he_used_transfer_out_h1_year,0))*-1) as farm_z_he_used_transfer_out_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_h1_year,0)) END
    AS farm_z_qty_h1_year,

    SUM(COALESCE(z_sales_he_h1_year,0)) AS farm_z_sales_he_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_brx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br,0)) *-1 END
    AS qty_he_trf_to_br_13 ,

    SUM(COALESCE(he_trf_to_br,0)) * -1 AS he_trf_to_br_13,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_yearx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br_year,0)) *-1 END
    as qty_he_trf_to_br_year_13,

    SUM(COALESCE(he_trf_to_br_year,0)) *-1 as he_trf_to_br_year_13,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_h1_yearx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br_h1_year,0)) *-1 END
    as qty_he_trf_to_br_h1_year_13,

    SUM(COALESCE(he_trf_to_br_h1_year,0)) *-1 as he_trf_to_br_h1_year_13,
    SUM(COALESCE(cost_trf_he_to_br,0)) as cost_trf_he_to_br_13,
    SUM(COALESCE(cost_trf_he_to_br_year,0)) as cost_trf_he_to_br_year_13,
    SUM(COALESCE(cost_trf_he_to_br_h1_year,0)) as cost_trf_he_to_br_h1_year_13,

    SUM(COALESCE(z_cost_transfer_variance,0)) AS z_cost_transfer_variance,
    SUM(COALESCE(z_cost_transfer_variance_year,0)) AS z_cost_transfer_variance_year,
    SUM(COALESCE(z_cost_transfer_variance_h1_year,0)) AS z_cost_transfer_variance_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_hex,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he,0)) *-1 END
    AS z_qty_adjustment_he,

    sum(COALESCE(z_adjustment_he,0))*-1 AS z_adjustment_he,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_yearx,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he_year,0)) *-1 END
    AS z_qty_adjustment_he_year,

    sum(COALESCE(z_adjustment_he_year,0))*-1 AS z_adjustment_he_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_h1_yearx,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he_h1_year,0)) *-1 END
    AS z_qty_adjustment_he_h1_year,

    sum(COALESCE(z_adjustment_he_h1_year,0))*-1 AS z_adjustment_he_h1_year


    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE
    $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    ) AS farm
    CROSS JOIN
    (
    SELECT

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_beginning_hatcheryx,0)),0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery,0)),0) END
    AS  hatchery_z_qty_he_beginning_hatchery,

    COALESCE(SUM(COALESCE(z_he_beginning_hatchery,0)) ,0)  AS  hatchery_z_he_beginning_hatchery,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_grx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr,0)) ,0) END
    AS hatchery_z_qty_he_transfer_farm_bef_gr,

    COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_brx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br,0)) ,0)  END
    AS hatchery_z_qty_add_he_transfer_from_br,

    COALESCE(SUM(COALESCE(z_add_he_transfer_from_br,0)) ,0)  AS hatchery_z_add_he_transfer_from_br,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_cox,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co,0)) ,0) END
    AS hatchery_z_qty_he_purchase_affiliate_co,

    COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co,
    COALESCE(SUM(COALESCE(z_transportation_he,0)) ,0)  AS hatchery_z_transportation_he,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_available_gr_processx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_available_gr_process,0)) ,0)  END
    AS hatchery_z_qty_he_available_gr_process,

    COALESCE(SUM(COALESCE(z_he_available_to_gr_process,0)) ,0)  AS hatchery_z_he_available_to_gr_process,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_soldx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_sold,0))*-1) ,0)  END
    AS hatchery_z_qty_non_he_sold,

    COALESCE((SUM(COALESCE(z_non_he_sold,0))*-1) ,0)  AS hatchery_z_non_he_sold,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_csrx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_csr,0))*-1) ,0)  END
    AS hatchery_z_qty_non_he_csr,

    COALESCE((SUM(COALESCE(z_non_he_csr,0))*-1) ,0)  AS hatchery_z_non_he_csr,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_docx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc,0)) ,0)  END
    AS hatchery_z_qty_he_avail_to_produce_doc,

    COALESCE(SUM(COALESCE(z_he_available_to_produce_doc,0)) ,0)  AS hatchery_z_he_available_to_produce_doc,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_processx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_hatch_process,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_processx,0))) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process,0))) ,0) END
    AS hatchery_cost_of_he_put_into_hatcher,

    COALESCE((SUM(COALESCE(z_he_used_to_hatching_process,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_destroyx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_destroy,

    COALESCE((SUM(COALESCE(z_he_used_to_destroy,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_endx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end,0)) ,0) END
    AS hatchery_z_qty_he_invent_hatchery_end,

    COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending,
    COALESCE(SUM(COALESCE(z_income_from_non_he,0)) ,0)  AS hatchery_z_income_from_non_he,
    COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher,
    COALESCE(SUM(COALESCE(z_hc_feed,0)) ,0)  AS hatchery_z_hc_feed,
    COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler,
    COALESCE(SUM(COALESCE(z_hc_hatchery_overhead,0)) ,0)  AS hatchery_z_hc_hatchery_overhead,
    COALESCE(SUM(COALESCE(z_hc_repair_maintenance,0)) ,0)  AS hatchery_z_hc_repair_maintenance,
    COALESCE(SUM(COALESCE(z_hc_depreciation,0)) ,0)  AS hatchery_z_hc_depreciation,
    COALESCE(SUM(COALESCE(z_hc_boxes_used,0)) ,0)  AS hatchery_z_hc_boxes_used,
    COALESCE(SUM(COALESCE(z_income_from_male *-1, 0)) ,0)  AS hatchery_z_income_from_male,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_income_from_malex *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_income_from_male *-1, 0)) ,0) END
    AS hatchery_z_qty_income_from_male,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_income_from_infertile_eggsx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_income_from_infertile_eggs *-1, 0)) ,0) END
    AS hatchery_z_income_from_infertile_eggs,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_dead_in_shellx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_dead_in_shell *-1, 0)) ,0) END
    AS hatchery_z_dead_in_shell,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_lossx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_loss *-1, 0)) ,0) END
    AS hatchery_z_loss,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_to_produce_docx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_to_produce_doc,0)) ,0) END
    AS hatchery_z_qty_to_produce_doc,


    COALESCE(SUM(COALESCE(z_amount_to_produce_doc,0)) ,0)  AS hatchery_z_amount_to_produce_doc,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_culledx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_culled *-1, 0)) ,0) END
    AS hatchery_z_qty_doc_culled,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_killedx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_killed *-1, 0)) ,0) END
    AS hatchery_z_qty_doc_killed,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransix *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi *-1, 0)) ,0) END
    AS hatchery_z_qty_doc_extra_toleransi,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_available_for_salesx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales,0)) ,0) END
    AS hatchery_z_qty_doc_available_for_sales,

    COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarmx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm,0)) ,0) END
    AS hatchery_z_deductqtytfdodtocomfarm,

    COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_add_qty_begiining_docx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_add_qty_begiining_doc,0)) ,0) END
    AS hatchery_z_add_qty_begiining_doc,

    COALESCE(SUM(COALESCE(z_add_begiining_doc,0)) ,0)  AS hatchery_z_add_begiining_doc,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deduct_qty_ending_docx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc,0)) ,0) END
    AS hatchery_z_deduct_qty_ending_doc,

    COALESCE(SUM(COALESCE(z_deduct_ending_doc,0)) ,0)  AS hatchery_z_deduct_ending_doc,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_brx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br,0)) ,0) END
    AS hatchery_z_total_qty_cost_trans_to_br,

    COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_total_cost_of_salesx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales,0)) ,0) END
    AS hatchery_z_qty_total_cost_of_sales,

    COALESCE(SUM(COALESCE(z_total_cost_of_sales,0)) ,0)  AS hatchery_z_total_cost_of_sales,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_year,0)) ,0) END
    AS  hatchery_z_qty_he_beginning_hatchery_year,

    COALESCE(SUM(COALESCE(z_he_beginning_hatchery_year,0)) ,0)  AS  hatchery_z_he_beginning_hatchery_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_year,0)) ,0) END
    AS hatchery_z_qty_he_transfer_farm_bef_gr_year,

    COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr_year,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_year,0)) ,0) END
    AS hatchery_z_qty_add_he_transfer_from_br_year,

    COALESCE(SUM(COALESCE(z_add_he_transfer_from_br_year,0)) ,0)  AS hatchery_z_add_he_transfer_from_br_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_year,0)) ,0)  END
    AS hatchery_z_qty_he_purchase_affiliate_co_year,

    COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co_year,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co_year,
    COALESCE(SUM(COALESCE(z_transportation_he_year,0)) ,0)  AS hatchery_z_transportation_he_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_year,0)) ,0)  END
    AS hatchery_z_qty_he_available_gr_process_year,

    COALESCE(SUM(COALESCE(z_he_available_to_gr_process_year,0)) ,0)  AS hatchery_z_he_available_to_gr_process_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_sold_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_sold_year,0))*-1) ,0)  END
    AS hatchery_z_qty_non_he_sold_year,

    COALESCE((SUM(COALESCE(z_non_he_sold_year,0))*-1) ,0)  AS hatchery_z_non_he_sold_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_csr_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_csr_year,0))*-1) ,0) END
    AS hatchery_z_qty_non_he_csr_year,

    COALESCE((SUM(COALESCE(z_non_he_csr_year,0))*-1) ,0)  AS hatchery_z_non_he_csr_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_year,0)) ,0)  END
    AS hatchery_z_qty_he_avail_to_produce_doc_year,

    COALESCE(SUM(COALESCE(z_he_available_to_produce_doc_year,0)) ,0)  AS hatchery_z_he_available_to_produce_doc_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_year,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_hatch_process_year,

    COALESCE((SUM(COALESCE(z_he_used_to_hatching_process_year,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_year,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_destroy_year,

    COALESCE((SUM(COALESCE(z_he_used_to_destroy_year,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_year,0)) ,0)  END
    AS hatchery_z_qty_he_invent_hatchery_end_year,

    COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending_year,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending_year,
    COALESCE(SUM(COALESCE(z_income_from_non_he_year,0)) ,0)  AS hatchery_z_income_from_non_he_year,
    COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher_year,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher_year,
    COALESCE(SUM(COALESCE(z_hc_feed_year,0)) ,0)  AS hatchery_z_hc_feed_year,
    COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler_year,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler_year,
    COALESCE(SUM(COALESCE(z_hc_hatchery_overhead_year,0)) ,0)  AS hatchery_z_hc_hatchery_overhead_year,
    COALESCE(SUM(COALESCE(z_hc_repair_maintenance_year,0)) ,0)  AS hatchery_z_hc_repair_maintenance_year,
    COALESCE(SUM(COALESCE(z_hc_depreciation_year,0)) ,0)  AS hatchery_z_hc_depreciation_year,
    COALESCE(SUM(COALESCE(z_hc_boxes_used_year,0)) ,0)  AS hatchery_z_hc_boxes_used_year,
    COALESCE(SUM(COALESCE(z_income_from_male_year,0)) ,0)  AS hatchery_z_income_from_male_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_income_from_male_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_income_from_male_year,0)) ,0) END
    AS hatchery_z_qty_income_from_male_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_year,0)) ,0) end
    AS hatchery_z_income_from_infertile_eggs_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_dead_in_shell_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_dead_in_shell_year,0)) ,0) END
    AS hatchery_z_dead_in_shell_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_loss_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_loss_year,0)) ,0) END
    AS hatchery_z_loss_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_to_produce_doc_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_to_produce_doc_year,0)) ,0) END
    AS hatchery_z_qty_to_produce_doc_year,


    COALESCE(SUM(COALESCE(z_amount_to_produce_doc_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_culled_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_culled_year,0)) ,0) END
    AS hatchery_z_qty_doc_culled_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_killed_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_killed_year,0)) ,0) END
    AS hatchery_z_qty_doc_killed_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_e_yearxtra_toleransi_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi_year,0)) ,0) END
    AS hatchery_z_qty_doc_extra_toleransi_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_year,0)) ,0) END
    AS hatchery_z_qty_doc_available_for_sales_year,

    COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_year * -1,0)) ,0) END
    AS hatchery_z_deductqtytfdodtocomfarm_year,

    COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm_year,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_year,0)) ,0) END
    AS hatchery_z_add_qty_begiining_doc_year,

    COALESCE(SUM(COALESCE(z_add_begiining_doc_year,0)) ,0)  AS hatchery_z_add_begiining_doc_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_year,0)) ,0) END
    AS hatchery_z_deduct_qty_ending_doc_year,

    COALESCE(SUM(COALESCE(z_deduct_ending_doc_year,0)) ,0)  AS hatchery_z_deduct_ending_doc_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_year,0)) ,0) END
    AS hatchery_z_total_qty_cost_trans_to_br_year,

    COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf_year,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_year,0)) ,0) END
    AS hatchery_z_qty_total_cost_of_sales_year,

    COALESCE(SUM(COALESCE(z_total_cost_of_sales_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_h1_year,0)) ,0) END
    AS  hatchery_z_qty_he_beginning_hatchery_h1_year,

    COALESCE(SUM(COALESCE(z_he_beginning_hatchery_h1_year,0)) ,0)  AS  hatchery_z_he_beginning_hatchery_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_h1_year,0)) ,0)  END
    AS hatchery_z_qty_he_transfer_farm_bef_gr_h1_year,

    COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr_h1_year,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_h1_year,0)) ,0) END
    AS hatchery_z_qty_add_he_transfer_from_br_h1_year,

    COALESCE(SUM(COALESCE(z_add_he_transfer_from_br_h1_year,0)) ,0)  AS hatchery_z_add_he_transfer_from_br_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_h1_year,0)) ,0) END
    AS hatchery_z_qty_he_purchase_affiliate_co_h1_year,

    COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co_h1_year,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co_h1_year,
    COALESCE(SUM(COALESCE(z_transportation_he_h1_year,0)) ,0)  AS hatchery_z_transportation_he_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_h1_year,0)) ,0)  END
    AS hatchery_z_qty_he_available_gr_process_h1_year,

    COALESCE(SUM(COALESCE(z_he_available_to_gr_process_h1_year,0)) ,0)  AS hatchery_z_he_available_to_gr_process_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_sold_h1_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_sold_h1_year,0))*-1) ,0) END
    AS hatchery_z_qty_non_he_sold_h1_year,

    COALESCE((SUM(COALESCE(z_non_he_sold_h1_year,0))*-1) ,0)  AS hatchery_z_non_he_sold_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_csr_h1_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_csr_h1_year,0))*-1) ,0)  END
    AS hatchery_z_qty_non_he_csr_h1_year,

    COALESCE((SUM(COALESCE(z_non_he_csr_h1_year,0))*-1) ,0)  AS hatchery_z_non_he_csr_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_h1_year,0)) ,0)  END
    AS hatchery_z_qty_he_avail_to_produce_doc_h1_year,

    COALESCE(SUM(COALESCE(z_he_available_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_he_available_to_produce_doc_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_h1_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_h1_year,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_hatch_process_h1_year,

    COALESCE((SUM(COALESCE(z_he_used_to_hatching_process_h1_year,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_h1_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_h1_year,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_destroy_h1_year,

    COALESCE((SUM(COALESCE(z_he_used_to_destroy_h1_year,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_h1_year,0)) ,0) END
    AS hatchery_z_qty_he_invent_hatchery_end_h1_year,

    COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending_h1_year,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending_h1_year,
    COALESCE(SUM(COALESCE(z_income_from_non_he_h1_year,0)) ,0)  AS hatchery_z_income_from_non_he_h1_year,
    COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher_h1_year,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher_h1_year,
    COALESCE(SUM(COALESCE(z_hc_feed_h1_year,0)) ,0)  AS hatchery_z_hc_feed_h1_year,
    COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler_h1_year,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler_h1_year,
    COALESCE(SUM(COALESCE(z_hc_hatchery_overhead_h1_year,0)) ,0)  AS hatchery_z_hc_hatchery_overhead_h1_year,
    COALESCE(SUM(COALESCE(z_hc_repair_maintenance_h1_year,0)) ,0)  AS hatchery_z_hc_repair_maintenance_h1_year,
    COALESCE(SUM(COALESCE(z_hc_depreciation_h1_year,0)) ,0)  AS hatchery_z_hc_depreciation_h1_year,
    COALESCE(SUM(COALESCE(z_hc_boxes_used_h1_year,0)) ,0)  AS hatchery_z_hc_boxes_used_h1_year,
    COALESCE(SUM(COALESCE(z_income_from_male_h1_year,0)) ,0)  AS hatchery_z_income_from_male_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_income_from_male_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_income_from_male_h1_year,0)),0) END
    AS hatchery_z_qty_income_from_male_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_h1_yearx,0)),0)
    ELSE COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_h1_year,0)),0) END  AS hatchery_z_income_from_infertile_eggs_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_dead_in_shell_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_dead_in_shell_h1_year,0)) ,0) END
    AS hatchery_z_dead_in_shell_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_loss_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_loss_h1_year,0)) ,0) END
    AS hatchery_z_loss_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_to_produce_doc_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_to_produce_doc_h1_year,0)) ,0) END
    AS hatchery_z_qty_to_produce_doc_h1_year,


    COALESCE(SUM(COALESCE(z_amount_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_culled_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_culled_h1_year,0)) ,0) END
    AS hatchery_z_qty_doc_culled_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_killed_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_killed_h1_year,0)) ,0) END
    AS hatchery_z_qty_doc_killed_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_e_h1_yearxtra_toleransi_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi_h1_year,0)) ,0)  END
    AS hatchery_z_qty_doc_extra_toleransi_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_h1_year,0)) ,0)  END
    AS hatchery_z_qty_doc_available_for_sales_h1_year,

    COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales_h1_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_h1_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_h1_year * -1,0)) ,0) END
    AS hatchery_z_deductqtytfdodtocomfarm_h1_year,

    COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm_h1_year,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_h1_year,0)) ,0) END
    AS hatchery_z_add_qty_begiining_doc_h1_year,

    COALESCE(SUM(COALESCE(z_add_begiining_doc_h1_year,0)) ,0)  AS hatchery_z_add_begiining_doc_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_h1_year,0)) ,0) END
    AS hatchery_z_deduct_qty_ending_doc_h1_year,

    COALESCE(SUM(COALESCE(z_deduct_ending_doc_h1_year,0)) ,0)  AS hatchery_z_deduct_ending_doc_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_h1_year,0)) ,0) END
    AS hatchery_z_total_qty_cost_trans_to_br_h1_year,

    COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf_h1_year,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_h1_year,0)) ,0) END
    AS hatchery_z_qty_total_cost_of_sales_h1_year,

    COALESCE(SUM(COALESCE(z_total_cost_of_sales_h1_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(AVG(COALESCE(z_salable_chickx,0)),0)
    ELSE COALESCE(AVG(COALESCE(z_salable_chick,0)),0) END AS
    hatchery_z_salable_chick,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(AVG(COALESCE(z_hatchabilityx,0)),0)
    ELSE COALESCE(AVG(COALESCE(z_hatchability,0)),0) END
    AS hatchery_z_hatchability,


    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_to_brx,0)) ,0) * -1
    ELSE COALESCE(SUM(COALESCE(qty_he_trf_to_br,0)) ,0) * -1 END
    AS qty_he_trf_to_br,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_to_br_yearx,0)) ,0) * -1
    ELSE COALESCE(SUM(COALESCE(qty_he_trf_to_br_year,0)) ,0) * -1 END
    AS qty_he_trf_to_br_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_to_br_h1_yearx,0)) ,0) * -1
    ELSE COALESCE(SUM(COALESCE(qty_he_trf_to_br_h1_year,0)) ,0) * -1 END
    AS qty_he_trf_to_br_h1_year,

    COALESCE(SUM(COALESCE(he_trf_to_br,0)) ,0) *-1  AS he_trf_to_br,
    COALESCE(SUM(COALESCE(he_trf_to_br_year,0)) ,0) *-1  AS he_trf_to_br_year,
    COALESCE(SUM(COALESCE(he_trf_to_br_h1_year,0)) ,0) *-1 AS he_trf_to_br_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_Qty_HE_sales_to_affiliatex * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(qty_he_sales_to_aff * -1,0)) ,0) END
    AS qty_he_sales_to_aff,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_Qty_HE_sales_to_affiliate_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(qty_he_sales_to_aff_year * -1,0)) ,0) END
    AS qty_he_sales_to_aff_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_Qty_HE_sales_to_affiliate_h1_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(qty_he_sales_to_aff_h1_year * -1,0)) ,0)  END
    AS qty_he_sales_to_aff_h1_year,

    COALESCE(SUM(COALESCE(he_sales_to_aff * -1,0)) ,0)  AS he_sales_to_aff,
    COALESCE(SUM(COALESCE(he_sales_to_aff_year * -1,0)) ,0)  AS he_sales_to_aff_year,
    COALESCE(SUM(COALESCE(he_sales_to_aff_h1_year * -1,0)) ,0)  AS he_sales_to_aff_h1_year,

    COALESCE(SUM(COALESCE(cost_trf_he_to_br,0)) ,0)  AS cost_trf_he_to_br,
    COALESCE(SUM(COALESCE(cost_trf_he_to_br_year,0)) ,0)  AS cost_trf_he_to_br_year,
    COALESCE(SUM(COALESCE(cost_trf_he_to_br_h1_year,0)) ,0)  AS cost_trf_he_to_br_h1_year,
    COALESCE(SUM(COALESCE(sales_he_to_affiliate,0)) ,0)  AS sales_he_to_affiliate,
    COALESCE(SUM(COALESCE(sales_he_to_affiliate_year,0)) ,0)  AS sales_he_to_affiliate_year,
    COALESCE(SUM(COALESCE(sales_he_to_affiliate_h1_year,0)) ,0)  AS sales_he_to_affiliate_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreedx, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed, 0)) ,0) END
    AS deductqtytfdodtofarmbreed,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_year * -1,0)) ,0) END
    AS deductqtytfdodtofarmbreed_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_h1_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_h1_year * -1,0)) ,0) END
    AS deductqtytfdodtofarmbreed_h1_year,

    COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed,0)) ,0)  AS deductcosttfdodtofarmbreed,
    COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed_year,0)) ,0)  AS deductcosttfdodtofarmbreed_year,
    COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed_h1_year,0)) ,0)  AS deductcosttfdodtofarmbreed_h1_year,

    COALESCE(SUM(COALESCE(qtymoveinouthehatch,0)),0) AS qtymoveinouthehatch,
    COALESCE(SUM(COALESCE(amountmoveinouthehatch,0)),0) AS  amountmoveinouthehatch,
    COALESCE(SUM(COALESCE(qtymoveinouthehatch_year,0)),0) AS  qtymoveinouthehatch_year,
    COALESCE(SUM(COALESCE(amountmoveinouthehatch_year,0)),0) AS  amountmoveinouthehatch_year,
    COALESCE(SUM(COALESCE(qtymoveinouthehatch_h1_year,0)),0) AS  qtymoveinouthehatch_h1_year,
    COALESCE(SUM(COALESCE(amountmoveinouthehatch_h1_year,0)),0) AS  amountmoveinouthehatch_h1_year,


    COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc,0)),0) AS qtyheAvailBefGradAfterMovehatc,
    COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc,0)),0) AS heAvailBefGradAfterMovehatc,
    COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc_year,0)),0) AS qtyheAvailBefGradAfterMovehatc_year,
    COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc_year,0)),0) AS heAvailBefGradAfterMovehatc_year,
    COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc_h1_year,0)),0) AS qtyheAvailBefGradAfterMovehatc_h1_year,
    COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc_h1_year,0)),0) AS heAvailBefGradAfterMovehatc_h1_year,

    COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_grxx,0)),0) AS z_qty_he_avail_bfr_gr,
    COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_gr_year,0)),0) AS z_qty_he_avail_bfr_gr_year,
    COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_gr_h1_year,0)),0) AS z_qty_he_avail_bfr_gr_h1_year,
    COALESCE(SUM(COALESCE(z_he_avail_bfr_grxx,0)),0) AS z_he_avail_bfr_gr,
    COALESCE(SUM(COALESCE(z_he_avail_bfr_gr_year,0)),0) AS z_he_avail_bfr_gr_year,
    COALESCE(SUM(COALESCE(z_he_avail_bfr_gr_h1_year,0)),0) AS z_he_avail_bfr_gr_h1_year,

    COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue,0)),0) AS z_incomefrominfertile_eggvalue,
    COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue_year,0)),0) AS z_incomefrominfertile_eggvalue_year,
    COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue_h1_year,0)),0) AS z_incomefrominfertile_eggvalue_h1_year,

    COALESCE(SUM(COALESCE(z_qty_docsumbangan,0)),0) AS z_qty_docsumbangan,
    COALESCE(SUM(COALESCE(z_qty_docsumbangan_year,0)),0) AS z_qty_docsumbangan_year,
    COALESCE(SUM(COALESCE(z_qty_docsumbangan_h1_year,0)),0) AS z_qty_docsumbangan_h1_year


    FROM z_get_cost_calculation_hatchery_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND (SELECT SUM(COALESCE(z_fp_feed_used,0)) AS farm_z_fp_feed_used  FROM adempiere.z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}) -- di crosjoin farm NULL
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        LIMIT 1) IS NOT NULL
    ) AS hatchery
)tabel
WHERE farm_z_qty IS NOT NULL
AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
    (SELECT per.startdate FROM adempiere.z_costing_duck pgc
            INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
            WHERE pgc.ad_org_id = $P{AD_Org_ID}
            ORDER BY per.startdate ASC LIMIT 1
    )

UNION
-- non_trading, layer, bpsold
-- ambil data farm bulan lalu
SELECT tabel.*, 2 orderkey
FROM
(
    SELECT
    (select name from c_period cp where c_period_id = $P{C_Period_ID}) as periodname,
    (select name from ad_org ao where ad_org_id = $P{AD_Org_ID}) as orgname,
    (select name from ad_org ao where ao.ad_org_id = $P{z_unit_ID}) as unitname,
    COALESCE($P{BranchType},'') AS brachtype,
    COALESCE($P{CategoryName},'') AS categoryname,
    COALESCE($P{Breed},'') breed,
    COALESCE($P{SexLine},'') sexline,
    *,

    (farm_z_depl_cost_doc_breeder +
    farm_z_depl_transportation_doc +
    farm_z_depl_feed_used +
    farm_z_depl_transportation_feed +
    farm_z_depl_medicine_used +
    farm_z_depl_direct_labor +
    farm_z_depl_farm_overhead +
    farm_z_depl_repair_maintenance +
    farm_z_depl_depreciation) AS persen_depletion_of_flockgrowing_cost,

    (farm_z_depl_cost_doc_breeder_year +
    farm_z_depl_transportation_doc_year +
    farm_z_depl_feed_used_year +
    farm_z_depl_transportation_feed_year +
    farm_z_depl_medicine_used_year +
    farm_z_depl_direct_labor_year +
    farm_z_depl_farm_overhead_year +
    farm_z_depl_repair_maintenance_year +
    farm_z_depl_depreciation_year) AS persen_depletion_of_flockgrowing_cost_ytd,

    1 AS penanda_data

    FROM
    (
    SELECT
    0 AS farm_z_fp_feed_used ,
    0 AS  farm_z_fp_transportation_feed,
    0 AS farm_z_fp_vaccine_medicine_used,
    0 AS farm_z_fp_direct_labor,
    0 AS farm_z_fp_farm_overhead,
    0 AS  farm_z_fp_repair_maintenance,
    0 AS  farm_z_fp_depreciation,
    0 AS  farm_z_depl_cost_doc_breeder,
    0 AS  farm_z_depl_transportation_doc,
    0 AS  farm_z_depl_feed_used,
    0 AS farm_z_depl_transportation_feed ,
    0 AS  farm_z_depl_medicine_used,
    0 AS  farm_z_depl_direct_labor,
    0 AS  farm_z_depl_farm_overhead,
    0 AS farm_z_depl_repair_maintenance ,
    0 AS farm_z_depl_depreciation ,
    0 AS farm_z_Total_Qty_to_produce_EGGS ,
    0 AS farm_z_Cost_produce_Eggs ,
    0 AS farm_z_qty_non_he ,
    0 AS farm_z_income_from_non_he ,
    0 AS farm_z_qty_produce_he ,
    0 AS farm_z_cost_produce_he ,
    0 AS farm_z_qty_he_inventory_farm_begin ,
    0 AS farm_z_he_inventory_farm_begin ,
    0 AS farm_z_qty_he_from_farm ,
    0 AS farm_z_cost_he_from_farm ,
    0 AS farm_z_qty_he_available_farm ,
    0 AS farm_z_he_available_in_farm ,
    0 AS farm_z_qty_he_sales_to_affiliate ,
    0 AS farm_z_he_sales_to_affiliate ,
    0 AS farm_z_qty_he_ing_bef_transfer ,
    0 AS farm_z_he_ing_bef_transfer_out ,
    0 AS farm_z_qty_he_used_transfer_out ,
    0 AS farm_z_he_used_transfer_out ,
    0 AS farm_z_qty_he_ing_farm ,
    0 AS farm_z_he_ing_farm ,
    0 AS farm_z_qty ,
    0 AS farm_z_sales_he,


    COALESCE(SUM(COALESCE(z_fp_feed_used_year,0)),0) AS farm_z_fp_feed_used_year ,
    COALESCE(SUM(COALESCE(z_fp_transportation_feed_year,0)),0) AS farm_z_fp_transportation_feed_year ,
    COALESCE(SUM(COALESCE(z_fp_vaccine_medicine_used_year,0)),0) AS farm_z_fp_vaccine_medicine_used_year ,
    COALESCE(SUM(COALESCE(z_fp_direct_labor_year,0)),0) AS farm_z_fp_direct_labor_year ,
    COALESCE(SUM(COALESCE(z_fp_farm_overhead_year,0)),0) AS farm_z_fp_farm_overhead_year ,
    COALESCE(SUM(COALESCE(z_fp_repair_maintenance_year,0)),0) AS farm_z_fp_repair_maintenance_year ,
    COALESCE(SUM(COALESCE(z_fp_depreciation_year,0)),0) AS farm_z_fp_depreciation_year ,
    COALESCE(SUM(COALESCE(z_depl_cost_doc_breeder_year,0)),0) AS farm_z_depl_cost_doc_breeder_year ,
    COALESCE(SUM(COALESCE(z_depl_transportation_doc_year,0)),0) AS farm_z_depl_transportation_doc_year ,
    COALESCE(SUM(COALESCE(z_depl_feed_used_year,0)),0) AS farm_z_depl_feed_used_year ,
    COALESCE(SUM(COALESCE(z_depl_transportation_feed_year,0)),0) AS farm_z_depl_transportation_feed_year ,
    COALESCE(SUM(COALESCE(z_depl_medicine_used_year,0)),0) AS farm_z_depl_medicine_used_year ,
    COALESCE(SUM(COALESCE(z_depl_direct_labor_year,0)),0) AS farm_z_depl_direct_labor_year ,
    COALESCE(SUM(COALESCE(z_depl_farm_overhead_year,0)),0) AS farm_z_depl_farm_overhead_year ,
    COALESCE(SUM(COALESCE(z_depl_repair_maintenance_year,0)),0) AS farm_z_depl_repair_maintenance_year ,
    COALESCE(SUM(COALESCE(z_depl_depreciation_year,0)),0) AS farm_z_depl_depreciation_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_yearx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_year,0)) END,0)
    AS farm_z_Total_Qty_to_produce_EGGS_year ,

    COALESCE(SUM(COALESCE(z_Cost_produce_Eggs_year,0)),0) AS farm_z_Cost_produce_Eggs_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he_year,0))*-1) END,0)
    AS farm_z_qty_non_he_year ,

    COALESCE((SUM(COALESCE(z_income_from_non_he_year,0))*-1),0) AS farm_z_income_from_non_he_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_he_yearx,0))
    ELSE SUM(COALESCE(z_qty_produce_he_year,0)) END,0)
    AS farm_z_qty_produce_he_year ,

    COALESCE(SUM(COALESCE(z_cost_produce_he_year,0)),0) AS farm_z_cost_produce_he_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_year,0)) END,0)
    AS farm_z_qty_he_inventory_farm_begin_year ,

    COALESCE(SUM(COALESCE(z_he_inventory_farm_begin_year,0)),0) AS farm_z_he_inventory_farm_begin_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm_year,0)) END,0)
    AS farm_z_qty_he_from_farm_year ,

    COALESCE(SUM(COALESCE(z_cost_he_from_farm_year,0)),0) AS farm_z_cost_he_from_farm_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm_year,0)) END,0)
    AS farm_z_qty_he_available_farm_year ,

    COALESCE(SUM(COALESCE(z_he_available_in_farm_year,0)),0) AS farm_z_he_available_in_farm_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_year,0))*-1) END,0)
    AS farm_z_qty_he_sales_to_affiliate_year ,

    COALESCE((SUM(COALESCE(z_he_sales_to_affiliate_year,0))*-1),0) AS farm_z_he_sales_to_affiliate_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_year,0))*-1) END,0)
    AS farm_z_qty_he_ending_bef_transfer_year ,

    COALESCE((SUM(COALESCE(z_he_used_transfer_out_year,0))*-1),0) AS farm_z_he_ending_bef_transfer_out_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_year,0))*-1) END,0)
    AS farm_z_qty_he_used_transfer_out_year ,

    COALESCE((SUM(COALESCE(z_he_used_transfer_out_year,0))*-1),0) AS farm_z_he_used_transfer_out_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_farm_year,0)) END,0)
    AS farm_z_qty_he_ending_farm_year ,

    COALESCE(SUM(COALESCE(z_he_ending_farm_year,0)),0) AS farm_z_he_ending_farm_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_yearx,0))
    ELSE SUM(COALESCE(z_qty_year,0)) END,0)
    AS farm_z_qty_year ,

    COALESCE(SUM(COALESCE(z_sales_he_year,0)),0) AS farm_z_sales_he_year,

    ----------------------------------------------------------------------------------------------------------------

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_year,0)) END,0)
    AS farm_z_qty_he_inventory_farm_begin_h1_year  ,

    COALESCE(SUM(COALESCE(z_he_inventory_farm_begin_year,0)),0) AS farm_z_he_inventory_farm_begin_h1_year ,
    COALESCE(SUM(COALESCE(z_qty_he_ending_farm_year,0)),0) AS farm_z_qty_he_ending_farm_h1_year ,
    COALESCE(SUM(COALESCE(z_he_ending_farm_year,0)),0) AS farm_z_he_ending_farm_h1_year,
    COALESCE(SUM(COALESCE(z_fp_feed_used_year,0)),0) as farm_z_fp_feed_used_h1_year,
    COALESCE(SUM(COALESCE(z_fp_transportation_feed_year,0)),0) as farm_z_fp_transportation_feed_h1_year,
    COALESCE(SUM(COALESCE(z_fp_vaccine_medicine_used_year,0)),0) as farm_z_fp_vaccine_medicine_used_h1_year,
    COALESCE(SUM(COALESCE(z_fp_direct_labor_year,0)),0) as farm_z_fp_direct_labor_h1_year,
    COALESCE(SUM(COALESCE(z_fp_farm_overhead_year,0)),0) as farm_z_fp_farm_overhead_h1_year,
    COALESCE(SUM(COALESCE(z_fp_repair_maintenance_year,0)),0) as farm_z_fp_repair_maintenance_h1_year,
    COALESCE(SUM(COALESCE(z_fp_depreciation_year,0)),0) as farm_z_fp_depreciation_h1_year,
    COALESCE(SUM(COALESCE(z_depl_cost_doc_breeder_year,0)),0) as farm_z_depl_cost_doc_breeder_h1_year,
    COALESCE(SUM(COALESCE(z_depl_transportation_doc_year,0)),0) as farm_z_depl_transportation_doc_h1_year,
    COALESCE(SUM(COALESCE(z_depl_feed_used_year,0)),0) as farm_z_depl_feed_used_h1_year,
    COALESCE(SUM(COALESCE(z_depl_transportation_feed_year,0)),0) as farm_z_depl_transportation_feed_h1_year,
    COALESCE(SUM(COALESCE(z_depl_medicine_used_year,0)),0) as farm_z_depl_medicine_used_h1_year,
    COALESCE(SUM(COALESCE(z_depl_direct_labor_year,0)),0) as farm_z_depl_direct_labor_h1_year,
    COALESCE(SUM(COALESCE(z_depl_farm_overhead_year,0)),0) as farm_z_depl_farm_overhead_h1_year,
    COALESCE(SUM(COALESCE(z_depl_repair_maintenance_year,0)),0) as farm_z_depl_repair_maintenance_h1_year,
    COALESCE(SUM(COALESCE(z_depl_depreciation_year,0)),0) as farm_z_depl_depreciation_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_yearx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_year,0)) END,0)
    as farm_z_Total_Qty_to_produce_EGGS_h1_year,

    COALESCE(SUM(COALESCE(z_Cost_produce_Eggs_year,0)),0) as farm_z_Cost_produce_Eggs_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he_year,0))*-1) END,0)
    as farm_z_qty_non_he_h1_year,

    COALESCE((SUM(COALESCE(z_income_from_non_he_year,0))*-1),0) as farm_z_income_from_non_he_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_he_yearx,0))
    ELSE SUM(COALESCE(z_qty_produce_he_year,0)) END,0)
    as farm_z_qty_produce_he_h1_year,

    COALESCE(SUM(COALESCE(z_cost_produce_he_year,0)),0) as farm_z_cost_produce_he_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm_year,0)) END,0)
    as farm_z_qty_he_from_farm_h1_year,

    COALESCE(SUM(COALESCE(z_cost_he_from_farm_year,0)),0) as farm_z_cost_he_from_farm_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm_year,0)) END,0)
    as farm_z_qty_he_available_farm_h1_year,

    COALESCE(SUM(COALESCE(z_he_available_in_farm_year,0)),0) as farm_z_he_available_in_farm_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_year,0))*-1) END,0)
    as farm_z_qty_he_sales_to_affiliate_h1_year,

    COALESCE((SUM(COALESCE(z_he_sales_to_affiliate_year,0))*-1),0) as farm_z_he_sales_to_affiliate_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transfer_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer_year,0)) END,0)
    as farm_z_qty_he_ending_bef_transfer_h1_year,

    COALESCE(SUM(COALESCE(z_he_ending_bef_transfer_out_year,0)),0) as farm_z_he_ending_bef_transfer_out_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_year,0))*-1) END,0)
    as farm_z_qty_he_used_transfer_out_h1_year,

    COALESCE((SUM(COALESCE(z_he_used_transfer_out_year,0))*-1),0) as farm_z_he_used_transfer_out_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_yearx,0))
    ELSE SUM(COALESCE(z_qty_year,0)) END,0)
    AS farm_z_qty_h1_year,

    COALESCE(SUM(COALESCE(z_sales_he_year,0)),0) AS farm_z_sales_he_h1_year,

    0 AS qty_he_trf_to_br_13 ,
    0 AS he_trf_to_br_13,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_yearx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br_year,0)) *-1 END,0)
    as qty_he_trf_to_br_year_13,

    COALESCE(SUM(COALESCE(he_trf_to_br_year,0)),0) *-1 as he_trf_to_br_year_13,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_yearx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br_year,0)) *-1 END,0)
    as qty_he_trf_to_br_h1_year_13,

    COALESCE(SUM(COALESCE(he_trf_to_br_year,0)) *-1,0) as he_trf_to_br_h1_year_13,
    0 as cost_trf_he_to_br_13,
    0 as cost_trf_he_to_br_year_13,
    COALESCE(SUM(COALESCE(cost_trf_he_to_br_year,0)),0) as cost_trf_he_to_br_h1_year_13,

    0 AS z_cost_transfer_variance,
    0 AS z_cost_transfer_variance_year,
    COALESCE(SUM(COALESCE(z_cost_transfer_variance_year,0)),0) AS z_cost_transfer_variance_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_hex,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he,0)) *-1 END
    AS z_qty_adjustment_he,

    sum(COALESCE(z_adjustment_he,0))*-1 AS z_adjustment_he,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_yearx,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he_year,0)) *-1 END
    AS z_qty_adjustment_he_year,

    sum(COALESCE(z_adjustment_he_year,0))*-1 AS z_adjustment_he_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_h1_yearx,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he_h1_year,0)) *-1 END
    AS z_qty_adjustment_he_h1_year,

    sum(COALESCE(z_adjustment_he_h1_year,0))*-1 AS z_adjustment_he_h1_year


    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},
            (SELECT tab.c_period_id
                FROM
                (
                    SELECT DISTINCT zccf.c_period_id

                    ,ao.ad_org_id
                    ,zccf.branchtype
                    ,zccf.categoryname
                    ,zccf.breed
                    ,zccf.sexline

                    FROM z_cost_calc_farm_cpjf zccf
                    INNER JOIN adempiere.ad_org ao ON ao.description = zccf.z_farm_code -- z_unit
                    WHERE zccf.ad_client_id = $P{AD_Client_ID} AND zccf.ad_org_id = $P{AD_Org_ID}
                    AND ($P{z_unit_ID} is null or ao.ad_org_id = $P{z_unit_ID})
                        AND (CASE WHEN $P{BranchType} IS NOT NULL THEN zccf.branchtype = $P{BranchType} ELSE 1=1 END)
                        AND (CASE WHEN $P{CategoryName} IS NOT NULL THEN zccf.categoryname = $P{CategoryName} ELSE 1=1 END)
                        AND (CASE WHEN $P{Breed} IS NOT NULL THEN left(zccf.breed,4) = $P{Breed} ELSE 1=1 END)
                        AND (CASE WHEN $P{SexLine} IS NOT NULL THEN zccf.sexline = $P{SexLine} ELSE 1=1 END)
                        AND $P{Trading} = 'N'
                        AND $P{Layer} = 'N'
                        AND $P{Bpsold} = 'N'

                    ORDER BY branchtype,categoryname,breed,sexline

                )tab
                ORDER BY c_period_id DESC LIMIT 1)::integer,
                $P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}
      )
    WHERE
    $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND (SELECT z_fp_feed_used
        FROM adempiere.z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}) -- di union 1 farm NULL
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        LIMIT 1) IS NULL
    )farm_bulan_lalu
    CROSS JOIN
    (
    SELECT

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_beginning_hatcheryx,0)),0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery,0)),0) END
    AS  hatchery_z_qty_he_beginning_hatchery,

    COALESCE(SUM(COALESCE(z_he_beginning_hatchery,0)) ,0)  AS  hatchery_z_he_beginning_hatchery,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_grx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr,0)) ,0) END
    AS hatchery_z_qty_he_transfer_farm_bef_gr,

    COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_brx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br,0)) ,0)  END
    AS hatchery_z_qty_add_he_transfer_from_br,

    COALESCE(SUM(COALESCE(z_add_he_transfer_from_br,0)) ,0)  AS hatchery_z_add_he_transfer_from_br,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_cox,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co,0)) ,0) END
    AS hatchery_z_qty_he_purchase_affiliate_co,

    COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co,
    COALESCE(SUM(COALESCE(z_transportation_he,0)) ,0)  AS hatchery_z_transportation_he,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_available_gr_processx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_available_gr_process,0)) ,0)  END
    AS hatchery_z_qty_he_available_gr_process,

    COALESCE(SUM(COALESCE(z_he_available_to_gr_process,0)) ,0)  AS hatchery_z_he_available_to_gr_process,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_soldx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_sold,0))*-1) ,0)  END
    AS hatchery_z_qty_non_he_sold,

    COALESCE((SUM(COALESCE(z_non_he_sold,0))*-1) ,0)  AS hatchery_z_non_he_sold,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_csrx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_csr,0))*-1) ,0)  END
    AS hatchery_z_qty_non_he_csr,

    COALESCE((SUM(COALESCE(z_non_he_csr,0))*-1) ,0)  AS hatchery_z_non_he_csr,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_docx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc,0)) ,0)  END
    AS hatchery_z_qty_he_avail_to_produce_doc,

    COALESCE(SUM(COALESCE(z_he_available_to_produce_doc,0)) ,0)  AS hatchery_z_he_available_to_produce_doc,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_processx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_hatch_process,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_processx,0))) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process,0))) ,0) END
    AS hatchery_cost_of_he_put_into_hatcher,

    COALESCE((SUM(COALESCE(z_he_used_to_hatching_process,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_destroyx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_destroy,

    COALESCE((SUM(COALESCE(z_he_used_to_destroy,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_endx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end,0)) ,0) END
    AS hatchery_z_qty_he_invent_hatchery_end,

    COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending,
    COALESCE(SUM(COALESCE(z_income_from_non_he,0)) ,0)  AS hatchery_z_income_from_non_he,
    COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher,
    COALESCE(SUM(COALESCE(z_hc_feed,0)) ,0)  AS hatchery_z_hc_feed,
    COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler,
    COALESCE(SUM(COALESCE(z_hc_hatchery_overhead,0)) ,0)  AS hatchery_z_hc_hatchery_overhead,
    COALESCE(SUM(COALESCE(z_hc_repair_maintenance,0)) ,0)  AS hatchery_z_hc_repair_maintenance,
    COALESCE(SUM(COALESCE(z_hc_depreciation,0)) ,0)  AS hatchery_z_hc_depreciation,
    COALESCE(SUM(COALESCE(z_hc_boxes_used,0)) ,0)  AS hatchery_z_hc_boxes_used,
    COALESCE(SUM(COALESCE(z_income_from_male *-1, 0)) ,0)  AS hatchery_z_income_from_male,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_income_from_malex *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_income_from_male *-1, 0)) ,0) END
    AS hatchery_z_qty_income_from_male,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_income_from_infertile_eggsx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_income_from_infertile_eggs *-1, 0)) ,0) END
    AS hatchery_z_income_from_infertile_eggs,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_dead_in_shellx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_dead_in_shell *-1, 0)) ,0) END
    AS hatchery_z_dead_in_shell,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_lossx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_loss *-1, 0)) ,0) END
    AS hatchery_z_loss,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_to_produce_docx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_to_produce_doc,0)) ,0) END
    AS hatchery_z_qty_to_produce_doc,


    COALESCE(SUM(COALESCE(z_amount_to_produce_doc,0)) ,0)  AS hatchery_z_amount_to_produce_doc,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_culledx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_culled *-1, 0)) ,0) END
    AS hatchery_z_qty_doc_culled,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_killedx *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_killed *-1, 0)) ,0) END
    AS hatchery_z_qty_doc_killed,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransix *-1, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi *-1, 0)) ,0) END
    AS hatchery_z_qty_doc_extra_toleransi,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_available_for_salesx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales,0)) ,0) END
    AS hatchery_z_qty_doc_available_for_sales,

    COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales,

    
    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarmx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm,0)) ,0) END
    AS hatchery_z_deductqtytfdodtocomfarm,

    COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_add_qty_begiining_docx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_add_qty_begiining_doc,0)) ,0) END
    AS hatchery_z_add_qty_begiining_doc,

    COALESCE(SUM(COALESCE(z_add_begiining_doc,0)) ,0)  AS hatchery_z_add_begiining_doc,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deduct_qty_ending_docx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc,0)) ,0) END
    AS hatchery_z_deduct_qty_ending_doc,

    COALESCE(SUM(COALESCE(z_deduct_ending_doc,0)) ,0)  AS hatchery_z_deduct_ending_doc,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_brx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br,0)) ,0) END
    AS hatchery_z_total_qty_cost_trans_to_br,

    COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_total_cost_of_salesx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales,0)) ,0) END
    AS hatchery_z_qty_total_cost_of_sales,

    COALESCE(SUM(COALESCE(z_total_cost_of_sales,0)) ,0)  AS hatchery_z_total_cost_of_sales,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_year,0)) ,0) END
    AS  hatchery_z_qty_he_beginning_hatchery_year,

    COALESCE(SUM(COALESCE(z_he_beginning_hatchery_year,0)) ,0)  AS  hatchery_z_he_beginning_hatchery_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_year,0)) ,0) END
    AS hatchery_z_qty_he_transfer_farm_bef_gr_year,

    COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr_year,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_year,0)) ,0) END
    AS hatchery_z_qty_add_he_transfer_from_br_year,

    COALESCE(SUM(COALESCE(z_add_he_transfer_from_br_year,0)) ,0)  AS hatchery_z_add_he_transfer_from_br_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_year,0)) ,0)  END
    AS hatchery_z_qty_he_purchase_affiliate_co_year,

    COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co_year,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co_year,
    COALESCE(SUM(COALESCE(z_transportation_he_year,0)) ,0)  AS hatchery_z_transportation_he_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_year,0)) ,0)  END
    AS hatchery_z_qty_he_available_gr_process_year,

    COALESCE(SUM(COALESCE(z_he_available_to_gr_process_year,0)) ,0)  AS hatchery_z_he_available_to_gr_process_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_sold_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_sold_year,0))*-1) ,0)  END
    AS hatchery_z_qty_non_he_sold_year,

    COALESCE((SUM(COALESCE(z_non_he_sold_year,0))*-1) ,0)  AS hatchery_z_non_he_sold_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_csr_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_csr_year,0))*-1) ,0) END
    AS hatchery_z_qty_non_he_csr_year,

    COALESCE((SUM(COALESCE(z_non_he_csr_year,0))*-1) ,0)  AS hatchery_z_non_he_csr_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_year,0)) ,0)  END
    AS hatchery_z_qty_he_avail_to_produce_doc_year,

    COALESCE(SUM(COALESCE(z_he_available_to_produce_doc_year,0)) ,0)  AS hatchery_z_he_available_to_produce_doc_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_year,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_hatch_process_year,

    COALESCE((SUM(COALESCE(z_he_used_to_hatching_process_year,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_year,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_destroy_year,

    COALESCE((SUM(COALESCE(z_he_used_to_destroy_year,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_year,0)) ,0)  END
    AS hatchery_z_qty_he_invent_hatchery_end_year,

    COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending_year,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending_year,
    COALESCE(SUM(COALESCE(z_income_from_non_he_year,0)) ,0)  AS hatchery_z_income_from_non_he_year,
    COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher_year,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher_year,
    COALESCE(SUM(COALESCE(z_hc_feed_year,0)) ,0)  AS hatchery_z_hc_feed_year,
    COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler_year,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler_year,
    COALESCE(SUM(COALESCE(z_hc_hatchery_overhead_year,0)) ,0)  AS hatchery_z_hc_hatchery_overhead_year,
    COALESCE(SUM(COALESCE(z_hc_repair_maintenance_year,0)) ,0)  AS hatchery_z_hc_repair_maintenance_year,
    COALESCE(SUM(COALESCE(z_hc_depreciation_year,0)) ,0)  AS hatchery_z_hc_depreciation_year,
    COALESCE(SUM(COALESCE(z_hc_boxes_used_year,0)) ,0)  AS hatchery_z_hc_boxes_used_year,
    COALESCE(SUM(COALESCE(z_income_from_male_year,0)) ,0)  AS hatchery_z_income_from_male_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_income_from_male_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_income_from_male_year,0)) ,0) END
    AS hatchery_z_qty_income_from_male_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_year,0)) ,0) end
    AS hatchery_z_income_from_infertile_eggs_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_dead_in_shell_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_dead_in_shell_year,0)) ,0) END
    AS hatchery_z_dead_in_shell_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_loss_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_loss_year,0)) ,0) END
    AS hatchery_z_loss_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_to_produce_doc_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_to_produce_doc_year,0)) ,0) END
    AS hatchery_z_qty_to_produce_doc_year,


    COALESCE(SUM(COALESCE(z_amount_to_produce_doc_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_culled_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_culled_year,0)) ,0) END
    AS hatchery_z_qty_doc_culled_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_killed_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_killed_year,0)) ,0) END
    AS hatchery_z_qty_doc_killed_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_e_yearxtra_toleransi_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi_year,0)) ,0) END
    AS hatchery_z_qty_doc_extra_toleransi_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_year,0)) ,0) END
    AS hatchery_z_qty_doc_available_for_sales_year,

    COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_year * -1,0)) ,0) END
    AS hatchery_z_deductqtytfdodtocomfarm_year,

    COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm_year,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_year,0)) ,0) END
    AS hatchery_z_add_qty_begiining_doc_year,

    COALESCE(SUM(COALESCE(z_add_begiining_doc_year,0)) ,0)  AS hatchery_z_add_begiining_doc_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_year,0)) ,0) END
    AS hatchery_z_deduct_qty_ending_doc_year,

    COALESCE(SUM(COALESCE(z_deduct_ending_doc_year,0)) ,0)  AS hatchery_z_deduct_ending_doc_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_year,0)) ,0) END
    AS hatchery_z_total_qty_cost_trans_to_br_year,

    COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf_year,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_year,0)) ,0) END
    AS hatchery_z_qty_total_cost_of_sales_year,

    COALESCE(SUM(COALESCE(z_total_cost_of_sales_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_h1_year,0)) ,0) END
    AS  hatchery_z_qty_he_beginning_hatchery_h1_year,

    COALESCE(SUM(COALESCE(z_he_beginning_hatchery_h1_year,0)) ,0)  AS  hatchery_z_he_beginning_hatchery_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_h1_year,0)) ,0)  END
    AS hatchery_z_qty_he_transfer_farm_bef_gr_h1_year,

    COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr_h1_year,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_h1_year,0)) ,0) END
    AS hatchery_z_qty_add_he_transfer_from_br_h1_year,

    COALESCE(SUM(COALESCE(z_add_he_transfer_from_br_h1_year,0)) ,0)  AS hatchery_z_add_he_transfer_from_br_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_h1_year,0)) ,0) END
    AS hatchery_z_qty_he_purchase_affiliate_co_h1_year,

    COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co_h1_year,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co_h1_year,
    COALESCE(SUM(COALESCE(z_transportation_he_h1_year,0)) ,0)  AS hatchery_z_transportation_he_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_h1_year,0)) ,0)  END
    AS hatchery_z_qty_he_available_gr_process_h1_year,

    COALESCE(SUM(COALESCE(z_he_available_to_gr_process_h1_year,0)) ,0)  AS hatchery_z_he_available_to_gr_process_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_sold_h1_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_sold_h1_year,0))*-1) ,0) END
    AS hatchery_z_qty_non_he_sold_h1_year,

    COALESCE((SUM(COALESCE(z_non_he_sold_h1_year,0))*-1) ,0)  AS hatchery_z_non_he_sold_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_non_he_csr_h1_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_non_he_csr_h1_year,0))*-1) ,0)  END
    AS hatchery_z_qty_non_he_csr_h1_year,

    COALESCE((SUM(COALESCE(z_non_he_csr_h1_year,0))*-1) ,0)  AS hatchery_z_non_he_csr_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_h1_year,0)) ,0)  END
    AS hatchery_z_qty_he_avail_to_produce_doc_h1_year,

    COALESCE(SUM(COALESCE(z_he_available_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_he_available_to_produce_doc_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_h1_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_h1_year,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_hatch_process_h1_year,

    COALESCE((SUM(COALESCE(z_he_used_to_hatching_process_h1_year,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_h1_yearx,0))*-1) ,0)
    ELSE COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_h1_year,0))*-1) ,0) END
    AS hatchery_z_qty_he_used_to_destroy_h1_year,

    COALESCE((SUM(COALESCE(z_he_used_to_destroy_h1_year,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_h1_year,0)) ,0) END
    AS hatchery_z_qty_he_invent_hatchery_end_h1_year,

    COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending_h1_year,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending_h1_year,
    COALESCE(SUM(COALESCE(z_income_from_non_he_h1_year,0)) ,0)  AS hatchery_z_income_from_non_he_h1_year,
    COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher_h1_year,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher_h1_year,
    COALESCE(SUM(COALESCE(z_hc_feed_h1_year,0)) ,0)  AS hatchery_z_hc_feed_h1_year,
    COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler_h1_year,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler_h1_year,
    COALESCE(SUM(COALESCE(z_hc_hatchery_overhead_h1_year,0)) ,0)  AS hatchery_z_hc_hatchery_overhead_h1_year,
    COALESCE(SUM(COALESCE(z_hc_repair_maintenance_h1_year,0)) ,0)  AS hatchery_z_hc_repair_maintenance_h1_year,
    COALESCE(SUM(COALESCE(z_hc_depreciation_h1_year,0)) ,0)  AS hatchery_z_hc_depreciation_h1_year,
    COALESCE(SUM(COALESCE(z_hc_boxes_used_h1_year,0)) ,0)  AS hatchery_z_hc_boxes_used_h1_year,
    COALESCE(SUM(COALESCE(z_income_from_male_h1_year,0)) ,0)  AS hatchery_z_income_from_male_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_income_from_male_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_income_from_male_h1_year,0)),0) END
    AS hatchery_z_qty_income_from_male_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_h1_yearx,0)),0)
    ELSE COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_h1_year,0)),0) END  AS hatchery_z_income_from_infertile_eggs_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_dead_in_shell_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_dead_in_shell_h1_year,0)) ,0) END
    AS hatchery_z_dead_in_shell_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_loss_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_loss_h1_year,0)) ,0) END
    AS hatchery_z_loss_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_to_produce_doc_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_to_produce_doc_h1_year,0)) ,0) END
    AS hatchery_z_qty_to_produce_doc_h1_year,


    COALESCE(SUM(COALESCE(z_amount_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_culled_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_culled_h1_year,0)) ,0) END
    AS hatchery_z_qty_doc_culled_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_killed_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_killed_h1_year,0)) ,0) END
    AS hatchery_z_qty_doc_killed_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_e_h1_yearxtra_toleransi_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi_h1_year,0)) ,0)  END
    AS hatchery_z_qty_doc_extra_toleransi_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_h1_year,0)) ,0)  END
    AS hatchery_z_qty_doc_available_for_sales_h1_year,

    COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales_h1_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_h1_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_h1_year * -1,0)) ,0) END
    AS hatchery_z_deductqtytfdodtocomfarm_h1_year,

    COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm_h1_year,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_h1_year,0)) ,0) END
    AS hatchery_z_add_qty_begiining_doc_h1_year,

    COALESCE(SUM(COALESCE(z_add_begiining_doc_h1_year,0)) ,0)  AS hatchery_z_add_begiining_doc_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_h1_year,0)) ,0) END
    AS hatchery_z_deduct_qty_ending_doc_h1_year,

    COALESCE(SUM(COALESCE(z_deduct_ending_doc_h1_year,0)) ,0)  AS hatchery_z_deduct_ending_doc_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_h1_year,0)) ,0) END
    AS hatchery_z_total_qty_cost_trans_to_br_h1_year,

    COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf_h1_year,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_h1_yearx,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_h1_year,0)) ,0) END
    AS hatchery_z_qty_total_cost_of_sales_h1_year,

    COALESCE(SUM(COALESCE(z_total_cost_of_sales_h1_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(AVG(COALESCE(z_salable_chickx,0)),0)
    ELSE COALESCE(AVG(COALESCE(z_salable_chick,0)),0) END AS
    hatchery_z_salable_chick,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(AVG(COALESCE(z_hatchabilityx,0)),0)
    ELSE COALESCE(AVG(COALESCE(z_hatchability,0)),0) END
    AS hatchery_z_hatchability,


    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_to_brx,0)) ,0) * -1
    ELSE COALESCE(SUM(COALESCE(qty_he_trf_to_br,0)) ,0) * -1 END
    AS qty_he_trf_to_br,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_to_br_yearx,0)) ,0) * -1
    ELSE COALESCE(SUM(COALESCE(qty_he_trf_to_br_year,0)) ,0) * -1 END
    AS qty_he_trf_to_br_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_qty_he_transfer_to_br_h1_yearx,0)) ,0) * -1
    ELSE COALESCE(SUM(COALESCE(qty_he_trf_to_br_h1_year,0)) ,0) * -1 END
    AS qty_he_trf_to_br_h1_year,

    COALESCE(SUM(COALESCE(he_trf_to_br,0)) ,0) *-1 AS he_trf_to_br,
    COALESCE(SUM(COALESCE(he_trf_to_br_year,0)) ,0) *-1 AS he_trf_to_br_year,
    COALESCE(SUM(COALESCE(he_trf_to_br_h1_year,0)) ,0) *-1 AS he_trf_to_br_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_Qty_HE_sales_to_affiliatex * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(qty_he_sales_to_aff * -1,0)) ,0) END
    AS qty_he_sales_to_aff,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_Qty_HE_sales_to_affiliate_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(qty_he_sales_to_aff_year * -1,0)) ,0) END
    AS qty_he_sales_to_aff_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_Qty_HE_sales_to_affiliate_h1_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(qty_he_sales_to_aff_h1_year * -1,0)) ,0)  END
    AS qty_he_sales_to_aff_h1_year,

    COALESCE(SUM(COALESCE(he_sales_to_aff * -1,0)) ,0)  AS he_sales_to_aff,
    COALESCE(SUM(COALESCE(he_sales_to_aff_year * -1,0)) ,0)  AS he_sales_to_aff_year,
    COALESCE(SUM(COALESCE(he_sales_to_aff_h1_year * -1,0)) ,0)  AS he_sales_to_aff_h1_year,

    COALESCE(SUM(COALESCE(cost_trf_he_to_br,0)) ,0)  AS cost_trf_he_to_br,
    COALESCE(SUM(COALESCE(cost_trf_he_to_br_year,0)) ,0)  AS cost_trf_he_to_br_year,
    COALESCE(SUM(COALESCE(cost_trf_he_to_br_h1_year,0)) ,0)  AS cost_trf_he_to_br_h1_year,
    COALESCE(SUM(COALESCE(sales_he_to_affiliate,0)) ,0)  AS sales_he_to_affiliate,
    COALESCE(SUM(COALESCE(sales_he_to_affiliate_year,0)) ,0)  AS sales_he_to_affiliate_year,
    COALESCE(SUM(COALESCE(sales_he_to_affiliate_h1_year,0)) ,0)  AS sales_he_to_affiliate_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreedx, 0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed, 0)) ,0) END
    AS deductqtytfdodtofarmbreed,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_year * -1,0)) ,0) END
    AS deductqtytfdodtofarmbreed_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_h1_yearx * -1,0)) ,0)
    ELSE COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_h1_year * -1,0)) ,0) END
    AS deductqtytfdodtofarmbreed_h1_year,

    COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed,0)) ,0)  AS deductcosttfdodtofarmbreed,
    COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed_year,0)) ,0)  AS deductcosttfdodtofarmbreed_year,
    COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed_h1_year,0)) ,0)  AS deductcosttfdodtofarmbreed_h1_year,

    COALESCE(SUM(COALESCE(qtymoveinouthehatch,0)),0) AS qtymoveinouthehatch,
    COALESCE(SUM(COALESCE(amountmoveinouthehatch,0)),0) AS  amountmoveinouthehatch,
    COALESCE(SUM(COALESCE(qtymoveinouthehatch_year,0)),0) AS  qtymoveinouthehatch_year,
    COALESCE(SUM(COALESCE(amountmoveinouthehatch_year,0)),0) AS  amountmoveinouthehatch_year,
    COALESCE(SUM(COALESCE(qtymoveinouthehatch_h1_year,0)),0) AS  qtymoveinouthehatch_h1_year,
    COALESCE(SUM(COALESCE(amountmoveinouthehatch_h1_year,0)),0) AS  amountmoveinouthehatch_h1_year,


    COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc,0)),0) AS qtyheAvailBefGradAfterMovehatc,
    COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc,0)),0) AS heAvailBefGradAfterMovehatc,
    COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc_year,0)),0) AS qtyheAvailBefGradAfterMovehatc_year,
    COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc_year,0)),0) AS heAvailBefGradAfterMovehatc_year,
    COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc_h1_year,0)),0) AS qtyheAvailBefGradAfterMovehatc_h1_year,
    COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc_h1_year,0)),0) AS heAvailBefGradAfterMovehatc_h1_year,

    COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_grxx,0)),0) AS z_qty_he_avail_bfr_gr,
    COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_gr_year,0)),0) AS z_qty_he_avail_bfr_gr_year,
    COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_gr_h1_year,0)),0) AS z_qty_he_avail_bfr_gr_h1_year,
    COALESCE(SUM(COALESCE(z_he_avail_bfr_grxx,0)),0) AS z_he_avail_bfr_gr,
    COALESCE(SUM(COALESCE(z_he_avail_bfr_gr_year,0)),0) AS z_he_avail_bfr_gr_year,
    COALESCE(SUM(COALESCE(z_he_avail_bfr_gr_h1_year,0)),0) AS z_he_avail_bfr_gr_h1_year,

    COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue,0)),0) AS z_incomefrominfertile_eggvalue,
    COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue_year,0)),0) AS z_incomefrominfertile_eggvalue_year,
    COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue_h1_year,0)),0) AS z_incomefrominfertile_eggvalue_h1_year,

    COALESCE(SUM(COALESCE(z_qty_docsumbangan,0)),0) AS z_qty_docsumbangan,
    COALESCE(SUM(COALESCE(z_qty_docsumbangan_year,0)),0) AS z_qty_docsumbangan_year,
    COALESCE(SUM(COALESCE(z_qty_docsumbangan_h1_year,0)),0) AS z_qty_docsumbangan_h1_year

    FROM z_get_cost_calculation_hatchery_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    ) AS hatchery
)tabel
WHERE (SELECT z_fp_feed_used FROM adempiere.z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}) -- di union 1 farm NULL
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        LIMIT 1) IS NULL
AND $P{Trading} = 'N'
AND $P{Layer} = 'N'
AND $P{Bpsold} = 'N'
AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
    (SELECT per.startdate FROM adempiere.z_costing_duck pgc
            INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
            WHERE pgc.ad_org_id = $P{AD_Org_ID}
            ORDER BY per.startdate ASC LIMIT 1
    )


UNION -- union_trading

    SELECT
    (select name from c_period cp where c_period_id = $P{C_Period_ID}) as periodname,
    (select name from ad_org ao where ad_org_id = $P{AD_Org_ID}) as orgname,
    (select name from ad_org ao where ao.ad_org_id = $P{z_unit_ID}) as unitname,
    '' AS brachtype,
    '' AS categoryname,
    '' breed,
    '' sexline,
    *,

    (farm_z_depl_cost_doc_breeder +
    farm_z_depl_transportation_doc +
    farm_z_depl_feed_used +
    farm_z_depl_transportation_feed +
    farm_z_depl_medicine_used +
    farm_z_depl_direct_labor +
    farm_z_depl_farm_overhead +
    farm_z_depl_repair_maintenance +
    farm_z_depl_depreciation) AS persen_depletion_of_flockgrowing_cost,

    (farm_z_depl_cost_doc_breeder_year +
    farm_z_depl_transportation_doc_year +
    farm_z_depl_feed_used_year +
    farm_z_depl_transportation_feed_year +
    farm_z_depl_medicine_used_year +
    farm_z_depl_direct_labor_year +
    farm_z_depl_farm_overhead_year +
    farm_z_depl_repair_maintenance_year +
    farm_z_depl_depreciation_year) AS persen_depletion_of_flockgrowing_cost_ytd,

    1 AS penanda_data, 3 orderkey

    FROM
    (
        (
        SELECT DISTINCT
        0 AS farm_z_fp_feed_used ,
        0 AS  farm_z_fp_transportation_feed,
        0 AS farm_z_fp_vaccine_medicine_used,
        0 AS farm_z_fp_direct_labor,
        0 AS farm_z_fp_farm_overhead,
        0 AS  farm_z_fp_repair_maintenance,
        0 AS  farm_z_fp_depreciation,
        0 AS  farm_z_depl_cost_doc_breeder,
        0 AS  farm_z_depl_transportation_doc,
        0 AS  farm_z_depl_feed_used,
        0 AS farm_z_depl_transportation_feed ,
        0 AS  farm_z_depl_medicine_used,
        0 AS  farm_z_depl_direct_labor,
        0 AS  farm_z_depl_farm_overhead,
        0 AS farm_z_depl_repair_maintenance ,
        0 AS farm_z_depl_depreciation ,
        0 AS farm_z_Total_Qty_to_produce_EGGS ,
        0 AS farm_z_Cost_produce_Eggs ,
        0 AS farm_z_qty_non_he ,
        0 AS farm_z_income_from_non_he ,
        0 AS farm_z_qty_produce_he ,
        0 AS farm_z_cost_produce_he ,
        0 AS farm_z_qty_he_inventory_farm_begin ,
        0 AS farm_z_he_inventory_farm_begin ,
        0 AS farm_z_qty_he_from_farm ,
        0 AS farm_z_cost_he_from_farm ,
        0 AS farm_z_qty_he_available_farm ,
        0 AS farm_z_he_available_in_farm ,
        0 AS farm_z_qty_he_sales_to_affiliate ,
        0 AS farm_z_he_sales_to_affiliate ,
        0 AS farm_z_qty_he_ending_bef_transfer ,
        0 AS farm_z_he_ending_bef_transfer_out ,
        0 AS farm_z_qty_he_used_transfer_out ,
        0 AS farm_z_he_used_transfer_out ,
        0 AS farm_z_qty_he_ending_farm ,
        0 AS farm_z_he_ending_farm ,
        0 AS farm_z_qty ,
        0 AS farm_z_sales_he,
        0 AS farm_z_fp_feed_used_year ,
        0 AS farm_z_fp_transportation_feed_year ,
        0 AS farm_z_fp_vaccine_medicine_used_year ,
        0 AS farm_z_fp_direct_labor_year ,
        0 AS farm_z_fp_farm_overhead_year ,
        0 AS farm_z_fp_repair_maintenance_year ,
        0 AS farm_z_fp_depreciation_year ,
        0 AS farm_z_depl_cost_doc_breeder_year ,
        0 AS farm_z_depl_transportation_doc_year ,
        0 AS farm_z_depl_feed_used_year ,
        0 AS farm_z_depl_transportation_feed_year ,
        0 AS farm_z_depl_medicine_used_year ,
        0 AS farm_z_depl_direct_labor_year ,
        0 AS farm_z_depl_farm_overhead_year ,
        0 AS farm_z_depl_repair_maintenance_year ,
        0 AS farm_z_depl_depreciation_year ,
        0 AS farm_z_Total_Qty_to_produce_EGGS_year ,
        0 AS farm_z_Cost_produce_Eggs_year ,
        0 AS farm_z_qty_non_he_year ,
        0 AS farm_z_income_from_non_he_year ,
        0 AS farm_z_qty_produce_he_year ,
        0 AS farm_z_cost_produce_he_year ,
        0 AS farm_z_qty_he_inventory_farm_begin_year ,
        0 AS farm_z_he_inventory_farm_begin_year ,
        0 AS farm_z_qty_he_from_farm_year ,
        0 AS farm_z_cost_he_from_farm_year ,
        0 AS farm_z_qty_he_available_farm_year ,
        0 AS farm_z_he_available_in_farm_year ,
        0 AS farm_z_qty_he_sales_to_affiliate_year ,
        0 AS farm_z_he_sales_to_affiliate_year ,
        0 AS farm_z_qty_he_ending_bef_transfer_year ,
        0 AS farm_z_he_ending_bef_transfer_out_year ,
        0 AS farm_z_qty_he_used_transfer_out_year ,
        0 AS farm_z_he_used_transfer_out_year ,
        0 AS farm_z_qty_he_ending_farm_year ,
        0 AS farm_z_he_ending_farm_year ,
        0 AS farm_z_qty_year ,
        0 AS farm_z_sales_he_year,
        0 AS farm_z_qty_he_inventory_farm_begin_h1_year  ,
        0 AS farm_z_he_inventory_farm_begin_h1_year ,
        0 AS farm_z_qty_he_ending_farm_h1_year ,
        0 AS farm_z_he_ending_farm_h1_year,
        0 as farm_z_fp_feed_used_h1_year,
        0 as farm_z_fp_transportation_feed_h1_year,
        0 as farm_z_fp_vaccine_medicine_used_h1_year,
        0 as farm_z_fp_direct_labor_h1_year,
        0 as farm_z_fp_farm_overhead_h1_year,
        0 as farm_z_fp_repair_maintenance_h1_year,
        0 as farm_z_fp_depreciation_h1_year,
        0 as farm_z_depl_cost_doc_breeder_h1_year,
        0 as farm_z_depl_transportation_doc_h1_year,
        0 as farm_z_depl_feed_used_h1_year,
        0 as farm_z_depl_transportation_feed_h1_year,
        0 as farm_z_depl_medicine_used_h1_year,
        0 as farm_z_depl_direct_labor_h1_year,
        0 as farm_z_depl_farm_overhead_h1_year,
        0 as farm_z_depl_repair_maintenance_h1_year,
        0 as farm_z_depl_depreciation_h1_year,
        0 as farm_z_Total_Qty_to_produce_EGGS_h1_year,
        0 as farm_z_Cost_produce_Eggs_h1_year,
        0 as farm_z_qty_non_he_h1_year,
        0 as farm_z_income_from_non_he_h1_year,
        0 as farm_z_qty_produce_he_h1_year,
        0 as farm_z_cost_produce_he_h1_year,
        0 as farm_z_qty_he_from_farm_h1_year,
        0 as farm_z_cost_he_from_farm_h1_year,
        0 as farm_z_qty_he_available_farm_h1_year,
        0 as farm_z_he_available_in_farm_h1_year,
        0 as farm_z_qty_he_sales_to_affiliate_h1_year,
        0 as farm_z_he_sales_to_affiliate_h1_year,
        0 as farm_z_qty_he_ending_bef_transfer_h1_year,
        0 as farm_z_he_ending_bef_transfer_out_h1_year,
        0 as farm_z_qty_he_used_transfer_out_h1_year,
        0 as farm_z_he_used_transfer_out_h1_year,
        0 AS farm_z_qty_h1_year,
        0 AS farm_z_sales_he_h1_year,

        0 AS qty_he_trf_to_br_13 ,
        0 AS he_trf_to_br_13,
        0 as qty_he_trf_to_br_year_13,
        0 as he_trf_to_br_year_13,
        0 as qty_he_trf_to_br_h1_year_13,
        0 as he_trf_to_br_h1_year_13,
        0 as cost_trf_he_to_br_13,
        0 as cost_trf_he_to_br_year_13,
        0 as cost_trf_he_to_br_h1_year_13,

        0::numeric AS z_cost_transfer_variance,
        0::numeric AS z_cost_transfer_variance_year,
        0::numeric AS z_cost_transfer_variance_h1_year,

        0 AS z_qty_adjustment_he,
        0 AS z_adjustment_he,
        0 AS z_qty_adjustment_he_year,
        0 AS z_adjustment_he_year,
        0 AS z_qty_adjustment_he_h1_year,
        0 AS z_adjustment_he_h1_year

        FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
        WHERE
        $P{Trading} = 'Y'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
        ) AS farm_trading

        CROSS JOIN

        (
        SELECT
        COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery,0)),0)  AS  hatchery_z_qty_he_beginning_hatchery,
        COALESCE(SUM(COALESCE(z_he_beginning_hatchery,0)) ,0)  AS  hatchery_z_he_beginning_hatchery,
        COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr,0)) ,0)  AS hatchery_z_qty_he_transfer_farm_bef_gr,
        COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr,
        COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br,0)) ,0)  AS hatchery_z_qty_add_he_transfer_from_br,
        COALESCE(SUM(COALESCE(z_add_he_transfer_from_br,0)) ,0)  AS hatchery_z_add_he_transfer_from_br,
        COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co,0)) ,0)  AS hatchery_z_qty_he_purchase_affiliate_co,
        COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co,
        COALESCE(SUM(COALESCE(z_transportation_he,0)) ,0)  AS hatchery_z_transportation_he,
        COALESCE(SUM(COALESCE(z_qty_he_available_gr_process,0)) ,0)  AS hatchery_z_qty_he_available_gr_process,
        COALESCE(SUM(COALESCE(z_he_available_to_gr_process,0)) ,0)  AS hatchery_z_he_available_to_gr_process,
        COALESCE((SUM(COALESCE(z_qty_non_he_sold,0))*-1) ,0)  AS hatchery_z_qty_non_he_sold,
        COALESCE((SUM(COALESCE(z_non_he_sold,0))*-1) ,0)  AS hatchery_z_non_he_sold,
        COALESCE((SUM(COALESCE(z_qty_non_he_csr,0))*-1) ,0)  AS hatchery_z_qty_non_he_csr,
        COALESCE((SUM(COALESCE(z_non_he_csr,0))*-1) ,0)  AS hatchery_z_non_he_csr,
        COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc,0)) ,0)  AS hatchery_z_qty_he_avail_to_produce_doc,
        COALESCE(SUM(COALESCE(z_he_available_to_produce_doc,0)) ,0)  AS hatchery_z_he_available_to_produce_doc,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_hatch_process,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process,0))) ,0) AS hatchery_cost_of_he_put_into_hatcher,
        COALESCE((SUM(COALESCE(z_he_used_to_hatching_process,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_destroy,
        COALESCE((SUM(COALESCE(z_he_used_to_destroy,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy,
        COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end,0)) ,0)  AS hatchery_z_qty_he_invent_hatchery_end,
        COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending,
        COALESCE(SUM(COALESCE(z_income_from_non_he,0)) ,0)  AS hatchery_z_income_from_non_he,
        COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher,
        COALESCE(SUM(COALESCE(z_hc_feed,0)) ,0)  AS hatchery_z_hc_feed,
        COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler,
        COALESCE(SUM(COALESCE(z_hc_hatchery_overhead,0)) ,0)  AS hatchery_z_hc_hatchery_overhead,
        COALESCE(SUM(COALESCE(z_hc_repair_maintenance,0)) ,0)  AS hatchery_z_hc_repair_maintenance,
        COALESCE(SUM(COALESCE(z_hc_depreciation,0)) ,0)  AS hatchery_z_hc_depreciation,
        COALESCE(SUM(COALESCE(z_hc_boxes_used,0)) ,0)  AS hatchery_z_hc_boxes_used,
        COALESCE(SUM(COALESCE(z_income_from_male *-1, 0)) ,0)  AS hatchery_z_income_from_male,
        COALESCE(SUM(COALESCE(z_qty_income_from_male *-1, 0)) ,0)  AS hatchery_z_qty_income_from_male,
        COALESCE(SUM(COALESCE(z_income_from_infertile_eggs *-1, 0)) ,0)  AS hatchery_z_income_from_infertile_eggs,
        COALESCE(SUM(COALESCE(z_dead_in_shell *-1, 0)) ,0)  AS hatchery_z_dead_in_shell,
        COALESCE(SUM(COALESCE(z_loss *-1, 0)) ,0)  AS hatchery_z_loss,
        COALESCE(SUM(COALESCE(z_qty_to_produce_doc,0)) ,0)  AS hatchery_z_qty_to_produce_doc,
        COALESCE(SUM(COALESCE(z_amount_to_produce_doc,0)) ,0)  AS hatchery_z_amount_to_produce_doc,
        COALESCE(SUM(COALESCE(z_qty_doc_culled *-1, 0)) ,0)  AS hatchery_z_qty_doc_culled,
        COALESCE(SUM(COALESCE(z_qty_doc_killed *-1, 0)) ,0)  AS hatchery_z_qty_doc_killed,
        COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi *-1, 0)) ,0)  AS hatchery_z_qty_doc_extra_toleransi,
        COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales,0)) ,0)  AS hatchery_z_qty_doc_available_for_sales,
        COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm,0)) ,0)  AS hatchery_z_deductqtytfdodtocomfarm,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm,
        COALESCE(SUM(COALESCE(z_add_qty_begiining_doc,0)) ,0)  AS hatchery_z_add_qty_begiining_doc,
        COALESCE(SUM(COALESCE(z_add_begiining_doc,0)) ,0)  AS hatchery_z_add_begiining_doc,
        COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc,0)) ,0)  AS hatchery_z_deduct_qty_ending_doc,
        COALESCE(SUM(COALESCE(z_deduct_ending_doc,0)) ,0)  AS hatchery_z_deduct_ending_doc,
        COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br,0)) ,0)  AS hatchery_z_total_qty_cost_trans_to_br,
        COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf,
        COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales,0)) ,0)  AS hatchery_z_qty_total_cost_of_sales,
        COALESCE(SUM(COALESCE(z_total_cost_of_sales,0)) ,0)  AS hatchery_z_total_cost_of_sales,
        COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_year,0)) ,0)  AS  hatchery_z_qty_he_beginning_hatchery_year,
        COALESCE(SUM(COALESCE(z_he_beginning_hatchery_year,0)) ,0)  AS  hatchery_z_he_beginning_hatchery_year,
        COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_year,0)) ,0)  AS hatchery_z_qty_he_transfer_farm_bef_gr_year,
        COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr_year,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr_year,
        COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_year,0)) ,0)  AS hatchery_z_qty_add_he_transfer_from_br_year,
        COALESCE(SUM(COALESCE(z_add_he_transfer_from_br_year,0)) ,0)  AS hatchery_z_add_he_transfer_from_br_year,
        COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_year,0)) ,0)  AS hatchery_z_qty_he_purchase_affiliate_co_year,
        COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co_year,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co_year,
        COALESCE(SUM(COALESCE(z_transportation_he_year,0)) ,0)  AS hatchery_z_transportation_he_year,
        COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_year,0)) ,0)  AS hatchery_z_qty_he_available_gr_process_year,
        COALESCE(SUM(COALESCE(z_he_available_to_gr_process_year,0)) ,0)  AS hatchery_z_he_available_to_gr_process_year,
        COALESCE((SUM(COALESCE(z_qty_non_he_sold_year,0))*-1) ,0)  AS hatchery_z_qty_non_he_sold_year,
        COALESCE((SUM(COALESCE(z_non_he_sold_year,0))*-1) ,0)  AS hatchery_z_non_he_sold_year,
        COALESCE((SUM(COALESCE(z_qty_non_he_csr_year,0))*-1) ,0)  AS hatchery_z_qty_non_he_csr_year,
        COALESCE((SUM(COALESCE(z_non_he_csr_year,0))*-1) ,0)  AS hatchery_z_non_he_csr_year,
        COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_year,0)) ,0)  AS hatchery_z_qty_he_avail_to_produce_doc_year,
        COALESCE(SUM(COALESCE(z_he_available_to_produce_doc_year,0)) ,0)  AS hatchery_z_he_available_to_produce_doc_year,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_year,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_hatch_process_year,
        COALESCE((SUM(COALESCE(z_he_used_to_hatching_process_year,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process_year,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_year,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_destroy_year,
        COALESCE((SUM(COALESCE(z_he_used_to_destroy_year,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy_year,
        COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_year,0)) ,0)  AS hatchery_z_qty_he_invent_hatchery_end_year,
        COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending_year,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending_year,
        COALESCE(SUM(COALESCE(z_income_from_non_he_year,0)) ,0)  AS hatchery_z_income_from_non_he_year,
        COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher_year,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher_year,
        COALESCE(SUM(COALESCE(z_hc_feed_year,0)) ,0)  AS hatchery_z_hc_feed_year,
        COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler_year,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler_year,
        COALESCE(SUM(COALESCE(z_hc_hatchery_overhead_year,0)) ,0)  AS hatchery_z_hc_hatchery_overhead_year,
        COALESCE(SUM(COALESCE(z_hc_repair_maintenance_year,0)) ,0)  AS hatchery_z_hc_repair_maintenance_year,
        COALESCE(SUM(COALESCE(z_hc_depreciation_year,0)) ,0)  AS hatchery_z_hc_depreciation_year,
        COALESCE(SUM(COALESCE(z_hc_boxes_used_year,0)) ,0)  AS hatchery_z_hc_boxes_used_year,
        COALESCE(SUM(COALESCE(z_income_from_male_year,0)) ,0)  AS hatchery_z_income_from_male_year,
        COALESCE(SUM(COALESCE(z_qty_income_from_male_year,0)) ,0)  AS hatchery_z_qty_income_from_male_year,
        COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_year,0)) ,0)  AS hatchery_z_income_from_infertile_eggs_year,
        COALESCE(SUM(COALESCE(z_dead_in_shell_year,0)) ,0)  AS hatchery_z_dead_in_shell_year,
        COALESCE(SUM(COALESCE(z_loss_year,0)) ,0)  AS hatchery_z_loss_year,
        COALESCE(SUM(COALESCE(z_qty_to_produce_doc_year,0)) ,0)  AS hatchery_z_qty_to_produce_doc_year,
        COALESCE(SUM(COALESCE(z_amount_to_produce_doc_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_year,
        COALESCE(SUM(COALESCE(z_qty_doc_culled_year,0)) ,0)  AS hatchery_z_qty_doc_culled_year,
        COALESCE(SUM(COALESCE(z_qty_doc_killed_year,0)) ,0)  AS hatchery_z_qty_doc_killed_year,
        COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi_year,0)) ,0)  AS hatchery_z_qty_doc_extra_toleransi_year,
        COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_year,0)) ,0)  AS hatchery_z_qty_doc_available_for_sales_year,
        COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_year,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_year * -1,0)) ,0)  AS hatchery_z_deductqtytfdodtocomfarm_year,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm_year,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm_year,
        COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_year,0)) ,0)  AS hatchery_z_add_qty_begiining_doc_year,
        COALESCE(SUM(COALESCE(z_add_begiining_doc_year,0)) ,0)  AS hatchery_z_add_begiining_doc_year,
        COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_year,0)) ,0)  AS hatchery_z_deduct_qty_ending_doc_year,
        COALESCE(SUM(COALESCE(z_deduct_ending_doc_year,0)) ,0)  AS hatchery_z_deduct_ending_doc_year,
        COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_year,0)) ,0)  AS hatchery_z_total_qty_cost_trans_to_br_year,
        COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf_year,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf_year,
        COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_year,0)) ,0)  AS hatchery_z_qty_total_cost_of_sales_year,
        COALESCE(SUM(COALESCE(z_total_cost_of_sales_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_year,
        COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_h1_year,0)) ,0)  AS  hatchery_z_qty_he_beginning_hatchery_h1_year,
        COALESCE(SUM(COALESCE(z_he_beginning_hatchery_h1_year,0)) ,0)  AS  hatchery_z_he_beginning_hatchery_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_h1_year,0)) ,0)  AS hatchery_z_qty_he_transfer_farm_bef_gr_h1_year,
        COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr_h1_year,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr_h1_year,
        COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_h1_year,0)) ,0)  AS hatchery_z_qty_add_he_transfer_from_br_h1_year,
        COALESCE(SUM(COALESCE(z_add_he_transfer_from_br_h1_year,0)) ,0)  AS hatchery_z_add_he_transfer_from_br_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_h1_year,0)) ,0)  AS hatchery_z_qty_he_purchase_affiliate_co_h1_year,
        COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co_h1_year,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co_h1_year,
        COALESCE(SUM(COALESCE(z_transportation_he_h1_year,0)) ,0)  AS hatchery_z_transportation_he_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_h1_year,0)) ,0)  AS hatchery_z_qty_he_available_gr_process_h1_year,
        COALESCE(SUM(COALESCE(z_he_available_to_gr_process_h1_year,0)) ,0)  AS hatchery_z_he_available_to_gr_process_h1_year,
        COALESCE((SUM(COALESCE(z_qty_non_he_sold_h1_year,0))*-1) ,0)  AS hatchery_z_qty_non_he_sold_h1_year,
        COALESCE((SUM(COALESCE(z_non_he_sold_h1_year,0))*-1) ,0)  AS hatchery_z_non_he_sold_h1_year,
        COALESCE((SUM(COALESCE(z_qty_non_he_csr_h1_year,0))*-1) ,0)  AS hatchery_z_qty_non_he_csr_h1_year,
        COALESCE((SUM(COALESCE(z_non_he_csr_h1_year,0))*-1) ,0)  AS hatchery_z_non_he_csr_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_qty_he_avail_to_produce_doc_h1_year,
        COALESCE(SUM(COALESCE(z_he_available_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_he_available_to_produce_doc_h1_year,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_h1_year,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_hatch_process_h1_year,
        COALESCE((SUM(COALESCE(z_he_used_to_hatching_process_h1_year,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process_h1_year,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_h1_year,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_destroy_h1_year,
        COALESCE((SUM(COALESCE(z_he_used_to_destroy_h1_year,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_h1_year,0)) ,0)  AS hatchery_z_qty_he_invent_hatchery_end_h1_year,
        COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending_h1_year,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending_h1_year,
        COALESCE(SUM(COALESCE(z_income_from_non_he_h1_year,0)) ,0)  AS hatchery_z_income_from_non_he_h1_year,
        COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher_h1_year,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher_h1_year,
        COALESCE(SUM(COALESCE(z_hc_feed_h1_year,0)) ,0)  AS hatchery_z_hc_feed_h1_year,
        COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler_h1_year,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler_h1_year,
        COALESCE(SUM(COALESCE(z_hc_hatchery_overhead_h1_year,0)) ,0)  AS hatchery_z_hc_hatchery_overhead_h1_year,
        COALESCE(SUM(COALESCE(z_hc_repair_maintenance_h1_year,0)) ,0)  AS hatchery_z_hc_repair_maintenance_h1_year,
        COALESCE(SUM(COALESCE(z_hc_depreciation_h1_year,0)) ,0)  AS hatchery_z_hc_depreciation_h1_year,
        COALESCE(SUM(COALESCE(z_hc_boxes_used_h1_year,0)) ,0)  AS hatchery_z_hc_boxes_used_h1_year,
        COALESCE(SUM(COALESCE(z_income_from_male_h1_year,0)) ,0)  AS hatchery_z_income_from_male_h1_year,
        COALESCE(SUM(COALESCE(z_qty_income_from_male_h1_year,0)) ,0)  AS hatchery_z_qty_income_from_male_h1_year,
        COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_h1_year,0)) ,0)  AS hatchery_z_income_from_infertile_eggs_h1_year,
        COALESCE(SUM(COALESCE(z_dead_in_shell_h1_year,0)) ,0)  AS hatchery_z_dead_in_shell_h1_year,
        COALESCE(SUM(COALESCE(z_loss_h1_year,0)) ,0)  AS hatchery_z_loss_h1_year,
        COALESCE(SUM(COALESCE(z_qty_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_qty_to_produce_doc_h1_year,
        COALESCE(SUM(COALESCE(z_amount_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_h1_year,
        COALESCE(SUM(COALESCE(z_qty_doc_culled_h1_year,0)) ,0)  AS hatchery_z_qty_doc_culled_h1_year,
        COALESCE(SUM(COALESCE(z_qty_doc_killed_h1_year,0)) ,0)  AS hatchery_z_qty_doc_killed_h1_year,
        COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi_h1_year,0)) ,0)  AS hatchery_z_qty_doc_extra_toleransi_h1_year,
        COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_h1_year,0)) ,0)  AS hatchery_z_qty_doc_available_for_sales_h1_year,
        COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales_h1_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_h1_year,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_h1_year * -1,0)) ,0)  AS hatchery_z_deductqtytfdodtocomfarm_h1_year,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm_h1_year,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm_h1_year,
        COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_h1_year,0)) ,0)  AS hatchery_z_add_qty_begiining_doc_h1_year,
        COALESCE(SUM(COALESCE(z_add_begiining_doc_h1_year,0)) ,0)  AS hatchery_z_add_begiining_doc_h1_year,
        COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_h1_year,0)) ,0)  AS hatchery_z_deduct_qty_ending_doc_h1_year,
        COALESCE(SUM(COALESCE(z_deduct_ending_doc_h1_year,0)) ,0)  AS hatchery_z_deduct_ending_doc_h1_year,
        COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_h1_year,0)) ,0)  AS hatchery_z_total_qty_cost_trans_to_br_h1_year,
        COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf_h1_year,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf_h1_year,
        COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_h1_year,0)) ,0)  AS hatchery_z_qty_total_cost_of_sales_h1_year,
        COALESCE(SUM(COALESCE(z_total_cost_of_sales_h1_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_h1_year,
        COALESCE(AVG(COALESCE(z_salable_chick,0)),0) AS
        hatchery_z_salable_chick,
        COALESCE(AVG(COALESCE(z_hatchability,0)),0) AS
        hatchery_z_hatchability,


        COALESCE(SUM(COALESCE(qty_he_trf_to_br,0)) ,0) * -1 AS qty_he_trf_to_br,
        COALESCE(SUM(COALESCE(qty_he_trf_to_br_year,0)) ,0) * -1  AS qty_he_trf_to_br_year,
        COALESCE(SUM(COALESCE(qty_he_trf_to_br_h1_year,0)) ,0) * -1 AS qty_he_trf_to_br_h1_year,
        COALESCE(SUM(COALESCE(he_trf_to_br,0)) ,0) *-1 AS he_trf_to_br,
        COALESCE(SUM(COALESCE(he_trf_to_br_year,0)) ,0) * -1  AS he_trf_to_br_year,
        COALESCE(SUM(COALESCE(he_trf_to_br_h1_year,0)) ,0) * -1 AS he_trf_to_br_h1_year,

        COALESCE(SUM(COALESCE(qty_he_sales_to_aff * -1,0)) ,0)  AS qty_he_sales_to_aff,
        COALESCE(SUM(COALESCE(qty_he_sales_to_aff_year * -1,0)) ,0)  AS qty_he_sales_to_aff_year,
        COALESCE(SUM(COALESCE(qty_he_sales_to_aff_h1_year * -1,0)) ,0)  AS qty_he_sales_to_aff_h1_year,
        COALESCE(SUM(COALESCE(he_sales_to_aff * -1,0)) ,0)  AS he_sales_to_aff,
        COALESCE(SUM(COALESCE(he_sales_to_aff_year * -1,0)) ,0)  AS he_sales_to_aff_year,
        COALESCE(SUM(COALESCE(he_sales_to_aff_h1_year * -1,0)) ,0)  AS he_sales_to_aff_h1_year,

        COALESCE(SUM(COALESCE(cost_trf_he_to_br,0)) ,0)  AS cost_trf_he_to_br,
        COALESCE(SUM(COALESCE(cost_trf_he_to_br_year,0)) ,0)  AS cost_trf_he_to_br_year,
        COALESCE(SUM(COALESCE(cost_trf_he_to_br_h1_year,0)) ,0)  AS cost_trf_he_to_br_h1_year,
        COALESCE(SUM(COALESCE(sales_he_to_affiliate,0)) ,0)  AS sales_he_to_affiliate,
        COALESCE(SUM(COALESCE(sales_he_to_affiliate_year,0)) ,0)  AS sales_he_to_affiliate_year,
        COALESCE(SUM(COALESCE(sales_he_to_affiliate_h1_year,0)) ,0)  AS sales_he_to_affiliate_h1_year,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed, 0)) ,0)  AS deductqtytfdodtofarmbreed,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_year * -1,0)) ,0)  AS deductqtytfdodtofarmbreed_year,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_h1_year * -1,0)) ,0)  AS deductqtytfdodtofarmbreed_h1_year,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed,0)) ,0)  AS deductcosttfdodtofarmbreed,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed_year,0)) ,0)  AS deductcosttfdodtofarmbreed_year,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed_h1_year,0)) ,0)  AS deductcosttfdodtofarmbreed_h1_year,

        COALESCE(SUM(COALESCE(qtymoveinouthehatch,0)),0) AS qtymoveinouthehatch,
        COALESCE(SUM(COALESCE(amountmoveinouthehatch,0)),0) AS  amountmoveinouthehatch,
        COALESCE(SUM(COALESCE(qtymoveinouthehatch_year,0)),0) AS  qtymoveinouthehatch_year,
        COALESCE(SUM(COALESCE(amountmoveinouthehatch_year,0)),0) AS  amountmoveinouthehatch_year,
        COALESCE(SUM(COALESCE(qtymoveinouthehatch_h1_year,0)),0) AS  qtymoveinouthehatch_h1_year,
        COALESCE(SUM(COALESCE(amountmoveinouthehatch_h1_year,0)),0) AS  amountmoveinouthehatch_h1_year,


        COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc,0)),0) AS qtyheAvailBefGradAfterMovehatc,
        COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc,0)),0) AS heAvailBefGradAfterMovehatc,
        COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc_year,0)),0) AS qtyheAvailBefGradAfterMovehatc_year,
        COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc_year,0)),0) AS heAvailBefGradAfterMovehatc_year,
        COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc_h1_year,0)),0) AS qtyheAvailBefGradAfterMovehatc_h1_year,
        COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc_h1_year,0)),0) AS heAvailBefGradAfterMovehatc_h1_year,

        COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_grxx,0)),0) AS z_qty_he_avail_bfr_gr,
        COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_gr_year,0)),0) AS z_qty_he_avail_bfr_gr_year,
        COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_gr_h1_year,0)),0) AS z_qty_he_avail_bfr_gr_h1_year,
        COALESCE(SUM(COALESCE(z_he_avail_bfr_grxx,0)),0) AS z_he_avail_bfr_gr,
        COALESCE(SUM(COALESCE(z_he_avail_bfr_gr_year,0)),0) AS z_he_avail_bfr_gr_year,
        COALESCE(SUM(COALESCE(z_he_avail_bfr_gr_h1_year,0)),0) AS z_he_avail_bfr_gr_h1_year,

        COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue,0)),0) AS z_incomefrominfertile_eggvalue,
        COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue_year,0)),0) AS z_incomefrominfertile_eggvalue_year,
        COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue_h1_year,0)),0) AS z_incomefrominfertile_eggvalue_h1_year,

        0 AS z_qty_docsumbangan,
        0 AS z_qty_docsumbangan_year,
        0 AS z_qty_docsumbangan_h1_year


        FROM z_get_cost_calculation_hatchery_duck_cpjf_trading($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID})
        WHERE $P{Trading} = 'Y'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
        )
        AS hatchery_trading
    )tabel
WHERE farm_z_qty IS NOT NULL AND farm_z_qty_year IS NOT NULL AND farm_z_qty_h1_year IS NOT NULL

UNION -- union_layer

    SELECT
    (select name from c_period cp where c_period_id = $P{C_Period_ID}) as periodname,
    (select name from ad_org ao where ad_org_id = $P{AD_Org_ID}) as orgname,
    (select name from ad_org ao where ao.ad_org_id = $P{z_unit_ID}) as unitname,
    '' brachtype,
    '' categoryname,
    '' breed,
    '' sexline,
    *,

    (farm_z_depl_cost_doc_breeder +
    farm_z_depl_transportation_doc +
    farm_z_depl_feed_used +
    farm_z_depl_transportation_feed +
    farm_z_depl_medicine_used +
    farm_z_depl_direct_labor +
    farm_z_depl_farm_overhead +
    farm_z_depl_repair_maintenance +
    farm_z_depl_depreciation) AS persen_depletion_of_flockgrowing_cost,

    (farm_z_depl_cost_doc_breeder_year +
    farm_z_depl_transportation_doc_year +
    farm_z_depl_feed_used_year +
    farm_z_depl_transportation_feed_year +
    farm_z_depl_medicine_used_year +
    farm_z_depl_direct_labor_year +
    farm_z_depl_farm_overhead_year +
    farm_z_depl_repair_maintenance_year +
    farm_z_depl_depreciation_year) AS persen_depletion_of_flockgrowing_cost_ytd,

    1 AS penanda_data, 4 orderkey

    FROM
    (
        (
        SELECT
        SUM(COALESCE(z_fp_feed_used,0)) AS farm_z_fp_feed_used ,
        SUM(COALESCE(z_fp_transportation_feed,0)) AS  farm_z_fp_transportation_feed,
        SUM(COALESCE(z_fp_vaccine_medicine_used,0)) AS farm_z_fp_vaccine_medicine_used,
        SUM(COALESCE(z_fp_direct_labor,0)) AS farm_z_fp_direct_labor,
        SUM(COALESCE(z_fp_farm_overhead,0)) AS farm_z_fp_farm_overhead,
        SUM(COALESCE(z_fp_repair_maintenance,0)) AS  farm_z_fp_repair_maintenance,
        SUM(COALESCE(z_fp_depreciation,0)) AS  farm_z_fp_depreciation,
        SUM(COALESCE(z_depl_cost_doc_breeder,0)) AS  farm_z_depl_cost_doc_breeder,
        SUM(COALESCE(z_depl_transportation_doc,0)) AS  farm_z_depl_transportation_doc,
        SUM(COALESCE(z_depl_feed_used,0)) AS  farm_z_depl_feed_used,
        SUM(COALESCE(z_depl_transportation_feed,0)) AS farm_z_depl_transportation_feed ,
        SUM(COALESCE(z_depl_medicine_used,0)) AS  farm_z_depl_medicine_used,
        SUM(COALESCE(z_depl_direct_labor,0)) AS  farm_z_depl_direct_labor,
        SUM(COALESCE(z_depl_farm_overhead,0)) AS  farm_z_depl_farm_overhead,
        SUM(COALESCE(z_depl_repair_maintenance,0)) AS farm_z_depl_repair_maintenance ,
        SUM(COALESCE(z_depl_depreciation,0)) AS farm_z_depl_depreciation ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGSx,0))
        ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS,0)) END
        AS farm_z_Total_Qty_to_produce_EGGS ,

        SUM(COALESCE(z_Cost_produce_Eggs,0)) AS farm_z_Cost_produce_Eggs ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_hex,0))*-1)
        ELSE (SUM(COALESCE(z_qty_non_he,0))*-1) END
        AS farm_z_qty_non_he ,

        (SUM(COALESCE(z_income_from_non_he,0))*-1) AS farm_z_income_from_non_he ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_hex,0))
        ELSE SUM(COALESCE(z_qty_produce_he,0)) END
        AS farm_z_qty_produce_he ,

        SUM(COALESCE(z_cost_produce_he,0)) AS farm_z_cost_produce_he ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_beginx,0))
        ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin,0)) END
        AS farm_z_qty_he_inventory_farm_begin ,

        SUM(COALESCE(z_he_inventory_farm_begin,0)) AS farm_z_he_inventory_farm_begin ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farmx,0))
        ELSE SUM(COALESCE(z_qty_he_from_farm,0)) END
        AS farm_z_qty_he_from_farm ,

        SUM(COALESCE(z_cost_he_from_farm,0)) AS farm_z_cost_he_from_farm ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farmx,0))
        ELSE SUM(COALESCE(z_qty_he_available_farm,0)) END
        AS farm_z_qty_he_available_farm ,

        SUM(COALESCE(z_he_available_in_farm,0)) AS farm_z_he_available_in_farm ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliatex,0))*-1)
        ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate,0))*-1) END
        AS farm_z_qty_he_sales_to_affiliate ,

        (SUM(COALESCE(z_he_sales_to_affiliate,0))*-1) AS farm_z_he_sales_to_affiliate ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transferx,0))
        ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer,0)) END
        AS farm_z_qty_he_ending_bef_transfer ,

        SUM(COALESCE(z_he_ending_bef_transfer_out,0)) AS farm_z_he_ending_bef_transfer_out ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_outx,0))*-1)
        ELSE (SUM(COALESCE(z_qty_he_used_transfer_out,0))*-1) END
        AS farm_z_qty_he_used_transfer_out ,

        (SUM(COALESCE(z_he_used_transfer_out,0))*-1) AS farm_z_he_used_transfer_out ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_farmx,0))
        ELSE SUM(COALESCE(z_qty_he_ending_farm,0)) END
        AS farm_z_qty_he_ending_farm ,

        SUM(COALESCE(z_he_ending_farm,0)) AS farm_z_he_ending_farm ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qtyx,0))
        ELSE SUM(COALESCE(z_qty,0)) END
        AS farm_z_qty ,

        SUM(COALESCE(z_sales_he,0)) AS farm_z_sales_he,
        SUM(COALESCE(z_fp_feed_used_year,0)) AS farm_z_fp_feed_used_year ,
        SUM(COALESCE(z_fp_transportation_feed_year,0)) AS farm_z_fp_transportation_feed_year ,
        SUM(COALESCE(z_fp_vaccine_medicine_used_year,0)) AS farm_z_fp_vaccine_medicine_used_year ,
        SUM(COALESCE(z_fp_direct_labor_year,0)) AS farm_z_fp_direct_labor_year ,
        SUM(COALESCE(z_fp_farm_overhead_year,0)) AS farm_z_fp_farm_overhead_year ,
        SUM(COALESCE(z_fp_repair_maintenance_year,0)) AS farm_z_fp_repair_maintenance_year ,
        SUM(COALESCE(z_fp_depreciation_year,0)) AS farm_z_fp_depreciation_year ,
        SUM(COALESCE(z_depl_cost_doc_breeder_year,0)) AS farm_z_depl_cost_doc_breeder_year ,
        SUM(COALESCE(z_depl_transportation_doc_year,0)) AS farm_z_depl_transportation_doc_year ,
        SUM(COALESCE(z_depl_feed_used_year,0)) AS farm_z_depl_feed_used_year ,
        SUM(COALESCE(z_depl_transportation_feed_year,0)) AS farm_z_depl_transportation_feed_year ,
        SUM(COALESCE(z_depl_medicine_used_year,0)) AS farm_z_depl_medicine_used_year ,
        SUM(COALESCE(z_depl_direct_labor_year,0)) AS farm_z_depl_direct_labor_year ,
        SUM(COALESCE(z_depl_farm_overhead_year,0)) AS farm_z_depl_farm_overhead_year ,
        SUM(COALESCE(z_depl_repair_maintenance_year,0)) AS farm_z_depl_repair_maintenance_year ,
        SUM(COALESCE(z_depl_depreciation_year,0)) AS farm_z_depl_depreciation_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_yearx,0))
        ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_year,0)) END
        AS farm_z_Total_Qty_to_produce_EGGS_year ,

        SUM(COALESCE(z_Cost_produce_Eggs_year,0)) AS farm_z_Cost_produce_Eggs_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_yearx,0))*-1)
        ELSE (SUM(COALESCE(z_qty_non_he_year,0))*-1) END
        AS farm_z_qty_non_he_year ,

        (SUM(COALESCE(z_income_from_non_he_year,0))*-1) AS farm_z_income_from_non_he_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_produce_he_yearx,0))*-1)
        ELSE SUM(COALESCE(z_qty_produce_he_year,0)) END
        AS farm_z_qty_produce_he_year ,

        SUM(COALESCE(z_cost_produce_he_year,0)) AS farm_z_cost_produce_he_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_yearx,0))
        ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_year,0)) END
        AS farm_z_qty_he_inventory_farm_begin_year ,

        SUM(COALESCE(z_he_inventory_farm_begin_year,0)) AS farm_z_he_inventory_farm_begin_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_yearx,0))
        ELSE SUM(COALESCE(z_qty_he_from_farm_year,0)) END
        AS farm_z_qty_he_from_farm_year ,

        SUM(COALESCE(z_cost_he_from_farm_year,0)) AS farm_z_cost_he_from_farm_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_yearx,0))
        ELSE SUM(COALESCE(z_qty_he_available_farm_year,0)) END
        AS farm_z_qty_he_available_farm_year ,

        SUM(COALESCE(z_he_available_in_farm_year,0)) AS farm_z_he_available_in_farm_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_yearx,0))*-1)
        ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_year,0))*-1) END
        AS farm_z_qty_he_sales_to_affiliate_year ,

        (SUM(COALESCE(z_he_sales_to_affiliate_year,0))*-1) AS farm_z_he_sales_to_affiliate_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transfer_yearx,0))
        ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer_year,0)) END
        AS farm_z_qty_he_ending_bef_transfer_year ,

        SUM(COALESCE(z_he_ending_bef_transfer_out_year,0)) AS farm_z_he_ending_bef_transfer_out_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_yearx,0))*-1)
        ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_year,0))*-1) END
        AS farm_z_qty_he_used_transfer_out_year ,

        (SUM(COALESCE(z_he_used_transfer_out_year,0))*-1) AS farm_z_he_used_transfer_out_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_farm_yearx,0))
        ELSE SUM(COALESCE(z_qty_he_ending_farm_year,0)) END
        AS farm_z_qty_he_ending_farm_year ,

        SUM(COALESCE(z_he_ending_farm_year,0)) AS farm_z_he_ending_farm_year ,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_yearx,0))
        ELSE SUM(COALESCE(z_qty_year,0)) END
        AS farm_z_qty_year ,

        SUM(COALESCE(z_sales_he_year,0)) AS farm_z_sales_he_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_h1_yearx,0))
        ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_h1_year,0)) END
        AS farm_z_qty_he_inventory_farm_begin_h1_year  ,

        SUM(COALESCE(z_he_inventory_farm_begin_h1_year,0)) AS farm_z_he_inventory_farm_begin_h1_year ,
        SUM(COALESCE(z_qty_he_ending_farm_h1_year,0)) AS farm_z_qty_he_ending_farm_h1_year ,
        SUM(COALESCE(z_he_ending_farm_h1_year,0)) AS farm_z_he_ending_farm_h1_year,
        SUM(COALESCE(z_fp_feed_used_h1_year,0)) as farm_z_fp_feed_used_h1_year,
        SUM(COALESCE(z_fp_transportation_feed_h1_year,0)) as farm_z_fp_transportation_feed_h1_year,
        SUM(COALESCE(z_fp_vaccine_medicine_used_h1_year,0)) as farm_z_fp_vaccine_medicine_used_h1_year,
        SUM(COALESCE(z_fp_direct_labor_h1_year,0)) as farm_z_fp_direct_labor_h1_year,
        SUM(COALESCE(z_fp_farm_overhead_h1_year,0)) as farm_z_fp_farm_overhead_h1_year,
        SUM(COALESCE(z_fp_repair_maintenance_h1_year,0)) as farm_z_fp_repair_maintenance_h1_year,
        SUM(COALESCE(z_fp_depreciation_h1_year,0)) as farm_z_fp_depreciation_h1_year,
        SUM(COALESCE(z_depl_cost_doc_breeder_h1_year,0)) as farm_z_depl_cost_doc_breeder_h1_year,
        SUM(COALESCE(z_depl_transportation_doc_h1_year,0)) as farm_z_depl_transportation_doc_h1_year,
        SUM(COALESCE(z_depl_feed_used_h1_year,0)) as farm_z_depl_feed_used_h1_year,
        SUM(COALESCE(z_depl_transportation_feed_h1_year,0)) as farm_z_depl_transportation_feed_h1_year,
        SUM(COALESCE(z_depl_medicine_used_h1_year,0)) as farm_z_depl_medicine_used_h1_year,
        SUM(COALESCE(z_depl_direct_labor_h1_year,0)) as farm_z_depl_direct_labor_h1_year,
        SUM(COALESCE(z_depl_farm_overhead_h1_year,0)) as farm_z_depl_farm_overhead_h1_year,
        SUM(COALESCE(z_depl_repair_maintenance_h1_year,0)) as farm_z_depl_repair_maintenance_h1_year,
        SUM(COALESCE(z_depl_depreciation_h1_year,0)) as farm_z_depl_depreciation_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_h1_yearx,0))
        ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_h1_year,0)) END
        as farm_z_Total_Qty_to_produce_EGGS_h1_year,

        SUM(COALESCE(z_Cost_produce_Eggs_h1_year,0)) as farm_z_Cost_produce_Eggs_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_h1_yearx,0))*-1)
        ELSE (SUM(COALESCE(z_qty_non_he_h1_year,0))*-1) END
        as farm_z_qty_non_he_h1_year,

        (SUM(COALESCE(z_income_from_non_he_h1_year,0))*-1) as farm_z_income_from_non_he_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_he_h1_yearx,0))
        ELSE SUM(COALESCE(z_qty_produce_he_h1_year,0)) END
        as farm_z_qty_produce_he_h1_year,

        SUM(COALESCE(z_cost_produce_he_h1_year,0)) as farm_z_cost_produce_he_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_h1_yearx,0))
        ELSE SUM(COALESCE(z_qty_he_from_farm_h1_year,0)) END
        as farm_z_qty_he_from_farm_h1_year,

        SUM(COALESCE(z_cost_he_from_farm_h1_year,0)) as farm_z_cost_he_from_farm_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_h1_yearx,0))
        ELSE SUM(COALESCE(z_qty_he_available_farm_h1_year,0)) END
        as farm_z_qty_he_available_farm_h1_year,

        SUM(COALESCE(z_he_available_in_farm_h1_year,0)) as farm_z_he_available_in_farm_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_h1_yearx,0))*-1)
        ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_h1_year,0))*-1) END
        as farm_z_qty_he_sales_to_affiliate_h1_year,

        (SUM(COALESCE(z_he_sales_to_affiliate_h1_year,0))*-1) as farm_z_he_sales_to_affiliate_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transfer_h1_yearx,0))
        ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer_h1_year,0)) END
        as farm_z_qty_he_ending_bef_transfer_h1_year,

        SUM(COALESCE(z_he_ending_bef_transfer_out_h1_year,0)) as farm_z_he_ending_bef_transfer_out_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_h1_yearx,0))*-1)
        ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_h1_year,0))*-1) END
        as farm_z_qty_he_used_transfer_out_h1_year,

        (SUM(COALESCE(z_he_used_transfer_out_h1_year,0))*-1) as farm_z_he_used_transfer_out_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_h1_yearx,0))
        ELSE SUM(COALESCE(z_qty_h1_year,0)) END
        AS farm_z_qty_h1_year,

        SUM(COALESCE(z_sales_he_h1_year,0)) AS farm_z_sales_he_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_brx,0)) *-1
        ELSE SUM(COALESCE(qty_he_trf_to_br,0)) *-1 END
        AS qty_he_trf_to_br_13 ,

        SUM(COALESCE(he_trf_to_br,0)) * -1 AS he_trf_to_br_13,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_yearx,0)) *-1
        ELSE SUM(COALESCE(qty_he_trf_to_br_year,0)) *-1 END
        as qty_he_trf_to_br_year_13,

        SUM(COALESCE(he_trf_to_br_year,0)) *-1 as he_trf_to_br_year_13,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_h1_yearx,0)) *-1
        ELSE SUM(COALESCE(qty_he_trf_to_br_h1_year,0)) *-1 END
        as qty_he_trf_to_br_h1_year_13,

        SUM(COALESCE(he_trf_to_br_h1_year,0)) *-1 as he_trf_to_br_h1_year_13,
        SUM(COALESCE(cost_trf_he_to_br,0)) as cost_trf_he_to_br_13,
        SUM(COALESCE(cost_trf_he_to_br_year,0)) as cost_trf_he_to_br_year_13,
        SUM(COALESCE(cost_trf_he_to_br_h1_year,0)) as cost_trf_he_to_br_h1_year_13,

        SUM(COALESCE(z_cost_transfer_variance,0)) AS z_cost_transfer_variance,
        SUM(COALESCE(z_cost_transfer_variance_year,0)) AS z_cost_transfer_variance_year,
        SUM(COALESCE(z_cost_transfer_variance_h1_year,0)) AS z_cost_transfer_variance_h1_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_hex,0)) *-1
        ELSE SUM(COALESCE(z_qty_adjustment_he,0)) *-1 END
        AS z_qty_adjustment_he,

        sum(COALESCE(z_adjustment_he,0))*-1 AS z_adjustment_he,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_yearx,0)) *-1
        ELSE SUM(COALESCE(z_qty_adjustment_he_year,0)) *-1 END
        AS z_qty_adjustment_he_year,

        sum(COALESCE(z_adjustment_he_year,0))*-1 AS z_adjustment_he_year,

        CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_h1_yearx,0)) *-1
        ELSE SUM(COALESCE(z_qty_adjustment_he_h1_year,0)) *-1 END
        AS z_qty_adjustment_he_h1_year,

        sum(COALESCE(z_adjustment_he_h1_year,0))*-1 AS z_adjustment_he_h1_year


        FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
        WHERE
        $P{Layer} = 'Y'
        AND $P{Trading} = 'N'
        AND $P{Bpsold} = 'N'
        AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
        ) AS farm_pslayer

        CROSS JOIN

        (
        SELECT
        COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery,0)),0)  AS  hatchery_z_qty_he_beginning_hatchery,
        COALESCE(SUM(COALESCE(z_he_beginning_hatchery,0)) ,0)  AS  hatchery_z_he_beginning_hatchery,
        COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr,0)) ,0)  AS hatchery_z_qty_he_transfer_farm_bef_gr,
        COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr,
        COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br,0)) ,0)  AS hatchery_z_qty_add_he_transfer_from_br,
        COALESCE(SUM(COALESCE(z_add_he_transfer_from_br,0)) ,0)  AS hatchery_z_add_he_transfer_from_br,
        COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co,0)) ,0)  AS hatchery_z_qty_he_purchase_affiliate_co,
        COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co,
        COALESCE(SUM(COALESCE(z_transportation_he,0)) ,0)  AS hatchery_z_transportation_he,
        COALESCE(SUM(COALESCE(z_qty_he_available_gr_process,0)) ,0)  AS hatchery_z_qty_he_available_gr_process,
        COALESCE(SUM(COALESCE(z_he_available_to_gr_process,0)) ,0)  AS hatchery_z_he_available_to_gr_process,
        COALESCE((SUM(COALESCE(z_qty_non_he_sold,0))*-1) ,0)  AS hatchery_z_qty_non_he_sold,
        COALESCE((SUM(COALESCE(z_non_he_sold,0))*-1) ,0)  AS hatchery_z_non_he_sold,
        COALESCE((SUM(COALESCE(z_qty_non_he_csr,0))*-1) ,0)  AS hatchery_z_qty_non_he_csr,
        COALESCE((SUM(COALESCE(z_non_he_csr,0))*-1) ,0)  AS hatchery_z_non_he_csr,
        COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc,0)) ,0)  AS hatchery_z_qty_he_avail_to_produce_doc,
        COALESCE(SUM(COALESCE(z_he_available_to_produce_doc,0)) ,0)  AS hatchery_z_he_available_to_produce_doc,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_hatch_process,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process,0))) ,0) AS hatchery_cost_of_he_put_into_hatcher,
        COALESCE((SUM(COALESCE(z_he_used_to_hatching_process,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_destroy,
        COALESCE((SUM(COALESCE(z_he_used_to_destroy,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy,
        COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end,0)) ,0)  AS hatchery_z_qty_he_invent_hatchery_end,
        COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending,
        COALESCE(SUM(COALESCE(z_income_from_non_he,0)) ,0)  AS hatchery_z_income_from_non_he,
        COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher,
        COALESCE(SUM(COALESCE(z_hc_feed,0)) ,0)  AS hatchery_z_hc_feed,
        COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler,
        COALESCE(SUM(COALESCE(z_hc_hatchery_overhead,0)) ,0)  AS hatchery_z_hc_hatchery_overhead,
        COALESCE(SUM(COALESCE(z_hc_repair_maintenance,0)) ,0)  AS hatchery_z_hc_repair_maintenance,
        COALESCE(SUM(COALESCE(z_hc_depreciation,0)) ,0)  AS hatchery_z_hc_depreciation,
        COALESCE(SUM(COALESCE(z_hc_boxes_used,0)) ,0)  AS hatchery_z_hc_boxes_used,
        COALESCE(SUM(COALESCE(z_income_from_male *-1, 0)) ,0)  AS hatchery_z_income_from_male,
        COALESCE(SUM(COALESCE(z_qty_income_from_male *-1, 0)) ,0)  AS hatchery_z_qty_income_from_male,
        COALESCE(SUM(COALESCE(z_income_from_infertile_eggs *-1, 0)) ,0)  AS hatchery_z_income_from_infertile_eggs,
        COALESCE(SUM(COALESCE(z_dead_in_shell *-1, 0)) ,0)  AS hatchery_z_dead_in_shell,
        COALESCE(SUM(COALESCE(z_loss *-1, 0)) ,0)  AS hatchery_z_loss,
        COALESCE(SUM(COALESCE(z_qty_to_produce_doc,0)) ,0)  AS hatchery_z_qty_to_produce_doc,
        COALESCE(SUM(COALESCE(z_amount_to_produce_doc,0)) ,0)  AS hatchery_z_amount_to_produce_doc,
        COALESCE(SUM(COALESCE(z_qty_doc_culled *-1, 0)) ,0)  AS hatchery_z_qty_doc_culled,
        COALESCE(SUM(COALESCE(z_qty_doc_killed *-1, 0)) ,0)  AS hatchery_z_qty_doc_killed,
        COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi *-1, 0)) ,0)  AS hatchery_z_qty_doc_extra_toleransi,
        COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales,0)) ,0)  AS hatchery_z_qty_doc_available_for_sales,
        COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm,0)) ,0)  AS hatchery_z_deductqtytfdodtocomfarm,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm,
        COALESCE(SUM(COALESCE(z_add_qty_begiining_doc,0)) ,0)  AS hatchery_z_add_qty_begiining_doc,
        COALESCE(SUM(COALESCE(z_add_begiining_doc,0)) ,0)  AS hatchery_z_add_begiining_doc,
        COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc,0)) ,0)  AS hatchery_z_deduct_qty_ending_doc,
        COALESCE(SUM(COALESCE(z_deduct_ending_doc,0)) ,0)  AS hatchery_z_deduct_ending_doc,
        COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br,0)) ,0)  AS hatchery_z_total_qty_cost_trans_to_br,
        COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf,
        COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales,0)) ,0)  AS hatchery_z_qty_total_cost_of_sales,
        COALESCE(SUM(COALESCE(z_total_cost_of_sales,0)) ,0)  AS hatchery_z_total_cost_of_sales,
        COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_year,0)) ,0)  AS  hatchery_z_qty_he_beginning_hatchery_year,
        COALESCE(SUM(COALESCE(z_he_beginning_hatchery_year,0)) ,0)  AS  hatchery_z_he_beginning_hatchery_year,
        COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_year,0)) ,0)  AS hatchery_z_qty_he_transfer_farm_bef_gr_year,
        COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr_year,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr_year,
        COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_year,0)) ,0)  AS hatchery_z_qty_add_he_transfer_from_br_year,
        COALESCE(SUM(COALESCE(z_add_he_transfer_from_br_year,0)) ,0)  AS hatchery_z_add_he_transfer_from_br_year,
        COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_year,0)) ,0)  AS hatchery_z_qty_he_purchase_affiliate_co_year,
        COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co_year,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co_year,
        COALESCE(SUM(COALESCE(z_transportation_he_year,0)) ,0)  AS hatchery_z_transportation_he_year,
        COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_year,0)) ,0)  AS hatchery_z_qty_he_available_gr_process_year,
        COALESCE(SUM(COALESCE(z_he_available_to_gr_process_year,0)) ,0)  AS hatchery_z_he_available_to_gr_process_year,
        COALESCE((SUM(COALESCE(z_qty_non_he_sold_year,0))*-1) ,0)  AS hatchery_z_qty_non_he_sold_year,
        COALESCE((SUM(COALESCE(z_non_he_sold_year,0))*-1) ,0)  AS hatchery_z_non_he_sold_year,
        COALESCE((SUM(COALESCE(z_qty_non_he_csr_year,0))*-1) ,0)  AS hatchery_z_qty_non_he_csr_year,
        COALESCE((SUM(COALESCE(z_non_he_csr_year,0))*-1) ,0)  AS hatchery_z_non_he_csr_year,
        COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_year,0)) ,0)  AS hatchery_z_qty_he_avail_to_produce_doc_year,
        COALESCE(SUM(COALESCE(z_he_available_to_produce_doc_year,0)) ,0)  AS hatchery_z_he_available_to_produce_doc_year,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_year,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_hatch_process_year,
        COALESCE((SUM(COALESCE(z_he_used_to_hatching_process_year,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process_year,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_year,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_destroy_year,
        COALESCE((SUM(COALESCE(z_he_used_to_destroy_year,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy_year,
        COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_year,0)) ,0)  AS hatchery_z_qty_he_invent_hatchery_end_year,
        COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending_year,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending_year,
        COALESCE(SUM(COALESCE(z_income_from_non_he_year,0)) ,0)  AS hatchery_z_income_from_non_he_year,
        COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher_year,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher_year,
        COALESCE(SUM(COALESCE(z_hc_feed_year,0)) ,0)  AS hatchery_z_hc_feed_year,
        COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler_year,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler_year,
        COALESCE(SUM(COALESCE(z_hc_hatchery_overhead_year,0)) ,0)  AS hatchery_z_hc_hatchery_overhead_year,
        COALESCE(SUM(COALESCE(z_hc_repair_maintenance_year,0)) ,0)  AS hatchery_z_hc_repair_maintenance_year,
        COALESCE(SUM(COALESCE(z_hc_depreciation_year,0)) ,0)  AS hatchery_z_hc_depreciation_year,
        COALESCE(SUM(COALESCE(z_hc_boxes_used_year,0)) ,0)  AS hatchery_z_hc_boxes_used_year,
        COALESCE(SUM(COALESCE(z_income_from_male_year,0)) ,0)  AS hatchery_z_income_from_male_year,
        COALESCE(SUM(COALESCE(z_qty_income_from_male_year,0)) ,0)  AS hatchery_z_qty_income_from_male_year,
        COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_year,0)) ,0)  AS hatchery_z_income_from_infertile_eggs_year,
        COALESCE(SUM(COALESCE(z_dead_in_shell_year,0)) ,0)  AS hatchery_z_dead_in_shell_year,
        COALESCE(SUM(COALESCE(z_loss_year,0)) ,0)  AS hatchery_z_loss_year,
        COALESCE(SUM(COALESCE(z_qty_to_produce_doc_year,0)) ,0)  AS hatchery_z_qty_to_produce_doc_year,
        COALESCE(SUM(COALESCE(z_amount_to_produce_doc_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_year,
        COALESCE(SUM(COALESCE(z_qty_doc_culled_year,0)) ,0)  AS hatchery_z_qty_doc_culled_year,
        COALESCE(SUM(COALESCE(z_qty_doc_killed_year,0)) ,0)  AS hatchery_z_qty_doc_killed_year,
        COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi_year,0)) ,0)  AS hatchery_z_qty_doc_extra_toleransi_year,
        COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_year,0)) ,0)  AS hatchery_z_qty_doc_available_for_sales_year,
        COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_year,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_year * -1,0)) ,0)  AS hatchery_z_deductqtytfdodtocomfarm_year,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm_year,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm_year,
        COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_year,0)) ,0)  AS hatchery_z_add_qty_begiining_doc_year,
        COALESCE(SUM(COALESCE(z_add_begiining_doc_year,0)) ,0)  AS hatchery_z_add_begiining_doc_year,
        COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_year,0)) ,0)  AS hatchery_z_deduct_qty_ending_doc_year,
        COALESCE(SUM(COALESCE(z_deduct_ending_doc_year,0)) ,0)  AS hatchery_z_deduct_ending_doc_year,
        COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_year,0)) ,0)  AS hatchery_z_total_qty_cost_trans_to_br_year,
        COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf_year,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf_year,
        COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_year,0)) ,0)  AS hatchery_z_qty_total_cost_of_sales_year,
        COALESCE(SUM(COALESCE(z_total_cost_of_sales_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_year,
        COALESCE(SUM(COALESCE(z_qty_he_beginning_hatchery_h1_year,0)) ,0)  AS  hatchery_z_qty_he_beginning_hatchery_h1_year,
        COALESCE(SUM(COALESCE(z_he_beginning_hatchery_h1_year,0)) ,0)  AS  hatchery_z_he_beginning_hatchery_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_transfer_farm_bef_gr_h1_year,0)) ,0)  AS hatchery_z_qty_he_transfer_farm_bef_gr_h1_year,
        COALESCE(SUM(COALESCE(z_he_transfer_farm_bef_gr_h1_year,0)) ,0)  AS hatchery_z_he_transfer_farm_bef_gr_h1_year,
        COALESCE(SUM(COALESCE(z_qty_add_he_transfer_from_br_h1_year,0)) ,0)  AS hatchery_z_qty_add_he_transfer_from_br_h1_year,
        COALESCE(SUM(COALESCE(z_add_he_transfer_from_br_h1_year,0)) ,0)  AS hatchery_z_add_he_transfer_from_br_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_purchase_affiliate_co_h1_year,0)) ,0)  AS hatchery_z_qty_he_purchase_affiliate_co_h1_year,
        COALESCE(SUM(COALESCE(z_he_purchase_affiliate_co_h1_year,0)) ,0)  AS hatchery_z_he_purchase_affiliate_co_h1_year,
        COALESCE(SUM(COALESCE(z_transportation_he_h1_year,0)) ,0)  AS hatchery_z_transportation_he_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_available_gr_process_h1_year,0)) ,0)  AS hatchery_z_qty_he_available_gr_process_h1_year,
        COALESCE(SUM(COALESCE(z_he_available_to_gr_process_h1_year,0)) ,0)  AS hatchery_z_he_available_to_gr_process_h1_year,
        COALESCE((SUM(COALESCE(z_qty_non_he_sold_h1_year,0))*-1) ,0)  AS hatchery_z_qty_non_he_sold_h1_year,
        COALESCE((SUM(COALESCE(z_non_he_sold_h1_year,0))*-1) ,0)  AS hatchery_z_non_he_sold_h1_year,
        COALESCE((SUM(COALESCE(z_qty_non_he_csr_h1_year,0))*-1) ,0)  AS hatchery_z_qty_non_he_csr_h1_year,
        COALESCE((SUM(COALESCE(z_non_he_csr_h1_year,0))*-1) ,0)  AS hatchery_z_non_he_csr_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_avail_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_qty_he_avail_to_produce_doc_h1_year,
        COALESCE(SUM(COALESCE(z_he_available_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_he_available_to_produce_doc_h1_year,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_hatch_process_h1_year,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_hatch_process_h1_year,
        COALESCE((SUM(COALESCE(z_he_used_to_hatching_process_h1_year,0))*-1) ,0)  AS hatchery_z_he_used_to_hatching_process_h1_year,
        COALESCE((SUM(COALESCE(z_qty_he_used_to_destroy_h1_year,0))*-1) ,0)  AS hatchery_z_qty_he_used_to_destroy_h1_year,
        COALESCE((SUM(COALESCE(z_he_used_to_destroy_h1_year,0))*-1) ,0)  AS hatchery_z_he_used_to_destroy_h1_year,
        COALESCE(SUM(COALESCE(z_qty_he_invent_hatchery_end_h1_year,0)) ,0)  AS hatchery_z_qty_he_invent_hatchery_end_h1_year,
        COALESCE(SUM(COALESCE(z_he_inventory_hatchery_ending_h1_year,0)) ,0)  AS hatchery_z_he_inventory_hatchery_ending_h1_year,
        COALESCE(SUM(COALESCE(z_income_from_non_he_h1_year,0)) ,0)  AS hatchery_z_income_from_non_he_h1_year,
        COALESCE(SUM(COALESCE(z_hc_cost_of_he_put_in_hatcher_h1_year,0)) ,0)  AS hatchery_z_hc_cost_of_he_put_in_hatcher_h1_year,
        COALESCE(SUM(COALESCE(z_hc_feed_h1_year,0)) ,0)  AS hatchery_z_hc_feed_h1_year,
        COALESCE(SUM(COALESCE(z_hc_vaccine_for_broiler_h1_year,0)) ,0)  AS hatchery_z_hc_vaccine_for_broiler_h1_year,
        COALESCE(SUM(COALESCE(z_hc_hatchery_overhead_h1_year,0)) ,0)  AS hatchery_z_hc_hatchery_overhead_h1_year,
        COALESCE(SUM(COALESCE(z_hc_repair_maintenance_h1_year,0)) ,0)  AS hatchery_z_hc_repair_maintenance_h1_year,
        COALESCE(SUM(COALESCE(z_hc_depreciation_h1_year,0)) ,0)  AS hatchery_z_hc_depreciation_h1_year,
        COALESCE(SUM(COALESCE(z_hc_boxes_used_h1_year,0)) ,0)  AS hatchery_z_hc_boxes_used_h1_year,
        COALESCE(SUM(COALESCE(z_income_from_male_h1_year,0)) ,0)  AS hatchery_z_income_from_male_h1_year,
        COALESCE(SUM(COALESCE(z_qty_income_from_male_h1_year,0)) ,0)  AS hatchery_z_qty_income_from_male_h1_year,
        COALESCE(SUM(COALESCE(z_income_from_infertile_eggs_h1_year,0)) ,0)  AS hatchery_z_income_from_infertile_eggs_h1_year,
        COALESCE(SUM(COALESCE(z_dead_in_shell_h1_year,0)) ,0)  AS hatchery_z_dead_in_shell_h1_year,
        COALESCE(SUM(COALESCE(z_loss_h1_year,0)) ,0)  AS hatchery_z_loss_h1_year,
        COALESCE(SUM(COALESCE(z_qty_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_qty_to_produce_doc_h1_year,
        COALESCE(SUM(COALESCE(z_amount_to_produce_doc_h1_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_h1_year,
        COALESCE(SUM(COALESCE(z_qty_doc_culled_h1_year,0)) ,0)  AS hatchery_z_qty_doc_culled_h1_year,
        COALESCE(SUM(COALESCE(z_qty_doc_killed_h1_year,0)) ,0)  AS hatchery_z_qty_doc_killed_h1_year,
        COALESCE(SUM(COALESCE(z_qty_doc_extra_toleransi_h1_year,0)) ,0)  AS hatchery_z_qty_doc_extra_toleransi_h1_year,
        COALESCE(SUM(COALESCE(z_qty_doc_available_for_sales_h1_year,0)) ,0)  AS hatchery_z_qty_doc_available_for_sales_h1_year,
        COALESCE(SUM(COALESCE(z_amount_doc_avail_for_sales_h1_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_h1_year,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtocomfarm_h1_year * -1,0)) ,0)  AS hatchery_z_deductqtytfdodtocomfarm_h1_year,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtocomfarm_h1_year,0)) ,0)  AS hatchery_z_deductcosttfdodtocomfarm_h1_year,
        COALESCE(SUM(COALESCE(z_add_qty_begiining_doc_h1_year,0)) ,0)  AS hatchery_z_add_qty_begiining_doc_h1_year,
        COALESCE(SUM(COALESCE(z_add_begiining_doc_h1_year,0)) ,0)  AS hatchery_z_add_begiining_doc_h1_year,
        COALESCE(SUM(COALESCE(z_deduct_qty_ending_doc_h1_year,0)) ,0)  AS hatchery_z_deduct_qty_ending_doc_h1_year,
        COALESCE(SUM(COALESCE(z_deduct_ending_doc_h1_year,0)) ,0)  AS hatchery_z_deduct_ending_doc_h1_year,
        COALESCE(SUM(COALESCE(z_total_qty_cost_trans_to_br_h1_year,0)) ,0)  AS hatchery_z_total_qty_cost_trans_to_br_h1_year,
        COALESCE(SUM(COALESCE(z_total_cost_transf_branch_rf_h1_year,0)) ,0)  AS hatchery_z_total_cost_transf_branch_rf_h1_year,
        COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_h1_year,0)) ,0)  AS hatchery_z_qty_total_cost_of_sales_h1_year,
        COALESCE(SUM(COALESCE(z_total_cost_of_sales_h1_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_h1_year,
        COALESCE(AVG(COALESCE(z_salable_chick,0)),0) AS
        hatchery_z_salable_chick,
        COALESCE(AVG(COALESCE(z_hatchability,0)),0) AS
        hatchery_z_hatchability,


        COALESCE(SUM(COALESCE(qty_he_trf_to_br,0)) ,0) * -1 AS qty_he_trf_to_br,
        COALESCE(SUM(COALESCE(qty_he_trf_to_br_year,0)) ,0) * -1 AS qty_he_trf_to_br_year,
        COALESCE(SUM(COALESCE(qty_he_trf_to_br_h1_year,0)) ,0) * -1 AS qty_he_trf_to_br_h1_year,
        COALESCE(SUM(COALESCE(he_trf_to_br,0)) ,0) * -1  AS he_trf_to_br,
        COALESCE(SUM(COALESCE(he_trf_to_br_year,0)) ,0) * -1  AS he_trf_to_br_year,
        COALESCE(SUM(COALESCE(he_trf_to_br_h1_year,0)) ,0) * -1 AS he_trf_to_br_h1_year,


        COALESCE(SUM(COALESCE(qty_he_sales_to_aff * -1,0)) ,0)  AS qty_he_sales_to_aff,
        COALESCE(SUM(COALESCE(qty_he_sales_to_aff_year * -1,0)) ,0)  AS qty_he_sales_to_aff_year,
        COALESCE(SUM(COALESCE(qty_he_sales_to_aff_h1_year * -1,0)) ,0)  AS qty_he_sales_to_aff_h1_year,
        COALESCE(SUM(COALESCE(he_sales_to_aff * -1,0)) ,0)  AS he_sales_to_aff,
        COALESCE(SUM(COALESCE(he_sales_to_aff_year * -1,0)) ,0)  AS he_sales_to_aff_year,
        COALESCE(SUM(COALESCE(he_sales_to_aff_h1_year * -1,0)) ,0)  AS he_sales_to_aff_h1_year,

        COALESCE(SUM(COALESCE(cost_trf_he_to_br,0)) ,0)  AS cost_trf_he_to_br,
        COALESCE(SUM(COALESCE(cost_trf_he_to_br_year,0)) ,0)  AS cost_trf_he_to_br_year,
        COALESCE(SUM(COALESCE(cost_trf_he_to_br_h1_year,0)) ,0)  AS cost_trf_he_to_br_h1_year,
        COALESCE(SUM(COALESCE(sales_he_to_affiliate,0)) ,0)  AS sales_he_to_affiliate,
        COALESCE(SUM(COALESCE(sales_he_to_affiliate_year,0)) ,0)  AS sales_he_to_affiliate_year,
        COALESCE(SUM(COALESCE(sales_he_to_affiliate_h1_year,0)) ,0)  AS sales_he_to_affiliate_h1_year,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed, 0)) ,0)  AS deductqtytfdodtofarmbreed,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_year * -1,0)) ,0)  AS deductqtytfdodtofarmbreed_year,
        COALESCE(SUM(COALESCE(z_deductqtytfdodtofarmbreed_h1_year * -1,0)) ,0)  AS deductqtytfdodtofarmbreed_h1_year,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed,0)) ,0)  AS deductcosttfdodtofarmbreed,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed_year,0)) ,0)  AS deductcosttfdodtofarmbreed_year,
        COALESCE(SUM(COALESCE(z_deductcosttfdodtofarmbreed_h1_year,0)) ,0)  AS deductcosttfdodtofarmbreed_h1_year,

        COALESCE(SUM(COALESCE(qtymoveinouthehatch,0)),0) AS qtymoveinouthehatch,
        COALESCE(SUM(COALESCE(amountmoveinouthehatch,0)),0) AS  amountmoveinouthehatch,
        COALESCE(SUM(COALESCE(qtymoveinouthehatch_year,0)),0) AS  qtymoveinouthehatch_year,
        COALESCE(SUM(COALESCE(amountmoveinouthehatch_year,0)),0) AS  amountmoveinouthehatch_year,
        COALESCE(SUM(COALESCE(qtymoveinouthehatch_h1_year,0)),0) AS  qtymoveinouthehatch_h1_year,
        COALESCE(SUM(COALESCE(amountmoveinouthehatch_h1_year,0)),0) AS  amountmoveinouthehatch_h1_year,


        COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc,0)),0) AS qtyheAvailBefGradAfterMovehatc,
        COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc,0)),0) AS heAvailBefGradAfterMovehatc,
        COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc_year,0)),0) AS qtyheAvailBefGradAfterMovehatc_year,
        COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc_year,0)),0) AS heAvailBefGradAfterMovehatc_year,
        COALESCE(SUM(COALESCE(qtyheAvailBefGradAfterMovehatc_h1_year,0)),0) AS qtyheAvailBefGradAfterMovehatc_h1_year,
        COALESCE(SUM(COALESCE(heAvailBefGradAfterMovehatc_h1_year,0)),0) AS heAvailBefGradAfterMovehatc_h1_year,

        COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_grxx,0)),0) AS z_qty_he_avail_bfr_gr,
        COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_gr_year,0)),0) AS z_qty_he_avail_bfr_gr_year,
        COALESCE(SUM(COALESCE(z_qty_he_avail_bfr_gr_h1_year,0)),0) AS z_qty_he_avail_bfr_gr_h1_year,
        COALESCE(SUM(COALESCE(z_he_avail_bfr_grxx,0)),0) AS z_he_avail_bfr_gr,
        COALESCE(SUM(COALESCE(z_he_avail_bfr_gr_year,0)),0) AS z_he_avail_bfr_gr_year,
        COALESCE(SUM(COALESCE(z_he_avail_bfr_gr_h1_year,0)),0) AS z_he_avail_bfr_gr_h1_year,

        COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue,0)),0) AS z_incomefrominfertile_eggvalue,
        COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue_year,0)),0) AS z_incomefrominfertile_eggvalue_year,
        COALESCE(SUM(COALESCE(z_incomefrominfertile_eggvalue_h1_year,0)),0) AS z_incomefrominfertile_eggvalue_h1_year,

        0 AS z_qty_docsumbangan,
        0 AS z_qty_docsumbangan_year,
        0 AS z_qty_docsumbangan_h1_year


        FROM z_get_cost_calculation_hatchery_duck_cpjf_pslayer($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID})
        WHERE $P{Layer} = 'Y'
        AND $P{Trading} = 'N'
        AND $P{Bpsold} = 'N'
        AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
        )
        AS hatchery_pslayer
    )tabel
WHERE farm_z_qty IS NOT NULL AND farm_z_qty_year IS NOT NULL AND farm_z_qty_h1_year IS NOT NULL

UNION -- union_bpsold

    SELECT
    (select name from c_period cp where c_period_id = $P{C_Period_ID}) as periodname,
    (select name from ad_org ao where ad_org_id = $P{AD_Org_ID}) as orgname,
    (select name from ad_org ao where ao.ad_org_id = $P{z_unit_ID}) as unitname,
    '' AS brachtype,
    '' AS categoryname,
    '' breed,
    '' sexline,
    *,

    (farm_z_depl_cost_doc_breeder +
    farm_z_depl_transportation_doc +
    farm_z_depl_feed_used +
    farm_z_depl_transportation_feed +
    farm_z_depl_medicine_used +
    farm_z_depl_direct_labor +
    farm_z_depl_farm_overhead +
    farm_z_depl_repair_maintenance +
    farm_z_depl_depreciation) AS persen_depletion_of_flockgrowing_cost,

    (farm_z_depl_cost_doc_breeder_year +
    farm_z_depl_transportation_doc_year +
    farm_z_depl_feed_used_year +
    farm_z_depl_transportation_feed_year +
    farm_z_depl_medicine_used_year +
    farm_z_depl_direct_labor_year +
    farm_z_depl_farm_overhead_year +
    farm_z_depl_repair_maintenance_year +
    farm_z_depl_depreciation_year) AS persen_depletion_of_flockgrowing_cost_ytd,

    1 AS penanda_data, 5 orderkey

    FROM
    (
        (
        SELECT DISTINCT
        0 AS farm_z_fp_feed_used ,
        0 AS  farm_z_fp_transportation_feed,
        0 AS farm_z_fp_vaccine_medicine_used,
        0 AS farm_z_fp_direct_labor,
        0 AS farm_z_fp_farm_overhead,
        0 AS  farm_z_fp_repair_maintenance,
        0 AS  farm_z_fp_depreciation,
        0 AS  farm_z_depl_cost_doc_breeder,
        0 AS  farm_z_depl_transportation_doc,
        0 AS  farm_z_depl_feed_used,
        0 AS farm_z_depl_transportation_feed ,
        0 AS  farm_z_depl_medicine_used,
        0 AS  farm_z_depl_direct_labor,
        0 AS  farm_z_depl_farm_overhead,
        0 AS farm_z_depl_repair_maintenance ,
        0 AS farm_z_depl_depreciation ,
        0 AS farm_z_Total_Qty_to_produce_EGGS ,
        0 AS farm_z_Cost_produce_Eggs ,
        0 AS farm_z_qty_non_he ,
        0 AS farm_z_income_from_non_he ,
        0 AS farm_z_qty_produce_he ,
        0 AS farm_z_cost_produce_he ,
        0 AS farm_z_qty_he_inventory_farm_begin ,
        0 AS farm_z_he_inventory_farm_begin ,
        0 AS farm_z_qty_he_from_farm ,
        0 AS farm_z_cost_he_from_farm ,
        0 AS farm_z_qty_he_available_farm ,
        0 AS farm_z_he_available_in_farm ,
        0 AS farm_z_qty_he_sales_to_affiliate ,
        0 AS farm_z_he_sales_to_affiliate ,
        0 AS farm_z_qty_he_ending_bef_transfer ,
        0 AS farm_z_he_ending_bef_transfer_out ,
        0 AS farm_z_qty_he_used_transfer_out ,
        0 AS farm_z_he_used_transfer_out ,
        0 AS farm_z_qty_he_ending_farm ,
        0 AS farm_z_he_ending_farm ,
        0 AS farm_z_qty ,
        0 AS farm_z_sales_he,
        0 AS farm_z_fp_feed_used_year ,
        0 AS farm_z_fp_transportation_feed_year ,
        0 AS farm_z_fp_vaccine_medicine_used_year ,
        0 AS farm_z_fp_direct_labor_year ,
        0 AS farm_z_fp_farm_overhead_year ,
        0 AS farm_z_fp_repair_maintenance_year ,
        0 AS farm_z_fp_depreciation_year ,
        0 AS farm_z_depl_cost_doc_breeder_year ,
        0 AS farm_z_depl_transportation_doc_year ,
        0 AS farm_z_depl_feed_used_year ,
        0 AS farm_z_depl_transportation_feed_year ,
        0 AS farm_z_depl_medicine_used_year ,
        0 AS farm_z_depl_direct_labor_year ,
        0 AS farm_z_depl_farm_overhead_year ,
        0 AS farm_z_depl_repair_maintenance_year ,
        0 AS farm_z_depl_depreciation_year ,
        0 AS farm_z_Total_Qty_to_produce_EGGS_year ,
        0 AS farm_z_Cost_produce_Eggs_year ,
        0 AS farm_z_qty_non_he_year ,
        0 AS farm_z_income_from_non_he_year ,
        0 AS farm_z_qty_produce_he_year ,
        0 AS farm_z_cost_produce_he_year ,
        0 AS farm_z_qty_he_inventory_farm_begin_year ,
        0 AS farm_z_he_inventory_farm_begin_year ,
        0 AS farm_z_qty_he_from_farm_year ,
        0 AS farm_z_cost_he_from_farm_year ,
        0 AS farm_z_qty_he_available_farm_year ,
        0 AS farm_z_he_available_in_farm_year ,
        0 AS farm_z_qty_he_sales_to_affiliate_year ,
        0 AS farm_z_he_sales_to_affiliate_year ,
        0 AS farm_z_qty_he_ending_bef_transfer_year ,
        0 AS farm_z_he_ending_bef_transfer_out_year ,
        0 AS farm_z_qty_he_used_transfer_out_year ,
        0 AS farm_z_he_used_transfer_out_year ,
        0 AS farm_z_qty_he_ending_farm_year ,
        0 AS farm_z_he_ending_farm_year ,
        0 AS farm_z_qty_year ,
        0 AS farm_z_sales_he_year,
        0 AS farm_z_qty_he_inventory_farm_begin_h1_year  ,
        0 AS farm_z_he_inventory_farm_begin_h1_year ,
        0 AS farm_z_qty_he_ending_farm_h1_year ,
        0 AS farm_z_he_ending_farm_h1_year,
        0 as farm_z_fp_feed_used_h1_year,
        0 as farm_z_fp_transportation_feed_h1_year,
        0 as farm_z_fp_vaccine_medicine_used_h1_year,
        0 as farm_z_fp_direct_labor_h1_year,
        0 as farm_z_fp_farm_overhead_h1_year,
        0 as farm_z_fp_repair_maintenance_h1_year,
        0 as farm_z_fp_depreciation_h1_year,
        0 as farm_z_depl_cost_doc_breeder_h1_year,
        0 as farm_z_depl_transportation_doc_h1_year,
        0 as farm_z_depl_feed_used_h1_year,
        0 as farm_z_depl_transportation_feed_h1_year,
        0 as farm_z_depl_medicine_used_h1_year,
        0 as farm_z_depl_direct_labor_h1_year,
        0 as farm_z_depl_farm_overhead_h1_year,
        0 as farm_z_depl_repair_maintenance_h1_year,
        0 as farm_z_depl_depreciation_h1_year,
        0 as farm_z_Total_Qty_to_produce_EGGS_h1_year,
        0 as farm_z_Cost_produce_Eggs_h1_year,
        0 as farm_z_qty_non_he_h1_year,
        0 as farm_z_income_from_non_he_h1_year,
        0 as farm_z_qty_produce_he_h1_year,
        0 as farm_z_cost_produce_he_h1_year,
        0 as farm_z_qty_he_from_farm_h1_year,
        0 as farm_z_cost_he_from_farm_h1_year,
        0 as farm_z_qty_he_available_farm_h1_year,
        0 as farm_z_he_available_in_farm_h1_year,
        0 as farm_z_qty_he_sales_to_affiliate_h1_year,
        0 as farm_z_he_sales_to_affiliate_h1_year,
        0 as farm_z_qty_he_ending_bef_transfer_h1_year,
        0 as farm_z_he_ending_bef_transfer_out_h1_year,
        0 as farm_z_qty_he_used_transfer_out_h1_year,
        0 as farm_z_he_used_transfer_out_h1_year,
        0 AS farm_z_qty_h1_year,
        0 AS farm_z_sales_he_h1_year,

        0 AS qty_he_trf_to_br_13 ,
        0 AS he_trf_to_br_13,
        0 as qty_he_trf_to_br_year_13,
        0 as he_trf_to_br_year_13,
        0 as qty_he_trf_to_br_h1_year_13,
        0 as he_trf_to_br_h1_year_13,
        0 as cost_trf_he_to_br_13,
        0 as cost_trf_he_to_br_year_13,
        0 as cost_trf_he_to_br_h1_year_13,

        0::numeric AS z_cost_transfer_variance,
        0::numeric AS z_cost_transfer_variance_year,
        0::numeric AS z_cost_transfer_variance_h1_year,

        0 AS z_qty_adjustment_he,
        0 AS z_adjustment_he,
        0 AS z_qty_adjustment_he_year,
        0 AS z_adjustment_he_year,
        0 AS z_qty_adjustment_he_h1_year,
        0 AS z_adjustment_he_h1_year

        FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},'GP','BROILER','FEMLN',$P{Breed})
        WHERE
        $P{Bpsold} = 'Y'
        AND $P{Layer} = 'N'
        AND $P{Trading} = 'N'
        AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
        ) AS farm_bpsold

        CROSS JOIN

        (SELECT DISTINCT
        0  AS  hatchery_z_qty_he_beginning_hatchery,
        0  AS  hatchery_z_he_beginning_hatchery,
        0  AS hatchery_z_qty_he_transfer_farm_bef_gr,
        0  AS hatchery_z_he_transfer_farm_bef_gr,
        0  AS hatchery_z_qty_add_he_transfer_from_br,
        0  AS hatchery_z_add_he_transfer_from_br,
        0  AS hatchery_z_qty_he_purchase_affiliate_co,
        0  AS hatchery_z_he_purchase_affiliate_co,
        0  AS hatchery_z_transportation_he,
        0  AS hatchery_z_qty_he_available_gr_process,
        0  AS hatchery_z_he_available_to_gr_process,
        0  AS hatchery_z_qty_non_he_sold,
        0  AS hatchery_z_non_he_sold,
        0  AS hatchery_z_qty_non_he_csr,
        0  AS hatchery_z_non_he_csr,
        0  AS hatchery_z_qty_he_avail_to_produce_doc,
        0  AS hatchery_z_he_available_to_produce_doc,
        0  AS hatchery_z_qty_he_used_to_hatch_process,
        0  AS hatchery_cost_of_he_put_into_hatcher,
        0  AS hatchery_z_he_used_to_hatching_process,
        0  AS hatchery_z_qty_he_used_to_destroy,
        0  AS hatchery_z_he_used_to_destroy,
        0  AS hatchery_z_qty_he_invent_hatchery_end,
        0  AS hatchery_z_he_inventory_hatchery_ending,
        0  AS hatchery_z_income_from_non_he,
        0  AS hatchery_z_hc_cost_of_he_put_in_hatcher,
        0  AS hatchery_z_hc_feed,
        0  AS hatchery_z_hc_vaccine_for_broiler,
        0  AS hatchery_z_hc_hatchery_overhead,
        0  AS hatchery_z_hc_repair_maintenance,
        0  AS hatchery_z_hc_depreciation,
        0  AS hatchery_z_hc_boxes_used,
        COALESCE(SUM(COALESCE(z_income_from_male, 0)) ,0)   AS hatchery_z_income_from_male,

        (
        SELECT COALESCE(SUM(COALESCE(z_qty_income_from_male, 0)) ,0)
        FROM z_get_cost_calculation_hatchery_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},'GP','BROILER',$P{SexLine},$P{Breed})
        WHERE $P{Bpsold} = 'Y'
        AND $P{Layer} = 'N'
        AND $P{Trading} = 'N'
        )
        AS hatchery_z_qty_income_from_male,

        0   AS hatchery_z_income_from_infertile_eggs,
        0   AS hatchery_z_dead_in_shell,
        0   AS hatchery_z_loss,
        0  AS hatchery_z_qty_to_produce_doc,
        COALESCE(SUM(COALESCE(z_income_from_male , 0)) ,0)  AS hatchery_z_amount_to_produce_doc,
        0   AS hatchery_z_qty_doc_culled,
        0   AS hatchery_z_qty_doc_killed,
        0   AS hatchery_z_qty_doc_extra_toleransi,
        0  AS hatchery_z_qty_doc_available_for_sales,
        COALESCE(SUM(COALESCE(z_income_from_male , 0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales,
        0  AS hatchery_z_deductqtytfdodtocomfarm,
        0  AS hatchery_z_deductcosttfdodtocomfarm,
        0  AS hatchery_z_add_qty_begiining_doc,
        0  AS hatchery_z_add_begiining_doc,
        0  AS hatchery_z_deduct_qty_ending_doc,
        0  AS hatchery_z_deduct_ending_doc,
        0  AS hatchery_z_total_qty_cost_trans_to_br,
        0  AS hatchery_z_total_cost_transf_branch_rf,
        0  AS hatchery_z_qty_total_cost_of_sales,
        COALESCE(SUM(COALESCE(z_total_cost_of_sales,0)) ,0)  AS hatchery_z_total_cost_of_sales,
        0  AS  hatchery_z_qty_he_beginning_hatchery_year,
        0  AS  hatchery_z_he_beginning_hatchery_year,
        0  AS hatchery_z_qty_he_transfer_farm_bef_gr_year,
        0  AS hatchery_z_he_transfer_farm_bef_gr_year,
        0  AS hatchery_z_qty_add_he_transfer_from_br_year,
        0  AS hatchery_z_add_he_transfer_from_br_year,
        0  AS hatchery_z_qty_he_purchase_affiliate_co_year,
        0  AS hatchery_z_he_purchase_affiliate_co_year,
        0  AS hatchery_z_transportation_he_year,
        0  AS hatchery_z_qty_he_available_gr_process_year,
        0  AS hatchery_z_he_available_to_gr_process_year,
        0  AS hatchery_z_qty_non_he_sold_year,
        0  AS hatchery_z_non_he_sold_year,
        0  AS hatchery_z_qty_non_he_csr_year,
        0  AS hatchery_z_non_he_csr_year,
        0  AS hatchery_z_qty_he_avail_to_produce_doc_year,
        0  AS hatchery_z_he_available_to_produce_doc_year,
        0  AS hatchery_z_qty_he_used_to_hatch_process_year,
        0  AS hatchery_z_he_used_to_hatching_process_year,
        0  AS hatchery_z_qty_he_used_to_destroy_year,
        0  AS hatchery_z_he_used_to_destroy_year,
        0  AS hatchery_z_qty_he_invent_hatchery_end_year,
        0  AS hatchery_z_he_inventory_hatchery_ending_year,
        0  AS hatchery_z_income_from_non_he_year,
        0  AS hatchery_z_hc_cost_of_he_put_in_hatcher_year,
        0  AS hatchery_z_hc_feed_year,
        0  AS hatchery_z_hc_vaccine_for_broiler_year,
        0  AS hatchery_z_hc_hatchery_overhead_year,
        0  AS hatchery_z_hc_repair_maintenance_year,
        0  AS hatchery_z_hc_depreciation_year,
        0  AS hatchery_z_hc_boxes_used_year,
        COALESCE(SUM(COALESCE(z_income_from_male_year,0)) ,0)  AS hatchery_z_income_from_male_year,

        (
        SELECT COALESCE(SUM(COALESCE(z_qty_income_from_male_year,0)) ,0)
        FROM z_get_cost_calculation_hatchery_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},'GP','BROILER',$P{SexLine},$P{Breed})
        WHERE $P{Bpsold} = 'Y'
        AND $P{Layer} = 'N'
        AND $P{Trading} = 'N'
        )
        AS hatchery_z_qty_income_from_male_year,

        0  AS hatchery_z_income_from_infertile_eggs_year,
        0  AS hatchery_z_dead_in_shell_year,
        0  AS hatchery_z_loss_year,
        COALESCE(SUM(COALESCE(z_qty_income_from_male_year,0)) ,0)  AS hatchery_z_qty_to_produce_doc_year,
        COALESCE(SUM(COALESCE(z_income_from_male_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_year,
        0  AS hatchery_z_qty_doc_culled_year,
        0  AS hatchery_z_qty_doc_killed_year,
        0  AS hatchery_z_qty_doc_extra_toleransi_year,
        COALESCE(SUM(COALESCE(z_qty_income_from_male_year,0)) ,0)  AS hatchery_z_qty_doc_available_for_sales_year,
        COALESCE(SUM(COALESCE(z_income_from_male_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_year,
        0  AS hatchery_z_deductqtytfdodtocomfarm_year,
        0  AS hatchery_z_deductcosttfdodtocomfarm_year,
        0  AS hatchery_z_add_qty_begiining_doc_year,
        0  AS hatchery_z_add_begiining_doc_year,
        0  AS hatchery_z_deduct_qty_ending_doc_year,
        0  AS hatchery_z_deduct_ending_doc_year,
        0  AS hatchery_z_total_qty_cost_trans_to_br_year,
        0  AS hatchery_z_total_cost_transf_branch_rf_year,
        COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_year,0)) ,0)  AS hatchery_z_qty_total_cost_of_sales_year,
        COALESCE(SUM(COALESCE(z_total_cost_of_sales_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_year,
        0  AS  hatchery_z_qty_he_beginning_hatchery_h1_year,
        0  AS  hatchery_z_he_beginning_hatchery_h1_year,
        0  AS hatchery_z_qty_he_transfer_farm_bef_gr_h1_year,
        0  AS hatchery_z_he_transfer_farm_bef_gr_h1_year,
        0  AS hatchery_z_qty_add_he_transfer_from_br_h1_year,
        0  AS hatchery_z_add_he_transfer_from_br_h1_year,
        0  AS hatchery_z_qty_he_purchase_affiliate_co_h1_year,
        0  AS hatchery_z_he_purchase_affiliate_co_h1_year,
        0  AS hatchery_z_transportation_he_h1_year,
        0  AS hatchery_z_qty_he_available_gr_process_h1_year,
        0  AS hatchery_z_he_available_to_gr_process_h1_year,
        0  AS hatchery_z_qty_non_he_sold_h1_year,
        0  AS hatchery_z_non_he_sold_h1_year,
        0  AS hatchery_z_qty_non_he_csr_h1_year,
        0  AS hatchery_z_non_he_csr_h1_year,
        0  AS hatchery_z_qty_he_avail_to_produce_doc_h1_year,
        0  AS hatchery_z_he_available_to_produce_doc_h1_year,
        0  AS hatchery_z_qty_he_used_to_hatch_process_h1_year,
        0  AS hatchery_z_he_used_to_hatching_process_h1_year,
        0  AS hatchery_z_qty_he_used_to_destroy_h1_year,
        0  AS hatchery_z_he_used_to_destroy_h1_year,
        0  AS hatchery_z_qty_he_invent_hatchery_end_h1_year,
        0  AS hatchery_z_he_inventory_hatchery_ending_h1_year,
        0  AS hatchery_z_income_from_non_he_h1_year,
        0  AS hatchery_z_hc_cost_of_he_put_in_hatcher_h1_year,
        0  AS hatchery_z_hc_feed_h1_year,
        0  AS hatchery_z_hc_vaccine_for_broiler_h1_year,
        0  AS hatchery_z_hc_hatchery_overhead_h1_year,
        0  AS hatchery_z_hc_repair_maintenance_h1_year,
        0  AS hatchery_z_hc_depreciation_h1_year,
        0  AS hatchery_z_hc_boxes_used_h1_year,
        COALESCE(SUM(COALESCE(z_income_from_male_h1_year,0)) ,0)  AS hatchery_z_income_from_male_h1_year,

        (
        SELECT COALESCE(SUM(COALESCE(z_qty_income_from_male_h1_year,0)) ,0)
        FROM z_get_cost_calculation_hatchery_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},'GP','BROILER',$P{SexLine},$P{Breed})
        WHERE $P{Bpsold} = 'Y'
        AND $P{Layer} = 'N'
        AND $P{Trading} = 'N'
        )
        AS hatchery_z_qty_income_from_male_h1_year,

        0  AS hatchery_z_income_from_infertile_eggs_h1_year,
        0  AS hatchery_z_dead_in_shell_h1_year,
        0  AS hatchery_z_loss_h1_year,
        COALESCE(SUM(COALESCE(z_qty_income_from_male_h1_year,0)) ,0)  AS hatchery_z_qty_to_produce_doc_h1_year,
        COALESCE(SUM(COALESCE(z_income_from_male_h1_year,0)) ,0)  AS hatchery_z_amount_to_produce_doc_h1_year,
        0  AS hatchery_z_qty_doc_culled_h1_year,
        0  AS hatchery_z_qty_doc_killed_h1_year,
        0  AS hatchery_z_qty_doc_extra_toleransi_h1_year,
        COALESCE(SUM(COALESCE(z_qty_income_from_male_h1_year,0)) ,0)  AS hatchery_z_qty_doc_available_for_sales_h1_year,
        COALESCE(SUM(COALESCE(z_income_from_male_h1_year,0)) ,0)  AS hatchery_z_amount_doc_avail_for_sales_h1_year,
        0  AS hatchery_z_deductqtytfdodtocomfarm_h1_year,
        0  AS hatchery_z_deductcosttfdodtocomfarm_h1_year,
        0  AS hatchery_z_add_qty_begiining_doc_h1_year,
        0  AS hatchery_z_add_begiining_doc_h1_year,
        0  AS hatchery_z_deduct_qty_ending_doc_h1_year,
        0  AS hatchery_z_deduct_ending_doc_h1_year,
        0  AS hatchery_z_total_qty_cost_trans_to_br_h1_year,
        0  AS hatchery_z_total_cost_transf_branch_rf_h1_year,
        COALESCE(SUM(COALESCE(z_qty_total_cost_of_sales_h1_year,0)) ,0)  AS hatchery_z_qty_total_cost_of_sales_h1_year,
        COALESCE(SUM(COALESCE(z_total_cost_of_sales_h1_year,0)) ,0)  AS hatchery_z_total_cost_of_sales_h1_year,
       0 AS hatchery_z_salable_chick,
       0 AS hatchery_z_hatchability,
        0  AS qty_he_trf_to_br,
        0  AS qty_he_trf_to_br_year,
        0  AS qty_he_trf_to_br_h1_year,
        0  AS he_trf_to_br,
        0  AS he_trf_to_br_year,
        0  AS he_trf_to_br_h1_year,
        0  AS qty_he_sales_to_aff,
        0  AS qty_he_sales_to_aff_year,
        0  AS qty_he_sales_to_aff_h1_year,
        0  AS he_sales_to_aff,
        0  AS he_sales_to_aff_year,
        0  AS he_sales_to_aff_h1_year,
        0  AS cost_trf_he_to_br,
        0  AS cost_trf_he_to_br_year,
        0  AS cost_trf_he_to_br_h1_year,
        0  AS sales_he_to_affiliate,
        0  AS sales_he_to_affiliate_year,
        0  AS sales_he_to_affiliate_h1_year,
        0   AS deductqtytfdodtofarmbreed,
        0  AS deductqtytfdodtofarmbreed_year,
        0  AS deductqtytfdodtofarmbreed_h1_year,
        0  AS deductcosttfdodtofarmbreed,
        0  AS deductcosttfdodtofarmbreed_year,
        0  AS deductcosttfdodtofarmbreed_h1_year,

        0 AS qtymoveinouthehatch,
        0 AS  amountmoveinouthehatch,
        0 AS  qtymoveinouthehatch_year,
        0 AS  amountmoveinouthehatch_year,
        0 AS  qtymoveinouthehatch_h1_year,
        0 AS  amountmoveinouthehatch_h1_year,


        0 AS qtyheAvailBefGradAfterMovehatc,
        0 AS heAvailBefGradAfterMovehatc,
        0 AS qtyheAvailBefGradAfterMovehatc_year,
        0 AS heAvailBefGradAfterMovehatc_year,
        0 AS qtyheAvailBefGradAfterMovehatc_h1_year,
        0 AS heAvailBefGradAfterMovehatc_h1_year,

        0 AS z_qty_he_avail_bfr_gr,
        0 AS z_qty_he_avail_bfr_gr_year,
        0 AS z_qty_he_avail_bfr_gr_h1_year,
        0 AS z_he_avail_bfr_gr,
        0 AS z_he_avail_bfr_gr_year,
        0 AS z_he_avail_bfr_gr_h1_year,

        0 AS z_incomefrominfertile_eggvalue,
        0 AS z_incomefrominfertile_eggvalue_year,
        0 AS z_incomefrominfertile_eggvalue_h1_year,

        COALESCE(SUM(COALESCE(z_qty_docsumbangan,0)),0) AS z_qty_docsumbangan,
        COALESCE(SUM(COALESCE(z_qty_docsumbangan_year,0)),0) AS z_qty_docsumbangan_year,
        COALESCE(SUM(COALESCE(z_qty_docsumbangan_h1_year,0)),0) AS z_qty_docsumbangan_h1_year --sampai sini--


        FROM z_get_cost_calculation_hatchery_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},'GP','BROILER',$P{SexLine},$P{Breed})
        WHERE $P{Bpsold} = 'Y'
        AND $P{Layer} = 'N'
        AND $P{Trading} = 'N'
        AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
        )
        AS hatchery_bpsold
    )tabel
WHERE farm_z_qty IS NOT NULL AND farm_z_qty_year IS NOT NULL AND farm_z_qty_h1_year IS NOT NULL

UNION

SELECT tabel.*, 7 orderkey
-- non_trading, layer, bpsold
-- org di param_reporting
FROM
(
    SELECT
    (select name from c_period cp where c_period_id = $P{C_Period_ID}) as periodname,
    (select name from ad_org ao where ad_org_id = $P{AD_Org_ID}) as orgname,
    (select name from ad_org ao where ao.ad_org_id = $P{z_unit_ID}) as unitname,
    COALESCE($P{BranchType},'') AS brachtype,
    COALESCE($P{CategoryName},'') AS categoryname,
    COALESCE($P{Breed},'') breed,
    COALESCE($P{SexLine},'') sexline,
    *,

    (farm_z_depl_cost_doc_breeder +
    farm_z_depl_transportation_doc +
    farm_z_depl_feed_used +
    farm_z_depl_transportation_feed +
    farm_z_depl_medicine_used +
    farm_z_depl_direct_labor +
    farm_z_depl_farm_overhead +
    farm_z_depl_repair_maintenance +
    farm_z_depl_depreciation) AS persen_depletion_of_flockgrowing_cost,

    (farm_z_depl_cost_doc_breeder_year +
    farm_z_depl_transportation_doc_year +
    farm_z_depl_feed_used_year +
    farm_z_depl_transportation_feed_year +
    farm_z_depl_medicine_used_year +
    farm_z_depl_direct_labor_year +
    farm_z_depl_farm_overhead_year +
    farm_z_depl_repair_maintenance_year +
    farm_z_depl_depreciation_year) AS persen_depletion_of_flockgrowing_cost_ytd,

    1 AS penanda_data

    FROM
    (
    SELECT
    SUM(COALESCE(z_fp_feed_used,0)) AS farm_z_fp_feed_used ,
    SUM(COALESCE(z_fp_transportation_feed,0)) AS  farm_z_fp_transportation_feed,
    SUM(COALESCE(z_fp_vaccine_medicine_used,0)) AS farm_z_fp_vaccine_medicine_used,
    SUM(COALESCE(z_fp_direct_labor,0)) AS farm_z_fp_direct_labor,
    SUM(COALESCE(z_fp_farm_overhead,0)) AS farm_z_fp_farm_overhead,
    SUM(COALESCE(z_fp_repair_maintenance,0)) AS  farm_z_fp_repair_maintenance,
    SUM(COALESCE(z_fp_depreciation,0)) AS  farm_z_fp_depreciation,
    SUM(COALESCE(z_depl_cost_doc_breeder,0)) AS  farm_z_depl_cost_doc_breeder,
    SUM(COALESCE(z_depl_transportation_doc,0)) AS  farm_z_depl_transportation_doc,
    SUM(COALESCE(z_depl_feed_used,0)) AS  farm_z_depl_feed_used,
    SUM(COALESCE(z_depl_transportation_feed,0)) AS farm_z_depl_transportation_feed ,
    SUM(COALESCE(z_depl_medicine_used,0)) AS  farm_z_depl_medicine_used,
    SUM(COALESCE(z_depl_direct_labor,0)) AS  farm_z_depl_direct_labor,
    SUM(COALESCE(z_depl_farm_overhead,0)) AS  farm_z_depl_farm_overhead,
    SUM(COALESCE(z_depl_repair_maintenance,0)) AS farm_z_depl_repair_maintenance ,
    SUM(COALESCE(z_depl_depreciation,0)) AS farm_z_depl_depreciation ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGSx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS,0)) END
    AS farm_z_Total_Qty_to_produce_EGGS ,

    SUM(COALESCE(z_Cost_produce_Eggs,0)) AS farm_z_Cost_produce_Eggs ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_hex,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he,0))*-1) END
    AS farm_z_qty_non_he ,

    (SUM(COALESCE(z_income_from_non_he,0))*-1) AS farm_z_income_from_non_he ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_hex,0))
    ELSE SUM(COALESCE(z_qty_produce_he,0)) END
    AS farm_z_qty_produce_he ,

    SUM(COALESCE(z_cost_produce_he,0)) AS farm_z_cost_produce_he ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_beginx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin,0)) END
    AS farm_z_qty_he_inventory_farm_begin ,

    SUM(COALESCE(z_he_inventory_farm_begin,0)) AS farm_z_he_inventory_farm_begin ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farmx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm,0)) END
    AS farm_z_qty_he_from_farm ,

    SUM(COALESCE(z_cost_he_from_farm,0)) AS farm_z_cost_he_from_farm ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farmx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm,0)) END
    AS farm_z_qty_he_available_farm ,

    SUM(COALESCE(z_he_available_in_farm,0)) AS farm_z_he_available_in_farm ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliatex,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate,0))*-1) END
    AS farm_z_qty_he_sales_to_affiliate ,

    (SUM(COALESCE(z_he_sales_to_affiliate,0))*-1) AS farm_z_he_sales_to_affiliate ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transferx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer,0)) END
    AS farm_z_qty_he_ending_bef_transfer ,

    SUM(COALESCE(z_he_ending_bef_transfer_out,0)) AS farm_z_he_ending_bef_transfer_out ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_outx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out,0))*-1) END
    AS farm_z_qty_he_used_transfer_out ,

    (SUM(COALESCE(z_he_used_transfer_out,0))*-1) AS farm_z_he_used_transfer_out ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_farmx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_farm,0)) END
    AS farm_z_qty_he_ending_farm ,

    SUM(COALESCE(z_he_ending_farm,0)) AS farm_z_he_ending_farm ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qtyx,0))
    ELSE SUM(COALESCE(z_qty,0)) END
    AS farm_z_qty ,

    SUM(COALESCE(z_sales_he,0)) AS farm_z_sales_he,
    SUM(COALESCE(z_fp_feed_used_year,0)) AS farm_z_fp_feed_used_year ,
    SUM(COALESCE(z_fp_transportation_feed_year,0)) AS farm_z_fp_transportation_feed_year ,
    SUM(COALESCE(z_fp_vaccine_medicine_used_year,0)) AS farm_z_fp_vaccine_medicine_used_year ,
    SUM(COALESCE(z_fp_direct_labor_year,0)) AS farm_z_fp_direct_labor_year ,
    SUM(COALESCE(z_fp_farm_overhead_year,0)) AS farm_z_fp_farm_overhead_year ,
    SUM(COALESCE(z_fp_repair_maintenance_year,0)) AS farm_z_fp_repair_maintenance_year ,
    SUM(COALESCE(z_fp_depreciation_year,0)) AS farm_z_fp_depreciation_year ,
    SUM(COALESCE(z_depl_cost_doc_breeder_year,0)) AS farm_z_depl_cost_doc_breeder_year ,
    SUM(COALESCE(z_depl_transportation_doc_year,0)) AS farm_z_depl_transportation_doc_year ,
    SUM(COALESCE(z_depl_feed_used_year,0)) AS farm_z_depl_feed_used_year ,
    SUM(COALESCE(z_depl_transportation_feed_year,0)) AS farm_z_depl_transportation_feed_year ,
    SUM(COALESCE(z_depl_medicine_used_year,0)) AS farm_z_depl_medicine_used_year ,
    SUM(COALESCE(z_depl_direct_labor_year,0)) AS farm_z_depl_direct_labor_year ,
    SUM(COALESCE(z_depl_farm_overhead_year,0)) AS farm_z_depl_farm_overhead_year ,
    SUM(COALESCE(z_depl_repair_maintenance_year,0)) AS farm_z_depl_repair_maintenance_year ,
    SUM(COALESCE(z_depl_depreciation_year,0)) AS farm_z_depl_depreciation_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_yearx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_year,0)) END
    AS farm_z_Total_Qty_to_produce_EGGS_year ,

    SUM(COALESCE(z_Cost_produce_Eggs_year,0)) AS farm_z_Cost_produce_Eggs_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he_year,0))*-1) END
    AS farm_z_qty_non_he_year ,

    (SUM(COALESCE(z_income_from_non_he_year,0))*-1) AS farm_z_income_from_non_he_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_produce_he_yearx,0))*-1)
    ELSE SUM(COALESCE(z_qty_produce_he_year,0)) END
    AS farm_z_qty_produce_he_year ,

    SUM(COALESCE(z_cost_produce_he_year,0)) AS farm_z_cost_produce_he_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_year,0)) END
    AS farm_z_qty_he_inventory_farm_begin_year ,

    SUM(COALESCE(z_he_inventory_farm_begin_year,0)) AS farm_z_he_inventory_farm_begin_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm_year,0)) END
    AS farm_z_qty_he_from_farm_year ,

    SUM(COALESCE(z_cost_he_from_farm_year,0)) AS farm_z_cost_he_from_farm_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm_year,0)) END
    AS farm_z_qty_he_available_farm_year ,

    SUM(COALESCE(z_he_available_in_farm_year,0)) AS farm_z_he_available_in_farm_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_year,0))*-1) END
    AS farm_z_qty_he_sales_to_affiliate_year ,

    (SUM(COALESCE(z_he_sales_to_affiliate_year,0))*-1) AS farm_z_he_sales_to_affiliate_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transfer_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer_year,0)) END
    AS farm_z_qty_he_ending_bef_transfer_year ,

    SUM(COALESCE(z_he_ending_bef_transfer_out_year,0)) AS farm_z_he_ending_bef_transfer_out_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_year,0))*-1) END
    AS farm_z_qty_he_used_transfer_out_year ,

    (SUM(COALESCE(z_he_used_transfer_out_year,0))*-1) AS farm_z_he_used_transfer_out_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_farm_year,0)) END
    AS farm_z_qty_he_ending_farm_year ,

    SUM(COALESCE(z_he_ending_farm_year,0)) AS farm_z_he_ending_farm_year ,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_yearx,0))
    ELSE SUM(COALESCE(z_qty_year,0)) END
    AS farm_z_qty_year ,

    SUM(COALESCE(z_sales_he_year,0)) AS farm_z_sales_he_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_h1_year,0)) END
    AS farm_z_qty_he_inventory_farm_begin_h1_year  ,

    SUM(COALESCE(z_he_inventory_farm_begin_h1_year,0)) AS farm_z_he_inventory_farm_begin_h1_year ,
    SUM(COALESCE(z_qty_he_ending_farm_h1_year,0)) AS farm_z_qty_he_ending_farm_h1_year ,
    SUM(COALESCE(z_he_ending_farm_h1_year,0)) AS farm_z_he_ending_farm_h1_year,
    SUM(COALESCE(z_fp_feed_used_h1_year,0)) as farm_z_fp_feed_used_h1_year,
    SUM(COALESCE(z_fp_transportation_feed_h1_year,0)) as farm_z_fp_transportation_feed_h1_year,
    SUM(COALESCE(z_fp_vaccine_medicine_used_h1_year,0)) as farm_z_fp_vaccine_medicine_used_h1_year,
    SUM(COALESCE(z_fp_direct_labor_h1_year,0)) as farm_z_fp_direct_labor_h1_year,
    SUM(COALESCE(z_fp_farm_overhead_h1_year,0)) as farm_z_fp_farm_overhead_h1_year,
    SUM(COALESCE(z_fp_repair_maintenance_h1_year,0)) as farm_z_fp_repair_maintenance_h1_year,
    SUM(COALESCE(z_fp_depreciation_h1_year,0)) as farm_z_fp_depreciation_h1_year,
    SUM(COALESCE(z_depl_cost_doc_breeder_h1_year,0)) as farm_z_depl_cost_doc_breeder_h1_year,
    SUM(COALESCE(z_depl_transportation_doc_h1_year,0)) as farm_z_depl_transportation_doc_h1_year,
    SUM(COALESCE(z_depl_feed_used_h1_year,0)) as farm_z_depl_feed_used_h1_year,
    SUM(COALESCE(z_depl_transportation_feed_h1_year,0)) as farm_z_depl_transportation_feed_h1_year,
    SUM(COALESCE(z_depl_medicine_used_h1_year,0)) as farm_z_depl_medicine_used_h1_year,
    SUM(COALESCE(z_depl_direct_labor_h1_year,0)) as farm_z_depl_direct_labor_h1_year,
    SUM(COALESCE(z_depl_farm_overhead_h1_year,0)) as farm_z_depl_farm_overhead_h1_year,
    SUM(COALESCE(z_depl_repair_maintenance_h1_year,0)) as farm_z_depl_repair_maintenance_h1_year,
    SUM(COALESCE(z_depl_depreciation_h1_year,0)) as farm_z_depl_depreciation_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_h1_yearx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_h1_year,0)) END
    as farm_z_Total_Qty_to_produce_EGGS_h1_year,

    SUM(COALESCE(z_Cost_produce_Eggs_h1_year,0)) as farm_z_Cost_produce_Eggs_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_h1_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he_h1_year,0))*-1) END
    as farm_z_qty_non_he_h1_year,

    (SUM(COALESCE(z_income_from_non_he_h1_year,0))*-1) as farm_z_income_from_non_he_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_he_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_produce_he_h1_year,0)) END
    as farm_z_qty_produce_he_h1_year,

    SUM(COALESCE(z_cost_produce_he_h1_year,0)) as farm_z_cost_produce_he_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm_h1_year,0)) END
    as farm_z_qty_he_from_farm_h1_year,

    SUM(COALESCE(z_cost_he_from_farm_h1_year,0)) as farm_z_cost_he_from_farm_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm_h1_year,0)) END
    as farm_z_qty_he_available_farm_h1_year,

    SUM(COALESCE(z_he_available_in_farm_h1_year,0)) as farm_z_he_available_in_farm_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_h1_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_h1_year,0))*-1) END
    as farm_z_qty_he_sales_to_affiliate_h1_year,

    (SUM(COALESCE(z_he_sales_to_affiliate_h1_year,0))*-1) as farm_z_he_sales_to_affiliate_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transfer_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer_h1_year,0)) END
    as farm_z_qty_he_ending_bef_transfer_h1_year,

    SUM(COALESCE(z_he_ending_bef_transfer_out_h1_year,0)) as farm_z_he_ending_bef_transfer_out_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_h1_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_h1_year,0))*-1) END
    as farm_z_qty_he_used_transfer_out_h1_year,

    (SUM(COALESCE(z_he_used_transfer_out_h1_year,0))*-1) as farm_z_he_used_transfer_out_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_h1_yearx,0))
    ELSE SUM(COALESCE(z_qty_h1_year,0)) END
    AS farm_z_qty_h1_year,

    SUM(COALESCE(z_sales_he_h1_year,0)) AS farm_z_sales_he_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_brx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br,0)) *-1 END
    AS qty_he_trf_to_br_13 ,

    SUM(COALESCE(he_trf_to_br,0)) * -1 AS he_trf_to_br_13,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_yearx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br_year,0)) *-1 END
    as qty_he_trf_to_br_year_13,

    SUM(COALESCE(he_trf_to_br_year,0)) *-1 as he_trf_to_br_year_13,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_h1_yearx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br_h1_year,0)) *-1 END
    as qty_he_trf_to_br_h1_year_13,

    SUM(COALESCE(he_trf_to_br_h1_year,0)) *-1 as he_trf_to_br_h1_year_13,
    SUM(COALESCE(cost_trf_he_to_br,0)) as cost_trf_he_to_br_13,
    SUM(COALESCE(cost_trf_he_to_br_year,0)) as cost_trf_he_to_br_year_13,
    SUM(COALESCE(cost_trf_he_to_br_h1_year,0)) as cost_trf_he_to_br_h1_year_13,

    SUM(COALESCE(z_cost_transfer_variance,0)) AS z_cost_transfer_variance,
    SUM(COALESCE(z_cost_transfer_variance_year,0)) AS z_cost_transfer_variance_year,
    SUM(COALESCE(z_cost_transfer_variance_h1_year,0)) AS z_cost_transfer_variance_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_hex,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he,0)) *-1 END
    AS z_qty_adjustment_he,

    sum(COALESCE(z_adjustment_he,0))*-1 AS z_adjustment_he,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_yearx,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he_year,0)) *-1 END
    AS z_qty_adjustment_he_year,

    sum(COALESCE(z_adjustment_he_year,0))*-1 AS z_adjustment_he_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_h1_yearx,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he_h1_year,0)) *-1 END
    AS z_qty_adjustment_he_h1_year,

    sum(COALESCE(z_adjustment_he_h1_year,0))*-1 AS z_adjustment_he_h1_year


    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE
    $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    ) AS farm
    CROSS JOIN
    (
    SELECT

        0  AS  hatchery_z_qty_he_beginning_hatchery,
        0  AS  hatchery_z_he_beginning_hatchery,
        0  AS hatchery_z_qty_he_transfer_farm_bef_gr,
        0  AS hatchery_z_he_transfer_farm_bef_gr,
        0  AS hatchery_z_qty_add_he_transfer_from_br,
        0  AS hatchery_z_add_he_transfer_from_br,
        0  AS hatchery_z_qty_he_purchase_affiliate_co,
        0  AS hatchery_z_he_purchase_affiliate_co,
        0  AS hatchery_z_transportation_he,
        0  AS hatchery_z_qty_he_available_gr_process,
        0  AS hatchery_z_he_available_to_gr_process,
        0  AS hatchery_z_qty_non_he_sold,
        0  AS hatchery_z_non_he_sold,
        0  AS hatchery_z_qty_non_he_csr,
        0  AS hatchery_z_non_he_csr,
        0  AS hatchery_z_qty_he_avail_to_produce_doc,
        0  AS hatchery_z_he_available_to_produce_doc,
        0  AS hatchery_z_qty_he_used_to_hatch_process,
        0  AS hatchery_cost_of_he_put_into_hatcher,
        0  AS hatchery_z_he_used_to_hatching_process,
        0  AS hatchery_z_qty_he_used_to_destroy,
        0  AS hatchery_z_he_used_to_destroy,
        0  AS hatchery_z_qty_he_invent_hatchery_end,
        0  AS hatchery_z_he_inventory_hatchery_ending,
        0  AS hatchery_z_income_from_non_he,

        SUM(
        COALESCE(he_trf_to_br,0) + COALESCE(z_he_sales_to_affiliate,0) - COALESCE(cost_trf_he_to_br,0) - COALESCE(z_sales_he,0)
        )  AS hatchery_z_hc_cost_of_he_put_in_hatcher,

        0  AS hatchery_z_hc_feed,
        0  AS hatchery_z_hc_vaccine_for_broiler,
        0  AS hatchery_z_hc_hatchery_overhead,
        0  AS hatchery_z_hc_repair_maintenance,
        0  AS hatchery_z_hc_depreciation,
        0  AS hatchery_z_hc_boxes_used,
        0   AS hatchery_z_income_from_male,

        0
        AS hatchery_z_qty_income_from_male,

        0   AS hatchery_z_income_from_infertile_eggs,
        0   AS hatchery_z_dead_in_shell,
        0   AS hatchery_z_loss,
        0  AS hatchery_z_qty_to_produce_doc,

        SUM(
        (COALESCE(he_trf_to_br,0) *-1) + COALESCE(z_he_sales_to_affiliate,0) - COALESCE(cost_trf_he_to_br,0) - COALESCE(z_sales_he,0)
        )  AS hatchery_z_amount_to_produce_doc,

        0   AS hatchery_z_qty_doc_culled,
        0   AS hatchery_z_qty_doc_killed,
        0   AS hatchery_z_qty_doc_extra_toleransi,
        0  AS hatchery_z_qty_doc_available_for_sales,

        SUM(
        (COALESCE(he_trf_to_br,0) *-1) + COALESCE(z_he_sales_to_affiliate,0) - COALESCE(cost_trf_he_to_br,0) - COALESCE(z_sales_he,0)
        )  AS hatchery_z_amount_doc_avail_for_sales,

        0  AS hatchery_z_deductqtytfdodtocomfarm,
        0  AS hatchery_z_deductcosttfdodtocomfarm,
        0  AS hatchery_z_add_qty_begiining_doc,
        0  AS hatchery_z_add_begiining_doc,
        0  AS hatchery_z_deduct_qty_ending_doc,
        0  AS hatchery_z_deduct_ending_doc,
        0  AS hatchery_z_total_qty_cost_trans_to_br,
        0  AS hatchery_z_total_cost_transf_branch_rf,
        0  AS hatchery_z_qty_total_cost_of_sales,

        SUM(
        (COALESCE(he_trf_to_br,0) *-1) + COALESCE(z_he_sales_to_affiliate,0) - COALESCE(cost_trf_he_to_br,0) - COALESCE(z_sales_he,0)
        )  AS hatchery_z_total_cost_of_sales,

        0  AS  hatchery_z_qty_he_beginning_hatchery_year,
        0  AS  hatchery_z_he_beginning_hatchery_year,
        0  AS hatchery_z_qty_he_transfer_farm_bef_gr_year,
        0  AS hatchery_z_he_transfer_farm_bef_gr_year,
        0  AS hatchery_z_qty_add_he_transfer_from_br_year,
        0  AS hatchery_z_add_he_transfer_from_br_year,
        0  AS hatchery_z_qty_he_purchase_affiliate_co_year,
        0  AS hatchery_z_he_purchase_affiliate_co_year,
        0  AS hatchery_z_transportation_he_year,
        0  AS hatchery_z_qty_he_available_gr_process_year,
        0  AS hatchery_z_he_available_to_gr_process_year,
        0  AS hatchery_z_qty_non_he_sold_year,
        0  AS hatchery_z_non_he_sold_year,
        0  AS hatchery_z_qty_non_he_csr_year,
        0  AS hatchery_z_non_he_csr_year,
        0  AS hatchery_z_qty_he_avail_to_produce_doc_year,
        0  AS hatchery_z_he_available_to_produce_doc_year,
        0  AS hatchery_z_qty_he_used_to_hatch_process_year,
        0  AS hatchery_z_he_used_to_hatching_process_year,
        0  AS hatchery_z_qty_he_used_to_destroy_year,
        0  AS hatchery_z_he_used_to_destroy_year,
        0  AS hatchery_z_qty_he_invent_hatchery_end_year,
        0  AS hatchery_z_he_inventory_hatchery_ending_year,
        0  AS hatchery_z_income_from_non_he_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_hc_cost_of_he_put_in_hatcher_year,

        0  AS hatchery_z_hc_feed_year,
        0  AS hatchery_z_hc_vaccine_for_broiler_year,
        0  AS hatchery_z_hc_hatchery_overhead_year,
        0  AS hatchery_z_hc_repair_maintenance_year,
        0  AS hatchery_z_hc_depreciation_year,
        0  AS hatchery_z_hc_boxes_used_year,
        0  AS hatchery_z_income_from_male_year,

        0
        AS hatchery_z_qty_income_from_male_year,

        0  AS hatchery_z_income_from_infertile_eggs_year,
        0  AS hatchery_z_dead_in_shell_year,
        0  AS hatchery_z_loss_year,
        0  AS hatchery_z_qty_to_produce_doc_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_amount_to_produce_doc_year,

        0  AS hatchery_z_qty_doc_culled_year,
        0  AS hatchery_z_qty_doc_killed_year,
        0  AS hatchery_z_qty_doc_extra_toleransi_year,
        0  AS hatchery_z_qty_doc_available_for_sales_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_amount_doc_avail_for_sales_year,

        0  AS hatchery_z_deductqtytfdodtocomfarm_year,
        0  AS hatchery_z_deductcosttfdodtocomfarm_year,
        0  AS hatchery_z_add_qty_begiining_doc_year,
        0  AS hatchery_z_add_begiining_doc_year,
        0  AS hatchery_z_deduct_qty_ending_doc_year,
        0  AS hatchery_z_deduct_ending_doc_year,
        0  AS hatchery_z_total_qty_cost_trans_to_br_year,
        0  AS hatchery_z_total_cost_transf_branch_rf_year,
        0  AS hatchery_z_qty_total_cost_of_sales_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_total_cost_of_sales_year,

        0  AS  hatchery_z_qty_he_beginning_hatchery_h1_year,
        0  AS  hatchery_z_he_beginning_hatchery_h1_year,
        0  AS hatchery_z_qty_he_transfer_farm_bef_gr_h1_year,
        0  AS hatchery_z_he_transfer_farm_bef_gr_h1_year,
        0  AS hatchery_z_qty_add_he_transfer_from_br_h1_year,
        0  AS hatchery_z_add_he_transfer_from_br_h1_year,
        0  AS hatchery_z_qty_he_purchase_affiliate_co_h1_year,
        0  AS hatchery_z_he_purchase_affiliate_co_h1_year,
        0  AS hatchery_z_transportation_he_h1_year,
        0  AS hatchery_z_qty_he_available_gr_process_h1_year,
        0  AS hatchery_z_he_available_to_gr_process_h1_year,
        0  AS hatchery_z_qty_non_he_sold_h1_year,
        0  AS hatchery_z_non_he_sold_h1_year,
        0  AS hatchery_z_qty_non_he_csr_h1_year,
        0  AS hatchery_z_non_he_csr_h1_year,
        0  AS hatchery_z_qty_he_avail_to_produce_doc_h1_year,
        0  AS hatchery_z_he_available_to_produce_doc_h1_year,
        0  AS hatchery_z_qty_he_used_to_hatch_process_h1_year,
        0  AS hatchery_z_he_used_to_hatching_process_h1_year,
        0  AS hatchery_z_qty_he_used_to_destroy_h1_year,
        0  AS hatchery_z_he_used_to_destroy_h1_year,
        0  AS hatchery_z_qty_he_invent_hatchery_end_h1_year,
        0  AS hatchery_z_he_inventory_hatchery_ending_h1_year,
        0  AS hatchery_z_income_from_non_he_h1_year,

        SUM(
        (COALESCE(he_trf_to_br_h1_year,0) ) + COALESCE(z_he_sales_to_affiliate_h1_year,0) - COALESCE(cost_trf_he_to_br_h1_year,0) - COALESCE(z_sales_he_h1_year,0)
        )  AS hatchery_z_hc_cost_of_he_put_in_hatcher_h1_year,

        0  AS hatchery_z_hc_feed_h1_year,
        0  AS hatchery_z_hc_vaccine_for_broiler_h1_year,
        0  AS hatchery_z_hc_hatchery_overhead_h1_year,
        0  AS hatchery_z_hc_repair_maintenance_h1_year,
        0  AS hatchery_z_hc_depreciation_h1_year,
        0  AS hatchery_z_hc_boxes_used_h1_year,
        0  AS hatchery_z_income_from_male_h1_year,

        0
        AS hatchery_z_qty_income_from_male_h1_year,

        0  AS hatchery_z_income_from_infertile_eggs_h1_year,
        0  AS hatchery_z_dead_in_shell_h1_year,
        0  AS hatchery_z_loss_h1_year,
        0  AS hatchery_z_qty_to_produce_doc_h1_year,

        SUM(
        (COALESCE(he_trf_to_br_h1_year,0) ) + COALESCE(z_he_sales_to_affiliate_h1_year,0) - COALESCE(cost_trf_he_to_br_h1_year,0) - COALESCE(z_sales_he_h1_year,0)
        )  AS hatchery_z_amount_to_produce_doc_h1_year,

        0  AS hatchery_z_qty_doc_culled_h1_year,
        0  AS hatchery_z_qty_doc_killed_h1_year,
        0  AS hatchery_z_qty_doc_extra_toleransi_h1_year,
        0  AS hatchery_z_qty_doc_available_for_sales_h1_year,

        SUM(
        (COALESCE(he_trf_to_br_h1_year,0) ) + COALESCE(z_he_sales_to_affiliate_h1_year,0) - COALESCE(cost_trf_he_to_br_h1_year,0) - COALESCE(z_sales_he_h1_year,0)
        )  AS hatchery_z_amount_doc_avail_for_sales_h1_year,

        0  AS hatchery_z_deductqtytfdodtocomfarm_h1_year,
        0  AS hatchery_z_deductcosttfdodtocomfarm_h1_year,
        0  AS hatchery_z_add_qty_begiining_doc_h1_year,
        0  AS hatchery_z_add_begiining_doc_h1_year,
        0  AS hatchery_z_deduct_qty_ending_doc_h1_year,
        0  AS hatchery_z_deduct_ending_doc_h1_year,
        0  AS hatchery_z_total_qty_cost_trans_to_br_h1_year,
        0  AS hatchery_z_total_cost_transf_branch_rf_h1_year,
        0  AS hatchery_z_qty_total_cost_of_sales_h1_year,

        SUM(
        (COALESCE(he_trf_to_br_h1_year,0) ) + COALESCE(z_he_sales_to_affiliate_h1_year,0) - COALESCE(cost_trf_he_to_br_h1_year,0) - COALESCE(z_sales_he_h1_year,0)
        )  AS hatchery_z_total_cost_of_sales_h1_year,

        0 AS hatchery_z_salable_chick,
        0 AS hatchery_z_hatchability,
        0  AS qty_he_trf_to_br,
        0  AS qty_he_trf_to_br_year,
        0  AS qty_he_trf_to_br_h1_year,
        0  AS he_trf_to_br,
        0  AS he_trf_to_br_year,
        0  AS he_trf_to_br_h1_year,
        0  AS qty_he_sales_to_aff,
        0  AS qty_he_sales_to_aff_year,
        0  AS qty_he_sales_to_aff_h1_year,
        0  AS he_sales_to_aff,
        0  AS he_sales_to_aff_year,
        0  AS he_sales_to_aff_h1_year,
        0  AS cost_trf_he_to_br,
        0  AS cost_trf_he_to_br_year,
        0  AS cost_trf_he_to_br_h1_year,
        0  AS sales_he_to_affiliate,
        0  AS sales_he_to_affiliate_year,
        0  AS sales_he_to_affiliate_h1_year,
        0   AS deductqtytfdodtofarmbreed,
        0  AS deductqtytfdodtofarmbreed_year,
        0  AS deductqtytfdodtofarmbreed_h1_year,
        0  AS deductcosttfdodtofarmbreed,
        0  AS deductcosttfdodtofarmbreed_year,
        0  AS deductcosttfdodtofarmbreed_h1_year,

        0 AS qtymoveinouthehatch,
        0 AS  amountmoveinouthehatch,
        0 AS  qtymoveinouthehatch_year,
        0 AS  amountmoveinouthehatch_year,
        0 AS  qtymoveinouthehatch_h1_year,
        0 AS  amountmoveinouthehatch_h1_year,


        0 AS qtyheAvailBefGradAfterMovehatc,
        0 AS heAvailBefGradAfterMovehatc,
        0 AS qtyheAvailBefGradAfterMovehatc_year,
        0 AS heAvailBefGradAfterMovehatc_year,
        0 AS qtyheAvailBefGradAfterMovehatc_h1_year,
        0 AS heAvailBefGradAfterMovehatc_h1_year,

        0 AS z_qty_he_avail_bfr_gr,
        0 AS z_qty_he_avail_bfr_gr_year,
        0 AS z_qty_he_avail_bfr_gr_h1_year,
        0 AS z_he_avail_bfr_gr,
        0 AS z_he_avail_bfr_gr_year,
        0 AS z_he_avail_bfr_gr_h1_year,

        0 AS z_incomefrominfertile_eggvalue,
        0 AS z_incomefrominfertile_eggvalue_year,
        0 AS z_incomefrominfertile_eggvalue_h1_year,

        0 AS z_qty_docsumbangan,
        0 AS z_qty_docsumbangan_year,
        0 AS z_qty_docsumbangan_h1_year


    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE
    $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    ) AS hatchery

)tabel
WHERE farm_z_qty IS NOT NULL
AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
    (SELECT per.startdate FROM adempiere.z_costing_duck pgc
            INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
            WHERE pgc.ad_org_id = $P{AD_Org_ID}
            ORDER BY per.startdate ASC LIMIT 1
    )

UNION
-- non_trading, layer, bpsold
-- ambil data farm bulan lalu, Organisasi IN Param_reporting
SELECT tabel.*, 8 orderkey
FROM
(
    SELECT
    (select name from c_period cp where c_period_id = $P{C_Period_ID}) as periodname,
    (select name from ad_org ao where ad_org_id = $P{AD_Org_ID}) as orgname,
    (select name from ad_org ao where ao.ad_org_id = $P{z_unit_ID}) as unitname,
    COALESCE($P{BranchType},'') AS brachtype,
    COALESCE($P{CategoryName},'') AS categoryname,
    COALESCE($P{Breed},'') breed,
    COALESCE($P{SexLine},'') sexline,
    *,

    (farm_z_depl_cost_doc_breeder +
    farm_z_depl_transportation_doc +
    farm_z_depl_feed_used +
    farm_z_depl_transportation_feed +
    farm_z_depl_medicine_used +
    farm_z_depl_direct_labor +
    farm_z_depl_farm_overhead +
    farm_z_depl_repair_maintenance +
    farm_z_depl_depreciation) AS persen_depletion_of_flockgrowing_cost,

    (farm_z_depl_cost_doc_breeder_year +
    farm_z_depl_transportation_doc_year +
    farm_z_depl_feed_used_year +
    farm_z_depl_transportation_feed_year +
    farm_z_depl_medicine_used_year +
    farm_z_depl_direct_labor_year +
    farm_z_depl_farm_overhead_year +
    farm_z_depl_repair_maintenance_year +
    farm_z_depl_depreciation_year) AS persen_depletion_of_flockgrowing_cost_ytd,

    1 AS penanda_data

    FROM
    (
    SELECT
    0 AS farm_z_fp_feed_used ,
    0 AS  farm_z_fp_transportation_feed,
    0 AS farm_z_fp_vaccine_medicine_used,
    0 AS farm_z_fp_direct_labor,
    0 AS farm_z_fp_farm_overhead,
    0 AS  farm_z_fp_repair_maintenance,
    0 AS  farm_z_fp_depreciation,
    0 AS  farm_z_depl_cost_doc_breeder,
    0 AS  farm_z_depl_transportation_doc,
    0 AS  farm_z_depl_feed_used,
    0 AS farm_z_depl_transportation_feed ,
    0 AS  farm_z_depl_medicine_used,
    0 AS  farm_z_depl_direct_labor,
    0 AS  farm_z_depl_farm_overhead,
    0 AS farm_z_depl_repair_maintenance ,
    0 AS farm_z_depl_depreciation ,
    0 AS farm_z_Total_Qty_to_produce_EGGS ,
    0 AS farm_z_Cost_produce_Eggs ,
    0 AS farm_z_qty_non_he ,
    0 AS farm_z_income_from_non_he ,
    0 AS farm_z_qty_produce_he ,
    0 AS farm_z_cost_produce_he ,
    0 AS farm_z_qty_he_inventory_farm_begin ,
    0 AS farm_z_he_inventory_farm_begin ,
    0 AS farm_z_qty_he_from_farm ,
    0 AS farm_z_cost_he_from_farm ,
    0 AS farm_z_qty_he_available_farm ,
    0 AS farm_z_he_available_in_farm ,
    0 AS farm_z_qty_he_sales_to_affiliate ,
    0 AS farm_z_he_sales_to_affiliate ,
    0 AS farm_z_qty_he_ing_bef_transfer ,
    0 AS farm_z_he_ing_bef_transfer_out ,
    0 AS farm_z_qty_he_used_transfer_out ,
    0 AS farm_z_he_used_transfer_out ,
    0 AS farm_z_qty_he_ing_farm ,
    0 AS farm_z_he_ing_farm ,
    0 AS farm_z_qty ,
    0 AS farm_z_sales_he,


    COALESCE(SUM(COALESCE(z_fp_feed_used_year,0)),0) AS farm_z_fp_feed_used_year ,
    COALESCE(SUM(COALESCE(z_fp_transportation_feed_year,0)),0) AS farm_z_fp_transportation_feed_year ,
    COALESCE(SUM(COALESCE(z_fp_vaccine_medicine_used_year,0)),0) AS farm_z_fp_vaccine_medicine_used_year ,
    COALESCE(SUM(COALESCE(z_fp_direct_labor_year,0)),0) AS farm_z_fp_direct_labor_year ,
    COALESCE(SUM(COALESCE(z_fp_farm_overhead_year,0)),0) AS farm_z_fp_farm_overhead_year ,
    COALESCE(SUM(COALESCE(z_fp_repair_maintenance_year,0)),0) AS farm_z_fp_repair_maintenance_year ,
    COALESCE(SUM(COALESCE(z_fp_depreciation_year,0)),0) AS farm_z_fp_depreciation_year ,
    COALESCE(SUM(COALESCE(z_depl_cost_doc_breeder_year,0)),0) AS farm_z_depl_cost_doc_breeder_year ,
    COALESCE(SUM(COALESCE(z_depl_transportation_doc_year,0)),0) AS farm_z_depl_transportation_doc_year ,
    COALESCE(SUM(COALESCE(z_depl_feed_used_year,0)),0) AS farm_z_depl_feed_used_year ,
    COALESCE(SUM(COALESCE(z_depl_transportation_feed_year,0)),0) AS farm_z_depl_transportation_feed_year ,
    COALESCE(SUM(COALESCE(z_depl_medicine_used_year,0)),0) AS farm_z_depl_medicine_used_year ,
    COALESCE(SUM(COALESCE(z_depl_direct_labor_year,0)),0) AS farm_z_depl_direct_labor_year ,
    COALESCE(SUM(COALESCE(z_depl_farm_overhead_year,0)),0) AS farm_z_depl_farm_overhead_year ,
    COALESCE(SUM(COALESCE(z_depl_repair_maintenance_year,0)),0) AS farm_z_depl_repair_maintenance_year ,
    COALESCE(SUM(COALESCE(z_depl_depreciation_year,0)),0) AS farm_z_depl_depreciation_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_yearx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_year,0)) END,0)
    AS farm_z_Total_Qty_to_produce_EGGS_year ,

    COALESCE(SUM(COALESCE(z_Cost_produce_Eggs_year,0)),0) AS farm_z_Cost_produce_Eggs_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he_year,0))*-1) END,0)
    AS farm_z_qty_non_he_year ,

    COALESCE((SUM(COALESCE(z_income_from_non_he_year,0))*-1),0) AS farm_z_income_from_non_he_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_he_yearx,0))
    ELSE SUM(COALESCE(z_qty_produce_he_year,0)) END,0)
    AS farm_z_qty_produce_he_year ,

    COALESCE(SUM(COALESCE(z_cost_produce_he_year,0)),0) AS farm_z_cost_produce_he_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_year,0)) END,0)
    AS farm_z_qty_he_inventory_farm_begin_year ,

    COALESCE(SUM(COALESCE(z_he_inventory_farm_begin_year,0)),0) AS farm_z_he_inventory_farm_begin_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm_year,0)) END,0)
    AS farm_z_qty_he_from_farm_year ,

    COALESCE(SUM(COALESCE(z_cost_he_from_farm_year,0)),0) AS farm_z_cost_he_from_farm_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm_year,0)) END,0)
    AS farm_z_qty_he_available_farm_year ,

    COALESCE(SUM(COALESCE(z_he_available_in_farm_year,0)),0) AS farm_z_he_available_in_farm_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_year,0))*-1) END,0)
    AS farm_z_qty_he_sales_to_affiliate_year ,

    COALESCE((SUM(COALESCE(z_he_sales_to_affiliate_year,0))*-1),0) AS farm_z_he_sales_to_affiliate_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_year,0))*-1) END,0)
    AS farm_z_qty_he_ending_bef_transfer_year ,

    COALESCE((SUM(COALESCE(z_he_used_transfer_out_year,0))*-1),0) AS farm_z_he_ending_bef_transfer_out_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_year,0))*-1) END,0)
    AS farm_z_qty_he_used_transfer_out_year ,

    COALESCE((SUM(COALESCE(z_he_used_transfer_out_year,0))*-1),0) AS farm_z_he_used_transfer_out_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_farm_year,0)) END,0)
    AS farm_z_qty_he_ending_farm_year ,

    COALESCE(SUM(COALESCE(z_he_ending_farm_year,0)),0) AS farm_z_he_ending_farm_year ,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_yearx,0))
    ELSE SUM(COALESCE(z_qty_year,0)) END,0)
    AS farm_z_qty_year ,

    COALESCE(SUM(COALESCE(z_sales_he_year,0)),0) AS farm_z_sales_he_year,

    ----------------------------------------------------------------------------------------------------------------

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_inventory_farm_begin_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_inventory_farm_begin_year,0)) END,0)
    AS farm_z_qty_he_inventory_farm_begin_h1_year  ,

    COALESCE(SUM(COALESCE(z_he_inventory_farm_begin_year,0)),0) AS farm_z_he_inventory_farm_begin_h1_year ,
    COALESCE(SUM(COALESCE(z_qty_he_ending_farm_year,0)),0) AS farm_z_qty_he_ending_farm_h1_year ,
    COALESCE(SUM(COALESCE(z_he_ending_farm_year,0)),0) AS farm_z_he_ending_farm_h1_year,
    COALESCE(SUM(COALESCE(z_fp_feed_used_year,0)),0) as farm_z_fp_feed_used_h1_year,
    COALESCE(SUM(COALESCE(z_fp_transportation_feed_year,0)),0) as farm_z_fp_transportation_feed_h1_year,
    COALESCE(SUM(COALESCE(z_fp_vaccine_medicine_used_year,0)),0) as farm_z_fp_vaccine_medicine_used_h1_year,
    COALESCE(SUM(COALESCE(z_fp_direct_labor_year,0)),0) as farm_z_fp_direct_labor_h1_year,
    COALESCE(SUM(COALESCE(z_fp_farm_overhead_year,0)),0) as farm_z_fp_farm_overhead_h1_year,
    COALESCE(SUM(COALESCE(z_fp_repair_maintenance_year,0)),0) as farm_z_fp_repair_maintenance_h1_year,
    COALESCE(SUM(COALESCE(z_fp_depreciation_year,0)),0) as farm_z_fp_depreciation_h1_year,
    COALESCE(SUM(COALESCE(z_depl_cost_doc_breeder_year,0)),0) as farm_z_depl_cost_doc_breeder_h1_year,
    COALESCE(SUM(COALESCE(z_depl_transportation_doc_year,0)),0) as farm_z_depl_transportation_doc_h1_year,
    COALESCE(SUM(COALESCE(z_depl_feed_used_year,0)),0) as farm_z_depl_feed_used_h1_year,
    COALESCE(SUM(COALESCE(z_depl_transportation_feed_year,0)),0) as farm_z_depl_transportation_feed_h1_year,
    COALESCE(SUM(COALESCE(z_depl_medicine_used_year,0)),0) as farm_z_depl_medicine_used_h1_year,
    COALESCE(SUM(COALESCE(z_depl_direct_labor_year,0)),0) as farm_z_depl_direct_labor_h1_year,
    COALESCE(SUM(COALESCE(z_depl_farm_overhead_year,0)),0) as farm_z_depl_farm_overhead_h1_year,
    COALESCE(SUM(COALESCE(z_depl_repair_maintenance_year,0)),0) as farm_z_depl_repair_maintenance_h1_year,
    COALESCE(SUM(COALESCE(z_depl_depreciation_year,0)),0) as farm_z_depl_depreciation_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_Total_Qty_to_produce_EGGS_yearx,0))
    ELSE SUM(COALESCE(z_Total_Qty_to_produce_EGGS_year,0)) END,0)
    as farm_z_Total_Qty_to_produce_EGGS_h1_year,

    COALESCE(SUM(COALESCE(z_Cost_produce_Eggs_year,0)),0) as farm_z_Cost_produce_Eggs_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_non_he_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_non_he_year,0))*-1) END,0)
    as farm_z_qty_non_he_h1_year,

    COALESCE((SUM(COALESCE(z_income_from_non_he_year,0))*-1),0) as farm_z_income_from_non_he_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_produce_he_yearx,0))
    ELSE SUM(COALESCE(z_qty_produce_he_year,0)) END,0)
    as farm_z_qty_produce_he_h1_year,

    COALESCE(SUM(COALESCE(z_cost_produce_he_year,0)),0) as farm_z_cost_produce_he_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_from_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_from_farm_year,0)) END,0)
    as farm_z_qty_he_from_farm_h1_year,

    COALESCE(SUM(COALESCE(z_cost_he_from_farm_year,0)),0) as farm_z_cost_he_from_farm_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_available_farm_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_available_farm_year,0)) END,0)
    as farm_z_qty_he_available_farm_h1_year,

    COALESCE(SUM(COALESCE(z_he_available_in_farm_year,0)),0) as farm_z_he_available_in_farm_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_sales_to_affiliate_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_sales_to_affiliate_year,0))*-1) END,0)
    as farm_z_qty_he_sales_to_affiliate_h1_year,

    COALESCE((SUM(COALESCE(z_he_sales_to_affiliate_year,0))*-1),0) as farm_z_he_sales_to_affiliate_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_he_ending_bef_transfer_yearx,0))
    ELSE SUM(COALESCE(z_qty_he_ending_bef_transfer_year,0)) END,0)
    as farm_z_qty_he_ending_bef_transfer_h1_year,

    COALESCE(SUM(COALESCE(z_he_ending_bef_transfer_out_year,0)),0) as farm_z_he_ending_bef_transfer_out_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN (SUM(COALESCE(z_qty_he_used_transfer_out_yearx,0))*-1)
    ELSE (SUM(COALESCE(z_qty_he_used_transfer_out_year,0))*-1) END,0)
    as farm_z_qty_he_used_transfer_out_h1_year,

    COALESCE((SUM(COALESCE(z_he_used_transfer_out_year,0))*-1),0) as farm_z_he_used_transfer_out_h1_year,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_yearx,0))
    ELSE SUM(COALESCE(z_qty_year,0)) END,0)
    AS farm_z_qty_h1_year,

    COALESCE(SUM(COALESCE(z_sales_he_year,0)),0) AS farm_z_sales_he_h1_year,

    0 AS qty_he_trf_to_br_13 ,
    0 AS he_trf_to_br_13,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_yearx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br_year,0)) *-1 END,0)
    as qty_he_trf_to_br_year_13,

    COALESCE(SUM(COALESCE(he_trf_to_br_year,0)),0) *-1 as he_trf_to_br_year_13,

    COALESCE(CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(qty_he_trf_to_br_yearx,0)) *-1
    ELSE SUM(COALESCE(qty_he_trf_to_br_year,0)) *-1 END,0)
    as qty_he_trf_to_br_h1_year_13,

    COALESCE(SUM(COALESCE(he_trf_to_br_year,0)) *-1,0) as he_trf_to_br_h1_year_13,
    0 as cost_trf_he_to_br_13,
    0 as cost_trf_he_to_br_year_13,
    COALESCE(SUM(COALESCE(cost_trf_he_to_br_year,0)),0) as cost_trf_he_to_br_h1_year_13,

    0 AS z_cost_transfer_variance,
    0 AS z_cost_transfer_variance_year,
    COALESCE(SUM(COALESCE(z_cost_transfer_variance_year,0)),0) AS z_cost_transfer_variance_h1_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_hex,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he,0)) *-1 END
    AS z_qty_adjustment_he,

    sum(COALESCE(z_adjustment_he,0))*-1 AS z_adjustment_he,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_yearx,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he_year,0)) *-1 END
    AS z_qty_adjustment_he_year,

    sum(COALESCE(z_adjustment_he_year,0))*-1 AS z_adjustment_he_year,

    CASE WHEN ($P{SexLine} IS NULL AND $P{Breed} IS NULL AND $P{BranchType} = 'GP') THEN SUM(COALESCE(z_qty_adjustment_he_h1_yearx,0)) *-1
    ELSE SUM(COALESCE(z_qty_adjustment_he_h1_year,0)) *-1 END
    AS z_qty_adjustment_he_h1_year,

    sum(COALESCE(z_adjustment_he_h1_year,0))*-1 AS z_adjustment_he_h1_year

    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},
            (SELECT tab.c_period_id
                FROM
                (
                    SELECT DISTINCT zccf.c_period_id

                    ,ao.ad_org_id
                    ,zccf.branchtype
                    ,zccf.categoryname
                    ,zccf.breed
                    ,zccf.sexline

                    FROM z_cost_calc_farm_cpjf zccf
                    INNER JOIN adempiere.ad_org ao ON ao.description = zccf.z_farm_code -- z_unit
                    WHERE zccf.ad_client_id = $P{AD_Client_ID} AND zccf.ad_org_id = $P{AD_Org_ID}
                    AND ($P{z_unit_ID} is null or ao.ad_org_id = $P{z_unit_ID})
                        AND (CASE WHEN $P{BranchType} IS NOT NULL THEN zccf.branchtype = $P{BranchType} ELSE 1=1 END)
                        AND (CASE WHEN $P{CategoryName} IS NOT NULL THEN zccf.categoryname = $P{CategoryName} ELSE 1=1 END)
                        AND (CASE WHEN $P{Breed} IS NOT NULL THEN left(zccf.breed,4) = $P{Breed} ELSE 1=1 END)
                        AND (CASE WHEN $P{SexLine} IS NOT NULL THEN zccf.sexline = $P{SexLine} ELSE 1=1 END)
                        AND $P{Trading} = 'N'
                        AND $P{Layer} = 'N'
                        AND $P{Bpsold} = 'N'

                    ORDER BY branchtype,categoryname,breed,sexline

                )tab
                ORDER BY c_period_id DESC LIMIT 1)::integer,
                $P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}
      )
    WHERE
    $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND (SELECT z_fp_feed_used
        FROM adempiere.z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}) -- di union 1 farm NULL
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        LIMIT 1) IS NULL
    )farm_bulan_lalu
    CROSS JOIN
    (
    SELECT

        0  AS  hatchery_z_qty_he_beginning_hatchery,
        0  AS  hatchery_z_he_beginning_hatchery,
        0  AS hatchery_z_qty_he_transfer_farm_bef_gr,
        0  AS hatchery_z_he_transfer_farm_bef_gr,
        0  AS hatchery_z_qty_add_he_transfer_from_br,
        0  AS hatchery_z_add_he_transfer_from_br,
        0  AS hatchery_z_qty_he_purchase_affiliate_co,
        0  AS hatchery_z_he_purchase_affiliate_co,
        0  AS hatchery_z_transportation_he,
        0  AS hatchery_z_qty_he_available_gr_process,
        0  AS hatchery_z_he_available_to_gr_process,
        0  AS hatchery_z_qty_non_he_sold,
        0  AS hatchery_z_non_he_sold,
        0  AS hatchery_z_qty_non_he_csr,
        0  AS hatchery_z_non_he_csr,
        0  AS hatchery_z_qty_he_avail_to_produce_doc,
        0  AS hatchery_z_he_available_to_produce_doc,
        0  AS hatchery_z_qty_he_used_to_hatch_process,
        0  AS hatchery_cost_of_he_put_into_hatcher,
        0  AS hatchery_z_he_used_to_hatching_process,
        0  AS hatchery_z_qty_he_used_to_destroy,
        0  AS hatchery_z_he_used_to_destroy,
        0  AS hatchery_z_qty_he_invent_hatchery_end,
        0  AS hatchery_z_he_inventory_hatchery_ending,
        0  AS hatchery_z_income_from_non_he,

        0  AS hatchery_z_hc_cost_of_he_put_in_hatcher,

        0  AS hatchery_z_hc_feed,
        0  AS hatchery_z_hc_vaccine_for_broiler,
        0  AS hatchery_z_hc_hatchery_overhead,
        0  AS hatchery_z_hc_repair_maintenance,
        0  AS hatchery_z_hc_depreciation,
        0  AS hatchery_z_hc_boxes_used,
        0   AS hatchery_z_income_from_male,
        0 AS hatchery_z_qty_income_from_male,

        0   AS hatchery_z_income_from_infertile_eggs,
        0   AS hatchery_z_dead_in_shell,
        0   AS hatchery_z_loss,
        0  AS hatchery_z_qty_to_produce_doc,

        0 AS hatchery_z_amount_to_produce_doc,

        0   AS hatchery_z_qty_doc_culled,
        0   AS hatchery_z_qty_doc_killed,
        0   AS hatchery_z_qty_doc_extra_toleransi,
        0  AS hatchery_z_qty_doc_available_for_sales,

        0  AS hatchery_z_amount_doc_avail_for_sales,

        0  AS hatchery_z_deductqtytfdodtocomfarm,
        0  AS hatchery_z_deductcosttfdodtocomfarm,
        0  AS hatchery_z_add_qty_begiining_doc,
        0  AS hatchery_z_add_begiining_doc,
        0  AS hatchery_z_deduct_qty_ending_doc,
        0  AS hatchery_z_deduct_ending_doc,
        0  AS hatchery_z_total_qty_cost_trans_to_br,
        0  AS hatchery_z_total_cost_transf_branch_rf,
        0  AS hatchery_z_qty_total_cost_of_sales,

        0 AS hatchery_z_total_cost_of_sales,

        0  AS  hatchery_z_qty_he_beginning_hatchery_year,
        0  AS  hatchery_z_he_beginning_hatchery_year,
        0  AS hatchery_z_qty_he_transfer_farm_bef_gr_year,
        0  AS hatchery_z_he_transfer_farm_bef_gr_year,
        0  AS hatchery_z_qty_add_he_transfer_from_br_year,
        0  AS hatchery_z_add_he_transfer_from_br_year,
        0  AS hatchery_z_qty_he_purchase_affiliate_co_year,
        0  AS hatchery_z_he_purchase_affiliate_co_year,
        0  AS hatchery_z_transportation_he_year,
        0  AS hatchery_z_qty_he_available_gr_process_year,
        0  AS hatchery_z_he_available_to_gr_process_year,
        0  AS hatchery_z_qty_non_he_sold_year,
        0  AS hatchery_z_non_he_sold_year,
        0  AS hatchery_z_qty_non_he_csr_year,
        0  AS hatchery_z_non_he_csr_year,
        0  AS hatchery_z_qty_he_avail_to_produce_doc_year,
        0  AS hatchery_z_he_available_to_produce_doc_year,
        0  AS hatchery_z_qty_he_used_to_hatch_process_year,
        0  AS hatchery_z_he_used_to_hatching_process_year,
        0  AS hatchery_z_qty_he_used_to_destroy_year,
        0  AS hatchery_z_he_used_to_destroy_year,
        0  AS hatchery_z_qty_he_invent_hatchery_end_year,
        0  AS hatchery_z_he_inventory_hatchery_ending_year,
        0  AS hatchery_z_income_from_non_he_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_hc_cost_of_he_put_in_hatcher_year,

        0  AS hatchery_z_hc_feed_year,
        0  AS hatchery_z_hc_vaccine_for_broiler_year,
        0  AS hatchery_z_hc_hatchery_overhead_year,
        0  AS hatchery_z_hc_repair_maintenance_year,
        0  AS hatchery_z_hc_depreciation_year,
        0  AS hatchery_z_hc_boxes_used_year,
        0  AS hatchery_z_income_from_male_year,

        0
        AS hatchery_z_qty_income_from_male_year,

        0  AS hatchery_z_income_from_infertile_eggs_year,
        0  AS hatchery_z_dead_in_shell_year,
        0  AS hatchery_z_loss_year,
        0  AS hatchery_z_qty_to_produce_doc_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_amount_to_produce_doc_year,

        0  AS hatchery_z_qty_doc_culled_year,
        0  AS hatchery_z_qty_doc_killed_year,
        0  AS hatchery_z_qty_doc_extra_toleransi_year,
        0  AS hatchery_z_qty_doc_available_for_sales_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_amount_doc_avail_for_sales_year,

        0  AS hatchery_z_deductqtytfdodtocomfarm_year,
        0  AS hatchery_z_deductcosttfdodtocomfarm_year,
        0  AS hatchery_z_add_qty_begiining_doc_year,
        0  AS hatchery_z_add_begiining_doc_year,
        0  AS hatchery_z_deduct_qty_ending_doc_year,
        0  AS hatchery_z_deduct_ending_doc_year,
        0  AS hatchery_z_total_qty_cost_trans_to_br_year,
        0  AS hatchery_z_total_cost_transf_branch_rf_year,
        0  AS hatchery_z_qty_total_cost_of_sales_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_total_cost_of_sales_year,

        0  AS  hatchery_z_qty_he_beginning_hatchery_h1_year,
        0  AS  hatchery_z_he_beginning_hatchery_h1_year,
        0  AS hatchery_z_qty_he_transfer_farm_bef_gr_h1_year,
        0  AS hatchery_z_he_transfer_farm_bef_gr_h1_year,
        0  AS hatchery_z_qty_add_he_transfer_from_br_h1_year,
        0  AS hatchery_z_add_he_transfer_from_br_h1_year,
        0  AS hatchery_z_qty_he_purchase_affiliate_co_h1_year,
        0  AS hatchery_z_he_purchase_affiliate_co_h1_year,
        0  AS hatchery_z_transportation_he_h1_year,
        0  AS hatchery_z_qty_he_available_gr_process_h1_year,
        0  AS hatchery_z_he_available_to_gr_process_h1_year,
        0  AS hatchery_z_qty_non_he_sold_h1_year,
        0  AS hatchery_z_non_he_sold_h1_year,
        0  AS hatchery_z_qty_non_he_csr_h1_year,
        0  AS hatchery_z_non_he_csr_h1_year,
        0  AS hatchery_z_qty_he_avail_to_produce_doc_h1_year,
        0  AS hatchery_z_he_available_to_produce_doc_h1_year,
        0  AS hatchery_z_qty_he_used_to_hatch_process_h1_year,
        0  AS hatchery_z_he_used_to_hatching_process_h1_year,
        0  AS hatchery_z_qty_he_used_to_destroy_h1_year,
        0  AS hatchery_z_he_used_to_destroy_h1_year,
        0  AS hatchery_z_qty_he_invent_hatchery_end_h1_year,
        0  AS hatchery_z_he_inventory_hatchery_ending_h1_year,
        0  AS hatchery_z_income_from_non_he_h1_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_hc_cost_of_he_put_in_hatcher_h1_year,

        0  AS hatchery_z_hc_feed_h1_year,
        0  AS hatchery_z_hc_vaccine_for_broiler_h1_year,
        0  AS hatchery_z_hc_hatchery_overhead_h1_year,
        0  AS hatchery_z_hc_repair_maintenance_h1_year,
        0  AS hatchery_z_hc_depreciation_h1_year,
        0  AS hatchery_z_hc_boxes_used_h1_year,
        0  AS hatchery_z_income_from_male_h1_year,

        0
        AS hatchery_z_qty_income_from_male_h1_year,

        0  AS hatchery_z_income_from_infertile_eggs_h1_year,
        0  AS hatchery_z_dead_in_shell_h1_year,
        0  AS hatchery_z_loss_h1_year,
        0  AS hatchery_z_qty_to_produce_doc_h1_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_amount_to_produce_doc_h1_year,

        0  AS hatchery_z_qty_doc_culled_h1_year,
        0  AS hatchery_z_qty_doc_killed_h1_year,
        0  AS hatchery_z_qty_doc_extra_toleransi_h1_year,
        0  AS hatchery_z_qty_doc_available_for_sales_h1_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_amount_doc_avail_for_sales_h1_year,

        0  AS hatchery_z_deductqtytfdodtocomfarm_h1_year,
        0  AS hatchery_z_deductcosttfdodtocomfarm_h1_year,
        0  AS hatchery_z_add_qty_begiining_doc_h1_year,
        0  AS hatchery_z_add_begiining_doc_h1_year,
        0  AS hatchery_z_deduct_qty_ending_doc_h1_year,
        0  AS hatchery_z_deduct_ending_doc_h1_year,
        0  AS hatchery_z_total_qty_cost_trans_to_br_h1_year,
        0  AS hatchery_z_total_cost_transf_branch_rf_h1_year,
        0  AS hatchery_z_qty_total_cost_of_sales_h1_year,

        SUM(
        (COALESCE(he_trf_to_br_year,0) ) + COALESCE(z_he_sales_to_affiliate_year,0) - COALESCE(cost_trf_he_to_br_year,0) - COALESCE(z_sales_he_year,0)
        )  AS hatchery_z_total_cost_of_sales_h1_year,

        0 AS hatchery_z_salable_chick,
        0 AS hatchery_z_hatchability,
        0  AS qty_he_trf_to_br,
        0  AS qty_he_trf_to_br_year,
        0  AS qty_he_trf_to_br_h1_year,
        0  AS he_trf_to_br,
        0  AS he_trf_to_br_year,
        0  AS he_trf_to_br_h1_year,
        0  AS qty_he_sales_to_aff,
        0  AS qty_he_sales_to_aff_year,
        0  AS qty_he_sales_to_aff_h1_year,
        0  AS he_sales_to_aff,
        0  AS he_sales_to_aff_year,
        0  AS he_sales_to_aff_h1_year,
        0  AS cost_trf_he_to_br,
        0  AS cost_trf_he_to_br_year,
        0  AS cost_trf_he_to_br_h1_year,
        0  AS sales_he_to_affiliate,
        0  AS sales_he_to_affiliate_year,
        0  AS sales_he_to_affiliate_h1_year,
        0   AS deductqtytfdodtofarmbreed,
        0  AS deductqtytfdodtofarmbreed_year,
        0  AS deductqtytfdodtofarmbreed_h1_year,
        0  AS deductcosttfdodtofarmbreed,
        0  AS deductcosttfdodtofarmbreed_year,
        0  AS deductcosttfdodtofarmbreed_h1_year,

        0 AS qtymoveinouthehatch,
        0 AS  amountmoveinouthehatch,
        0 AS  qtymoveinouthehatch_year,
        0 AS  amountmoveinouthehatch_year,
        0 AS  qtymoveinouthehatch_h1_year,
        0 AS  amountmoveinouthehatch_h1_year,


        0 AS qtyheAvailBefGradAfterMovehatc,
        0 AS heAvailBefGradAfterMovehatc,
        0 AS qtyheAvailBefGradAfterMovehatc_year,
        0 AS heAvailBefGradAfterMovehatc_year,
        0 AS qtyheAvailBefGradAfterMovehatc_h1_year,
        0 AS heAvailBefGradAfterMovehatc_h1_year,

        0 AS z_qty_he_avail_bfr_gr,
        0 AS z_qty_he_avail_bfr_gr_year,
        0 AS z_qty_he_avail_bfr_gr_h1_year,
        0 AS z_he_avail_bfr_gr,
        0 AS z_he_avail_bfr_gr_year,
        0 AS z_he_avail_bfr_gr_h1_year,

        0 AS z_incomefrominfertile_eggvalue,
        0 AS z_incomefrominfertile_eggvalue_year,
        0 AS z_incomefrominfertile_eggvalue_h1_year,

        0 AS z_qty_docsumbangan,
        0 AS z_qty_docsumbangan_year,
        0 AS z_qty_docsumbangan_h1_year


     FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},
            (SELECT tab.c_period_id
                FROM
                (
                    SELECT DISTINCT zccf.c_period_id

                    ,ao.ad_org_id
                    ,zccf.branchtype
                    ,zccf.categoryname
                    ,zccf.breed
                    ,zccf.sexline

                    FROM z_cost_calc_farm_cpjf zccf
                    INNER JOIN adempiere.ad_org ao ON ao.description = zccf.z_farm_code -- z_unit
                    WHERE zccf.ad_client_id = $P{AD_Client_ID} AND zccf.ad_org_id = $P{AD_Org_ID}
                    AND ($P{z_unit_ID} is null or ao.ad_org_id = $P{z_unit_ID})
                        AND (CASE WHEN $P{BranchType} IS NOT NULL THEN zccf.branchtype = $P{BranchType} ELSE 1=1 END)
                        AND (CASE WHEN $P{CategoryName} IS NOT NULL THEN zccf.categoryname = $P{CategoryName} ELSE 1=1 END)
                        AND (CASE WHEN $P{Breed} IS NOT NULL THEN left(zccf.breed,4) = $P{Breed} ELSE 1=1 END)
                        AND (CASE WHEN $P{SexLine} IS NOT NULL THEN zccf.sexline = $P{SexLine} ELSE 1=1 END)
                        AND $P{Trading} = 'N'
                        AND $P{Layer} = 'N'
                        AND $P{Bpsold} = 'N'

                    ORDER BY branchtype,categoryname,breed,sexline

                )tab
                ORDER BY c_period_id DESC LIMIT 1)::integer,
                $P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}
        )
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
        AND (SELECT z_fp_feed_used
        FROM adempiere.z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}) -- di union 1 farm NULL
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        LIMIT 1) IS NULL
     ) AS hatchery
)tabel
WHERE (SELECT z_fp_feed_used
        FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
        LIMIT 1) IS NULL
AND $P{Trading} = 'N'
AND $P{Layer} = 'N'
AND $P{Bpsold} = 'N'
AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
    (SELECT per.startdate FROM adempiere.z_costing_duck pgc
            INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
            WHERE pgc.ad_org_id = $P{AD_Org_ID}
            ORDER BY per.startdate ASC LIMIT 1
    )


UNION

SELECT *, 2 AS penanda_data, 6 orderkey
FROM
(
    SELECT
    NULL as periodname,
    NULL as orgname,
    NULL as unitname,
    '' AS brachtype,
    '' AS categoryname,
    '' breed,
    '' sexline,

    NULL::NUMERIC    AS farm_z_fp_feed_used ,                   NULL::NUMERIC    AS  farm_z_fp_transportation_feed,
    NULL::NUMERIC    AS farm_z_fp_vaccine_medicine_used,        NULL::NUMERIC    AS farm_z_fp_direct_labor,
    NULL::NUMERIC    AS farm_z_fp_farm_overhead,                NULL::NUMERIC    AS  farm_z_fp_repair_maintenance,
    NULL::NUMERIC    AS  farm_z_fp_depreciation,                NULL::NUMERIC    AS  farm_z_depl_cost_doc_breeder,
    NULL::NUMERIC    AS  farm_z_depl_transportation_doc,        NULL::NUMERIC    AS  farm_z_depl_feed_used,
    NULL::NUMERIC    AS farm_z_depl_transportation_feed ,       NULL::NUMERIC    AS  farm_z_depl_medicine_used,
    NULL::NUMERIC    AS  farm_z_depl_direct_labor,              NULL::NUMERIC    AS  farm_z_depl_farm_overhead,
    NULL::NUMERIC    AS farm_z_depl_repair_maintenance ,        NULL::NUMERIC    AS farm_z_depl_depreciation ,
    NULL::NUMERIC    AS farm_z_Total_Qty_to_produce_EGGS ,      NULL::NUMERIC    AS farm_z_Cost_produce_Eggs ,
    NULL::NUMERIC    AS farm_z_qty_non_he ,                     NULL::NUMERIC    AS farm_z_income_from_non_he ,
    NULL::NUMERIC    AS farm_z_qty_produce_he ,                 NULL::NUMERIC    AS farm_z_cost_produce_he ,
    NULL::NUMERIC    AS farm_z_qty_he_inventory_farm_begin ,    NULL::NUMERIC    AS farm_z_he_inventory_farm_begin ,
    NULL::NUMERIC    AS farm_z_qty_he_from_farm ,               NULL::NUMERIC    AS farm_z_cost_he_from_farm ,
    NULL::NUMERIC    AS farm_z_qty_he_available_farm ,          NULL::NUMERIC    AS farm_z_he_available_in_farm ,
    NULL::NUMERIC    AS farm_z_qty_he_sales_to_affiliate ,      NULL::NUMERIC    AS farm_z_he_sales_to_affiliate ,
    NULL::NUMERIC    AS farm_z_qty_he_ending_bef_transfer ,     NULL::NUMERIC    AS farm_z_he_ending_bef_transfer_out ,
    NULL::NUMERIC    AS farm_z_qty_he_used_transfer_out ,       NULL::NUMERIC    AS farm_z_he_used_transfer_out ,
    NULL::NUMERIC    AS farm_z_qty_he_ending_farm ,             NULL::NUMERIC    AS farm_z_he_ending_farm ,
    NULL::NUMERIC    AS farm_z_qty ,                            NULL::NUMERIC    AS farm_z_sales_he,
    NULL::NUMERIC    AS farm_z_fp_feed_used_year ,              NULL::NUMERIC    AS farm_z_fp_transportation_feed_year ,
    NULL::NUMERIC    AS farm_z_fp_vaccine_medicine_used_year ,  NULL::NUMERIC    AS farm_z_fp_direct_labor_year ,
    NULL::NUMERIC    AS farm_z_fp_farm_overhead_year ,          NULL::NUMERIC    AS farm_z_fp_repair_maintenance_year ,
    NULL::NUMERIC    AS farm_z_fp_depreciation_year ,           NULL::NUMERIC    AS farm_z_depl_cost_doc_breeder_year ,
    NULL::NUMERIC    AS farm_z_depl_transportation_doc_year ,   NULL::NUMERIC    AS farm_z_depl_feed_used_year ,
    NULL::NUMERIC    AS farm_z_depl_transportation_feed_year ,  NULL::NUMERIC    AS farm_z_depl_medicine_used_year ,
    NULL::NUMERIC    AS farm_z_depl_direct_labor_year ,         NULL::NUMERIC    AS farm_z_depl_farm_overhead_year ,
    NULL::NUMERIC    AS farm_z_depl_repair_maintenance_year ,   NULL::NUMERIC    AS farm_z_depl_depreciation_year ,
    NULL::NUMERIC    AS farm_z_Total_Qty_to_produce_EGGS_year , NULL::NUMERIC    AS farm_z_Cost_produce_Eggs_year ,
    NULL::NUMERIC    AS farm_z_qty_non_he_year ,                NULL::NUMERIC    AS farm_z_income_from_non_he_year ,
    NULL::NUMERIC    AS farm_z_qty_produce_he_year ,            NULL::NUMERIC    AS farm_z_cost_produce_he_year ,
    NULL::NUMERIC    AS farm_z_qty_he_inventory_farm_begin_year,NULL::NUMERIC    AS farm_z_he_inventory_farm_begin_year ,
    NULL::NUMERIC    AS farm_z_qty_he_from_farm_year ,          NULL::NUMERIC    AS farm_z_cost_he_from_farm_year ,
    NULL::NUMERIC    AS farm_z_qty_he_available_farm_year ,     NULL::NUMERIC    AS farm_z_he_available_in_farm_year ,
    NULL::NUMERIC    AS farm_z_qty_he_sales_to_affiliate_year , NULL::NUMERIC    AS farm_z_he_sales_to_affiliate_year ,
    NULL::NUMERIC    AS farm_z_qty_he_ending_bef_transfer_year ,NULL::NUMERIC    AS farm_z_he_ending_bef_transfer_out_year ,
    NULL::NUMERIC    AS farm_z_qty_he_used_transfer_out_year ,  NULL::NUMERIC    AS farm_z_he_used_transfer_out_year ,
    NULL::NUMERIC    AS farm_z_qty_he_ending_farm_year ,        NULL::NUMERIC    AS farm_z_he_ending_farm_year ,
    NULL::NUMERIC    AS farm_z_qty_year ,                       NULL::NUMERIC    AS farm_z_sales_he_year,
    NULL::NUMERIC    AS farm_z_qty_he_inventory_farm_begin_h1_year  ,NULL::NUMERIC    AS farm_z_he_inventory_farm_begin_h1_year ,
    NULL::NUMERIC    AS farm_z_qty_he_ending_farm_h1_year ,     NULL::NUMERIC    AS farm_z_he_ending_farm_h1_year,
    NULL::NUMERIC    as farm_z_fp_feed_used_h1_year,            NULL::NUMERIC    as farm_z_fp_transportation_feed_h1_year,
    NULL::NUMERIC    as farm_z_fp_vaccine_medicine_used_h1_year,NULL::NUMERIC    as farm_z_fp_direct_labor_h1_year,
    NULL::NUMERIC    as farm_z_fp_farm_overhead_h1_year,        NULL::NUMERIC    as farm_z_fp_repair_maintenance_h1_year,
    NULL::NUMERIC    as farm_z_fp_depreciation_h1_year,         NULL::NUMERIC    as farm_z_depl_cost_doc_breeder_h1_year,
    NULL::NUMERIC    as farm_z_depl_transportation_doc_h1_year, NULL::NUMERIC    as farm_z_depl_feed_used_h1_year,
    NULL::NUMERIC    as farm_z_depl_transportation_feed_h1_year,NULL::NUMERIC    as farm_z_depl_medicine_used_h1_year,
    NULL::NUMERIC    as farm_z_depl_direct_labor_h1_year,       NULL::NUMERIC    as farm_z_depl_farm_overhead_h1_year,
    NULL::NUMERIC    as farm_z_depl_repair_maintenance_h1_year, NULL::NUMERIC    as farm_z_depl_depreciation_h1_year,
    NULL::NUMERIC    as farm_z_Total_Qty_to_produce_EGGS_h1_year,NULL::NUMERIC    as farm_z_Cost_produce_Eggs_h1_year,
    NULL::NUMERIC    as farm_z_qty_non_he_h1_year,              NULL::NUMERIC    as farm_z_income_from_non_he_h1_year,
    NULL::NUMERIC    as farm_z_qty_produce_he_h1_year,          NULL::NUMERIC    as farm_z_cost_produce_he_h1_year,
    NULL::NUMERIC    as farm_z_qty_he_from_farm_h1_year,        NULL::NUMERIC    as farm_z_cost_he_from_farm_h1_year,
    NULL::NUMERIC    as farm_z_qty_he_available_farm_h1_year,   NULL::NUMERIC    as farm_z_he_available_in_farm_h1_year,
    NULL::NUMERIC    as farm_z_qty_he_sales_to_affiliate_h1_year,NULL::NUMERIC    as farm_z_he_sales_to_affiliate_h1_year,
    NULL::NUMERIC    as farm_z_qty_he_ending_bef_transfer_h1_year,NULL::NUMERIC    as farm_z_he_ending_bef_transfer_out_h1_year,
    NULL::NUMERIC    as farm_z_qty_he_used_transfer_out_h1_year,NULL::NUMERIC    as farm_z_he_used_transfer_out_h1_year,
    NULL::NUMERIC    AS farm_z_qty_h1_year,                     NULL::NUMERIC    AS farm_z_sales_he_h1_year,
    NULL::NUMERIC    AS persen_depletion_of_flockgrowing_cost,  NULL::NUMERIC    AS persen_depletion_of_flockgrowing_cost,

    NULL::NUMERIC  AS  hatchery_z_qty_he_beginning_hatchery,            NULL::NUMERIC  AS  hatchery_z_he_beginning_hatchery,
    NULL::NUMERIC  AS hatchery_z_qty_he_transfer_farm_bef_gr,           NULL::NUMERIC  AS hatchery_z_he_transfer_farm_bef_gr,
    NULL::NUMERIC  AS hatchery_z_qty_add_he_transfer_from_br,           NULL::NUMERIC  AS hatchery_z_add_he_transfer_from_br,
    NULL::NUMERIC  AS hatchery_z_qty_he_purchase_affiliate_co,          NULL::NUMERIC  AS hatchery_z_he_purchase_affiliate_co,
    NULL::NUMERIC  AS hatchery_z_transportation_he,                     NULL::NUMERIC  AS hatchery_z_qty_he_available_gr_process,
    NULL::NUMERIC  AS hatchery_z_he_available_to_gr_process,            NULL::NUMERIC  AS hatchery_z_qty_non_he_sold,
    NULL::NUMERIC  AS hatchery_z_non_he_sold,                           NULL::NUMERIC  AS hatchery_z_qty_non_he_csr,
    NULL::NUMERIC  AS hatchery_z_non_he_csr,                            NULL::NUMERIC  AS hatchery_z_qty_he_avail_to_produce_doc,
    NULL::NUMERIC  AS hatchery_z_he_available_to_produce_doc,           NULL::NUMERIC  AS hatchery_z_qty_he_used_to_hatch_process,
    NULL::NUMERIC hatchery_cost_of_he_put_into_hatcher,
    NULL::NUMERIC  AS hatchery_z_he_used_to_hatching_process,           NULL::NUMERIC  AS hatchery_z_qty_he_used_to_destroy,
    NULL::NUMERIC  AS hatchery_z_he_used_to_destroy,                    NULL::NUMERIC  AS hatchery_z_qty_he_invent_hatchery_end,
    NULL::NUMERIC  AS hatchery_z_he_inventory_hatchery_ending,          NULL::NUMERIC  AS hatchery_z_income_from_non_he,
    NULL::NUMERIC  AS hatchery_z_hc_cost_of_he_put_in_hatcher,          NULL::NUMERIC  AS hatchery_z_hc_feed,
    NULL::NUMERIC  AS hatchery_z_hc_vaccine_for_broiler,                NULL::NUMERIC  AS hatchery_z_hc_hatchery_overhead,
    NULL::NUMERIC  AS hatchery_z_hc_repair_maintenance,                 NULL::NUMERIC  AS hatchery_z_hc_depreciation,
    NULL::NUMERIC  AS hatchery_z_hc_boxes_used,                         NULL::NUMERIC  AS hatchery_z_income_from_male,
    NULL::NUMERIC  AS hatchery_z_qty_income_from_male,
    NULL::NUMERIC  AS hatchery_z_income_from_infertile_eggs,            NULL::NUMERIC  AS hatchery_z_dead_in_shell,
    NULL::NUMERIC  AS hatchery_z_loss,                                  NULL::NUMERIC  AS hatchery_z_qty_to_produce_doc,
    NULL::NUMERIC  AS hatchery_z_amount_to_produce_doc,                 NULL::NUMERIC  AS hatchery_z_qty_doc_culled,
    NULL::NUMERIC  AS hatchery_z_qty_doc_killed,                        NULL::NUMERIC  AS hatchery_z_qty_doc_extra_toleransi,
    NULL::NUMERIC  AS hatchery_z_qty_doc_available_for_sales,           NULL::NUMERIC  AS hatchery_z_amount_doc_avail_for_sales,
    NULL::NUMERIC  AS hatchery_z_deductqtytfdodtocomfarm,                  NULL::NUMERIC  AS hatchery_z_deductcosttfdodtocomfarm,
    NULL::NUMERIC  AS hatchery_z_add_qty_begiining_doc,                 NULL::NUMERIC  AS hatchery_z_add_begiining_doc,
    NULL::NUMERIC  AS hatchery_z_deduct_qty_ending_doc,                 NULL::NUMERIC  AS hatchery_z_deduct_ending_doc,
    NULL::NUMERIC  AS hatchery_z_total_qty_cost_trans_to_br,            NULL::NUMERIC  AS hatchery_z_total_cost_transf_branch_rf,
    NULL::NUMERIC  AS hatchery_z_qty_total_cost_of_sales,               NULL::NUMERIC  AS hatchery_z_total_cost_of_sales,
    NULL::NUMERIC  AS  hatchery_z_qty_he_beginning_hatchery_year,       NULL::NUMERIC  AS  hatchery_z_he_beginning_hatchery_year,
    NULL::NUMERIC  AS hatchery_z_qty_he_transfer_farm_bef_gr_year,      NULL::NUMERIC  AS hatchery_z_he_transfer_farm_bef_gr_year,
    NULL::NUMERIC  AS hatchery_z_qty_add_he_transfer_from_br_year,      NULL::NUMERIC  AS hatchery_z_add_he_transfer_from_br_year,
    NULL::NUMERIC  AS hatchery_z_qty_he_purchase_affiliate_co_year,     NULL::NUMERIC  AS hatchery_z_he_purchase_affiliate_co_year,
    NULL::NUMERIC  AS hatchery_z_transportation_he_year,                NULL::NUMERIC  AS hatchery_z_qty_he_available_gr_process_year,
    NULL::NUMERIC  AS hatchery_z_he_available_to_gr_process_year,       NULL::NUMERIC  AS hatchery_z_qty_non_he_sold_year,
    NULL::NUMERIC  AS hatchery_z_non_he_sold_year,                      NULL::NUMERIC  AS hatchery_z_qty_non_he_csr_year,
    NULL::NUMERIC  AS hatchery_z_non_he_csr_year,                       NULL::NUMERIC  AS hatchery_z_qty_he_avail_to_produce_doc_year,
    NULL::NUMERIC  AS hatchery_z_he_available_to_produce_doc_year,      NULL::NUMERIC  AS hatchery_z_qty_he_used_to_hatch_process_year,
    NULL::NUMERIC  AS hatchery_z_he_used_to_hatching_process_year,      NULL::NUMERIC  AS hatchery_z_qty_he_used_to_destroy_year,
    NULL::NUMERIC  AS hatchery_z_he_used_to_destroy_year,               NULL::NUMERIC  AS hatchery_z_qty_he_invent_hatchery_end_year,
    NULL::NUMERIC  AS hatchery_z_he_inventory_hatchery_ending_year,     NULL::NUMERIC  AS hatchery_z_income_from_non_he_year,
    NULL::NUMERIC  AS hatchery_z_hc_cost_of_he_put_in_hatcher_year,     NULL::NUMERIC  AS hatchery_z_hc_feed_year,
    NULL::NUMERIC  AS hatchery_z_hc_vaccine_for_broiler_year,           NULL::NUMERIC  AS hatchery_z_hc_hatchery_overhead_year,
    NULL::NUMERIC  AS hatchery_z_hc_repair_maintenance_year,            NULL::NUMERIC  AS hatchery_z_hc_depreciation_year,
    NULL::NUMERIC  AS hatchery_z_hc_boxes_used_year,                    NULL::NUMERIC  AS hatchery_z_income_from_male_year,
    NULL::NUMERIC  AS hatchery_z_qty_income_from_male_year,
    NULL::NUMERIC  AS hatchery_z_income_from_infertile_eggs_year,       NULL::NUMERIC  AS hatchery_z_dead_in_shell_year,
    NULL::NUMERIC  AS hatchery_z_loss_year,                             NULL::NUMERIC  AS hatchery_z_qty_to_produce_doc_year,
    NULL::NUMERIC  AS hatchery_z_amount_to_produce_doc_year,            NULL::NUMERIC  AS hatchery_z_qty_doc_culled_year,
    NULL::NUMERIC  AS hatchery_z_qty_doc_killed_year,                   NULL::NUMERIC  AS hatchery_z_qty_doc_extra_toleransi_year,
    NULL::NUMERIC  AS hatchery_z_qty_doc_available_for_sales_year,      NULL::NUMERIC  AS hatchery_z_amount_doc_avail_for_sales_year,
    NULL::NUMERIC  AS hatchery_z_deductqtytfdodtocomfarm_year,             NULL::NUMERIC  AS hatchery_z_deductcosttfdodtocomfarm_year,
    NULL::NUMERIC  AS hatchery_z_add_qty_begiining_doc_year,            NULL::NUMERIC  AS hatchery_z_add_begiining_doc_year,
    NULL::NUMERIC  AS hatchery_z_deduct_qty_ending_doc_year,            NULL::NUMERIC  AS hatchery_z_deduct_ending_doc_year,
    NULL::NUMERIC  AS hatchery_z_total_qty_cost_trans_to_br_year,       NULL::NUMERIC  AS hatchery_z_total_cost_transf_branch_rf_year,
    NULL::NUMERIC  AS hatchery_z_qty_total_cost_of_sales_year,          NULL::NUMERIC  AS hatchery_z_total_cost_of_sales_year,
    NULL::NUMERIC  AS  hatchery_z_qty_he_beginning_hatchery_h1_year,    NULL::NUMERIC  AS  hatchery_z_he_beginning_hatchery_h1_year,
    NULL::NUMERIC  AS hatchery_z_qty_he_transfer_farm_bef_gr_h1_year,   NULL::NUMERIC  AS hatchery_z_he_transfer_farm_bef_gr_h1_year,
    NULL::NUMERIC  AS hatchery_z_qty_add_he_transfer_from_br_h1_year,   NULL::NUMERIC  AS hatchery_z_add_he_transfer_from_br_h1_year,
    NULL::NUMERIC  AS hatchery_z_qty_he_purchase_affiliate_co_h1_year,  NULL::NUMERIC  AS hatchery_z_he_purchase_affiliate_co_h1_year,
    NULL::NUMERIC  AS hatchery_z_transportation_he_h1_year,             NULL::NUMERIC  AS hatchery_z_qty_he_available_gr_process_h1_year,
    NULL::NUMERIC  AS hatchery_z_he_available_to_gr_process_h1_year,    NULL::NUMERIC  AS hatchery_z_qty_non_he_sold_h1_year,
    NULL::NUMERIC  AS hatchery_z_non_he_sold_h1_year,                   NULL::NUMERIC  AS hatchery_z_qty_non_he_csr_h1_year,
    NULL::NUMERIC  AS hatchery_z_non_he_csr_h1_year,                    NULL::NUMERIC  AS hatchery_z_qty_he_avail_to_produce_doc_h1_year,
    NULL::NUMERIC  AS hatchery_z_he_available_to_produce_doc_h1_year,   NULL::NUMERIC  AS hatchery_z_qty_he_used_to_hatch_process_h1_year,
    NULL::NUMERIC  AS hatchery_z_he_used_to_hatching_process_h1_year,   NULL::NUMERIC  AS hatchery_z_qty_he_used_to_destroy_h1_year,
    NULL::NUMERIC  AS hatchery_z_he_used_to_destroy_h1_year,            NULL::NUMERIC  AS hatchery_z_qty_he_invent_hatchery_end_h1_year,
    NULL::NUMERIC  AS hatchery_z_he_inventory_hatchery_ending_h1_year,  NULL::NUMERIC  AS hatchery_z_income_from_non_he_h1_year,
    NULL::NUMERIC  AS hatchery_z_hc_cost_of_he_put_in_hatcher_h1_year,  NULL::NUMERIC  AS hatchery_z_hc_feed_h1_year,
    NULL::NUMERIC  AS hatchery_z_hc_vaccine_for_broiler_h1_year,        NULL::NUMERIC  AS hatchery_z_hc_hatchery_overhead_h1_year,
    NULL::NUMERIC  AS hatchery_z_hc_repair_maintenance_h1_year,         NULL::NUMERIC  AS hatchery_z_hc_depreciation_h1_year,
    NULL::NUMERIC  AS hatchery_z_hc_boxes_used_h1_year,                 NULL::NUMERIC  AS hatchery_z_income_from_male_h1_year,
    NULL::NUMERIC  AS hatchery_z_qty_income_from_male_h1_year,
    NULL::NUMERIC  AS hatchery_z_income_from_infertile_eggs_h1_year,    NULL::NUMERIC  AS hatchery_z_dead_in_shell_h1_year,
    NULL::NUMERIC  AS hatchery_z_loss_h1_year,                          NULL::NUMERIC  AS hatchery_z_qty_to_produce_doc_h1_year,
    NULL::NUMERIC  AS hatchery_z_amount_to_produce_doc_h1_year,         NULL::NUMERIC  AS hatchery_z_qty_doc_culled_h1_year,
    NULL::NUMERIC  AS hatchery_z_qty_doc_killed_h1_year,                NULL::NUMERIC  AS hatchery_z_qty_doc_extra_toleransi_h1_year,
    NULL::NUMERIC  AS hatchery_z_qty_doc_available_for_sales_h1_year,   NULL::NUMERIC  AS hatchery_z_amount_doc_avail_for_sales_h1_year,
    NULL::NUMERIC  AS hatchery_z_deductqtytfdodtocomfarm_h1_year,          NULL::NUMERIC  AS hatchery_z_deductcosttfdodtocomfarm_h1_year,
    NULL::NUMERIC  AS hatchery_z_add_qty_begiining_doc_h1_year,         NULL::NUMERIC  AS hatchery_z_add_begiining_doc_h1_year,
    NULL::NUMERIC  AS hatchery_z_deduct_qty_ending_doc_h1_year,         NULL::NUMERIC  AS hatchery_z_deduct_ending_doc_h1_year,
    NULL::NUMERIC  AS hatchery_z_total_qty_cost_trans_to_br_h1_year,    NULL::NUMERIC  AS hatchery_z_total_cost_transf_branch_rf_h1_year,
    NULL::NUMERIC  AS hatchery_z_qty_total_cost_of_sales_h1_year,       NULL::NUMERIC  AS hatchery_z_total_cost_of_sales_h1_year,
    NULL::NUMERIC  AS hatchery_z_salable_chick,                         NULL::NUMERIC  AS hatchery_z_hatchability,

    NULL::NUMERIC AS qty_he_trf_to_br,                                  NULL::NUMERIC AS he_trf_to_br,
    NULL::NUMERIC as qty_he_trf_to_br_year,                             NULL::NUMERIC as he_trf_to_br_year,
    NULL::NUMERIC as qty_he_trf_to_br_h1_year,                          NULL::NUMERIC as he_trf_to_br_h1_year,
    NULL::NUMERIC as cost_trf_he_to_br,                                 NULL::NUMERIC as cost_trf_he_to_br_year,
    NULL::NUMERIC as cost_trf_he_to_br_h1_year,

    NULL::NUMERIC AS qty_he_trf_to_br,                                   NULL::NUMERIC AS qty_he_trf_to_br_year,
    NULL::NUMERIC AS qty_he_trf_to_br_h1_year,                           NULL::NUMERIC AS he_trf_to_br,
    NULL::NUMERIC AS he_trf_to_br_year,                                  NULL::NUMERIC AS he_trf_to_br_year_h1_year,
    NULL::NUMERIC AS qty_he_sales_to_aff,                                NULL::NUMERIC AS qty_he_sales_to_aff_year,
    NULL::NUMERIC AS qty_he_sales_to_aff_h1_year,                        NULL::NUMERIC AS he_sales_to_aff,
    NULL::NUMERIC AS he_sales_to_aff_year,                               NULL::NUMERIC AS he_sales_to_aff_h1_year,
    NULL::NUMERIC AS cost_trf_he_to_br,                                  NULL::NUMERIC AS cost_trf_he_to_br_year,
    NULL::NUMERIC AS cost_trf_he_to_br_h1_year,                          NULL::NUMERIC AS sales_he_to_affiliate,
    NULL::NUMERIC AS sales_he_to_affiliate_year,                         NULL::NUMERIC AS sales_he_to_affiliate_h1_year,
    NULL::NUMERIC AS deductqtytfdodtofarmbreed,                            NULL::NUMERIC AS deductqtytfdodtofarmbreed_year,
    NULL::NUMERIC AS deductqtytfdodtofarmbreed_h1_year,                    NULL::NUMERIC AS deductcosttfdodtofarmbreed,
    NULL::NUMERIC AS deductcosttfdodtofarmbreed_year,                          NULL::NUMERIC AS deductcosttfdodtofarmbreed_h1_year,

    NULL::NUMERIC AS z_cost_transfer_variance,
    NULL::NUMERIC AS z_cost_transfer_variance_year,
    NULL::NUMERIC AS z_cost_transfer_variance_h1_year,

    NULL::NUMERIC AS z_qty_adjustment_he,
    NULL::NUMERIC AS z_adjustment_he,
    NULL::NUMERIC AS z_qty_adjustment_he_year,
    NULL::NUMERIC AS z_adjustment_he_year,
    NULL::NUMERIC AS z_qty_adjustment_he_h1_year,
    NULL::NUMERIC AS z_adjustment_he_h1_year,

    NULL::NUMERIC AS qtymoveinouthehatch,
    NULL::NUMERIC AS  amountmoveinouthehatch,
    NULL::NUMERIC AS  qtymoveinouthehatch_year,
    NULL::NUMERIC AS  amountmoveinouthehatch_year,
    NULL::NUMERIC AS  qtymoveinouthehatch_h1_year,
    NULL::NUMERIC AS  amountmoveinouthehatch_h1_year,


    NULL::NUMERIC AS qtyheAvailBefGradAfterMovehatc,
    NULL::NUMERIC AS heAvailBefGradAfterMovehatc,
    NULL::NUMERIC AS qtyheAvailBefGradAfterMovehatc_year,
    NULL::NUMERIC AS heAvailBefGradAfterMovehatc_year,
    NULL::NUMERIC AS qtyheAvailBefGradAfterMovehatc_h1_year,
    NULL::NUMERIC AS heAvailBefGradAfterMovehatc_h1_year,

    NULL::NUMERIC AS z_qty_he_avail_bfr_gr,
    NULL::NUMERIC AS z_qty_he_avail_bfr_gr_year,
    NULL::NUMERIC AS z_qty_he_avail_bfr_gr_h1_year,
    NULL::NUMERIC AS z_he_avail_bfr_gr,
    NULL::NUMERIC AS z_he_avail_bfr_gr_year,
    NULL::NUMERIC AS z_he_avail_bfr_gr_h1_year,

    NULL::NUMERIC AS z_incomefrominfertile_eggvalue,
    NULL::NUMERIC AS z_incomefrominfertile_eggvalue_year,
    NULL::NUMERIC AS z_incomefrominfertile_eggvalue_h1_year,

    NULL::NUMERIC AS z_qty_docsumbangan,
    NULL::NUMERIC AS z_qty_docsumbangan_year,
    NULL::NUMERIC AS z_qty_docsumbangan_h1_year

)tabel

WHERE
(SELECT COALESCE(z_qty,0) AS farm_z_qty
    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE
    $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
    (SELECT per.startdate FROM adempiere.z_costing_duck pgc
            INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
            WHERE pgc.ad_org_id = $P{AD_Org_ID}
            ORDER BY per.startdate ASC LIMIT 1
    )
UNION
SELECT COALESCE(z_qty_he_beginning_hatchery,0) AS hatchery_z_qty_he_beginning_hatchery
    FROM z_get_cost_calculation_hatchery_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND (SELECT SUM(COALESCE(z_fp_feed_used,0)) AS farm_z_fp_feed_used
        FROM adempiere.z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}) -- di crosjoin 1 NULL
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        LIMIT 1) IS NOT NULL
    AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
    (SELECT per.startdate FROM adempiere.z_costing_duck pgc
            INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
            WHERE pgc.ad_org_id = $P{AD_Org_ID}
            ORDER BY per.startdate ASC LIMIT 1
    )
UNION
SELECT COALESCE(z_qty,0) AS farm_z_qty
    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},(SELECT c_period_id FROM adempiere.c_period WHERE startdate = (SELECT startdate - INTERVAL '1 month' FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID})
                                                                            AND ad_org_id = $P{AD_Org_ID})::integer,$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE
    $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND (SELECT z_fp_feed_used FROM adempiere.z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}) -- di union 1 farm NULL
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        LIMIT 1) IS NULL
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
    (SELECT per.startdate FROM adempiere.z_costing_duck pgc
            INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
            WHERE pgc.ad_org_id = $P{AD_Org_ID}
            ORDER BY per.startdate ASC LIMIT 1
    )
UNION
SELECT COALESCE(z_qty_he_beginning_hatchery,0) AS hatchery_z_qty_he_beginning_hatchery
    FROM z_get_cost_calculation_hatchery_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
    (SELECT per.startdate FROM adempiere.z_costing_duck pgc
            INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
            WHERE pgc.ad_org_id = $P{AD_Org_ID}
            ORDER BY per.startdate ASC LIMIT 1
    )
UNION
SELECT 0 AS farm_z_qty
    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE $P{Trading} = 'Y'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
UNION
SELECT COALESCE(z_qty_he_beginning_hatchery,0)
    FROM z_get_cost_calculation_hatchery_duck_cpjf_trading($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID})
    WHERE $P{Trading} = 'Y'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
UNION
   SELECT 0 AS farm_z_qty
    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE $P{Layer} = 'Y'
    AND $P{Trading} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
UNION
    SELECT COALESCE(z_qty_he_beginning_hatchery,0)
    FROM z_get_cost_calculation_hatchery_duck_cpjf_pslayer($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID})
    WHERE $P{Layer} = 'Y'
    AND $P{Trading} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
UNION
    SELECT 0 AS farm_z_qty
    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},'GP','BROILER','FEMLN',$P{Breed})
    WHERE
    (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'Y'
UNION
SELECT COALESCE(z_qty_he_beginning_hatchery,0)
    FROM z_get_cost_calculation_hatchery_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},'GP','BROILER','FEMLN',$P{Breed})
    WHERE $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'Y'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) NOT IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
UNION
SELECT COALESCE(he_trf_to_br,0)
FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed})
    WHERE $P{Trading} = 'N'
    AND $P{Layer} = 'N'
    AND $P{Bpsold} = 'N'
    AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
    AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
    (SELECT per.startdate FROM adempiere.z_costing_duck pgc
            INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
            WHERE pgc.ad_org_id = $P{AD_Org_ID}
            ORDER BY per.startdate ASC LIMIT 1
    )
UNION
SELECT (
        (COALESCE(he_trf_to_br,0) *-1) + COALESCE(z_he_sales_to_affiliate,0) - COALESCE(cost_trf_he_to_br,0) - COALESCE(z_sales_he,0)
        ) AS hatchery_z_qty_he_beginning_hatchery
    FROM z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},
            (SELECT tab.c_period_id
                FROM
                (
                    SELECT DISTINCT zccf.c_period_id

                    ,ao.ad_org_id
                    ,zccf.branchtype
                    ,zccf.categoryname
                    ,zccf.breed
                    ,zccf.sexline

                    FROM z_cost_calc_farm_cpjf zccf
                    INNER JOIN adempiere.ad_org ao ON ao.description = zccf.z_farm_code -- z_unit
                    WHERE zccf.ad_client_id = $P{AD_Client_ID} AND zccf.ad_org_id = $P{AD_Org_ID}
                    AND ($P{z_unit_ID} is null or ao.ad_org_id = $P{z_unit_ID})
                        AND (CASE WHEN $P{BranchType} IS NOT NULL THEN zccf.branchtype = $P{BranchType} ELSE 1=1 END)
                        AND (CASE WHEN $P{CategoryName} IS NOT NULL THEN zccf.categoryname = $P{CategoryName} ELSE 1=1 END)
                        AND (CASE WHEN $P{Breed} IS NOT NULL THEN left(zccf.breed,4) = $P{Breed} ELSE 1=1 END)
                        AND (CASE WHEN $P{SexLine} IS NOT NULL THEN zccf.sexline = $P{SexLine} ELSE 1=1 END)
                        AND $P{Trading} = 'N'
                        AND $P{Layer} = 'N'
                        AND $P{Bpsold} = 'N'

                    ORDER BY branchtype,categoryname,breed,sexline

                )tab
                ORDER BY c_period_id DESC LIMIT 1)::integer,
                $P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}
        )
        WHERE
        $P{Trading} = 'N'
        AND $P{Layer} = 'N'
        AND $P{Bpsold} = 'N'
        AND (SELECT ad_org_id::TEXT||$P{CategoryName}::text FROM adempiere.ad_org WHERE ad_org_id = $P{AD_Org_ID}) IN (SELECT * FROM adempiere.z_get_identity_organisasi_cost_calc_new())
        AND (SELECT z_fp_feed_used
            FROM adempiere.z_get_cost_calculation_farm_duck_cpjf($P{AD_Client_ID},$P{AD_Org_ID},$P{C_Period_ID},$P{z_unit_ID},$P{BranchType},$P{CategoryName},$P{SexLine},$P{Breed}) -- di union 1 farm NULL
            WHERE
            $P{Trading} = 'N'
            AND $P{Layer} = 'N'
            AND $P{Bpsold} = 'N'
            LIMIT 1) IS NULL
        AND (SELECT startdate FROM adempiere.c_period WHERE c_period_id = $P{C_Period_ID}) >=
            (SELECT per.startdate FROM adempiere.z_costing_duck pgc
                    INNER JOIN adempiere.c_period per ON per.c_period_id = pgc.c_period_id
                    WHERE pgc.ad_org_id = $P{AD_Org_ID}
                    ORDER BY per.startdate ASC LIMIT 1
            )
LIMIT 1
) IS NULL

ORDER BY orderkey asc;