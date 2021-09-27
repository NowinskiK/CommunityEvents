--Data source:
--https://data.cityofnewyork.us/view/ba8s-jw6u

DROP EXTERNAL TABLE [KNext].[taxi]
GO
CREATE EXTERNAL TABLE [KNext].[taxi] (
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
WITH ( LOCATION ='/v3/taxi/',   
    DATA_SOURCE = KnBlobStorage,  
    FILE_FORMAT = KnTaxiFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);
GO

SELECT TOP 3 * FROM [KNext].[taxi]	--17 min
GO




--DROP TABLE [KNdwh].[taxi_full2]
CREATE TABLE [KNdwh].[taxi_full2]
WITH
( 
    DISTRIBUTION = HASH([pickup_datetime]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNext].[taxi]
OPTION (LABEL = 'CTAS : Load [taxi_full2]')
;		--16 min

SELECT TOP 3 * FROM [KNdwh].[taxi_full2]
SELECT COUNT(*) FROM [KNdwh].[taxi_full2]
--77,080,575

SELECT YEAR(pickup_datetime) AS [Year], MONTH(pickup_datetime) AS [Month]
	, COUNT(*) AS cnt
	, SUM(passenger_count) AS SumOfPassenger
FROM [KNdwh].[taxi_full2]
GROUP BY YEAR(pickup_datetime), MONTH(pickup_datetime)







SELECT TOP 3 * FROM [ext].[taxi];	--15:40 with all VARCHAR(50) :)
/*
vendor_id	pickup_datetime	dropoff_datetime	passenger_count	trip_distance	pickup_longitude	pickup_latitude	rate_code	store_and_fwd_flag	dropoff_longitude	dropoff_latitude	payment_type	fare_amount	extra	mta_tax	imp_surcharge	tip_amount	tolls_amount	total_amount
1	2015-06-14 11:40:48.000	2015-06-14 11:54:37.000	1	4.00	-74.011123657226563	40.7291259765625	1	N	-73.982589721679688	40.777206420898438	1	14.5	0	0.5	4.59	0	19.89	NULL
2	2015-06-14 19:54:23.000	2015-06-14 20:07:55.000	1	4.74	-73.985153198242188	40.742214202880859	1	N	-74.012962341308594	40.702861785888672	1	16	0	0.5	3.36	0	20.16	NULL
1	2015-06-19 08:24:02.000	2015-06-19 08:35:39.000	1	1.20	-73.972297668457031	40.745487213134766	1	N	-73.985359191894531	40.755775451660156	1	9	0	0.5	1	0	10.8	NULL
*/

