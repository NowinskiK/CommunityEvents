CREATE PROCEDURE [TestClassCRM].[test every table in dbo schema have primary key]
AS
BEGIN
	DECLARE @message NVARCHAR(MAX) = 'every table in [dbo] schema must have a primary key. Please find below tables without a primary key:';
	
	IF OBJECT_ID('#result') IS NOT NULL DROP TABLE #result;
		
	SELECT CONCAT('[',s.[name],'].[',t.[name],']') as [name]
	INTO #result
	FROM [sys].[tables] t
	JOIN [sys].[schemas] s				 ON t.[schema_id] = s.[schema_id]
	LEFT JOIN [sys].[key_constraints] kc ON s.[schema_id] = kc.[schema_id] AND 
											t.[object_id] = kc.[parent_object_id] AND 
											'PK' = kc.[type]
	WHERE
		s.[name] = 'dbo' AND
		kc.[object_id] IS NULL

    EXEC tSQLt.AssertEmptyTable '#result', @message;
END;
GO