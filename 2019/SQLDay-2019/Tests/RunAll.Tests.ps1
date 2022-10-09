$SqlServerName = "sqlplayer"
$ResourceGroupName = "rg_sql"
$region = "North Europe"
$dbname = "crm"

Set-Location "X:\DEV\AzureDevOps\SQLPlayer\MyDevOps2019"
$dir = Get-Location

$params = @{ 
    ResourceGroupName = $ResourceGroupName
    DbAzureRegion = $region
    SqlServerName = $SqlServerName
    SqlDatabase = $dbname
}
Invoke-Pester -Script @{ Path = "$dir\Tests\Connection.Tests.ps1"; Parameters = $params }

#Connect-AzureRmAccount
#Get-AzureRmResourceGroup -Name $ResourceGroupName
