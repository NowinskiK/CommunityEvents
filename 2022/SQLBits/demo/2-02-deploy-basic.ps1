#$SubscriptionName = 'Subscription'
#Set-AzContext -Subscription $SubscriptionName
$ResourceGroupName = 'rg-datafactory'
$DataFactoryName = "BigFactoryTest"
$Location = "UKSouth"
$RootFolder = "D:\GitAz\SQLPlayer\ADF-demo\BigFactoryTest"

# Dry Run (WhatIf)
Publish-AdfV2FromJson -RootFolder "$RootFolder" -ResourceGroupName "$ResourceGroupName" `
    -DataFactoryName "$DataFactoryName" -Location "$Location" -DryRun

# Real run
Publish-AdfV2FromJson -RootFolder "$RootFolder" -ResourceGroupName "$ResourceGroupName" `
    -DataFactoryName "$DataFactoryName" -Location "$Location"


