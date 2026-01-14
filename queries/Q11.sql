USE AccountReceive

-- Q11. Check Index Fragmentation (All Indexes)
SELECT 
    DB_NAME() AS DatabaseName,
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ips.index_id,
    ips.avg_fragmentation_in_percent AS FragmentationPct,
    ips.page_count AS PageCount,
    CAST(ips.page_count * 8.0 / 1024 AS DECIMAL(10,2)) AS SizeMB,
    CASE 
        WHEN ips.avg_fragmentation_in_percent > 30 THEN 'REBUILD'
        WHEN ips.avg_fragmentation_in_percent > 10 THEN 'REORGANIZE'
        ELSE 'OK'
    END AS Recommendation
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.index_id > 0
  AND ips.page_count > 100
ORDER BY ips.avg_fragmentation_in_percent DESC