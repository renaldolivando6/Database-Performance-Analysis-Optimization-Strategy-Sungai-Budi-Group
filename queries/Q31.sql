-- Q31. Top 10 Most I/O Intensive Queries (SQL 2005)
USE  SFA -- InventoryManagement CustomerOrder SFA AccountReceive
GO

SELECT TOP 10
    DB_NAME() AS DatabaseName,
    
    -- I/O Stats
    qs.total_logical_reads AS TotalLogicalReads,
    qs.total_logical_reads / qs.execution_count AS AvgLogicalReads,
    qs.total_physical_reads AS TotalPhysicalReads,
    qs.total_physical_reads / qs.execution_count AS AvgPhysicalReads,
    
    -- Execution stats
    qs.execution_count AS ExecCount,
    qs.total_elapsed_time / 1000000 AS TotalDuration_Sec,
    qs.total_elapsed_time / qs.execution_count / 1000 AS AvgDuration_Ms,
    
    -- CPU
    qs.total_worker_time / qs.execution_count / 1000 AS AvgCPU_Ms,
    
    -- Cache efficiency (lower = better)
    CAST(qs.total_physical_reads * 100.0 / NULLIF(qs.total_logical_reads, 0) AS DECIMAL(5,2)) AS CacheMissRate_Pct,
    
    -- Query info
    qs.creation_time AS CachedTime,
    qs.last_execution_time AS LastExecTime,
    
    -- Query text
    SUBSTRING(st.text, 1, 500) AS QueryText

FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE st.dbid = DB_ID()
  AND qs.execution_count > 10  -- Filter: minimal 10x execution
ORDER BY qs.total_logical_reads DESC  -- Sort by total I/O