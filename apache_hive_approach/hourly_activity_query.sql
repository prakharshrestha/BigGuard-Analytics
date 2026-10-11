SET hive.local.time.zone=UTC;
WITH time_fields AS (
    SELECT TO_DATE(FROM_UNIXTIME(stime)) AS capture_date,
           HOUR(FROM_UNIXTIME(stime)) AS capture_hour,
           label
    FROM network_flows_analysis
), hourly_summary AS (
    SELECT capture_date, capture_hour,
           COUNT(*) AS total_records,
           SUM(CASE WHEN label = 1 THEN 1 ELSE 0 END)
               AS attack_records,
           SUM(CASE WHEN label = 0 THEN 1 ELSE 0 END)
               AS normal_records
    FROM time_fields
    GROUP BY capture_date, capture_hour
), hourly_with_daily AS (
    SELECT capture_date, capture_hour, total_records,
           attack_records, normal_records,
           SUM(attack_records) OVER (PARTITION BY capture_date)
               AS daily_attack_records
    FROM hourly_summary
)
SELECT capture_date, capture_hour, total_records,
       attack_records, normal_records,
       ROUND(100.0 * attack_records / total_records, 2)
           AS within_hour_attack_percentage,
       CASE WHEN daily_attack_records > 0
            THEN ROUND(100.0 * attack_records / daily_attack_records, 2)
            ELSE NULL
       END AS share_of_day_attacks_percentage
FROM hourly_with_daily
ORDER BY capture_date, capture_hour;
