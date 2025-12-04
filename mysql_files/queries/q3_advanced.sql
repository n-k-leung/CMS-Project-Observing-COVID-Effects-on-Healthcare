WITH state_metrics AS (
	SELECT
		p.Rndrng_Prvdr_State_Abrvtn AS state,
		S.HCPCS_Cd,
		h.HCPCS_Desc,
		h.Place_Of_Srvc,
		s.Year,
		SUM(st.Tot_Srvcs) AS total_services,
		SUM(st.Tot_Benes) AS total_benes,
		AVG(s.Avg_Mdcr_Pymt_Amt) AS avg_payment,
		AVG(s.Avg_Mdcr_Stdzd_Amt) AS avg_stdzd
	FROM provider_benefit_service_amounts s
	JOIN provider_address p ON s.Rndrng_NPI=p.Rndrng_NPI
	JOIN service_totals st ON s.Rndrng_NPI = st.Rndrng_NPI AND s.Year = st.Year
	JOIN hcpcs h ON h.HCPCS_Cd = s.HCPCS_Cd
	GROUP BY state, s.HCPCS_Cd, h.Place_Of_Srvc, s.Year
),
national_avg AS (
	SELECT
		HCPCS_Cd,
		Place_Of_Srvc,
		Year,
		AVG(avg_payment) AS nat_payment,
		AVG(avg_stdzd) AS nat_stdzd
	FROM state_metrics
	GROUP BY HCPCS_Cd, Place_Of_Srvc, Year
)
SELECT
	s.state,
	s.Place_Of_Srvc,
	ROUND(AVG(ABS((s.avg_payment - n.nat_payment) / n.nat_payment)) * 100, 2) AS pct_diff_payment,
	ROUND(AVG(ABS((s.avg_stdzd - n.nat_stdzd) / n.nat_stdzd)) * 100, 2) AS pct_diff_stdzd,
	ROUND(
	AVG(ABS((s.avg_payment - n.nat_payment) / n.nat_payment)) -
	AVG(ABS((s.avg_stdzd - n.nat_stdzd) / n.nat_stdzd)), 4
	) AS standardization_reduction
FROM state_metrics s
JOIN national_avg n USING (HCPCS_Cd, Place_Of_Srvc, Year)
GROUP BY s.state, s.Place_Of_Srvc
ORDER BY standardization_reduction DESC;