CREATE SCHEMA Dimension;
GO

CREATE TABLE [Dimension].[Date] (
 [Date] Date NOT NULL
,[Day Number] Int NOT NULL
,[Day] NVarchar(10) NOT NULL
,[Month] NVarchar(10) NOT NULL
,[Short Month] NVarchar(3) NOT NULL
,[Calendar Month Number] Int NOT NULL
,[Calendar Month Label] NVarchar(20) NOT NULL
,[Calendar Year] Int NOT NULL
,[Calendar Year Label] NVarchar(10) NOT NULL
,[Fiscal Month Number] Int NOT NULL
,[Fiscal Month Label] NVarchar(20) NOT NULL
,[Fiscal Year] Int NOT NULL
,[Fiscal Year Label] NVarchar(10) NOT NULL
,[ISO Week Number] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = HASH([Date]))
GO

/* IMPORT the data
Folder: "\2018 SQLDay DWH\DataWarehouseMigrationUtility\" 
File:	WideWorldImportersDW_Export.bat
		WideWorldImportersDW_Import.bat 
*/


SELECT * FROM [Dimension].[Date]
GO

DBCC SHOW_STATISTICS ("[Dimension].[Date]", [ClusteredIndex_77c91ed21be74cbe8d9b6b1c58bb0cfa]); 
--empty


SELECT * FROM [Dimension].[Date] WHERE [Calendar Year] = 2016
-- nothing




--Clean
DROP TABLE [Dimension].[Date];
DROP SCHEMA [Dimension];



