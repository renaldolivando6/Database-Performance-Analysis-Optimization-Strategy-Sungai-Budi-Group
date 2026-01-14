USE master
-- Q14. CPU Usage by Database (SQL 2005 Compatible)
SELECT 
    DB_NAME(dbid) AS DatabaseName,
    SUM(total_worker_time) / 1000 AS CPU_Time_Ms,
    SUM(total_worker_time) / 1000000 AS CPU_Time_Sec,
    COUNT(*) AS QueryCount
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE dbid > 4
GROUP BY dbid
ORDER BY CPU_Time_Ms DESC