--Cell: PYTHON !!!

%%tsql -artifact sqldb1 -type SQLDatabase -bind df2
SELECT TOP (10) [AddressID]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[City]
      ,[StateProvince]
      ,[CountryRegion]
      ,[PostalCode]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [SalesLT].[Address];


-- Using T-SQL magic command as line magic
  df = %tsql SELECT TOP(10) * FROM [ContosoDWH].[dbo].[Geography];


-- Reference Python variables in T-SQL
count = 10

df = %tsql SELECT TOP({count}) * FROM [dw1].[dbo].[Geography];




--
-- https://learn.microsoft.com/en-us/fabric/data-engineering/tsql-magic-command-notebook
--