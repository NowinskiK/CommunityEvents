CREATE PROCEDURE [dbo].[TempDemo2]
AS
	
	IF 0=1 CREATE TABLE #TempTable (ID int);	

	SELECT * FROM #TempTable;

RETURN 0
