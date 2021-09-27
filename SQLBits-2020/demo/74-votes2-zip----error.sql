-- DROP EXTERNAL FILE FORMAT KnTextFileFormat 
CREATE EXTERNAL FILE FORMAT KnTextFileFormatZip
WITH 
(   
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS
    (   
        FIELD_TERMINATOR = '|',
        USE_TYPE_DEFAULT = FALSE,
        First_Row = 2
    )
	, DATA_COMPRESSION = 'org.apache.hadoop.io.compress.GzipCodec' 
);
GO

-- DROP EXTERNAL TABLE [KNext].[votes2]
CREATE EXTERNAL TABLE [KNext].[votes2] (
	[Id] [INT] NOT NULL,
	[PostId] [INT] NOT NULL,
	[UserId] [INT] NULL,
	[BountyAmount] [INT] NULL,
	[VoteTypeId] [INT] NOT NULL,
	[CreationDate] [DATETIME] NOT NULL
)
WITH ( LOCATION ='/v2/votes/',   
    DATA_SOURCE = KnBlobStorage,  
    FILE_FORMAT = KnTextFileFormatZip,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);


CREATE TABLE [KNdwh].[votes2]
WITH
( 
    DISTRIBUTION = HASH([Id]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[votes2]
OPTION (LABEL = 'CTAS : Load [votes2]')
;
--Total execution time: 00:00:37.805

/*
Msg 107090, Level 16, State 1, Line 33
Query aborted-- the maximum reject threshold (0 rows) was reached while reading from an external source: 1 rows rejected out of total 0 rows processed.
(/v2/votes/votes2.zip)UTF8 decode failed.
*/

