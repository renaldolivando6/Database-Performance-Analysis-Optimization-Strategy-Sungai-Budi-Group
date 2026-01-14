-- Q16. Disk I/O Statistics by Database (SQL 2005)
USE master
GO

SELECT 
    DB_NAME(database_id) AS DatabaseName,
    
    -- Read Stats
    SUM(num_of_reads) AS Total_Reads,
    SUM(num_of_bytes_read) / 1024 / 1024 AS Total_Read_MB,
    SUM(io_stall_read_ms) AS Total_Read_Wait_Ms,
    CASE 
        WHEN SUM(num_of_reads) = 0 THEN 0
        ELSE SUM(io_stall_read_ms) / SUM(num_of_reads)
    END AS Avg_Read_Latency_Ms,
    
    -- Write Stats
    SUM(num_of_writes) AS Total_Writes,
    SUM(num_of_bytes_written) / 1024 / 1024 AS Total_Write_MB,
    SUM(io_stall_write_ms) AS Total_Write_Wait_Ms,
    CASE 
        WHEN SUM(num_of_writes) = 0 THEN 0
        ELSE SUM(io_stall_write_ms) / SUM(num_of_writes)
    END AS Avg_Write_Latency_Ms,
    
    -- Total I/O
    SUM(num_of_reads) + SUM(num_of_writes) AS Total_IO_Operations,
    SUM(io_stall_read_ms) + SUM(io_stall_write_ms) AS Total_IO_Wait_Ms
    
FROM sys.dm_io_virtual_file_stats(NULL, NULL)
WHERE database_id > 4
GROUP BY database_id
ORDER BY Total_IO_Wait_Ms DESC