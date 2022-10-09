CREATE PROCEDURE [data].[PopulateAll]
AS
BEGIN

	EXEC [data].PopulateAction_v2;
	EXEC [data].[Populate_dbo_Channel];

RETURN 0
END