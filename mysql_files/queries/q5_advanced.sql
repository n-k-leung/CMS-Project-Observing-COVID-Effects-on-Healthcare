# Question 5 - States with the Most Providers and Their Most Common Services (2019 vs 2023)
WITH provider_service_counts AS (
	SELECT
		pbs.Year,
		p.Rndrng_Prvdr_State_Abrvtn AS state,
		pbs.HCPCS_Cd,
		SUM(st.Tot_Srvcs) AS total_services,
		COUNT(DISTINCT pbs.Rndrng_NPI) AS providers
	FROM provider_benefit_service_amounts pbs
	JOIN service_totals st ON st.Rndrng_NPI = pbs.Rndrng_NPI AND st.Year = pbs.Year
	JOIN provider_address p ON p.Rndrng_NPI AND pbs.Rndrng_NPI
	WHERE pbs.Year IN (2019, 2023)
	GROUP BY pbs.Year, state, pbs.HCPCS_Cd
),
ranked_services AS (
	SELECT
		Year, state, HCPCS_Cd, total_services, providers,
		ROW_NUMBER() OVER (PARTITION BY Year, state ORDER BY total_services DESC) AS rn
	FROM provider_service_counts
)
SELECT
	r.Year,
	r.state,
	r.providers,
	r.total_services,
	h.HCPCS_Desc AS most_common_service
FROM ranked_services r
LEFT JOIN hcpcs h ON h.HCPCS_Cd = r.HCPCS_Cd
WHERE rn = 1
ORDER BY r.providers DESC, r.total_services DESC;