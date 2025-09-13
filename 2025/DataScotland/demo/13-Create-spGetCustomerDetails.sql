CREATE PROCEDURE [dbo].[spGetCustomerDetails]
    @customerId int
AS
BEGIN
    SELECT c.CustomerId, c.FirstName, c.LastName
    FROM SalesLT.Customer c
    WHERE CustomerId = @customerId
END