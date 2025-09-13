CREATE PROCEDURE [dbo].[spGetCustomerFullDetails]
    @customerId int
AS
BEGIN
    SELECT c.CustomerId, c.FirstName, c.LastName, 
        a.AddressLine1, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion, a.PostalCode
    FROM SalesLT.Customer c
    INNER JOIN SalesLT.CustomerAddress ca ON ca.CustomerId = c.CustomerId
    INNER JOIN SalesLT.Address a ON a.AddressID = ca.AddressID
    WHERE c.CustomerId = @customerId
END
GO
