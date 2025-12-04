-- CREATE INDEX idx_service_totals_npi_year
-- ON service_totals (Rndrng_NPI, Year);

-- CREATE INDEX idx_provider_npi_year
-- ON provider (Rndrng_NPI, Year);

-- CREATE INDEX idx_provider_address_npi_year
-- ON provider_address (Rndrng_NPI, Year);
-- EXPLAIN ANALYZE
WITH medicare_coverage AS (
SELECT
		p.Rndrng_NPI,
		p.Rndrng_Prvdr_Last_Org_Name,
		a.Rndrng_Prvdr_City,
		a.Rndrng_Prvdr_State_Abrvtn AS state,
		st.Year,
		st.Tot_Mdcr_Pymt_Amt AS Medicare_Amt_Covered,
		(st.Tot_Mdcr_Pymt_Amt / NULLIF(st.Tot_Sbmtd_Chrg, 0)) * 100 AS Medicare_Percentage_Covered
	FROM service_totals st
	JOIN provider p
		ON st.Rndrng_NPI = p.Rndrng_NPI
		AND st.Year = p.Year
	JOIN provider_address a
		ON st.Rndrng_NPI = a.Rndrng_NPI
),
changes AS (
	SELECT
		tp_2019.Rndrng_NPI,
		tp_2019.state,
		tp_2023.Medicare_Amt_Covered - tp_2019.Medicare_Amt_Covered AS Medicare_Amt_Covered_Change,
		tp_2023.Medicare_Percentage_Covered - tp_2019.Medicare_Percentage_Covered AS Medicare_Percentage_Covered_Change
	FROM medicare_coverage tp_2019
	JOIN medicare_coverage tp_2023
		ON tp_2019.Rndrng_NPI = tp_2023.Rndrng_NPI
		AND tp_2019.state = tp_2023.state
	WHERE tp_2019.Year = 2019
		AND tp_2023.Year = 2023
)
SELECT
	-- Increasing medicare coverage
	SUM(CASE WHEN Medicare_Percentage_Covered_Change > 0 THEN 1 ELSE 0 END)
		AS num_providers_increasing_medicare_coverage,
	AVG(CASE WHEN Medicare_Percentage_Covered_Change > 0
			THEN Medicare_Percentage_Covered_Change END)
		AS avg_percent_increase_medicare_coverage,
	AVG(CASE WHEN Medicare_Amt_Covered_Change > 0
			THEN Medicare_Amt_Covered_Change END)
		AS avg_increase_medicare_coverage_usd,

	-- Decreasing medicare coverage
	SUM(CASE WHEN Medicare_Percentage_Covered_Change < 0 THEN 1 ELSE 0 END)
		AS num_providers_decreasing_medicare_coverage,
	AVG(CASE WHEN Medicare_Percentage_Covered_Change < 0
			THEN Medicare_Percentage_Covered_Change END)
		AS avg_percent_decrease_medicare_coverage,
	AVG(CASE WHEN Medicare_Amt_Covered_Change < 0
			THEN Medicare_Amt_Covered_Change END)
		AS avg_decrease_medicare_coverage_usd
FROM changes;