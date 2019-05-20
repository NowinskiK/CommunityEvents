USE [$(DatabaseName)]
GO

--CREATE LOGIN [$(svcSyncProc)] WITH PASSWORD = 'pa$$w0rd';

IF NOT EXISTS (SELECT 1 FROM sys.database_principals dp WHERE dp.name = '$(svcSyncProc)')
BEGIN
PRINT 'User [$(svcSyncProc)] Created in [$(DatabaseName)] database.';
    CREATE USER [$(svcSyncProc)] FROM LOGIN [$(svcSyncProc)];
END
EXEC sys.sp_addrolemember @rolename = 'db_owner', @membername = [$(svcSyncProc)];
PRINT 'User [$(svcSyncProc)] was granted db_owner role permissions in [$(DatabaseName)] database.';
GO


