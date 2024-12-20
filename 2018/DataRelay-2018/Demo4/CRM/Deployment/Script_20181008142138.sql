/*
Deployment script for CRM_DEV

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar ContosoRetailDW "ContosoRetailDW"
:setvar DatabaseName "CRM_DEV"
:setvar DefaultFilePrefix "CRM_DEV"
:setvar DefaultDataPath "D:\MSSQL\Data\"
:setvar DefaultLogPath "D:\MSSQL\Data\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Creating [data].[PopulateAllData]...';


GO
CREATE PROCEDURE [data].[PopulateAllData]
AS
BEGIN
	EXECUTE [data].[PopulateAction_v1];
	EXECUTE [data].[PopulateAction_v2];
	EXECUTE [data].[PopulateAction_v3];
RETURN 0
END
GO
/*
--------------------------------------------------------------------------------------
Post-Deployment Script
--------------------------------------------------------------------------------------
*/
--Option 3
EXECUTE [data].[PopulateAllData];


--Or JUST: Option 3'
--EXECUTE [data].[PopulateAllData];
GO

GO
PRINT N'Update complete.';


GO

