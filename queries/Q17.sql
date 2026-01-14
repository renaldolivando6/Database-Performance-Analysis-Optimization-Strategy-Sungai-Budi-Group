-- Q17. Top 10 Wait Types - Simple Overview (SQL 2005)
USE master
GO

SELECT TOP 10
    wait_type AS WaitType,
    waiting_tasks_count AS WaitCount,
    wait_time_ms / 1000 AS Total_Wait_Sec,
    wait_time_ms / 1000 / 60 AS Total_Wait_Min,
    max_wait_time_ms AS Max_Wait_Ms,
    CAST(wait_time_ms * 100.0 / SUM(wait_time_ms) OVER() AS DECIMAL(5,2)) AS Pct_Total_Wait
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN (
    -- Filter out benign waits
    'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE',
    'SLEEP_TASK', 'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH',
    'WAITFOR', 'LOGMGR_QUEUE', 'CHECKPOINT_QUEUE',
    'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BROKER_TO_FLUSH',
    'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT',
    'DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
    'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP'
)
AND wait_time_ms > 0
ORDER BY wait_time_ms DESC