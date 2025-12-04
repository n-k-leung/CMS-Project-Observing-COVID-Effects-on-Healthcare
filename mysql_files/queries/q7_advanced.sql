WITH yearly_chronic_agg AS (
    SELECT
        Year,
        AVG(Bene_CC_BH_ADHD_OthCD_V1_Pct) AS ADHD,
        AVG(Bene_CC_BH_Alcohol_Drug_V1_Pct) AS Alcohol_Drug,
        AVG(Bene_CC_BH_Tobacco_V1_Pct) AS Tobacco,
        AVG(Bene_CC_BH_Alz_NonAlzdem_V2_Pct) AS Alzheimers,
        AVG(Bene_CC_BH_Anxiety_V1_Pct) AS Anxiety,
        AVG(Bene_CC_BH_Bipolar_V1_Pct) AS Bipolar,
        AVG(Bene_CC_BH_Mood_V2_Pct) AS Mood,
        AVG(Bene_CC_BH_Depress_V1_Pct) AS Depression,
        AVG(Bene_CC_BH_PD_V1_Pct) AS Personality_Disorder,
        AVG(Bene_CC_BH_PTSD_V1_Pct) AS PTSD,
        AVG(Bene_CC_BH_Schizo_OthPsy_V1_Pct) AS Schizophrenia,
        AVG(Bene_CC_PH_Asthma_V2_Pct) AS Asthma,
        AVG(Bene_CC_PH_Afib_V2_Pct) AS Afib,
        AVG(Bene_CC_PH_Cancer6_V2_Pct) AS Cancer,
        AVG(Bene_CC_PH_CKD_V2_Pct) AS CKD,
        AVG(Bene_CC_PH_COPD_V2_Pct) AS COPD,
        AVG(Bene_CC_PH_Diabetes_V2_Pct) AS Diabetes,
        AVG(Bene_CC_PH_HF_NonIHD_V2_Pct) AS HF_NonIHD,
        AVG(Bene_CC_PH_Hyperlipidemia_V2_Pct) AS Hyperlipidemia,
        AVG(Bene_CC_PH_Hypertension_V2_Pct) AS Hypertension,
        AVG(Bene_CC_PH_IschemicHeart_V2_Pct) AS Ischemic_Heart,
        AVG(Bene_CC_PH_Osteoporosis_V2_Pct) AS Osteoporosis,
        AVG(Bene_CC_PH_Parkinson_V2_Pct) AS Parkinson,
        AVG(Bene_CC_PH_Arthritis_V2_Pct) AS Arthritis,
        AVG(Bene_CC_PH_Stroke_TIA_V2_Pct) AS Stroke_TIA
    FROM bene_clinical_conditions
    WHERE Year IN (2019, 2023)
    GROUP BY Year
),

