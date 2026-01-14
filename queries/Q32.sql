-- Q32. Anti-pattern Detection
USE CustomerOrder  -- Ganti per database CustomerOrder InventoryManagement AccountReceive
GO

SELECT 
    Pattern,
    COUNT(*) AS QueryCount,
    SUM(execution_count) AS TotalExecutions,
    MIN(QuerySample) AS ExampleQuery
FROM (
    SELECT 
        qs.execution_count,
        SUBSTRING(st.text, 1, 200) AS QuerySample,
        CASE 
            WHEN st.text LIKE '%SELECT%*%FROM%' 
            THEN 'SELECT * (unnecessary columns)'
            
            WHEN st.text LIKE '%WHERE%YEAR(%' 
                 OR st.text LIKE '%WHERE%MONTH(%'
                 OR st.text LIKE '%WHERE%CONVERT(%'
            THEN 'Function on column (non-sargable)'
            
            WHEN st.text LIKE '%WHERE%OR%'
            THEN 'OR in WHERE (index issue)'
            
            WHEN st.text LIKE '%NOT IN%'
            THEN 'NOT IN (use NOT EXISTS)'
            
            WHEN st.text LIKE '%SELECT DISTINCT%'
            THEN 'DISTINCT abuse'
            
            ELSE NULL
        END AS Pattern
    FROM sys.dm_exec_query_stats qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
    WHERE st.dbid = DB_ID()
      AND qs.execution_count > 5
) AS AntiPatterns
WHERE Pattern IS NOT NULL
GROUP BY Pattern
ORDER BY TotalExecutions DESC