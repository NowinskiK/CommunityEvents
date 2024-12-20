--#1 Locally, in the database:
USE [ContosoRetailDW]
GO
DISABLE TRIGGER dbo.[Trigger_DimChannel] ON dbo.DimChannel;
GO

--#2 From other database:
use CRM
GO
ALTER TABLE [ContosoRetailDW].dbo.DimChannel DISABLE TRIGGER [Trigger_DimChannel];
--Problem: Doesn't work in SSDT

--Alternative solution in SSDT:
--#2 Alt.#1
EXEC sp_executeSQL N'ALTER TABLE [ContosoRetailDW].dbo.DimChannel DISABLE TRIGGER [Trigger_DimChannel];'

--#2 Alt.#2
--1. Create SP in the second database (locally for the trigger)
--2. Call that SP.

