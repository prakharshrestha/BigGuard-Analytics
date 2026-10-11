WITH destination_summary AS (
    SELECT dstip, COUNT(*) AS total_records,
           SUM(CASE WHEN label = 1 THEN 1 ELSE 0 END)
               AS attack_records,
           SUM(CASE WHEN label = 0 THEN 1 ELSE 0 END)
               AS normal_records,
           COUNT(DISTINCT CASE WHEN label = 1 THEN attack_cat
                               ELSE NULL END)
               AS distinct_attack_categories
    FROM network_flows_analysis
    GROUP BY dstip
), category_counts AS (
    SELECT dstip, attack_cat, COUNT(*) AS category_records
    FROM network_flows_analysis
    WHERE label = 1
    GROUP BY dstip, attack_cat
), ranked_categories AS (
    SELECT dstip, attack_cat, category_records,
           ROW_NUMBER() OVER (
               PARTITION BY dstip
               ORDER BY category_records DESC, attack_cat ASC
           ) AS category_rank
    FROM category_counts
)
SELECT d.dstip, d.total_records, d.attack_records, d.normal_records,
       ROUND(100.0 * d.attack_records / d.total_records, 2)
           AS within_destination_attack_percentage,
       d.distinct_attack_categories,
       r.attack_cat AS dominant_attack_category,
       r.category_records AS dominant_category_records,
       ROUND(100.0 * r.category_records / d.attack_records, 2)
           AS dominant_category_share_of_attacks
FROM destination_summary d
JOIN ranked_categories r ON d.dstip = r.dstip
WHERE r.category_rank = 1
ORDER BY d.attack_records DESC, d.dstip
LIMIT 15;
