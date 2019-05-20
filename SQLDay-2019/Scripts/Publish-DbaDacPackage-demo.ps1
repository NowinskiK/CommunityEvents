# Publish-DbaDacPackage
# src: https://docs.dbatools.io/#Publish-DbaDacPackage
#

# Install
Install-Module dbatools
Get-Module 
Import-Module dbatools

# Init
$config = @{
    "ENV" = "LOCALHOST";
    "Database" = "CRM";
    "DACPACPath" = "x:\DEV\AzureDevOps\SQLPlayer\MyDevOps2019\SQLDB\";
    "Report" = "True";
    "Script" = "True";
    "Deploy" = "True";
    "TargetServer" = "LOCALHOST";
    "TargetDatabase" = "CRM_sqlday";
  };

$CurrentPath = Get-Location  
$SourcePath = $config["DACPACPath"]
$SourcePath = Join-Path $SourcePath $config["Database"]
$PublishProfile = Join-Path $SourcePath ("\{0}.{1}.publish.xml" -f $config['ENV'], $config["Database"])
$DACPACPackageName = Join-Path $SourcePath ("bin\Release\{0}.dacpac" -f $config["Database"])
$OutputFolder = Join-Path $CurrentPath "Scripts\output"

# $DeployOptions = @{AllowDropBlockingAssemblies=False; AllowIncompatiblePlatform=False; BackupDatabaseBeforeChanges=False;
#     BlockOnPossibleDataLoss=True; BlockWhenDriftDetected=True; CommandTimeout=60; CommentOutSetVarDeclarations=False; CompareUsingTargetCollation=False; CreateNewDatabase=False;
#     DatabaseSpecification=Microsoft.SqlServer.Dac.DacAzureDatabaseSpecification; DeployDatabaseInSingleUserMode=False; DisableAndReenableDdlTriggers=True;
#     DoNotAlterChangeDataCaptureObjects=True; DoNotAlterReplicatedObjects=True; DoNotDropObjectTypes=True; DropConstraintsNotInSource=True; DropDmlTriggersNotInSource=True;
#     DropExtendedPropertiesNotInSource=True; DropIndexesNotInSource=True; DropObjectsNotInSource=False; DropPermissionsNotInSource=False; DropRoleMembersNotInSource=False;
#     DropStatisticsNotInSource=True; GenerateSmartDefaults=False; IgnoreAnsiNulls=True; IgnoreAuthorizer=False; IgnoreColumnCollation=False; IgnoreColumnOrder=False; IgnoreComments=False;
#     IgnoreCryptographicProviderFilePath=True; IgnoreDdlTriggerOrder=False; IgnoreDdlTriggerState=False; IgnoreDefaultSchema=False; IgnoreDmlTriggerOrder=False;
#     IgnoreDmlTriggerState=False; IgnoreExtendedProperties=False; IgnoreFileAndLogFilePath=True; IgnoreFilegroupPlacement=True; IgnoreFileSize=True; IgnoreFillFactor=True;
#     IgnoreFullTextCatalogFilePath=True; IgnoreIdentitySeed=False; IgnoreIncrement=False; IgnoreIndexOptions=False; IgnoreIndexPadding=True; IgnoreKeywordCasing=True;
#     IgnoreLockHintsOnIndexes=False; IgnoreLoginSids=True; ExcludeObjectTypes=False; IgnoreNotForReplication=False; IgnoreObjectPlacementOnPartitionScheme=True; IgnorePartitionSchemes=False;
#     IgnorePermissions=False; IgnoreQuotedIdentifiers=True; IgnoreRoleMembership=False; IgnoreRouteLifetime=True; IgnoreSemicolonBetweenStatements=True; IgnoreTableOptions=False;
#     IgnoreUserSettingsObjects=False; IgnoreWhitespace=True; IgnoreWithNocheckOnCheckConstraints=False; IgnoreWithNocheckOnForeignKeys=False;
#     AllowUnsafeRowLevelSecurityDataMovement=False; IncludeCompositeObjects=True; IncludeTransactionalScripts=False; NoAlterStatementsToChangeClrTypes=False;
#     PopulateFilesOnFileGroups=True; RegisterDataTierApplication=False; RunDeploymentPlanExecutors=False; ScriptDatabaseCollation=False; ScriptDatabaseCompatibility=False;
#     ScriptDatabaseOptions=True; ScriptDeployStateChecks=False; ScriptFileSize=False; ScriptNewConstraintValidation=True; ScriptRefreshModule=True;
#     TreatVerificationErrorsAsWarnings=False; UnmodifiableObjectWarnings=True; VerifyCollationCompatibility=True; VerifyDeployment=True}


Publish-DbaDacPackage -SqlInstance $config["TargetServer"] -Database $config["TargetDatabase"] `
    -Path $DACPACPackageName `
    -PublishXml $PublishProfile -OutputPath $OutputFolder `
    -GenerateDeploymentScript -ScriptOnly -GenerateDeploymentReport

Publish-DbaDacPackage -SqlInstance $config["TargetServer"] -Database $config["TargetDatabase"] `
    -Path $DACPACPackageName `
    -PublishXml $PublishProfile -OutputPath $OutputFolder


#
# Publish with options
#

$options = New-DbaDacOption -Type Dacpac -Action Publish
$options.DeployOptions.DropObjectsNotInSource = $true
Publish-DbaDacPackage -SqlInstance $config["TargetServer"] -Database $config["TargetDatabase"] `
    -Path $DACPACPackageName `
    -PublishXml $PublishProfile -OutputPath $OutputFolder `
    -DacOption $options

