DROP EXTERNAL TABLE [KNext].[taxi4]
GO

CREATE EXTERNAL TABLE [KNext].[taxi4] (
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
WITH ( LOCATION ='/v4/uncompressed/',   
    DATA_SOURCE = KnBlobStorage,  
    FILE_FORMAT = KnTaxiFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);
GO

SELECT TOP 3 * FROM [KNext].[taxi4]	--0:25 m/s
GO




-- DROP TABLE [KNdwh].[taxi4]

CREATE TABLE [KNdwh].[taxi4]
WITH
( 
    DISTRIBUTION = HASH([pickup_datetime]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[taxi4]
OPTION (LABEL = 'CTAS : Load [taxi4] - 9 uncompressed files')
;
--0:12


SELECT TOP 10 * FROM [KNdwh].[taxi4]

SELECT COUNT(*) FROM [KNdwh].[taxi4]
--5,921,556

SELECT YEAR(pickup_datetime) AS [Year], MONTH(pickup_datetime) AS [Month]
	, COUNT(*) AS cnt
	, SUM(passenger_count) AS SumOfPassenger
FROM [KNdwh].[taxi4]
GROUP BY YEAR(pickup_datetime), MONTH(pickup_datetime)



SELECT *
FROM sys.dm_pdw_exec_requests	req 
JOIN sys.dm_pdw_dms_workers				wrk ON req.request_id = wrk.request_id
WHERE req.[label] LIKE '%9 uncompressed%'
ORDER BY wrk.start_time DESC
