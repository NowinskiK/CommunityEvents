USE [CRM]
GO

-- Drop stored procedure if it already exists
DROP PROCEDURE IF EXISTS dbo.GetCustomerDetail;		--'IF EXISTS' - new feature in SQL 2016
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kamil Nowinski
-- Create date: 30/09/2017
-- Description:	Get basic information about customer and additional info from DWH
-- =============================================
CREATE PROCEDURE dbo.GetCustomerDetail
	@CustomerId INT
AS
BEGIN
	SELECT C.[CustomerId], C.[Title], C.[CountryCode], C.[FirstName], C.[Surname], C.[isActive], C.[CustomerTypeCode], C.[Twitter]
		, DC.[YearlyIncome], DC.[TotalChildren], DC.[NumberChildrenAtHome], DC.[DateFirstPurchase]
	FROM [dbo].[Customer] as C
	INNER JOIN [ContosoRetailDW].[dbo].[DimCustomer] as DC ON DC.CustomerKey = C.CustomerId
	WHERE C.CustomerId = @CustomerId;
END
GO

/* TEST
exec dbo.GetCustomerDetail 50

*/

