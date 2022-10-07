# Deployment with config / other environment

$Env = 'dev2'
$ResourceGroupName = 'rg-devops-factory'
$DataFactoryName = "BigFactorySample2$Env"
$Location = "UKSouth"
$RootFolder = ".\adf1"




## Run case #1: Provide ENV code only
Publish-AdfV2FromJson -RootFolder "$RootFolder" `
    -ResourceGroupName "$ResourceGroupName" `
    -DataFactoryName "$DataFactoryName" `
    -Location "$Location" `
    -Stage $Env -DryRun
