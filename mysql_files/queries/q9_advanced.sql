WITH provider_charges AS (
	SELECT
		p.Rndrng_NPI,
		p.Rndrng_Prvdr_Last_Org_Name,
		a.Rndrng_Prvdr_City,
		a.Rndrng_Prvdr_State_Abrvtn AS state,
		st.Tot_Mdcr_Pymt_Amt,
		ds.Drug_Mdcr_Pymt_Amt,
		st.Tot_Srvcs,
		st.Year,
		((st.Tot_Sbmtd_Chrg - st.Tot_Mdcr_Pymt_Amt) / NULLIF(st.Tot_Sbmtd_Chrg, 0)) * 100 AS Service_Out_of_Pocket_Pct,
		((ds.Drug_Sbmtd_Chrg - ds.Drug_Mdcr_Pymt_Amt) / NULLIF(ds.Drug_Sbmtd_Chrg, 0)) * 100 AS Drug_Out_of_Pocket_Pct
	FROM service_totals st
	JOIN provider p ON st.Rndrng_NPI = p.Rndrng_NPI AND st.Year = p.Year
	JOIN provider_address a ON st.Rndrng_NPI = a.Rndrng_NPI
	LEFT JOIN drug_services ds ON st.Rndrng_NPI = ds.Rndrng_NPI AND st.Year = ds.Year
	WHERE st.Year IN (2019, 2023)
	LIMIT 1000000
),
comparing_providers_by_year AS (
	SELECT
		pc_2019.state,
		pc_2019.Rndrng_NPI,
		pc_2019.Rndrng_Prvdr_Last_Org_Name,
		pc_2019.Rndrng_Prvdr_City,
		ROUND(pc_2023.Service_Out_of_Pocket_Pct - pc_2019.Service_Out_of_Pocket_Pct, 3) AS Service_Out_of_Pocket_Pct_Change,
		ROUND(pc_2023.Drug_Out_of_Pocket_Pct - pc_2019.Drug_Out_of_Pocket_Pct, 3) AS Drug_Out_of_Pocket_Pct_Change
	FROM provider_charges pc_2019
	JOIN provider_charges pc_2023
	ON pc_2019.Rndrng_NPI = pc_2023.Rndrng_NPI
	AND pc_2019.state = pc_2023.state
	WHERE pc_2019.Year = 2019 AND pc_2023.Year = 2023
	AND pc_2019.Drug_Out_of_Pocket_Pct IS NOT NULL
	AND pc_2023.Drug_Out_of_Pocket_Pct IS NOT NULL
),
providers_by_state AS (
	SELECT
		state,
		COUNT(*) AS num_providers,
		ROUND(AVG(Service_Out_of_Pocket_Pct_Change), 2) AS avg_service_out_of_pocket_change,
		ROUND(AVG(Drug_Out_of_Pocket_Pct_Change), 2) AS avg_drug_out_of_pocket_change
	FROM comparing_providers_by_year
	WHERE Drug_Out_of_Pocket_Pct_Change != 0
	GROUP BY state
	HAVING num_providers >= 100
)

SELECT
	RANK() OVER (ORDER BY ABS(avg_service_out_of_pocket_change) DESC, ABS(avg_drug_out_of_pocket_change) DESC) AS service_change_rank,
	state,
	num_providers,
	avg_service_out_of_pocket_change,
	avg_drug_out_of_pocket_change
FROM providers_by_state
ORDER BY service_change_rank
LIMIT 10;