# API:
# https://learn.microsoft.com/en-us/rest/api/fabric/core/git/connect?tabs=HTTP




#################################################

##### CURRENTLY DO IT MANUALLY IN FABRIC UI #####

#################################################



# GET https://api.fabric.microsoft.com/v1/workspaces/{workspaceId}/git/connection
$w2 = Get-FabricWorkspace -WorkspaceName 'mslearn-dev'
$response = Invoke-FabricRestMethod -Uri ("workspaces/{0}/git/connection" -f $w2.id) 
$response.gitProviderDetails

# GET https://api.fabric.microsoft.com/v1/workspaces/{workspaceId}/git/myGitCredentials
$response = Invoke-FabricRestMethod -Uri ("workspaces/{0}/git/myGitCredentials" -f $w2.id) 

#POST https://api.fabric.microsoft.com/v1/workspaces/{workspaceId}/git/connect
$body = @{
    gitProviderDetails = @{
        branchName = 'data-scotland'
        directoryName = '/data-scotland'
        gitProviderType = 'AzureDevOps'
        organizationName = 'AzurePlayerBlog'
        projectName = 'Fabric'
        repositoryName = 'Fabric' 
    }
    myGitCredentials = @{
       source = "ConfiguredConnection"
       connectionId = "3f2504e0-4f89-11d3-9a0c-0305e82c3301"
    }
}

$apiEndpointUrl = "workspaces/{0}/git/connect" -f $w.id
$apiParams = @{
    Uri = $apiEndpointUrl
    Method = 'POST'
    Body = $body
    TypeName = 'GIT-Connect'
    HandleResponse = $true
}
$response = Invoke-FabricRestMethod @apiParams
$response
