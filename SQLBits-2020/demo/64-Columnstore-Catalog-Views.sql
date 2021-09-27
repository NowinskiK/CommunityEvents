/*
	State of various row groups (open, closed, compressed)
	Total rows
*/
SELECT TOP 100 OBJECT_NAME(object_id) AS ObjectName, *
FROM sys.pdw_nodes_column_store_row_groups
WHERE OBJECT_NAME(object_id) = 'taxi5'

/*
	Encoding used
	Dictionary id
	Min,max metadata
*/
SELECT TOP 100 * FROM sys.pdw_nodes_column_store_segments

/*
	On disk dictionary size
*/
SELECT TOP 100 * FROM sys.pdw_nodes_column_store_dictionaries

