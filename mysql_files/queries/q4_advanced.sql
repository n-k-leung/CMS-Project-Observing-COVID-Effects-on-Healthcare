-- Which medical services or procedures cost Medicare the most money overall?
-- CREATE INDEX idx_year
-- 	ON state_providers_benefit_service_amounts (Year);
-- EXPLAIN ANALYZE
WITH detail AS (
	SELECT
		s.Year,
		S.HCPCS_Cd,
		SUM(st.Tot_Srvcs) AS services,
		SUM(s.Avg_Mdcr_Pymt_Amt * st.Tot_Srvcs) AS spend
	FROM provider_benefit_service_amounts s
	JOIN service_totals st ON st.Rndrng_NPI = s.Rndrng_NPI AND st.Year = s.Year
	GROUP BY s.Year, s.HCPCS_Cd
)
SELECT
	Year,
	HCPCS_Cd,
	services,
	ROUND(spend, 2) AS spend
FROM detail
ORDER BY Year DESC, spend DESC
LIMIT 50;-- change to see more/less