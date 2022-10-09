CREATE PROCEDURE [dbo].[Toggle_Trigger_DimChannel]
	@enable BIT
AS
	IF @enable = 1
		ENABLE TRIGGER dbo.[Trigger_DimChannel] ON dbo.DimChannel;
	ELSE	
		DISABLE TRIGGER dbo.[Trigger_DimChannel] ON dbo.DimChannel;

RETURN 0
