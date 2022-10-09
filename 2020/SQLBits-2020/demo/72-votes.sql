CREATE EXTERNAL TABLE [KNext].[votes] (
	[Id] [int] NOT NULL,
	[PostId] [int] NOT NULL,
	[UserId] [int] NULL,
	[BountyAmount] [int] NULL,
	[VoteTypeId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL
)
WITH ( LOCATION ='/v1/votes/',   
    DATA_SOURCE = KnBlobStorage,  
    FILE_FORMAT = KnTextFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);


CREATE TABLE [KNdwh].[votes]
WITH
( 
    DISTRIBUTION = HASH([Id]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[votes]
OPTION (LABEL = 'CTAS : Load [votes]')
;
--Total execution time: 00:00:33.776 (DWU100)


-- DROP TABLE [KNdwh].[votes]

--Query #1:
SELECT COUNT(1) FROM [KNext].[votes];
SELECT TOP 100 * FROM [KNext].[votes];
--10,146,802

--Query #2:
SELECT YEAR(CreationDate) as [Year], COUNT(*) 
FROM [KNext].[votes]
GROUP BY YEAR(CreationDate)

--LOOK! Statistics are over there! (...or not...?)
SELECT SCHEMA_NAME(t.schema_id) AS schemaName, t.* 
FROM sys.tables AS t
WHERE SCHEMA_NAME(t.schema_id) LIKE 'KN%';

DBCC SHOW_STATISTICS ('[KNdwh].[votes]', [_WA_Sys_00000006_3D2915A8]); 

--Query #3:
SELECT Id, VoteTypeId
FROM [KNdwh].[votes]
WHERE VoteTypeId = 1

--...and now...?
DBCC SHOW_STATISTICS ('[KNdwh].[votes]', [_WA_Sys_00000005_60283922]); 


--Query #4:
SELECT * FROM [KNdwh].[votes] WHERE UserId = 4918     
--LOOK! Statistics are over there! +1
DBCC SHOW_STATISTICS ('[KNdwh].[votes]', [_WA_Sys_00000003_60283922]); 



SELECT OBJECT_NAME(object_id), *
FROM sys.stats WHERE auto_created = 1 AND OBJECT_NAME(object_id) = 'votes';

--STATISTICS
--SELECT * FROM sys.dm_db_stats_properties 



