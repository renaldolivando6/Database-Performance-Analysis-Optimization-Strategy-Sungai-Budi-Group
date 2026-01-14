USE SFA

SELECT 
    t.name AS TableName,
    p.reserved_page_count * 8 AS Reserved,
    p.used_page_count * 8 AS Data,
    0 AS [Index],
    (p.reserved_page_count - p.used_page_count) * 8 AS Unused,
    CAST((p.reserved_page_count - p.used_page_count) * 100.0 / 
         NULLIF(p.reserved_page_count, 0) AS DECIMAL(5,2)) AS [% Terbuang]
FROM sys.tables t
INNER JOIN sys.dm_db_partition_stats p ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
  AND p.reserved_page_count > 0
ORDER BY (p.reserved_page_count - p.used_page_count) DESC


