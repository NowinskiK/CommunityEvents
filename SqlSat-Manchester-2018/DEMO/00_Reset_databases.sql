/*
	PREPARE DATABASES TO IMPORT to SSDT
*/
USE [CRM]
GO

DROP PROCEDURE [dbo].[TempDemo1];
DROP PROCEDURE [dbo].[TempDemo2];
DROP PROCEDURE dbo.Populate_DimChannel_from_CRM;
DROP PROCEDURE dbo.Populate_DimChannel_from_CRM_v1;
DROP PROCEDURE dbo.Populate_DimChannel_from_CRM_v2;
GO
DELETE FROM [dbo].[Action] WHERE ActionId = 5;
GO

select * from [dbo].[Action]





ALTER PROCEDURE [dbo].[TempDemo2]
AS
	
	SELECT * FROM #TempTable;

RETURN 0
GO


-- =============================================
-- Author:		Kamil Nowinski
-- Create date: 30/09/2017
-- Description:	Populate DimChannel from OLTP.
-- =============================================
ALTER PROCEDURE dbo.Populate_DimChannel_from_CRM
AS
BEGIN

PRINT 'Disable trigger'
--Error: Following statement is not understanding by SSDT
ALTER TABLE [ContosoRetailDW].dbo.DimChannel DISABLE TRIGGER dbo.Trigger_DimChannel;

/*
   1. DO some updates or other actions
   2. Enable the trigger again
*/


END
GO
