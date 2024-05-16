# Azure DevOps

## Source Code
Team Project: DataServices  
Repo: ADF-Demo  
Branch: master
folder: adf-repo

## Build Pipeline
NPM steps         : [AdfBuild-with-npm-2](https://dev.azure.com/sqlplayer/DataServices/_apps/hub/ms.vss-ciworkflow.build-ci-hub?_a=edit-build-definition&id=74)  
One SQLPlayer step: [master-adf-repo-CI-sqlday](https://dev.azure.com/sqlplayer/DataServices/_apps/hub/ms.vss-ciworkflow.build-ci-hub?_a=edit-build-definition&id=75)


## Release Pipeline --- we saw this before (demo 1)
[ADF-adf-repo-from-ADFpublish-CD](https://dev.azure.com/sqlplayer/DataServices/_release?_a=releases&view=all&definitionId=6)



## Target
RG: **rg-devops-factory**  
ADF: **adf-repo-UAT**
