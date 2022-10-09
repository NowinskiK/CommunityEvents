CREATE SCHEMA microsoft;
GO



PRINT 'Info: Creating the ''microsoft.vw_query_queue'' view';
GO

CREATE VIEW microsoft.vw_query_queue
AS
SELECT
    *
    , [queued_sec] = DATEDIFF(MILLISECOND, request_time, GETDATE()) / 1000.0
FROM
    sys.dm_pdw_resource_waits
WHERE
    [state] = 'Queued';
GO


PRINT 'Info: Creating the ''microsoft.vw_query_slots'' view';
GO

CREATE VIEW microsoft.vw_query_slots
AS
SELECT
	SUM(CASE WHEN r.[status] = 'Running' THEN 1 ELSE 0 END) [running_queries],
	SUM(CASE WHEN r.[status] = 'Running' THEN rw.concurrency_slots_used ELSE 0 END) [running_queries_slots],
	SUM(CASE WHEN r.[status] = 'Suspended' THEN 1 ELSE 0 END) [queued_queries],
	SUM(CASE WHEN rw.[state] = 'Queued' THEN rw.concurrency_slots_used ELSE 0 END) [queued_queries_slots]
FROM
	sys.dm_pdw_exec_requests r 
	JOIN sys.dm_pdw_resource_waits rw ON rw.request_id = r.request_id
WHERE
	( (r.[status] = 'Running' AND r.resource_class IS NOT NULL ) OR r.[status] ='Suspended' )
	AND rw.[type] = 'UserConcurrencyResourceType';
GO



PRINT 'Info: Creating the ''microsoft.vw_security_role_members'' view';
GO

CREATE VIEW microsoft.vw_security_role_members
AS
SELECT
	r.[name]     AS role_principal_name
	, m.[name]   AS member_principal_name
FROM
	sys.database_role_members rm
	JOIN sys.database_principals AS r ON rm.[role_principal_id] = r.[principal_id]
	JOIN sys.database_principals AS m ON rm.[member_principal_id] = m.[principal_id]
WHERE
	r.[type_desc] = 'DATABASE_ROLE';
GO



PRINT 'Info: Creating the ''microsoft.vw_statistics_age'' view';
GO

CREATE VIEW microsoft.vw_statistics_age AS
SELECT
    sm.[name]                                  AS [schema_name],
    tb.[name]                                  AS [table_name],
    co.[name]                                  AS [stats_column_name],
    st.[name]                                  AS [stats_name],
    STATS_DATE(st.[object_id],st.[stats_id])   AS [stats_last_updated_date]
FROM
    sys.objects ob
    JOIN sys.stats st ON  ob.[object_id] = st.[object_id]
    JOIN sys.stats_columns sc ON  st.[stats_id] = sc.[stats_id]
        AND st.[object_id] = sc.[object_id]
    JOIN sys.columns co ON  sc.[column_id] = co.[column_id]
        AND sc.[object_id] = co.[object_id]
    JOIN sys.types ty ON co.[user_type_id] = ty.[user_type_id]
    JOIN sys.tables tb ON co.[object_id] = tb.[object_id]
    JOIN sys.schemas sm ON tb.[schema_id] = sm.[schema_id]
WHERE
    st.[user_created] = 1;
GO



