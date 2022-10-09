CREATE TABLE [KNdwh].[votes_replicate]
WITH
( 
    DISTRIBUTION = REPLICATE,
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT TOP 1000 * FROM [KNext].[votes]
OPTION (LABEL = 'CTAS : Load [votes_replicate]')
;



SELECT VoteTypeId, COUNT(UserId) 
FROM [KNdwh].[votes_rr]
GROUP BY VoteTypeId
OPTION (LABEL = 'Select RR with VoteTypeId')
;

--Execution Plan
SELECT s.step_index, s.operation_type, s.total_elapsed_time, s.row_count, s.command
FROM sys.dm_pdw_exec_requests r
JOIN sys.dm_pdw_request_steps s ON s.request_id = r.request_id
WHERE r.[label] = 'Select RR with VoteTypeId'
--Look at: ShuffleMoveOperation 
--BroadcastMoveOperation



SELECT VoteTypeId, COUNT(UserId) 
FROM [KNdwh].[votes_replicate]
GROUP BY VoteTypeId
OPTION (LABEL = 'Select REPLICATE with VoteTypeId')
;

--Execution Plan
SELECT s.step_index, s.operation_type, s.total_elapsed_time, s.row_count, s.command
FROM sys.dm_pdw_exec_requests r
JOIN sys.dm_pdw_request_steps s ON s.request_id = r.request_id
WHERE r.[label] = 'Select REPLICATE with VoteTypeId'



SELECT VoteTypeId, COUNT(UserId) 
FROM [KNdwh].[votes_replicate]
GROUP BY VoteTypeId
OPTION (LABEL = 'Select REPLICATE#2 with VoteTypeId')
;

--Execution Plan
SELECT s.step_index, s.operation_type, s.total_elapsed_time, s.row_count, s.command
FROM sys.dm_pdw_exec_requests r
JOIN sys.dm_pdw_request_steps s ON s.request_id = r.request_id
WHERE r.[label] = 'Select REPLICATE#2 with VoteTypeId'
