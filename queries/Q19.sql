-- Jalankan di setiap database (CustomerOrder, InventoryManagement, AccountReceive, SFA)
USE CustomerOrder  -- <-- GANTI ini sesuai database yang mau dicheck
GO

SELECT 
    DB_NAME() AS DatabaseName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    
    -- Usage Stats
    ISNULL(s.user_seeks, 0) AS UserSeeks,
    ISNULL(s.user_scans, 0) AS UserScans,
    ISNULL(s.user_lookups, 0) AS UserLookups,
    ISNULL(s.user_updates, 0) AS UserWrites,
    
    -- Total Reads
    ISNULL(s.user_seeks, 0) + ISNULL(s.user_scans, 0) + ISNULL(s.user_lookups, 0) AS TotalReads,
    
    -- Size
    ps.reserved_page_count * 8 / 1024 AS SizeMB,
    
    -- Simple Recommendation
    CASE
        WHEN ISNULL(s.user_seeks, 0) + ISNULL(s.user_scans, 0) + ISNULL(s.user_lookups, 0) = 0 
        THEN 'DROP - Unused'
        
        WHEN ISNULL(s.user_updates, 0) > 1000 
             AND (ISNULL(s.user_seeks, 0) + ISNULL(s.user_scans, 0) + ISNULL(s.user_lookups, 0)) < 10
        THEN 'Consider DROP - High writes, low reads'
        
        ELSE 'Keep'
    END AS Recommendation

FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats s 
    ON i.object_id = s.object_id 
    AND i.index_id = s.index_id 
    AND s.database_id = DB_ID()
INNER JOIN sys.dm_db_partition_stats ps 
    ON i.object_id = ps.object_id 
    AND i.index_id = ps.index_id
WHERE 
    i.type IN (1, 2)  -- 1=Clustered, 2=Nonclustered
    AND i.is_primary_key = 0
    AND i.is_unique_constraint = 0
    AND ps.reserved_page_count > 100  -- Min 800KB
ORDER BY 
    TotalReads ASC,  -- Unused indexes first
    SizeMB DESC