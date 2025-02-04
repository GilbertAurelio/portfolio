select

par.name AS c_bpartner_id,
farow.z_weekof,
scsow.value AS Z_Sow_ID,
mat.z_parity AS parity,
scboar.value AS z_boar_id,
farow.Z_DateOfBirth,
farow.Z_Total_Born_Loss,
farow.Z_Total_Qty_Alive,
farow.Z_Death,
farow.z_mummy,
farow.Z_Disabled,
farow.Z_Weak,
farow.Z_Male_Alive,
farow.Z_feMale_Alive,
farow.Z_Total_Weight_Kg,
farow.Z_Average_Weight_Kg,
farow.Z_ID_Anak_From,
farow.Z_ID_Anak_To,
sbl.breedname


FROM adempiere.z_daily_transaction dt
INNER JOIN adempiere.Z_Farrowing farow ON farow.z_daily_transaction_id = dt.z_daily_transaction_id
LEFT JOIN adempiere.c_bpartner par ON par.c_bpartner_id = dt.c_bpartner_id
LEFT JOIN adempiere.z_mating mat ON mat.z_mating_id = farow.z_mating_id
LEFT JOIN adempiere.z_swine_card scboar ON scboar.z_swine_card_id = farow.z_boar_id
LEFT JOIN adempiere.z_swine_card scsow ON scsow.z_swine_card_id = farow.z_sow_id
LEFT JOIN adempiere.c_project proj ON proj.c_project_id = farow.c_project_id
LEFT JOIN adempiere.z_swinebreedlist sbl ON sbl.z_swinebreedlist_id = proj.z_swinebreedlist_id


--WHERE dt.ad_client_id = client_idx AND dt.ad_org_id = org_idx
--AND (CASE WHEN bpartner_idx IS NOT NULL THEN dt.c_bpartner_id = bpartner_idx ELSE 1=1 END)
--AND (CASE WHEN weekofx IS NOT NULL THEN farow.z_weekof = weekofx ELSE 1=1 END)