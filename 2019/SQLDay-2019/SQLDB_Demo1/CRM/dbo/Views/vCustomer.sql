CREATE VIEW dbo.vCustomer
AS
SELECT [CustomerId]
      ,[RegionCode]
      ,[Title]
      ,[CountryCode]
      ,[FirstName]
      ,[Surname]
      ,[isActive]
      ,[InactiveDate]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[CustomerTypeCode]
      ,[Twitter]
  FROM [CRM].[dbo].[Customer]

