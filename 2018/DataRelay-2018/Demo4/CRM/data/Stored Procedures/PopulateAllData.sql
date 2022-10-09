CREATE PROCEDURE [data].[PopulateAllData]
AS
BEGIN
	--EXECUTE [data].[PopulateAction_v1];
	EXECUTE [data].[PopulateAction_v2];
	--EXECUTE [data].[PopulateAction_v3];
RETURN 0
END