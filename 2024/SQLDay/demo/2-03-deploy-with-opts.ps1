# Deployment with options

New-AdfPublishOption


$ResourceGroupName = 'rg-datafactory'
$DataFactoryName = "BigFactoryTest"
$Location = "UKSouth"
$RootFolder = "D:\GitAz\SQLPlayer\ADF-demo\BigFactoryTest"

## Options prep
$o = New-AdfPublishOption
$o.CreateNewInstance = $false
$o.DeleteNotInSource = $true
$o.StopStartTriggers = $false
$o.IncrementalDeployment = $true    # NEW Feature!

## Run 
Publish-AdfV2FromJson -RootFolder "$RootFolder" `
    -ResourceGroupName "$ResourceGroupName" `
    -DataFactoryName "$DataFactoryName" `
    -Location "$Location" `
    -Option $o      #  <-------- Publish OPTIONS


# Do it faster!
$o.DeleteNotInSource = $false
# Run the PUBLISH

