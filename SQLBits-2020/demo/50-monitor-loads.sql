--View your data as it loads.
SELECT
    r.command,
    s.request_id,
    r.status,
    count(distinct input_name) as nbr_files,
    sum(s.bytes_processed)/1024/1024/1024 as gb_processed
FROM 
    sys.dm_pdw_exec_requests r
    LEFT JOIN sys.dm_pdw_dms_external_work s
    ON r.request_id = s.request_id
WHERE
    r.[label] = 'CTAS : Load [votes]' OR
    r.[label] = 'CTAS : Load [fact_Purchase]' 
GROUP BY
    r.command,
    s.request_id,
    r.status
ORDER BY
    nbr_files desc, 
    gb_processed desc;


--View all system queries.
SELECT * FROM sys.dm_pdw_exec_requests WHERE label IS NOT null
--Msg 103010, Level 16, State 1, Line 22
--Parse error at line: 1, column: 40: Incorrect syntax near 'WHERE'.

SELECT * FROM sys.dm_pdw_exec_requests WHERE [label] is not null
SELECT * FROM sys.dm_pdw_exec_requests WHERE [label] = 'CTAS : Load [votes]'
SELECT * FROM sys.dm_pdw_dms_external_work s        --doesn't show anything

SELECT * FROM sys.dm_pdw_exec_requests WHERE [Status] = 'Running' AND session_id <> session_id()

--JRJ
SELECT *
FROM sys.dm_pdw_exec_requests	req 
JOIN sys.dm_pdw_dms_workers				wrk ON req.request_id = wrk.request_id
WHERE req.[label] LIKE '%full2%'
ORDER BY wrk.start_time DESC


SELECT *
FROM sys.dm_pdw_exec_requests	req 
JOIN sys.dm_pdw_dms_workers				wrk ON req.request_id = wrk.request_id
WHERE req.[status] = 'Running'
ORDER BY wrk.start_time DESC



SELECT 
    req.command,
    req.request_id,
    req.status,
    wrk.bytes_processed/1024/1024 as mb_processed,
	wrk.type, wrk.status, wrk.bytes_per_sec, wrk.rows_processed
FROM sys.dm_pdw_exec_requests	req 
JOIN sys.dm_pdw_dms_workers				wrk ON req.request_id = wrk.request_id
WHERE req.[label] LIKE '%full2%' AND req.request_id = 'QID978'
ORDER BY wrk.start_time DESC

SELECT 
    req.request_id, MIN(wrk.start_time) AS start_time, wrk.type, wrk.status, req.status,
    SUM(wrk.bytes_processed)/1024/1024 as mb_processed,
	SUM(wrk.bytes_per_sec)/1024 AS kb_per_sec,
	SUM(wrk.rows_processed) AS rows_processed,
	req.resource_class,
	MAX(wrk.buffers_available) AS max_buffers_available,
	COUNT(DISTINCT wrk.pdw_node_id) AS node_count, 
	COUNT(*) AS process_cnt,
	req.[label]
FROM sys.dm_pdw_exec_requests	req 
JOIN sys.dm_pdw_dms_workers				wrk ON req.request_id = wrk.request_id
WHERE --req.[label] LIKE '%taxi4%' 
	 --req.status = 'Running'
	 req.request_id = 'QID1501'
GROUP BY req.request_id, wrk.type, wrk.status, req.status, req.resource_class, req.[label]