CREATE VIEW microsoft.vw_table_sizes AS
WITH base AS
(
    SELECT
        GETDATE()                                                              AS  [execution_time]
        , DB_NAME()                                                            AS  [database_name]
        , s.name                                                               AS  [schema_name]
        , t.name                                                               AS  [table_name]
        , QUOTENAME(s.name) + '.' + QUOTENAME(t.name)                          AS  [two_part_name]
        , nt.[name]                                                            AS  [node_table_name]
        , ROW_NUMBER() OVER(PARTITION BY nt.[name] ORDER BY (SELECT NULL))     AS  [node_table_name_seq]
        , tp.[distribution_policy_desc]                                        AS  [distribution_policy_name]
        , c.[name]                                                             AS  [distribution_column]
        , nt.[distribution_id]                                                 AS  [distribution_id]
        , i.[type]                                                             AS  [index_type]
        , i.[type_desc]                                                        AS  [index_type_desc]
        , nt.[pdw_node_id]                                                     AS  [pdw_node_id]
        , pn.[type]                                                            AS  [pdw_node_type]
        , pn.[name]                                                            AS  [pdw_node_name]
        , di.name                                                              AS  [dist_name]
        , di.position                                                          AS  [dist_position]
        , nps.[partition_number]                                               AS  [partition_nmbr]
        , nps.[reserved_page_count]                                            AS  [reserved_space_page_count]
        , nps.[reserved_page_count] - nps.[used_page_count]                    AS  [unused_space_page_count]
        , nps.[in_row_data_page_count] 
            + nps.[row_overflow_used_page_count] 
            + nps.[lob_used_page_count]                                        AS  [data_space_page_count]
        , nps.[reserved_page_count] 
            - (nps.[reserved_page_count] - nps.[used_page_count]) 
            - ([in_row_data_page_count] 
            + [row_overflow_used_page_count]+[lob_used_page_count])            AS  [index_space_page_count]
        , nps.[row_count]                                                      AS  [row_count]
    FROM
        sys.schemas s
        INNER JOIN sys.tables t ON s.[schema_id] = t.[schema_id]
        INNER JOIN sys.indexes i ON  t.[object_id] = i.[object_id]
            AND i.[index_id] <= 1
        INNER JOIN sys.pdw_table_distribution_properties tp ON t.[object_id] = tp.[object_id]
        INNER JOIN sys.pdw_table_mappings tm ON t.[object_id] = tm.[object_id]
        INNER JOIN sys.pdw_nodes_tables nt ON tm.[physical_name] = nt.[name]
        INNER JOIN sys.dm_pdw_nodes pn ON  nt.[pdw_node_id] = pn.[pdw_node_id]
        INNER JOIN sys.pdw_distributions di ON  nt.[distribution_id] = di.[distribution_id]
        INNER JOIN sys.dm_pdw_nodes_db_partition_stats nps ON nt.[object_id] = nps.[object_id]
            AND nt.[pdw_node_id] = nps.[pdw_node_id]
            AND nt.[distribution_id] = nps.[distribution_id]
        LEFT OUTER JOIN (select * from sys.pdw_column_distribution_properties where distribution_ordinal = 1) cdp ON t.[object_id] = cdp.[object_id]
        LEFT OUTER JOIN sys.columns c ON cdp.[object_id] = c.[object_id]
            AND cdp.[column_id] = c.[column_id]
)
, size AS (
    SELECT
        [execution_time]
        , [database_name]
        , [schema_name]
        , [table_name]
        , [two_part_name]
        , [node_table_name]
        , [node_table_name_seq]
        , [distribution_policy_name]
        , [distribution_column]
        , [distribution_id]
        , [index_type]
        , [index_type_desc]
        , [pdw_node_id]
        , [pdw_node_type]
        , [pdw_node_name]
        , [dist_name]
        , [dist_position]
        , [partition_nmbr]
        , [reserved_space_page_count]
        , [unused_space_page_count]
        , [data_space_page_count]
        , [index_space_page_count]
        , [row_count]
        , ([reserved_space_page_count] * 8.0)                                 AS [reserved_space_KB]
        , ([reserved_space_page_count] * 8.0)/1000                            AS [reserved_space_MB]
        , ([reserved_space_page_count] * 8.0)/1000000                         AS [reserved_space_GB]
        , ([reserved_space_page_count] * 8.0)/1000000000                      AS [reserved_space_TB]
        , ([unused_space_page_count]   * 8.0)                                 AS [unused_space_KB]
        , ([unused_space_page_count]   * 8.0)/1000                            AS [unused_space_MB]
        , ([unused_space_page_count]   * 8.0)/1000000                         AS [unused_space_GB]
        , ([unused_space_page_count]   * 8.0)/1000000000                      AS [unused_space_TB]
        , ([data_space_page_count]     * 8.0)                                 AS [data_space_KB]
        , ([data_space_page_count]     * 8.0)/1000                            AS [data_space_MB]
        , ([data_space_page_count]     * 8.0)/1000000                         AS [data_space_GB]
        , ([data_space_page_count]     * 8.0)/1000000000                      AS [data_space_TB]
        , ([index_space_page_count]    * 8.0)                                 AS [index_space_KB]
        , ([index_space_page_count]    * 8.0)/1000                            AS [index_space_MB]
        , ([index_space_page_count]    * 8.0)/1000000                         AS [index_space_GB]
        , ([index_space_page_count]    * 8.0)/1000000000                      AS [index_space_TB]
    FROM base
)
SELECT
    * 
