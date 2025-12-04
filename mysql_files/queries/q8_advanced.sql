WITH age_summary AS (
    SELECT
        pa.Rndrng_Prvdr_State_Abrvtn,
        b.Year,
        ( Bene_Age_GT_84_Cnt) AS Elderly_Cnt,
        (Bene_Age_LT_65_Cnt + Bene_Age_65_74_Cnt + Bene_Age_75_84_Cnt + Bene_Age_GT_84_Cnt) AS Total_Benes
    FROM bene_demographics b
    JOIN provider_address pa 
        ON pa.Rndrng_NPI = b.Rndrng_NPI
	JOIN provider p 
		ON p.Rndrng_NPI = b.Rndrng_NPI AND p.Year = b.Year
    WHERE b.Year IN (2019, 2023)
),

elderly_pct AS (
    SELECT
        Rndrng_Prvdr_State_Abrvtn AS State,
        Year,
        (Elderly_Cnt * 1.0 / NULLIF(Total_Benes, 0)) * 100 AS Elderly_Percentage
    FROM age_summary
),

elderly_pivot AS (
    SELECT
        State,
        MAX(CASE WHEN Year = 2019 THEN Elderly_Percentage END) AS Elderly_2019,
        MAX(CASE WHEN Year = 2023 THEN Elderly_Percentage END) AS Elderly_2023
    FROM elderly_pct
    GROUP BY State
),

risk_pivot AS (
    SELECT
        pa.Rndrng_Prvdr_State_Abrvtn AS State,
        AVG(CASE WHEN bcc.Year = 2019 THEN Bene_Avg_Risk_Scre END) AS Risk_2019,
        AVG(CASE WHEN bcc.Year = 2023 THEN Bene_Avg_Risk_Scre END) AS Risk_2023
    FROM bene_clinical_conditions bcc
    JOIN provider_address pa 
        ON pa.Rndrng_NPI = bcc.Rndrng_NPI
	JOIN provider p 
		ON p.Rndrng_NPI = bcc.Rndrng_NPI AND p.Year = bcc.Year
    WHERE bcc.Year IN (2019, 2023)
    GROUP BY pa.Rndrng_Prvdr_State_Abrvtn
)

SELECT
    r.State,
    (e.Elderly_2023 - e.Elderly_2019) AS Elderly_Growth,
    (r.Risk_2023 - r.Risk_2019) AS Risk_Growth,
    RANK() OVER (ORDER BY (r.Risk_2023 - r.Risk_2019) DESC) AS Risk_Ranking
FROM elderly_pivot e
JOIN risk_pivot r USING (State)
ORDER BY Risk_Growth DESC