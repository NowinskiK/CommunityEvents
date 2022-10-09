--PERMISSIONS
--To query the DMVs in this article, you need either VIEW DATABASE STATE or CONTROL permission. 
--Usually granting VIEW DATABASE STATE is the preferred permission as it is much more restrictive.
GRANT VIEW DATABASE STATE TO myuser;
GO

-- My session id
SELECT session_id();

-- Other Active Connections
SELECT * FROM sys.dm_pdw_exec_sessions where [status] <> 'Closed' and session_id <> session_id();

SELECT * FROM sys.dm_pdw_exec_sessions 
WHERE [status] <> 'Closed' AND [status]<>'idle' and session_id <> session_id()
AND APP_NAME LIKE '.net%' ;


/*

	Monitor query execution

*/
--STEP 1: Identify the query you wish to investigate
-- Monitor active queries
SELECT * FROM sys.dm_pdw_exec_requests 
WHERE [STATUS] not in ('Completed','Failed','Cancelled')
  AND session_id <> session_id()
ORDER BY submit_time DESC;

-- Find top 10 queries longest running queries
SELECT TOP 10 * 
FROM sys.dm_pdw_exec_requests 
ORDER BY total_elapsed_time DESC;

-- Find a query with the Label 'My Query'
-- Use brackets when querying the label column, as it it a key word
SELECT  *
FROM    sys.dm_pdw_exec_requests
WHERE   [label] = 'My Query';



--STEP 2: Investigate the query plan
--Use the Request ID to retrieve the query's distributed SQL (DSQL) plan from sys.dm_pdw_request_steps.

-- Find the distributed query plan steps for a specific query.
-- Replace request_id with value from Step 1.

SELECT * FROM sys.dm_pdw_request_steps
WHERE request_id = 'QID1662'
ORDER BY step_index;



--STEP 3a: Investigate SQL on the distributed databases
-- Find the distribution run times for a SQL step.
-- Replace request_id and step_index with values from Step 1 and 3.

SELECT * FROM sys.dm_pdw_sql_requests
WHERE request_id = 'QID63537' AND step_index = 10;



-- Find the SQL Server execution plan for a query running on a specific SQL Data Warehouse Compute or Control node.
-- Replace distribution_id and spid with values from previous query.

DBCC PDW_SHOWEXECUTIONPLAN(1, 78);


--STEP 3b: Investigate data movement on the distributed databases
-- Find the information about all the workers completing a Data Movement Step.
-- Replace request_id and step_index with values from Step 1 and 3.

SELECT * FROM sys.dm_pdw_dms_workers
WHERE request_id = 'QID63537' AND step_index = 10;
--Check the total_elapsed_time column to see if a particular distribution is taking significantly longer than others for data movement.
--For the long-running distribution, check the rows_processed column to see if the number of rows being moved from that distribution is significantly larger than others. 
--IF so, this finding might indicate skew of your underlying data.


-- Find the SQL Server estimated plan for a query running on a specific SQL Data Warehouse Compute or Control node.
-- Replace distribution_id and spid with values from previous query.

DBCC PDW_SHOWEXECUTIONPLAN(52, 2340);

