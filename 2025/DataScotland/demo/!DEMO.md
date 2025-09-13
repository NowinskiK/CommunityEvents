# Agenda

## How to create SQL databases in Fabric

- Fabric UI (simple!)
- Introduction to [FabricTools](./00-FabricTools.ps1)

## Create SQL Database

- Create new database from PowerShell: [01-Deploy](./01-DeployWithFabricTools.ps1)
  - `DATA:Scotland` -> `AdventureWorksLT`

## Import Sample Data to the database & Open in VSCode

1) Fabric UI: Import DEMO dataset
2) Meanwhile: [Connect from VS Code](./02-ConnectFromVSCode.ps1)

## Set up GIT Integration

1) Show DevOps & scripts: [Fabric - Repos](https://dev.azure.com/AzurePlayerBlog/_git/Fabric)
1) Create new branch
1) [Set up Git integration for the Workspace](03-Setup-Git-for-Workspace.ps1)
1) Fabric UI: Sync new database to GIT
1) (optional) [Create new table](./12-Create-new-table.ps1)
1) (optional) Commit to GIT  


## Managing the database

1) Fabric UI: Add function or use Template -> SP: spGetCustomerDetails  
2) Open iv VSCode & alter SP + exec SP in Fabric query editor  

```sql
DECLARE @CustomerId INT = abs(checksum(newid())) % 1000
exec [dbo].[spGetCustomerDetails] @CustomerId
```
or
```sql
DECLARE @CustomerId INT = abs(checksum(newid())) % 1000 + 29000
exec [dbo].[spGetCustomerFullDetails] @CustomerId
```

- Show Performance Dashboard


## VSCode: open database project

Location: `x:\!WORK\GitAz\AzurePlayerBlog\Fabric`

## Run QueryStress app

[SQLQueryStress.exe](x:\!WORK\GitHub\SqlQueryStress\src\SQLQueryStress\bin\windows\Debug\net8.0-windows\SQLQueryStress.exe)


## Optionally

- Show SQL Analytics endpoint
- BUILD database project  
- Run Pipeline to clone data (Product)
- Deploy with SQLPackage
