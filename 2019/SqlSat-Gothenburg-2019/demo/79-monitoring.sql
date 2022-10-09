--Monitoring / Power BI:
CREATE VIEW [KNdwh].[CurrentlyRunningWriters]
AS
SELECT r.[request_id], r.[status], r.[label], r.start_time, r.end_time
	, DATEDIFF(SECOND, r.start_time, r.end_time) AS exec_time_in_sec
	, SUM(w.rows_processed) AS rows_processed
FROM sys.dm_pdw_exec_requests AS r
JOIN sys.dm_pdw_dms_workers AS w ON r.request_id = w.request_id
WHERE r.[label] LIKE '%CTAS : Load%'
	AND w.[type] = 'WRITER'
GROUP BY r.[request_id], r.[status], r.[label], r.start_time, r.end_time
--ORDER BY r.[request_id]
GO




SELECT * FROM [KNdwh].[CurrentlyRunningWriters]
ORDER BY [request_id]



SELECT *
FROM sys.dm_pdw_exec_requests	req 
JOIN sys.dm_pdw_dms_workers				wrk ON req.request_id = wrk.request_id
WHERE req.[status] = 'Running'
ORDER BY wrk.start_time DESC