--   This trick doesn't work:
SELECT CAST ('
<ShowPlanXML xmlns="http://schemas.microsoft.com/sqlserver/2004/07/showplan" Version="1.520" Build="15.0.300.407"><BatchSequence><Batch><Statements><StmtSimple StatementText="insert bulk [tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52]([ADSMKTEmailSentHash] varbinary(8000),[ADSMKTEmailSentChangeHash] varbinary(8000),[ACCOUNT_ID] int,[LIST_ID] int,[CAMPAIGN_ID] int,[LAUNCH_ID] int,[EMAIL_ISP] nvarchar(100) collate SQL_Latin1_General_CP1_CI_AS,[EMAIL_FORMAT] nchar(1) collate SQL_Latin1_General_CP1_CI_AS,[OFFER_SIGNATURE_ID] nvarchar(20) collate SQL_Latin1_General_CP1_CI_AS,[DYNAMIC_CONTENT_SIGNATURE_ID] nvarchar(20) collate SQL_Latin1_General_CP1_CI_AS,[MESSAGE_SIZE] nvarchar(20) collate SQL_Latin1_General_CP1_CI_AS,[SEGMENT_INFO] nvarchar(100) collate SQL_Latin1_General_CP1_CI_AS,[ADSEntityId] uniqueidentifier,[col] tinyint,[col1] bigint,[col2] int,[col3] datetime2(0),[col4] datetime2(0))with(TABLOCK,ROWS_PER_BATCH=10000)" StatementId="1" StatementCompId="1" StatementType="BULK INSERT" RetrievedFromCache="false" StatementSubTreeCost="72.1978" StatementEstRows="10000" SecurityPolicyApplied="false" StatementOptmLevel="FULL" QueryHash="0x56421BAF4E0C54A6" QueryPlanHash="0xF94EEE9556E761AC" CardinalityEstimationModelVersion="130"><StatementSetOptions QUOTED_IDENTIFIER="true" ARITHABORT="false" CONCAT_NULL_YIELDS_NULL="true" ANSI_NULLS="true" ANSI_PADDING="true" ANSI_WARNINGS="true" NUMERIC_ROUNDABORT="false"/><QueryPlan CachedPlanSize="32" CompileTime="358" CompileCPU="1" CompileMemory="224"><MemoryGrantInfo SerialRequiredMemory="0" SerialDesiredMemory="0"/><OptimizerHardwareDependentProperties EstimatedAvailableMemoryGrant="707788" EstimatedPagesCached="2831152" EstimatedAvailableDegreeOfParallelism="32" MaxCompileMemory="294361040"/><RelOp NodeId="0" PhysicalOp="Table Insert" LogicalOp="Insert" EstimateRows="10000" EstimateIO="68.8245" EstimateCPU="0.01" AvgRowSize="9" EstimatedTotalSubtreeCost="72.1978" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row"><OutputList/><Update DMLRequestSort="0"><Object Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" IndexKind="Heap" Storage="RowStore"/><SetPredicate><ScalarOperator ScalarString="[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[ADSMKTEmailSentHash] = [!BulkInsert].[ADSMKTEmailSentHash],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[ADSMKTEmailSentChangeHash] = [!BulkInsert].[ADSMKTEmailSentChangeHash],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[ACCOUNT_ID] = [!BulkInsert].[ACCOUNT_ID],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[LIST_ID] = [!BulkInsert].[LIST_ID],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[CAMPAIGN_ID] = [!BulkInsert].[CAMPAIGN_ID],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[LAUNCH_ID] = [!BulkInsert].[LAUNCH_ID],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[EMAIL_ISP] = [!BulkInsert].[EMAIL_ISP],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[EMAIL_FORMAT] = [!BulkInsert].[EMAIL_FORMAT],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[OFFER_SIGNATURE_ID] = [!BulkInsert].[OFFER_SIGNATURE_ID],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[DYNAMIC_CONTENT_SIGNATURE_ID] = [!BulkInsert].[DYNAMIC_CONTENT_SIGNATURE_ID],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[MESSAGE_SIZE] = [!BulkInsert].[MESSAGE_SIZE],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[SEGMENT_INFO] = [!BulkInsert].[SEGMENT_INFO],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[ADSEntityId] = [!BulkInsert].[ADSEntityId],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[col] = [!BulkInsert].[col],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[col1] = [!BulkInsert].[col1],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[col2] = [!BulkInsert].[col2],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[col3] = [!BulkInsert].[col3],[tempdb].[dbo].[QTable_31f45abb07434f7099f813ec08b50400_52].[col4] = [!BulkInsert].[col4]"><ScalarExpressionList><ScalarOperator><MultipleAssign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="ADSMKTEmailSentHash"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="ADSMKTEmailSentHash"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="ADSMKTEmailSentChangeHash"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="ADSMKTEmailSentChangeHash"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="ACCOUNT_ID"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="ACCOUNT_ID"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="LIST_ID"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="LIST_ID"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="CAMPAIGN_ID"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="CAMPAIGN_ID"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="LAUNCH_ID"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="LAUNCH_ID"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="EMAIL_ISP"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="EMAIL_ISP"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="EMAIL_FORMAT"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="EMAIL_FORMAT"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="OFFER_SIGNATURE_ID"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="OFFER_SIGNATURE_ID"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="DYNAMIC_CONTENT_SIGNATURE_ID"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="DYNAMIC_CONTENT_SIGNATURE_ID"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="MESSAGE_SIZE"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="MESSAGE_SIZE"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="SEGMENT_INFO"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="SEGMENT_INFO"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="ADSEntityId"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="ADSEntityId"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="col"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="col"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="col1"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="col1"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="col2"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="col2"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="col3"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="col3"/></Identifier></ScalarOperator></Assign><Assign><ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[QTable_31f45abb07434f7099f813ec08b50400_52]" Column="col4"/><ScalarOperator><Identifier><ColumnReference Table="[!BulkInsert]" Column="col4"/></Identifier></ScalarOperator></Assign></MultipleAssign></ScalarOperator></ScalarExpressionList></ScalarOperator></SetPredicate><RelOp NodeId="1" PhysicalOp="Remote Scan" LogicalOp="Remote Scan" EstimateRows="10000" EstimateIO="0" EstimateCPU="3.36333" AvgRowSize="8344" EstimatedTotalSubtreeCost="3.36333" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row"><OutputList><ColumnReference Table="[!BulkInsert]" Column="ADSMKTEmailSentHash"/><ColumnReference Table="[!BulkInsert]" Column="ADSMKTEmailSentChangeHash"/><ColumnReference Table="[!BulkInsert]" Column="ACCOUNT_ID"/><ColumnReference Table="[!BulkInsert]" Column="LIST_ID"/><ColumnReference Table="[!BulkInsert]" Column="CAMPAIGN_ID"/><ColumnReference Table="[!BulkInsert]" Column="LAUNCH_ID"/><ColumnReference Table="[!BulkInsert]" Column="EMAIL_ISP"/><ColumnReference Table="[!BulkInsert]" Column="EMAIL_FORMAT"/><ColumnReference Table="[!BulkInsert]" Column="OFFER_SIGNATURE_ID"/><ColumnReference Table="[!BulkInsert]" Column="DYNAMIC_CONTENT_SIGNATURE_ID"/><ColumnReference Table="[!BulkInsert]" Column="MESSAGE_SIZE"/><ColumnReference Table="[!BulkInsert]" Column="SEGMENT_INFO"/><ColumnReference Table="[!BulkInsert]" Column="ADSEntityId"/><ColumnReference Table="[!BulkInsert]" Column="col"/><ColumnReference Table="[!BulkInsert]" Column="col1"/><ColumnReference Table="[!BulkInsert]" Column="col2"/><ColumnReference Table="[!BulkInsert]" Column="col3"/><ColumnReference Table="[!BulkInsert]" Column="col4"/></OutputList><RemoteScan RemoteObject="STREAM"/></RelOp></Update></RelOp></QueryPlan></StmtSimple></Statements></Batch></BatchSequence></ShowPlanXML>'
AS XML)
/*
Msg 104220, Level 16, State 1, Line 83
Cannot find data type 'XML'.
*/


--MONITOR WAITING QUERIES
-- Find queries 
-- Replace request_id with value from Step 1.

SELECT waits.session_id,
      waits.request_id,  
      requests.command,
      requests.status,
      requests.start_time,  
      waits.type,
      waits.state,
      waits.object_type,
      waits.object_name
FROM   sys.dm_pdw_waits waits
   JOIN  sys.dm_pdw_exec_requests requests
   ON waits.request_id=requests.request_id
WHERE waits.request_id = 'QID63537'
ORDER BY waits.object_name, waits.object_type, waits.state;








--https://docs.microsoft.com/en-us/azure/sql-data-warehouse/sql-data-warehouse-manage-monitor
