# Delete SQL database

$WorkSpaceName = 'DATA:Scotland'
$w = Get-FabricWorkspace -WorkspaceName $WorkSpaceName
$w

$name = "AdventureWorksLT"
$db = Get-FabricSQLDatabase -workspaceId $w.id -SQLDatabaseName $name
$db

Remove-FabricSQLDatabase -workspaceId $w.id -SQLDatabaseId $db.id -Confirm:$false

# Delete the workspace
$w
Remove-FabricWorkspace -WorkspaceId $w.id 

