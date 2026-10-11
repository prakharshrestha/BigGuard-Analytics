WITH service_summary AS (
    SELECT proto, service,
           COUNT(*) AS total_records,
           SUM(CASE WHEN label = 1 THEN 1 ELSE 0 END)
               AS attack_records,
           SUM(CASE WHEN label = 0 THEN 1 ELSE 0 END)
               AS normal_records
    FROM network_flows_analysis
    GROUP BY proto, service
), summary_with_total AS (
    SELECT proto, service, total_records,
           attack_records, normal_records,
           SUM(attack_records) OVER () AS all_attack_records
    FROM service_summary
)
SELECT proto, service, total_records, attack_records, normal_records,
       ROUND(100.0 * attack_records / total_records, 2)
           AS within_group_attack_percentage,
       ROUND(100.0 * attack_records / all_attack_records, 2)
           AS share_of_all_attacks_percentage
FROM summary_with_total
WHERE total_records >= 100
ORDER BY attack_records DESC, total_records DESC, proto, service
LIMIT 15;
