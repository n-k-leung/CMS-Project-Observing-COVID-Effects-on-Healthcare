-- Top 20 biggest changes 
WITH average_age_counts AS (
    SELECT 
		bd.Bene_Avg_Age AS average_age,
		SUM(bd.Bene_Feml_Cnt) AS female_count, 
		SUM(bd.Bene_Male_Cnt) AS male_count, 
		ROUND(AVG(st.Tot_Srvcs), 2) AS avg_total_services,
		st.Year
    FROM bene_demographics bd
    JOIN service_totals st
		ON bd.Rndrng_NPI = st.Rndrng_NPI
        AND bd.Year = st.Year
    WHERE bd.Bene_Avg_Age BETWEEN 20 AND 40
		OR bd.Bene_Avg_Age BETWEEN 60 AND 80
    GROUP BY bd.Bene_Avg_Age, st.Year
    HAVING SUM(bd.Bene_Feml_Cnt) > 0
    AND SUM(bd.Bene_Male_Cnt) > 0
)	
SELECT 
	average_age, 
	ROUND(COALESCE((avg_total_services  - LAG(avg_total_services ) OVER (PARTITION BY average_age ORDER BY Year)) / NULLIF(LAG(avg_total_services) OVER (PARTITION BY average_age ORDER BY Year), 0) * 100, 0), 2) AS pct_service_change,
	avg_total_services AS avg_total_services_2023,
	ROUND(female_count / (female_count + male_count) * 100, 2) AS pct_female, 
	female_count AS female_count_2023,
	ROUND(male_count / (female_count + male_count) * 100, 2) AS pct_male,
	male_count AS male_count_2023
FROM average_age_counts
ORDER BY pct_service_change DESC
LIMIT 10;

