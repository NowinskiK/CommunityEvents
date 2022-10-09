--USE WWI

CREATE MASTER KEY;
GO

CREATE DATABASE SCOPED CREDENTIAL KnAzureStorageCredential 
WITH IDENTITY = 'sqlplayer', 
SECRET =									'VBZQ+a0JfmxYfL5zPseertaHWbOs3eGjIQYTQ8GREC+cfdncJzHwn6OylFRD+TcdBPE2BWORJgTSlRXBRVY2wA==';
GO

-- Create an external data source with CREDENTIAL option.
--https://blogs.msdn.microsoft.com/cindygross/2015/02/04/understanding-wasb-and-hadoop-storage-in-azure/
--https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=sql-server-2017
--Blob: wasb://YOURDefaultContainer@YOURStorageAccount.blob.core.windows.net/SomeDirectory/ASubDirectory/AFile.txt
CREATE EXTERNAL DATA SOURCE KnBlobStorage
WITH
(
    TYPE = Hadoop,
    LOCATION = 'wasb://dwh@sqlplayer.blob.core.windows.net' ,
	CREDENTIAL = KnAzureStorageCredential
);
GO

--DROP EXTERNAL DATA SOURCE KnBlobStorage

CREATE SCHEMA [ext]
GO

CREATE EXTERNAL FILE FORMAT KnTextFileFormat 
WITH 
(   
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS
    (   
        FIELD_TERMINATOR = '|',
        USE_TYPE_DEFAULT = FALSE,
        First_Row = 2
    )
);
GO


--All OK
CREATE EXTERNAL TABLE [ext].[Fact_Order] (
	[Order Key] [bigint] NOT NULL,
	[City Key] [int] NOT NULL,
	[Customer Key] [int] NOT NULL,
	[Stock Item Key] [int] NOT NULL,
	[Order Date Key] [date] NOT NULL,
	[Picked Date Key] [date] NULL,
	[Salesperson Key] [int] NOT NULL,
	[Picker Key] [int] NULL,
	[WWI Order ID] [int] NOT NULL,
	[WWI Backorder ID] [int] NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Unit Price] [decimal](18, 2) NOT NULL,
	[Tax Rate] [decimal](18, 3) NOT NULL,
	[Total Excluding Tax] [decimal](18, 2) NOT NULL,
	[Tax Amount] [decimal](18, 2) NOT NULL,
	[Total Including Tax] [decimal](18, 2) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH ( 
	LOCATION ='/wwidw/Fact.Order.txt',   
    DATA_SOURCE = KnBlobStorage,  
    FILE_FORMAT = KnTextFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0,
);
--DROP EXTERNAL TABLE [ext].[Fact_Order]



CREATE EXTERNAL TABLE [ext].[Fact_Order_broken] (
	[Order Key] [bigint] NOT NULL,
	[City Key] [int] NOT NULL,
	[Customer Key] [int] NOT NULL,
	[Stock Item Key] [int] NOT NULL,
	[Order Date Key] [date] NOT NULL,
	[Picked Date Key] [date] NULL,
	[Salesperson Key] [int] NOT NULL,
	[Picker Key] [int] NULL,
	[WWI Order ID] [int] NOT NULL,
	[WWI Backorder ID] [int] NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Unit Price] [decimal](18, 2) NOT NULL,
	[Tax Rate] [decimal](18, 3) NOT NULL,
	[Total Excluding Tax] [decimal](18, 2) NOT NULL,
	[Tax Amount] [decimal](18, 2) NOT NULL,
	[Total Including Tax] [decimal](18, 2) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH ( 
	LOCATION ='/wwidw/Fact.Order (broken).txt',   
    DATA_SOURCE = KnBlobStorage,  
    FILE_FORMAT = KnTextFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 10,
	REJECTED_ROW_LOCATION='/wwidw/RejectedRows'
);
--  DROP EXTERNAL TABLE [ext].[Fact_Order_broken]


SELECT TOP 100 * FROM [ext].[Fact_Order_broken]
WHERE [Order Key] < 3000
ORDER BY [Order Key] ASC

SELECT TOP 100 * FROM [ext].[Fact_Order_broken]
WHERE [Order Key] IN ( 1941, 1981, 2148 )

SELECT * FROM sys.system_views