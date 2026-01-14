-- Q34. Statistics Health Check (SQL 2005 - Safe Version)
USE SFA --AccountReceive --InventoryManagement -- CustomerOrder
GO

SELECT TOP 20
    OBJECT_NAME(id) AS TableName,
    name AS IndexName,
    STATS_DATE(id, indid) AS LastUpdated,
    DATEDIFF(day, STATS_DATE(id, indid), GETDATE()) AS DaysOld,
    rowcnt AS TotalRows,
    CASE 
        WHEN rowmodctr < 0 THEN 0
        ELSE rowmodctr 
    END AS Modifications,
    CASE 
        WHEN rowcnt = 0 THEN 0
        WHEN rowmodctr < 0 THEN 0
        WHEN rowmodctr > rowcnt THEN 100.00
        ELSE CAST(rowmodctr * 100.0 / rowcnt AS DECIMAL(10,2))
    END AS ModPct,
    CASE 
        WHEN DATEDIFF(day, STATS_DATE(id, indid), GETDATE()) > 30 THEN 'CRITICAL'
        WHEN DATEDIFF(day, STATS_DATE(id, indid), GETDATE()) > 7 THEN 'WARNING'
        ELSE 'OK'
    END AS Status
FROM sysindexes
WHERE OBJECTPROPERTY(id, 'IsUserTable') = 1
  AND indid > 0 
  AND indid < 255
  AND rowcnt > 1000
  AND STATS_DATE(id, indid) IS NOT NULL
ORDER BY DATEDIFF(day, STATS_DATE(id, indid), GETDATE()) DESC