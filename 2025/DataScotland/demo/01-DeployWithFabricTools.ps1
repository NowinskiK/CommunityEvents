#
# https://github.com/dataplat/FabricTools
#

Clear-Host

# 1. Get the access token and add it to the headers
Connect-AzAccount -AuthScope 'https://api.fabric.microsoft.com'
Connect-FabricAccount

$w = Get-FabricWorkspace -WorkspaceName $WorkSpaceName
$w

# 2. Create the database and wait for it to be created.
$name = "AdventureWorksLT"
New-FabricSQLDatabase -workspaceId $w.id -Name $name -Description 'DATA:Scotland'

# 3. List all SQL databases in a Fabric workspace
$list = Get-FabricItem -Workspace $w -type 'sqldatabase'
$list | ft

$db = Get-FabricSQLDatabase -workspaceId $w.id -SQLDatabaseName $name
$databaseProperties = $db.properties

Write-Host "===================================================="
Write-Host "SERVERNAME:  $($databaseProperties.serverFqdn)"
Write-Host "DBNAME:      $($databaseProperties.databaseName)"
Write-Host "LOGIN:       kamil@azureplayer.net"
Write-Host "===================================================="
