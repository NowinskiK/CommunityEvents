/*

	*** IMPORT THE DATA HERE ***
	Scripts

*/


SELECT TOP (5) * FROM Fact.[Order]
SELECT COUNT(*) FROM Fact.[Order]
SELECT TOP (5) * FROM [Dimension].[City]

SELECT SCHEMA_NAME(o.schema_id), OBJECT_NAME(o.object_id) AS [objectName], * 
FROM sys.stats s
JOIN sys.objects o ON o.object_id = s.object_id
GO


CREATE VIEW Fact.vwTotalIncome
AS
SELECT SUM([Total Including Tax]) AS Income, 
	COUNT(DISTINCT [Order Key]) AS OrderCount,
	COUNT(*) AS CountAll
FROM [Fact].[Order]
GO

SELECT e.[Employee], SUM(o.[Total Including Tax]) AS Income, 
	COUNT(DISTINCT o.[Order Key]) AS OrderCount
FROM [Fact].[Order] o
INNER JOIN [Dimension].[Employee] e ON o.[Salesperson Key] = e.[Employee Key]
GROUP BY e.[Employee]
