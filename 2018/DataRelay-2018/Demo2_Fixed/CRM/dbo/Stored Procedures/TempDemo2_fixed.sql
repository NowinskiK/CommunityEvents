CREATE PROCEDURE [dbo].[TempDemo2_fixed]
AS
BEGIN	
	--Trick in nested stored procedure for temp table:
	IF 0=1 CREATE TABLE #TempTable (ID int);	

	SELECT [ID] FROM #TempTable;

RETURN 0
END