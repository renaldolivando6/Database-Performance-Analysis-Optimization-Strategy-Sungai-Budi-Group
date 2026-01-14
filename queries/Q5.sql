USE SFA

SELECT TOP 10
    t.name AS TableName,
    SUM(p.rows) AS Rows,
    (SELECT COUNT(*) 
     FROM sys.indexes i 
     WHERE i.object_id = t.object_id AND i.type > 0) AS Idx
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
GROUP BY t.name, t.object_id
ORDER BY SUM(p.rows) DESC;