USE SFA

-- Create temp table
CREATE TABLE #TempSpace (
    TableName VARCHAR(128),
    Rows VARCHAR(50),
    Reserved VARCHAR(50),
    Data VARCHAR(50),
    Index_size VARCHAR(50),
    Unused VARCHAR(50)
)
 
-- Get all tables
EXEC sp_MSforeachtable 'INSERT INTO #TempSpace EXEC sp_spaceused ''?'''
 
-- Display TOP 15 sorted by size
SELECT TOP 15 * FROM #TempSpace
ORDER BY CAST(REPLACE(REPLACE(Reserved, ' KB', ''), ',', '') AS BIGINT) DESC
 
-- Cleanup
DROP TABLE #TempSpace

