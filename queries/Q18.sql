-- Q23. Missing Index Recommendations (SQL 2005)
USE master
GO

SELECT TOP 20
    DB_NAME(mid.database_id) AS DatabaseName,
    mid.statement AS TableName,
    
    mid.equality_columns AS EqualityColumns,
    mid.inequality_columns AS InequalityColumns,
    mid.included_columns AS IncludedColumns,
    
    -- Impact metrics
    migs.user_seeks AS UserSeeks,
    migs.user_scans AS UserScans,
    CAST(migs.avg_total_user_cost AS DECIMAL(10,2)) AS AvgQueryCost,
    CAST(migs.avg_user_impact AS DECIMAL(5,2)) AS AvgImpactPercent,
    
    -- Overall impact score
    CAST((migs.user_seeks + migs.user_scans) * migs.avg_total_user_cost * migs.avg_user_impact AS BIGINT) AS ImpactScore

FROM sys.dm_db_missing_index_details mid
INNER JOIN sys.dm_db_missing_index_groups mig ON mid.index_handle = mig.index_handle
INNER JOIN sys.dm_db_missing_index_group_stats migs ON mig.index_group_handle = migs.group_handle

WHERE mid.database_id > 4

ORDER BY ImpactScore DESC