-- Q30. Top 10 Slowest Queries (Production-Ready Version)
-- Filter: ExecCount > 10 untuk data yang lebih representative
USE SFA  -- Ganti: InventoryManagement,CustomerOrder,  AccountReceive, SFA
GO

SELECT TOP 10
    DB_NAME() AS DatabaseName,
    
    -- Execution stats
    qs.execution_count AS ExecCount,
    qs.total_elapsed_time / 1000000 AS TotalDuration_Sec,
    qs.total_elapsed_time / qs.execution_count / 1000 AS AvgDuration_Ms,
    qs.last_elapsed_time / 1000 AS LastDuration_Ms,
    
    -- Resource usage
    qs.total_logical_reads AS TotalLogicalReads,
    qs.total_logical_reads / qs.execution_count AS AvgLogicalReads,
    qs.total_worker_time / 1000000 AS TotalCPU_Sec,
    qs.total_worker_time / qs.execution_count / 1000 AS AvgCPU_Ms,
    
    -- Query info
    qs.creation_time AS CachedTime,
    qs.last_execution_time AS LastExecTime,
    
    -- Query text (first 500 chars)
    SUBSTRING(st.text, 1, 500) AS QueryText

FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE st.dbid = DB_ID()
  AND qs.execution_count > 10  -- Filter: minimal 10x execution
ORDER BY qs.total_elapsed_time / qs.execution_count DESC