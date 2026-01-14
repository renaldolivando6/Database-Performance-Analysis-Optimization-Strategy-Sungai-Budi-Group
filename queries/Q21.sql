-- Jalankan di master database
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'max server memory'
GO