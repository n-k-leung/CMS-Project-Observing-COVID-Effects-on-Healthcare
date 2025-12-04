WITH service_rank AS (
	SELECT
		pbs.Year,
		pbs.HCPCS_Cd,
		h.HCPCS_Desc,
		SUM(st.Tot_Srvcs) AS total_services,
		ROW_NUMBER() OVER (
			PARTITION BY pbs.Year
			ORDER BY SUM(st.Tot_Srvcs) DESC
		) AS rn
	FROM provider_benefit_service_amounts pbs
	LEFT JOIN hcpcs h ON h.HCPCS_Cd = pbs.HCPCS_Cd
	LEFT JOIN service_totals st ON st.Rndrng_NPI = pbs.Rndrng_NPI AND st.Year = pbs.Year
	WHERE pbs.Year IN (2019, 2023)
	GROUP BY pbs.Year, pbs.HCPCS_Cd, h.HCPCS_Desc
)
SELECT Year, HCPCS_Cd, HCPCS_Desc, total_services
FROM service_rank

WHERE rn <= 5
ORDER BY Year, total_services DESC;