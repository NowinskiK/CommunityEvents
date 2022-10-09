CREATE PROCEDURE [dbo].[TempDemo3_join]
AS
BEGIN	
	CREATE TABLE #TempTable (ID int NOT NULL);	

	--1. This query is being validated
	SELECT C.CustomerId, C.FirstName
	FROM dbo.Customer C

	--2. Above version with bad name of column
	--SELECT C.CustomerId, C.FirstName2
	--FROM dbo.Customer C

	--3. Above version with bad name of column + join to temp table
	--SELECT C.CustomerId, C.FirstName2
	--FROM dbo.Customer C
	--JOIN #TempTable TT on C.CustomerId = TT.ID


RETURN 0
END