FROM
    size;
GO


PRINT 'Info: Creating the ''microsoft.vw_table_space_by_distribution'' view';
GO

CREATE VIEW microsoft.vw_table_space_by_distribution AS
SELECT 
    distribution_id
    , SUM(row_count)                AS [total_node_distribution_row_count]
    , SUM(reserved_space_MB)        AS [total_node_distribution_reserved_space_MB]
    , SUM(data_space_MB)            AS [total_node_distribution_data_space_MB]
    , SUM(index_space_MB)           AS [total_node_distribution_index_space_MB]
    , SUM(unused_space_MB)          AS [total_node_distribution_unused_space_MB]
FROM
    microsoft.vw_table_sizes
GROUP BY
    distribution_id;
GO

PRINT 'Info: Creating the ''microsoft.vw_table_space_by_distribution_type'' view';
GO



CREATE VIEW microsoft.vw_table_space_by_distribution_type AS
SELECT 
    distribution_policy_name
    , SUM(row_count)                AS [table_type_row_count]
    , SUM(reserved_space_GB)        AS [table_type_reserved_space_GB]
    , SUM(data_space_GB)            AS [table_type_data_space_GB]
    , SUM(index_space_GB)           AS [table_type_index_space_GB]
    , SUM(unused_space_GB)          AS [table_type_unused_space_GB]
FROM
    microsoft.vw_table_sizes
GROUP BY
    distribution_policy_name;
GO



PRINT 'Info: Creating the ''microsoft.vw_table_space_by_index_type'' view';
GO

CREATE VIEW microsoft.vw_table_space_by_index_type AS
SELECT
    index_type_desc
    , SUM(row_count)                AS [table_type_row_count]
    , SUM(reserved_space_GB)        AS [table_type_reserved_space_GB]
    , SUM(data_space_GB)            AS [table_type_data_space_GB]
    , SUM(index_space_GB)           AS [table_type_index_space_GB]
    , SUM(unused_space_GB)          AS [table_type_unused_space_GB]
FROM
    microsoft.vw_table_sizes
GROUP BY
    index_type_desc;
GO



PRINT 'Info: Creating the ''microsoft.vw_table_space_summary'' view';
GO

CREATE VIEW microsoft.vw_table_space_summary AS
SELECT 
    database_name
    , schema_name
    , table_name
    , distribution_policy_name
    , distribution_column
    , index_type_desc
    , COUNT(distinct partition_nmbr) AS [nbr_partitions]
    , SUM(row_count)                 AS [table_row_count]
    , SUM(reserved_space_GB)         AS [table_reserved_space_GB]
    , SUM(data_space_GB)             AS [table_data_space_GB]
    , SUM(index_space_GB)            AS [table_index_space_GB]
    , SUM(unused_space_GB)           AS [table_unused_space_GB]
FROM 
    microsoft.vw_table_sizes
GROUP BY 
    database_name
    , schema_name
    , table_name
    , distribution_policy_name
    , distribution_column
    , index_type_desc;
GO


PRINT 'Info: Creating the ''microsoft.vw_tables_with_skew'' view';
GO

CREATE VIEW microsoft.vw_tables_with_skew AS
SELECT
    *
FROM
    microsoft.vw_table_sizes
WHERE two_part_name IN
(
    SELECT 
        two_part_name
    FROM
        microsoft.vw_table_sizes
    WHERE
        row_count > 0
    GROUP BY
        two_part_name
    HAVING MIN(row_count * 1.000) / MAX(row_count * 1.000) > .10
)
GO


--All views
/*
SELECT * FROM microsoft.vw_query_queue
SELECT * FROM microsoft.vw_query_slots
SELECT * FROM microsoft.vw_security_role_members
SELECT * FROM microsoft.vw_statistics_age
SELECT * FROM microsoft.vw_table_sizes
SELECT * FROM microsoft.vw_table_space_by_distribution
SELECT * FROM microsoft.vw_table_space_by_distribution_type
SELECT * FROM microsoft.vw_table_space_by_index_type
SELECT * FROM microsoft.vw_table_space_summary
SELECT * FROM microsoft.vw_tables_with_skew
--vdmsbufferdensity
*/

SELECT * FROM microsoft.vw_table_sizes WHERE [table_name] = 'taxi_full'

