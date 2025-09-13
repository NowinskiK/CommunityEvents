#
# https://github.com/dataplat/FabricTools
#

Clear-Host

# Import the module
Install-Module FabricTools
Update-Module FabricTools
Remove-Module FabricTools
Import-Module FabricTools
Install-Module PsFramework
Import-Module PsFramework

Get-Module
Get-Command -Module FabricTools

$c = Get-AzContext
$c

# Connect-FabricAccount -TenantId $c.Tenant.Id
Connect-FabricAccount -TenantId $c.Tenant.Id
Get-FabricWorkspace | Format-Table

$WorkSpaceName = 'mslearn-dev'

$w = Get-FabricWorkspace -WorkspaceName $WorkSpaceName
$list = Get-FabricItem -Workspace $w -type 'sqldatabase'
$list | Format-Table

$db = Get-FabricSQLDatabase -workspaceId $w.id -SQLDatabaseName 'testdb5'
Remove-FabricSQLDatabase -workspaceId $w.id -SQLDatabaseId $db.id -Confirm:$false
#Remove-FabricSQLDatabase -workspaceId $w.id -SQLDatabaseId $db.id


# Create new workspace & assign paid capacity

$WorkSpaceName = 'DATA:Scotland'
New-FabricWorkspace -WorkspaceName $WorkSpaceName
$w = Get-FabricWorkspace -WorkspaceName $WorkSpaceName
$w

$fc = Get-FabricCapacity -capacityName 'fabricblogdemof4'
Assign-FabricWorkspaceCapacity -WorkspaceId $w.id -CapacityId $fc.id

Get-FabricWorkspace -WorkspaceId $w.id
