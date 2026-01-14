USE CustomerOrder

SELECT 
    DB_NAME() AS 'Nama Database',
    CAST(SUM(a.total_pages) * 8 / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS 'Total Reserved (GB)',
    CAST(SUM(a.data_pages) * 8 / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS 'Total Data (GB)',
    CAST((SUM(a.used_pages) - SUM(a.data_pages)) * 8 / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS 'Total Index (GB)',
	CAST(SUM(a.used_pages) * 8 / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS 'Total Used (GB)',
    CAST((SUM(a.total_pages) - SUM(a.used_pages)) * 8 / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS 'Total Unused (GB)',
    CAST((SUM(a.total_pages) - SUM(a.used_pages)) * 100.0 / 
         NULLIF(SUM(a.total_pages), 0) AS DECIMAL(5,2)) AS '% Unused'
FROM sys.partitions p
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id