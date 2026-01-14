use master
-- Q15. Buffer Pool Usage by Database (SQL 2005)
SELECT 
    CASE 
        WHEN database_id = 32767 THEN 'ResourceDB'
        ELSE DB_NAME(database_id)
    END AS DatabaseName,
    COUNT(*) * 8 / 1024 AS Buffer_MB,
    COUNT(*) * 8 / 1024.0 / 1024 AS Buffer_GB
FROM sys.dm_os_buffer_descriptors
WHERE database_id > 4
GROUP BY database_id
ORDER BY Buffer_MB DESC