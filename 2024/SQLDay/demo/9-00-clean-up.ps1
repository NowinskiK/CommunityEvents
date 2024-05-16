$SubscriptionName = 'MVP'
Set-AzContext -Subscription $SubscriptionName


$ResourceGroupName = 'rg-datafactory'
$DataFactoryName = "BigFactoryTest"
# Get-AzDataFactoryV2 -ResourceGroupName $ResourceGroupName -Name $DataFactoryName
Remove-AzDataFactoryV2 -ResourceGroupName $ResourceGroupName -Name $DataFactoryName -Force


$ResourceGroupName = 'rg-devops-factory'
$DataFactoryName = "BigFactorySample2uat"
# Get-AzDataFactoryV2 -ResourceGroupName $ResourceGroupName -Name $DataFactoryName
Remove-AzDataFactoryV2 -ResourceGroupName $ResourceGroupName -Name $DataFactoryName -Force
