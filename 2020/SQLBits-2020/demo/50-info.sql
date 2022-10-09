--from master
SELECT db.[name] AS [DatabaseName]
	, dso.service_objective AS [Service Objective]
	, dso.edition 
FROM sys.database_service_objectives AS dso
JOIN sys.databases db ON db.database_id = dso.database_id

--from master
ALTER DATABASE wwi
MODIFY (SERVICE_OBJECTIVE = 'DW100');
GO

DBCC PDW_ShowSpaceUsed('wwi.taxi_full')
--Msg 40518, Level 16, State 1, Line 12
--DBCC command 'PDW_ShowSpaceUsed' is not supported in this version of SQL Server.

SELECT * FROM sys.dm_operation_status
--https://docs.microsoft.com/en-us/azure/sql-data-warehouse/memory-and-concurrency-limits

--NODES
SELECT  [pdw_node_id]   AS node_id
,       [type]          AS node_type
,       [name]          AS node_name
FROM    sys.[dm_pdw_nodes]
;

--DISTRIBUTION
SELECT  [distribution_id]   AS dist_id
,       [pdw_node_id]       AS node_id
,       [name]              AS dist_name
,       [position]          AS dist_position
FROM    sys.[pdw_distributions]
;

--SNAPSHOTS
SELECT  [run_id]                    AS bkup_run_id
,       [session_id]                AS session_id
,       [request_id]                AS request_id
,       [name]                      AS bkup_name
,       [submit_time]               AS bkup_submit_time
,       [start_time]                AS bkup_start_time
,       [end_time]                  AS bkup_end_time
,       [total_elapsed_time]        AS bkup_duration_ms
,       [total_elapsed_time]/1000.0 AS bkup_duration_sec
FROM    sys.pdw_loader_backup_runs
; 
