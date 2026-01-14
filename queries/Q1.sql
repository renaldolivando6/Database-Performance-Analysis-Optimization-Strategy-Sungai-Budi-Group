SELECT 
    @@SERVERNAME AS server_name,
    create_date AS last_restart
FROM sys.databases
WHERE name = 'tempdb'