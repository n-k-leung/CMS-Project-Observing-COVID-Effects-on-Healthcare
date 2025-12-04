-- What was the average number of distinct Medicare beneficiaries in California for each year?
SELECT
	Year,
	Rndrng_Prvdr_Geo_Desc AS ProviderGeoDescription,
	AVG(Tot_Benes) AS avg_benefits_amount
FROM service_totals
JOIN provider_address USING (Rndrng_NPI)
INNER JOIN geography USING (Rndrng_Prvdr_State_Abrvtn)
WHERE Rndrng_Prvdr_State_Abrvtn = 'CA'
GROUP BY
	Rndrng_Prvdr_Geo_Desc,
	Year;