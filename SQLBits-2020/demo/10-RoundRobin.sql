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

--SELECT top 100 * FROM [KNext].[votes]






DROP TABLE [KNdwh].[votes]
GO

--ROUND ROBIN
CREATE TABLE [KNdwh].[votes_rr]
WITH
( 
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[votes]
OPTION (LABEL = 'CTAS : Load ROUND_ROBIN')
;

-- Find data skew for a distributed table
SELECT distribution_id, row_count 
FROM microsoft.vw_tables_with_skew where table_name = 'votes_rr'

DBCC PDW_SHOWSPACEUSED('KNdwh.votes_rr');


