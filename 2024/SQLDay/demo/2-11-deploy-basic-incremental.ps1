$ResourceGroupName = 'rg-datafactory'
$DataFactoryName = "BigFactoryTest"
$Location = "UKSouth"
$RootFolder = "D:\GitAz\SQLPlayer\ADF-demo\BigFactoryTest"

# Incremental RUN (new feature!!!)
$o = New-AdfPublishOption
$o.IncrementalDeployment = $true
Publish-AdfV2FromJson -RootFolder "$RootFolder" -ResourceGroupName "$ResourceGroupName" `
    -DataFactoryName "$DataFactoryName" -Location "$Location" -Option $o