combined AS (
    SELECT
        (y23.ADHD - y19.ADHD) / y19.ADHD * 100 AS ADHD_Perc,
        (y23.Alcohol_Drug - y19.Alcohol_Drug) / y19.Alcohol_Drug * 100 AS Alcohol_Drug_Perc,
        (y23.Tobacco - y19.Tobacco) / y19.Tobacco * 100 AS Tobacco_Perc,
        (y23.Alzheimers - y19.Alzheimers) / y19.Alzheimers * 100 AS Alzheimers_Perc,
        (y23.Anxiety - y19.Anxiety) / y19.Anxiety * 100 AS Anxiety_Perc,
        (y23.Bipolar - y19.Bipolar) / y19.Bipolar * 100 AS Bipolar_Perc,
        (y23.Mood - y19.Mood) / y19.Mood * 100 AS Mood_Perc,
        (y23.Depression - y19.Depression) / y19.Depression * 100 AS Depression_Perc,
        (y23.Personality_Disorder - y19.Personality_Disorder) / y19.Personality_Disorder * 100 AS PD_Perc,
        (y23.PTSD - y19.PTSD) / y19.PTSD * 100 AS PTSD_Perc,
        (y23.Schizophrenia - y19.Schizophrenia) / y19.Schizophrenia * 100 AS Schizo_Perc,
        (y23.Asthma - y19.Asthma) / y19.Asthma * 100 AS Asthma_Perc,
        (y23.Afib - y19.Afib) / y19.Afib * 100 AS Afib_Perc,
        (y23.Cancer - y19.Cancer) / y19.Cancer * 100 AS Cancer_Perc,
        (y23.CKD - y19.CKD) / y19.CKD * 100 AS CKD_Perc,
        (y23.COPD - y19.COPD) / y19.COPD * 100 AS COPD_Perc,
        (y23.Diabetes - y19.Diabetes) / y19.Diabetes * 100 AS Diabetes_Perc,
        (y23.HF_NonIHD - y19.HF_NonIHD) / y19.HF_NonIHD * 100 AS HF_NonIHD_Perc,
        (y23.Hyperlipidemia - y19.Hyperlipidemia) / y19.Hyperlipidemia * 100 AS Hyperlipidemia_Perc,
        (y23.Hypertension - y19.Hypertension) / y19.Hypertension * 100 AS Hypertension_Perc,
        (y23.Ischemic_Heart - y19.Ischemic_Heart) / y19.Ischemic_Heart * 100 AS Ischemic_Heart_Perc,
        (y23.Osteoporosis - y19.Osteoporosis) / y19.Osteoporosis * 100 AS Osteoporosis_Perc,
        (y23.Parkinson - y19.Parkinson) / y19.Parkinson * 100 AS Parkinson_Perc,
        (y23.Arthritis - y19.Arthritis) / y19.Arthritis * 100 AS Arthritis_Perc,
        (y23.Stroke_TIA - y19.Stroke_TIA) / y19.Stroke_TIA * 100 AS Stroke_TIA_Perc

    FROM yearly_chronic_agg y19
    JOIN yearly_chronic_agg y23 
        ON y19.Year = 2019 
       AND y23.Year = 2023
)

SELECT
    Condition_Name,
    Perc_Change,
    RANK() OVER (ORDER BY Perc_Change DESC) AS Growth_Ranking
FROM (
    SELECT 'ADHD' AS Condition_Name, ADHD_Perc AS Perc_Change FROM combined
    UNION ALL SELECT 'Alcohol & Drug Use', Alcohol_Drug_Perc FROM combined
    UNION ALL SELECT 'Tobacco Use', Tobacco_Perc FROM combined
    UNION ALL SELECT 'Alzheimers / Dementia', Alzheimers_Perc FROM combined
    UNION ALL SELECT 'Anxiety', Anxiety_Perc FROM combined
    UNION ALL SELECT 'Bipolar', Bipolar_Perc FROM combined
    UNION ALL SELECT 'Mood Disorder', Mood_Perc FROM combined
    UNION ALL SELECT 'Depression', Depression_Perc FROM combined
    UNION ALL SELECT 'Personality Disorder', PD_Perc FROM combined
    UNION ALL SELECT 'PTSD', PTSD_Perc FROM combined
    UNION ALL SELECT 'Schizophrenia / Other Psychosis', Schizo_Perc FROM combined
    UNION ALL SELECT 'Asthma', Asthma_Perc FROM combined
    UNION ALL SELECT 'Atrial Fibrillation', Afib_Perc FROM combined
    UNION ALL SELECT 'Cancer', Cancer_Perc FROM combined
    UNION ALL SELECT 'Chronic Kidney Disease', CKD_Perc FROM combined
    UNION ALL SELECT 'COPD', COPD_Perc FROM combined
    UNION ALL SELECT 'Diabetes', Diabetes_Perc FROM combined
    UNION ALL SELECT 'Heart Failure (Non-IHD)', HF_NonIHD_Perc FROM combined
    UNION ALL SELECT 'Hyperlipidemia', Hyperlipidemia_Perc FROM combined
    UNION ALL SELECT 'Hypertension', Hypertension_Perc FROM combined
    UNION ALL SELECT 'Ischemic Heart Disease', Ischemic_Heart_Perc FROM combined
    UNION ALL SELECT 'Osteoporosis', Osteoporosis_Perc FROM combined
    UNION ALL SELECT 'Parkinsons', Parkinson_Perc FROM combined
    UNION ALL SELECT 'Arthritis', Arthritis_Perc FROM combined
    UNION ALL SELECT 'Stroke / TIA', Stroke_TIA_Perc FROM combined
) AS conditions
ORDER BY Perc_Change DESC;
