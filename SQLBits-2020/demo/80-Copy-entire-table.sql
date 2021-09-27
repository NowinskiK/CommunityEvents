-- Copy entire table

SELECT COUNT(*) FROM [KNdwh].[taxi5]

CREATE TABLE [KNdwh].[taxi5copy]
WITH
( 
    DISTRIBUTION = HASH([pickup_datetime]),
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [KNdwh].[taxi5]
OPTION (LABEL = 'CTAS : Copy entire [taxi5]')
;



--queries
SELECT top 10 * FROM [KNdwh].[taxi5]


SELECT CONVERT(DATE, [pickup_datetime]) as [Date], 
	COUNT(passenger_count) as SumOfPassenger
FROM [KNdwh].[taxi5]
GROUP BY CONVERT(DATE, [pickup_datetime])




