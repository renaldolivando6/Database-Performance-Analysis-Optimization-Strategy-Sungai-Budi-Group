USE AccountReceive
-- Q12. Fragmentation Summary (Grouped)
SELECT 
    Category,
    COUNT(*) AS IndexCount,
    CAST(SUM(SizeMB) AS DECIMAL(10,2)) AS TotalSizeMB
FROM (
    SELECT 
        CASE 
            WHEN ips.avg_fragmentation_in_percent > 30 THEN 'Critical (>30%)'
            WHEN ips.avg_fragmentation_in_percent > 10 THEN 'Warning (10-30%)'
            ELSE 'Healthy (<10%)'
        END AS Category,
        CASE 
            WHEN ips.avg_fragmentation_in_percent > 30 THEN 1
            WHEN ips.avg_fragmentation_in_percent > 10 THEN 2
            ELSE 3
        END AS SortOrder,
        ips.page_count * 8.0 / 1024 AS SizeMB
    FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
    INNER JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
    WHERE ips.index_id > 0
      AND ips.page_count > 100
) AS FragmentationData
GROUP BY Category, SortOrder
ORDER BY SortOrder