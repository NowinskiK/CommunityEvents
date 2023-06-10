# Deployment with config / other environment

$Env = 'uat'
$ResourceGroupName = 'rg-devops-factory'
$DataFactoryName = "BigFactorySample2$Env"
$Location = "UKSouth"
$RootFolder = "d:\GitAz\SQLPlayer\ADF-demo\BigFactoryTest"




## Run case #1: Provide ENV code only (.)
Publish-AdfV2FromJson -RootFolder "$RootFolder" `
    -ResourceGroupName "$ResourceGroupName" `
    -DataFactoryName "$DataFactoryName" `
    -Location "$Location" `
    -Stage $Env             # <-- This requires config file in location: ./deployment/config-$Env.csv




## Run case #2: Provide full path to config file
$configFile = "$RootFolder\deployment\config-$Env.csv"
Publish-AdfV2FromJson -RootFolder "$RootFolder" `
    -ResourceGroupName "$ResourceGroupName" `
    -DataFactoryName "$DataFactoryName" `
    -Location "$Location" `
    -Stage $configFile      # <-- This param can be either CSV or JSON file format
# Error!
# What you can do?
    

## Run case #3: Provide full path to config file + exclude a few objects from deployment
$configFile = "$RootFolder\deployment\config-$Env.csv"

## Options prep
$o = New-AdfPublishOption
$o.Excludes.Add("*.*IR-DEV2019", "")
$o.Excludes.Add("*.LS_SqlServer_DEV19_AW2017", "")

Publish-AdfV2FromJson -RootFolder "$RootFolder" `
    -ResourceGroupName "$ResourceGroupName" `
    -DataFactoryName "$DataFactoryName" `
    -Location "$Location" `
    -Stage $configFile `
    -Option $o          # Do not forget to add options here

