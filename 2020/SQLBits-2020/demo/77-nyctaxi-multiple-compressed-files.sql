DROP EXTERNAL TABLE [KNext].[taxi4gz]
GO

CREATE EXTERNAL TABLE [KNext].[taxi4gz] (
    vendor_id           [INT] NULL,
    pickup_datetime     [datetime] NULL,
    dropoff_datetime    [datetime] NULL,
    passenger_count     [INT] NULL,
    trip_distance       [DECIMAL](12,2) NULL,
    pickup_longitude    VARCHAR(25) NULL,  --[DECIMAL](18,15) NULL,
    pickup_latitude     VARCHAR(25) NULL,  --[DECIMAL](18,15) NULL,
    rate_code           [INT] NULL,
    store_and_fwd_flag  [VARCHAR](1) NULL,
    dropoff_longitude   VARCHAR(25) NULL,
    dropoff_latitude    VARCHAR(25) NULL,
    payment_type        [INT] NULL,
    fare_amount         [DECIMAL](9,2) NULL,
    extra               [decimal](9,2) NULL,
    mta_tax             [decimal](9,2) NULL,
    imp_surcharge       [decimal](9,2) NULL,
    tip_amount          [decimal](9,2) NULL,
    tolls_amount        [decimal](9,2) NULL,
    total_amount        [decimal](9,2) NULL
)
WITH ( LOCATION ='/v4/compressed/',   
    DATA_SOURCE = KnBlobStorage,  
    FILE_FORMAT = KnTaxiFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);
GO

SELECT TOP 3 * FROM [KNext].[taxi4gz]	--0:25 m/s
GO
SELECT COUNT(*) FROM [KNext].[taxi4gz]
--6,622,295


-- DROP TABLE [KNdwh].[taxi4gz]

CREATE TABLE [KNdwh].[taxi4gz]
WITH
( 
    DISTRIBUTION = HASH([pickup_datetime]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[taxi4gz]
OPTION (LABEL = 'CTAS : Load [taxi4gz] - 10 compressed files')
;


SELECT TOP 10 * FROM [KNdwh].[taxi4gz] 

SELECT COUNT(*) FROM [KNdwh].[taxi4gz]
--6,622,295


SELECT r.[request_id], r.[status], r.[label], r.start_time, r.end_time
	, DATEDIFF(SECOND, r.start_time, r.end_time) AS exec_time_in_sec
	, SUM(w.rows_processed) AS rows_processed
FROM sys.dm_pdw_exec_requests AS r
JOIN sys.dm_pdw_dms_workers AS w ON r.request_id = w.request_id
WHERE r.[label] LIKE '%CTAS : Load%'
	AND w.[type] = 'WRITER'
GROUP BY r.[request_id], r.[status], r.[label], r.start_time, r.end_time
ORDER BY r.[request_id]
