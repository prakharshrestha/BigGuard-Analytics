WITH flow_measures AS (
    SELECT attack_cat, dur,
           CAST(sbytes AS DOUBLE) + CAST(dbytes AS DOUBLE)
               AS total_bytes
    FROM network_flows_analysis
), category_summary AS (
    SELECT attack_cat,
           COUNT(*) AS record_count,
           AVG(dur) AS mean_duration,
           PERCENTILE_APPROX(dur, ARRAY(0.5, 0.95), 10000)
               AS duration_percentiles,
           AVG(total_bytes) AS mean_bytes,
           PERCENTILE_APPROX(total_bytes, ARRAY(0.5, 0.95), 10000)
               AS byte_percentiles,
           SUM(CASE WHEN dur = 0 THEN 1 ELSE 0 END)
               AS zero_duration_records
    FROM flow_measures
    GROUP BY attack_cat
)
SELECT attack_cat, record_count,
       ROUND(mean_duration, 6) AS mean_duration_seconds,
       ROUND(duration_percentiles[0], 6)
           AS approx_median_duration_seconds,
       ROUND(duration_percentiles[1], 6)
           AS approx_p95_duration_seconds,
       ROUND(mean_bytes, 2) AS mean_total_bytes,
       ROUND(byte_percentiles[0], 2) AS approx_median_total_bytes,
       ROUND(byte_percentiles[1], 2) AS approx_p95_total_bytes,
       zero_duration_records,
       ROUND(100.0 * zero_duration_records / record_count, 2)
           AS zero_duration_percentage
FROM category_summary
ORDER BY record_count DESC;
