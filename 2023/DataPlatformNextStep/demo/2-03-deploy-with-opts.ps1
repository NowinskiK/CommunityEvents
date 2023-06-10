# Deployment with options

$ResourceGroupName = 'rg-datafactory'
$DataFactoryName = "BigFactoryTest"
$Location = "UKSouth"
$RootFolder = "D:\GitAz\SQLPlayer\ADF-demo\BigFactoryTest"

## Options prep
$o = New-AdfPublishOption
$o.CreateNewInstance = $false
$o.DeleteNotInSource = $true
$o.StopStartTriggers = $false

## Run 
Publish-AdfV2FromJson -RootFolder "$RootFolder" `
    -ResourceGroupName "$ResourceGroupName" `
    -DataFactoryName "$DataFactoryName" `
    -Location "$Location" `
    -Option $o      #  <-------- Publish OPTIONS


