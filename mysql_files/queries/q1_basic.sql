-- Query 1 (Basic): Compare average Medicare payments by state before and after COVID (2019 vs 2023)

SELECT
	pa.Rndrng_Prvdr_State_Abrvtn AS State,
	s.Year,
	ROUND(AVG(s.Avg_Mdcr_Pymt_Amt), 2) AS Avg_Medicare_Payment
FROM provider p
JOIN provider_benefit_service_amounts s ON p.Rndrng_NPI = s.Rndrng_NPI AND p.Year = s.Year
JOIN provider_address pa ON p.Rndrng_NPI = pa.Rndrng_NPI
GROUP BY
	pa.Rndrng_Prvdr_State_Abrvtn, s.Year
ORDER BY
	State, s.Year
LIMIT 10;

