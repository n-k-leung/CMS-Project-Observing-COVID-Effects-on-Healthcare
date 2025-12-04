
-- Calculates percentage of each ethnicity
WITH ethnicity_observations AS (
	SELECT pa.Rndrng_Prvdr_State_Abrvtn,
		SUM(bd.Bene_Race_Wht_Cnt) AS total_white, 
		SUM(bd.Bene_Race_Black_Cnt) AS total_black, 
		SUM(bd.Bene_Race_API_Cnt) AS total_API, 
		SUM(bd.Bene_Race_Hspnc_Cnt) AS total_Hspnc, 
		SUM(bd.Bene_Race_Othr_Cnt) AS total_other, 
		SUM(bd.Bene_Race_Wht_Cnt + bd.Bene_Race_Black_Cnt + bd.Bene_Race_API_Cnt + bd.Bene_Race_Hspnc_Cnt + bd.Bene_Race_Othr_Cnt) AS total_race,
		ROUND(AVG(st.Tot_Srvcs), 2) AS avg_total_services
	FROM bene_demographics bd
	JOIN service_totals st
		ON bd.Rndrng_NPI = st.Rndrng_NPI AND bd.Year = st.Year
	JOIN provider_address pa
		ON pa.Rndrng_NPI  = bd.Rndrng_NPI
	WHERE pa.Rndrng_Prvdr_State_Abrvtn NOT IN ('AA','AE','AP','FM','XX','ZZ')
	GROUP BY pa.Rndrng_Prvdr_State_Abrvtn
)
SELECT Rndrng_Prvdr_State_Abrvtn, 
	avg_total_services,
	ROUND(total_white / total_race * 100, 2) AS pct_white, 
	ROUND(total_black / total_race * 100, 2) AS pct_black, 
	ROUND(total_API / total_race * 100, 2) AS pct_API, 
	ROUND(total_Hspnc / total_race * 100, 2) AS pct_Hspc,
	ROUND(total_other / total_race * 100, 2)AS pct_other
FROM ethnicity_observations
ORDER BY avg_total_services DESC
LIMIT 10;

