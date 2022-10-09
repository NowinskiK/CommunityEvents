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

SELECT top 1000 * FROM [KNext].[votes]

CREATE TABLE [KNdwh].[votes_hash_id]
WITH
( 
    DISTRIBUTION = HASH([Id]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[votes]
OPTION (LABEL = 'CTAS : Load [votes_hash_id]')
;

SELECT top 1000 * FROM [KNdwh].[votes_hash_id]


-- Find data skew for a distributed table
SELECT distribution_id, row_count 
FROM microsoft.vw_tables_with_skew where table_name = 'votes_hash_id';

DBCC PDW_SHOWSPACEUSED('KNdwh.votes_hash_id');

/*
    HASH by UserId
*/

CREATE TABLE [KNdwh].[votes_hash_userid]
WITH
( 
    DISTRIBUTION = HASH([UserId]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[votes]
OPTION (LABEL = 'CTAS : Load [votes_hash_userid]')
;

SELECT top 1000 * FROM [KNdwh].[votes_hash_userid]


-- Find data skew for a distributed table
DBCC PDW_SHOWSPACEUSED('KNdwh.votes_hash_userid');


SELECT table_name, distribution_id, row_count 
FROM microsoft.vw_tables_with_skew 
where table_name = 'votes_hash_userid';

SELECT distribution_id, row_count 
FROM microsoft.vw_tables_with_skew where table_name = 'votes_hash_userid';

SELECT distribution_id, row_count 
FROM microsoft.vw_tables_with_skew where table_name = 'votes_hash_id';





--9483210 rows in distribution 1 - all for NULL values
