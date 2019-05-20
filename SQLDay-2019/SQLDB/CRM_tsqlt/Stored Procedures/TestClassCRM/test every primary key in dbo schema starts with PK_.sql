CREATE PROCEDURE [TestClassCRM].[test every primary key in dbo schema starts with PK_]
AS
BEGIN
	DECLARE @message NVARCHAR(MAX) = 'Every primary key name in [dbo] schema must start with a "PK_" prefix. Please find below tables without correct prefix:';
	
	IF OBJECT_ID('#result') IS NOT NULL DROP TABLE #result;
		
	SELECT CONCAT('[',s.[name],'].[',t.[name],']') AS [table name],
		   kc.[name] AS [PK name]
	INTO #result
	FROM [sys].[tables] t
	JOIN [sys].[schemas] s			 ON t.[schema_id] = s.[schema_id]
	JOIN [sys].[key_constraints] kc	 ON s.[schema_id] = kc.[schema_id] AND
										t.[object_id] = kc.[parent_object_id]
	WHERE
		s.[name] = 'dbo' AND
		kc.[type] = 'PK' AND
		kc.[name] NOT LIKE 'PK_%'

    EXEC tSQLt.AssertEmptyTable '#result', @message;
END;
GO