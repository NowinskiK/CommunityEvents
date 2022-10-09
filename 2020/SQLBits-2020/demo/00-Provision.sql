--https://docs.microsoft.com/en-us/azure/sql-data-warehouse/load-data-wideworldimportersdw

/*
Connection String:
sqlplayer-dwh.database.windows.net,1433

*/

USE master
GO
CREATE LOGIN LoaderRC60 WITH PASSWORD = 'a123STRONGpassword$';
CREATE USER LoaderRC60 FOR LOGIN LoaderRC60;
GO

USE dwh  --SampleDWH
GO
CREATE USER LoaderRC60 FOR LOGIN LoaderRC60;
GRANT CONTROL ON DATABASE::dwh to LoaderRC60;
EXEC sp_addrolemember 'staticrc60', 'LoaderRC60';


GO


--https://docs.microsoft.com/en-us/azure/sql-data-warehouse/resource-classes-for-workload-management
--View the resource classes
SELECT * 
FROM   sys.database_principals
WHERE  name LIKE '%rc%' AND type_desc = 'DATABASE_ROLE';


--https://docs.microsoft.com/en-us/azure/sql-data-warehouse/memory-and-concurrency-limits

DROP LOGIN LoaderRC60
DROP USER LoaderRC60

