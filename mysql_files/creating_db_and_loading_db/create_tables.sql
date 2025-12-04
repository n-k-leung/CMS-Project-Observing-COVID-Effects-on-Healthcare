DROP DATABASE IF EXISTS cms_db;
CREATE DATABASE cms_db;
USE cms_db;

CREATE TABLE provider (
    Rndrng_NPI INT,
    Rndrng_Prvdr_Last_Org_Name TEXT,
    Rndrng_Prvdr_First_Name TEXT,
    Rndrng_Prvdr_MI TEXT,
    Rndrng_Prvdr_Crdntls TEXT,
    Rndrng_Prvdr_Ent_Cd TEXT,
    Year INT,
    PRIMARY KEY (Rndrng_NPI, Year)
);

CREATE TABLE state (
	Rndrng_Prvdr_State_Abrvtn VARCHAR(3) PRIMARY KEY,
    Rndrng_Prvdr_State_FIPS TEXT
);

CREATE TABLE provider_address (
    Rndrng_NPI INT,
    Rndrng_Prvdr_St1 TEXT,
    Rndrng_Prvdr_St2 TEXT,
    Rndrng_Prvdr_City TEXT,
    Rndrng_Prvdr_State_Abrvtn VARCHAR(3),
    Rndrng_Prvdr_Zip5 TEXT,
    Rndrng_Prvdr_Cntry TEXT,
    PRIMARY KEY (Rndrng_NPI),
    FOREIGN KEY (Rndrng_NPI) REFERENCES provider(Rndrng_NPI),
    FOREIGN KEY (Rndrng_Prvdr_State_Abrvtn) REFERENCES state(Rndrng_Prvdr_State_Abrvtn)
);

CREATE TABLE ruca (
	Rndrng_Prvdr_RUCA FLOAT PRIMARY KEY,
    Rndrng_Prvdr_RUCA_Desc TEXT
);

CREATE TABLE provider_classification (
    Rndrng_NPI INT,
    Rndrng_Prvdr_RUCA FLOAT,
    Rndrng_Prvdr_Type TEXT,
    Rndrng_Prvdr_Mdcr_Prtcptg_Ind TEXT,
    Year INT,
    PRIMARY KEY (Rndrng_NPI, Year),
    FOREIGN KEY (Rndrng_NPI, Year) REFERENCES provider(Rndrng_NPI, Year),
    FOREIGN KEY (Rndrng_Prvdr_RUCA) REFERENCES ruca(Rndrng_Prvdr_RUCA)
);

CREATE TABLE service_totals (
    Rndrng_NPI INT,
    Tot_HCPCS_Cds INT,
    Tot_Benes INT,
    Tot_Srvcs FLOAT,
    Tot_Sbmtd_Chrg FLOAT,
    Tot_Mdcr_Alowd_Amt FLOAT,
    Tot_Mdcr_Pymt_Amt FLOAT,
    Tot_Mdcr_Stdzd_Amt FLOAT,
    Year INT,
    PRIMARY KEY (Rndrng_NPI, Year),
    FOREIGN KEY (Rndrng_NPI, Year) REFERENCES provider(Rndrng_NPI,Year)
);

CREATE TABLE drug_services (
    Rndrng_NPI INT,
    Drug_Sprsn_Ind TEXT,
    Drug_Tot_HCPCS_Cds FLOAT,
    Drug_Tot_Benes FLOAT,
    Drug_Tot_Srvcs FLOAT,
    Drug_Sbmtd_Chrg FLOAT,
    Drug_Mdcr_Alowd_Amt FLOAT,
    Drug_Mdcr_Pymt_Amt FLOAT,
    Drug_Mdcr_Stdzd_Amt FLOAT,
    Year INT,
    PRIMARY KEY (Rndrng_NPI, Year),
    FOREIGN KEY (Rndrng_NPI, Year) REFERENCES provider(Rndrng_NPI,Year)
);

CREATE TABLE medical_services (
    Rndrng_NPI INT,
    Med_Sprsn_Ind TEXT,
    Med_Tot_HCPCS_Cds FLOAT,
    Med_Tot_Benes FLOAT,
    Med_Tot_Srvcs FLOAT,
    Med_Sbmtd_Chrg FLOAT,
    Med_Mdcr_Alowd_Amt FLOAT,
    Med_Mdcr_Pymt_Amt FLOAT,
    Med_Mdcr_Stdzd_Amt FLOAT,
    Year INT,
    PRIMARY KEY (Rndrng_NPI, Year),
    FOREIGN KEY (Rndrng_NPI, Year) REFERENCES provider(Rndrng_NPI,Year)
);

