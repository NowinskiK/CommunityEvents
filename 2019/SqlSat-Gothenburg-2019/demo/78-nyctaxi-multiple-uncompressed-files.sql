/*
	SOURCE Type:		BLOB
	Container:			dwh
	Location:			v5/uncompressed/
	Files count:		13  (10.9 GB)
*/

DROP EXTERNAL TABLE [KNext].[taxi5]
GO

CREATE EXTERNAL TABLE [KNext].[taxi5] (
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
WITH ( LOCATION ='/v5/uncompressed/',   
    DATA_SOURCE = KnBlobStorage,  
    FILE_FORMAT = KnTaxiFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);
GO


SELECT COUNT(*) FROM [KNext].[taxi5]		--0:41
--77,080,563


-- DROP TABLE [KNdwh].[taxi5]

CREATE TABLE [KNdwh].[taxi5]
WITH
( 
    DISTRIBUTION = HASH([pickup_datetime]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[taxi5]
OPTION (LABEL = 'CTAS : Load [taxi5] - 13 uncompressed files')
;
--usually: writer 60, hash_Converter 16
--Execution time: 2:48

--with LoaderRC60: writer 120, hash_Converter 16
--Execution time: 3:05


--   1:21 (DWU 1000) (m:s)
--or 8:09 (DWU  100)

SELECT TOP 10 * FROM [KNdwh].[taxi5] 

SELECT COUNT(1) FROM [KNdwh].[taxi5]
--77,080,563



--Monitoring / Power BI:  #19

--North Europe




--Clean
DROP TABLE [KNdwh].[taxi5];
DROP EXTERNAL TABLE [KNext].[taxi5];

