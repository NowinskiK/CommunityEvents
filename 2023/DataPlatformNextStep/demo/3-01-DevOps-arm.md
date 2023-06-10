# Azure DevOps

## Source Code
Team Project: DataServices  
Repo: ADF-Demo  
Branch: master
folder: adf-repo

## Build Pipeline
NPM steps         : [AdfBuild-with-npm-2](https://dev.azure.com/sqlplayer/DataServices/_build?definitionId=74)  
One SQLPlayer step: [master-adf-repo-CI-sqlbits](https://dev.azure.com/sqlplayer/DataServices/_build?definitionId=75&_a=summary)


## Release Pipeline
[ADF-adf-repo-from-ADFpublish-CD](https://dev.azure.com/sqlplayer/DataServices/_release?_a=releases&view=all&definitionId=6)



## Target
RG: **rg-devops-factory**  
ADF: **adf-repo-UAT**