CREATE TABLE bene_demographics (
    Rndrng_NPI INT,
    Bene_Avg_Age INT,
    Bene_Age_LT_65_Cnt FLOAT,
    Bene_Age_65_74_Cnt FLOAT,
    Bene_Age_75_84_Cnt FLOAT,
    Bene_Age_GT_84_Cnt FLOAT,
    Bene_Feml_Cnt FLOAT,
    Bene_Male_Cnt FLOAT,
    Bene_Race_Wht_Cnt FLOAT,
    Bene_Race_Black_Cnt FLOAT,
    Bene_Race_API_Cnt FLOAT,
    Bene_Race_Hspnc_Cnt FLOAT,
    Bene_Race_NatInd_Cnt FLOAT,
    Bene_Race_Othr_Cnt FLOAT,
    Bene_Dual_Cnt FLOAT,
    Bene_Ndual_Cnt FLOAT,
    Year INT,
    PRIMARY KEY (Rndrng_NPI, Year),
    FOREIGN KEY (Rndrng_NPI, Year) REFERENCES provider(Rndrng_NPI,Year)
);

CREATE TABLE bene_clinical_conditions (
    Rndrng_NPI INT,
    Bene_CC_BH_ADHD_OthCD_V1_Pct FLOAT,
    Bene_CC_BH_Alcohol_Drug_V1_Pct FLOAT,
    Bene_CC_BH_Tobacco_V1_Pct FLOAT,
    Bene_CC_BH_Alz_NonAlzdem_V2_Pct FLOAT,
    Bene_CC_BH_Anxiety_V1_Pct FLOAT,
    Bene_CC_BH_Bipolar_V1_Pct FLOAT,
    Bene_CC_BH_Mood_V2_Pct FLOAT,
    Bene_CC_BH_Depress_V1_Pct FLOAT,
    Bene_CC_BH_PD_V1_Pct FLOAT,
    Bene_CC_BH_PTSD_V1_Pct FLOAT,
    Bene_CC_BH_Schizo_OthPsy_V1_Pct FLOAT,
    Bene_CC_PH_Asthma_V2_Pct FLOAT,
    Bene_CC_PH_Afib_V2_Pct FLOAT,
    Bene_CC_PH_Cancer6_V2_Pct FLOAT,
    Bene_CC_PH_CKD_V2_Pct FLOAT,
    Bene_CC_PH_COPD_V2_Pct FLOAT,
    Bene_CC_PH_Diabetes_V2_Pct FLOAT,
    Bene_CC_PH_HF_NonIHD_V2_Pct FLOAT,
    Bene_CC_PH_Hyperlipidemia_V2_Pct FLOAT,
    Bene_CC_PH_Hypertension_V2_Pct FLOAT,
    Bene_CC_PH_IschemicHeart_V2_Pct FLOAT,
    Bene_CC_PH_Osteoporosis_V2_Pct FLOAT,
    Bene_CC_PH_Parkinson_V2_Pct FLOAT,
    Bene_CC_PH_Arthritis_V2_Pct FLOAT,
    Bene_CC_PH_Stroke_TIA_V2_Pct FLOAT,
    Bene_Avg_Risk_Scre FLOAT,
    Year INT,
    PRIMARY KEY (Rndrng_NPI, Year),
    FOREIGN KEY (Rndrng_NPI, Year) REFERENCES provider(Rndrng_NPI,Year)
);

CREATE TABLE hcpcs (
	HCPCS_Cd VARCHAR(100) PRIMARY KEY,
    HCPCS_Desc TEXT,
    HCPCS_Drug_Ind TEXT,
    Place_Of_Srvc TEXT
);

CREATE TABLE provider_benefit_service_amounts (
	Rndrng_NPI INT,
    HCPCS_Cd VARCHAR(100),
    Year INT,
    Tot_Bene_Day_Srvcs INT,
    Avg_Sbmtd_Chrg FLOAT,
    Avg_Mdcr_Alowd_Amt FLOAT,
    Avg_Mdcr_Pymt_Amt FLOAT,
    Avg_Mdcr_Stdzd_Amt FLOAT,
    PRIMARY KEY (Rndrng_NPI, Year),
    FOREIGN KEY (Rndrng_NPI, Year) REFERENCES provider(Rndrng_NPI,Year),
    FOREIGN KEY (HCPCS_Cd) REFERENCES hcpcs(HCPCS_Cd)
);

CREATE TABLE geography (
    Rndrng_Prvdr_State_Abrvtn VARCHAR(100) PRIMARY KEY,
    Rndrng_Prvdr_Geo_Cd TEXT,
    Rndrng_Prvdr_Geo_Lvl TEXT,
    Rndrng_Prvdr_Geo_Desc TEXT,
    FOREIGN KEY (Rndrng_Prvdr_State_Abrvtn) REFERENCES provider_address(Rndrng_Prvdr_State_Abrvtn)
);
