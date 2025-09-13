# 1. List all SQL Analytics endpoints in a Fabric workspace
$list = Get-FabricItem -Workspace $w -type 'SQLEndpoint'
$list | ft

$endpoint = Get-FabricSQLEndpoint -workspaceId $w.id -SQLEndpointName 'AdventureWorksLT'
$endpoint



# POST https://api.fabric.microsoft.com/v1/workspaces/{workspaceId}/sqlEndpoints/{sqlEndpointId}/refreshMetadata



$invokeParams = @{
    Uri = "workspaces/$($endpoint.workspaceId)/sqlEndpoints/$($endpoint.id)/refreshMetadata"
    Method = 'POST'
    Body = @{ 
        timeout = @{
            timeUnit = "Minutes"
            value = 60
        } 
    }
}
Invoke-FabricRestMethod @invokeParams 


