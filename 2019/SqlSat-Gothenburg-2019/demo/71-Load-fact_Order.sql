-- DROP EXTERNAL FILE FORMAT KnTextFileFormat 
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


-- DROP EXTERNAL TABLE [KNext].[fact_Order]
CREATE EXTERNAL TABLE [KNext].[fact_Order] (
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
WITH ( LOCATION ='/v1/fact_Order/',   
    DATA_SOURCE = KnBlobStorage,  
    FILE_FORMAT = KnTextFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);

/*
Msg 105019, Level 16, State 1, Line 49
EXTERNAL TABLE access failed due to internal error: 'Error occurred while accessing HDFS: Java exception raised on call to HdfsBridge_Connect. Java exception message:
Parameters provided to connect to the Azure storage account are not valid.'

Solution: fix CREDENTIAL
*/


--Load the data into your data warehouse

CREATE TABLE [KNdwh].[fact_Order]
WITH
( 
    DISTRIBUTION = HASH([Order Key]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[fact_Order]
OPTION (LABEL = 'CTAS : Load [fact_Order]')
;
--Exec time: 00:00:21

SELECT SCHEMA_NAME(t.schema_id) AS schemaName, t.* 
FROM sys.tables AS t
WHERE SCHEMA_NAME(t.schema_id) LIKE 'KN%';

/*
1) Msg 107090, Level 16, State 1, Line 105
Query aborted-- the maximum reject threshold (0 rows) was reached while reading from an external source: 1 rows rejected out of total 1 rows processed.
(/v1/fact_Order/factorder.csv)Column ordinal: 1, Expected data type: BIGINT NOT NULL, Offending value: Order Key  (Column Conversion Error), Error: Error converting data type NVARCHAR to BIGINT. 
Solution: First_Row = 2

2) Msg 107090, Level 16, State 1, Line 1
Query aborted-- the maximum reject threshold (0 rows) was reached while reading from an external source: 1 rows rejected out of total 8 rows processed.
(/v1/fact_Order/factorder.csv)UTF8 decode failed. 
Solution: Convert file to UTF-8
Question: So, how to export my data from current db? with SSMS???

*/

SELECT TOP 100 [Order Key] FROM [ext].[fact_Order];
SELECT TOP 1 * FROM [ext].[fact_Order];

SELECT TOP 100 [Order Key] FROM [wwi].[fact_Order];
SELECT TOP 1 [Order Key] FROM [wwi].[fact_Order];

TRUNCATE TABLE [wwi].[fact_Order]






