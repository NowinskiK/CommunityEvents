-- Connect to serwer: sqlplayer.database.windows.net

-- Database: StackOverflow
USE StackOverflow
GO

SELECT * FROM dbo.Votes
--nic -> wygenerowac dane   LUB migrate Stackoverflow 2010 to Azure DB








-- Connect to Azure SQL DW --
SELECT TOP 1000 * FROM [KNdwh].[votes]
SELECT MIN(CreationDate), MAX(CreationDate) FROM [KNdwh].[votes]
--2008-07-31 	2010-12-31 

--Step 1 (master)
CREATE LOGIN SalesDBLogin WITH PASSWORD = 'hegf37^%2ijf21!'
GO

--Step 2 (dwh)
CREATE USER SalesDBUser FOR LOGIN SalesDBLogin
GO

GRANT SELECT ON SCHEMA :: [dbo] TO SalesDBUser
GO

--Step 3 (SQL DB)
CREATE MASTER KEY
GO

CREATE DATABASE SCOPED CREDENTIAL SalesDBElasticCred
WITH IDENTITY = 'SalesDBLogin'
SECRET = 'hegf37^%2ijf21!'
GO

CREATE EXTERNAL DATA SOURCE ArchVotesSrc WITH
(TYPE = RDBMS, LOCATION = 'sqlplayer-dwh.database.windows.net', 
	DATABASE_NAME = 'wwi', CREDENTIAL = SalesDBElasticCred );

--CREATE EXTERNAL TABLE extVotes
-- Has been created in step (72-votes)


--Query 1
SELECT * FROM extVotes

--Query 2
SELECT v.voteId
FROM dbo.[User] u 
INNER JOIN extVotes AS v ON v.UserId = u.UserId
WHERE u.UserId = 68490

--Query 3
CREATE VIEW dbo.VotesElastic 
AS
SELECT 
	[Id], [PostId], [UserId], [BountyAmount], [VoteTypeId], [CreationDate]
FROM dbo.Votes 
WHERE CreationDate >= '20170101'
UNION
SELECT 
	[Id], [PostId], [UserId], [BountyAmount], [VoteTypeId], [CreationDate]
FROM dbo.extVotes 
WHERE CreationDate < '20170101'

--Check
SELECT * FROM dbo.VotesElastic 
