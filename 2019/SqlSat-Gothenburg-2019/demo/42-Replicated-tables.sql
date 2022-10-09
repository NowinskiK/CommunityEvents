SELECT * FROM microsoft.vw_table_sizes


SELECT s.name, o.name, d.distribution_policy_desc
FROM sys.pdw_table_distribution_properties d
JOIN sys.objects o ON o.object_id = d.object_id
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE o.name IN ('Date', 'Order', 'Employee')

--Execution Plan
SELECT s.step_index, s.operation_type
FROM sys.dm_pdw_exec_requests r
JOIN sys.dm_pdw_request_steps s ON s.request_id = r.request_id
WHERE r.[label] = 'Statement:Demo22'

SELECT SUM(FOI.[UKPrice]) AS [TotalSales]
FROM [datawarehouse].[FactOrderItem] AS FOI
INNER JOIN [datawarehouse].[DimDate] AS D ON FOI.[DimBilledDateSKey] = D.DimDateSKey
WHERE D.CalendarYearNumber = 2017
OPTION (LABEL = 'Statement:Demo22')

SELECT e.[Employee], SUM(o.[Total Including Tax]) AS Income, 
	COUNT(DISTINCT o.[Order Key]) AS OrderCount
FROM [Fact].[Order] o
INNER JOIN [Dimension].[Employee] e ON o.[Salesperson Key] = e.[Employee Key]
GROUP BY e.[Employee]
OPTION (LABEL = 'Statement: Demo22.1')

--Execution Plan
SELECT s.step_index, s.operation_type, s.total_elapsed_time, s.row_count, s.command
FROM sys.dm_pdw_exec_requests r
JOIN sys.dm_pdw_request_steps s ON s.request_id = r.request_id
WHERE r.[label] = 'Statement: Demo22.1'
--Look at: ShuffleMoveOperation 
--BroadcastMoveOperation


--Create Replicated table
CREATE TABLE [Dimension].[Employee_Rep]
WITH
( 
    DISTRIBUTION = REPLICATE,
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [Dimension].[Employee]
OPTION (LABEL = 'CTAS : Copy [Dimension].[Employee]')
GO

--Create statistics on new table
CREATE STATISTICS [Employee] ON [Dimension].[Employee_Rep] ([Employee])

--Switch table names
RENAME OBJECT [Dimension].[Employee] TO [Dimension].[Employee_OLD];
RENAME OBJECT [Dimension].[Employee_Rep] TO [Dimension].[Employee];
DROP TABLE [Dimension].[Employee_OLD];
GO


SELECT e.[Employee], SUM(o.[Total Including Tax]) AS Income, 
	COUNT(DISTINCT o.[Order Key]) AS OrderCount
FROM [Fact].[Order] o
INNER JOIN [Dimension].[Employee_Rep] e ON o.[Salesperson Key] = e.[Employee Key]
GROUP BY e.[Employee]
OPTION (LABEL = 'Statement: Demo22.R1')

--Execution Plan
SELECT s.step_index, s.operation_type, s.total_elapsed_time, s.row_count, s.command
FROM sys.dm_pdw_exec_requests r
JOIN sys.dm_pdw_request_steps s ON s.request_id = r.request_id
WHERE r.[label] = 'Statement: Demo22.R1'
--Look at: ShuffleMoveOperation x3

--Again:
SELECT e.[Employee], SUM(o.[Total Including Tax]) AS Income, 
	COUNT(DISTINCT o.[Order Key]) AS OrderCount
FROM [Fact].[Order] o
INNER JOIN [Dimension].[Employee_Rep] e ON o.[Salesperson Key] = e.[Employee Key]
GROUP BY e.[Employee]
OPTION (LABEL = 'Statement: Demo22.R2')

SELECT s.step_index, s.operation_type, s.total_elapsed_time, s.row_count, s.command
FROM sys.dm_pdw_exec_requests r
JOIN sys.dm_pdw_request_steps s ON s.request_id = r.request_id
WHERE r.[label] = 'Statement: Demo22.R2'
