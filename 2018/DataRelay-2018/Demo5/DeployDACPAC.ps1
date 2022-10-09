<#
 .SYNOPSIS
 Finds the DAC File that you specify

 .DESCRIPTION
 Looks through the supplied PathList array and searches for the file you specify.  It will return the first one that it finds.

 .PARAMETER FileName
 Name of the file you are looking for

 .PARAMETER PathList
 Array of Paths to search through.

 .EXAMPLE
 Find-File -FileName "Microsoft.SqlServer.TransactSql.ScriptDom.dll" -PathList @("${env:ProgramFiles}\Microsoft SQL Server", "${env:ProgramFiles(x86)}\Microsoft SQL Server")
#>
Function Find-File {
	Param(
		[Parameter(Mandatory=$true)]
		[string]$FileName,
		[Parameter(Mandatory=$true)]
		[string[]]$PathList
	)

    Write-Verbose "Searching for: $FileName"
	$File = $null

	ForEach($Path in $PathList)
	{
		If (!($File))
		{
		    Write-Verbose ("   in: {0}" -f $Path)
			$File = (
				Get-ChildItem $Path -ErrorAction SilentlyContinue -Filter $FileName -Recurse |
				Sort-Object FullName -Descending |
				Select -First 1
				)

			If ($File)
			{
				Write-Verbose ("Found: {0}" -f $File.FullName)
			}
		}
	}

	Return $File
}

<#
 .SYNOPSIS
 Adds the required types so that they can be used

 .DESCRIPTION
 Adds the DacFX types that are required to do database deploys, scripts and deployment reports from SSDT

 .EXAMPLE
 Add-DACAssemblies
#>
Function Add-DACAssemblies {

	Write-Verbose "Loading the DacFX Assemblies"

	$SqlVersion = "140"
    $SearchPathList = @("${env:ProgramFiles(x86)}\Microsoft SQL Server\$SqlVersion\DAC", "${env:ProgramFiles(x86)}\Microsoft SQL Server\$SqlVersion", "${env:ProgramFiles}\Microsoft SQL Server\$SqlVersion" `
	                  , "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\140")
	$ScriptDomDLL = (Find-File -FileName "Microsoft.SqlServer.TransactSql.ScriptDom.dll" -PathList $SearchPathList)
	$DacDLL = (Find-File -FileName "Microsoft.SqlServer.Dac.dll" -PathList $SearchPathList)

	If (!($ScriptDomDLL))
	{
		Throw "Could not find the file: Microsoft.SqlServer.TransactSql.ScriptDom.dll"
	}
	If (!($DacDLL))
	{
		Throw "Could not find the file: Microsoft.SqlServer.Dac.dll"
	}

	Write-Debug ("Adding the type: {0}" -f $ScriptDomDLL.FullName)
	Add-Type -Path $ScriptDomDLL.FullName

	Write-Debug ("Adding the type: {0}" -f $DacDLL.FullName)
	Add-Type -Path $DacDLL.FullName

	Write-Host "Loaded the DAC assemblies"
}


<#
 .SYNOPSIS
 Generates a connection string

 .DESCRIPTION
 Derive a connection string from the supplied variables

 .PARAMETER ServerName
 Name of the server to connect to

 .PARAMETER UseIntegratedSecurity
 Boolean value to indicate if Integrated Security should be used or not

 .PARAMETER UserName
 User name to use if we are not using integrated security

 .PASSWORD Password
 Password to use if we are not using integrated security

 .EXAMPLE
 Get-ConnectionString -ServerName localhost -UseIntegratedSecurity -Database OctopusDeploy

 .EXAMPLE
 Get-ConnectionString -ServerName localhost -UserName sa -Password ProbablyNotSecure -Database OctopusDeploy
#>
Function Get-ConnectionString {
	Param(
		[Parameter(Mandatory=$True)]
		[string]$ServerName,
		[bool]$UseIntegratedSecurity,
		[string]$UserName,
		[string]$Password,
		[string]$Database
	)

	$ApplicationName = "OctopusDeploy"
	$connectionString = ("Application Name={0};Server={1}" -f $ApplicationName, $ServerName)

	If ($UseIntegratedSecurity)
	{
		Write-Verbose "Using integrated security"
		$connectionString += ";Integrated Security=true"
	}
	Else{
		Write-Verbose "Using standard security"
		$connectionString += (";Integrated Security=false;User Id={0};Password={1}" -f $UserName, $Password)
	}

	If ($Database)
	{
		$connectionString += (";Initial Catalog={0}" -f $Database)
	}

	Return $connectionString
}


<#
 .SYNOPSIS
 Invokes the DacPac utility

 .DESCRIPTION
 Used to invoke the actions against the DacFx library.  This utility can generate deployment reports, deployment scripts and execute a deploy

 .PARAMETER Report
 Boolean flag as to whether a deploy report should be generated

 .PARAMETER Script
 Boolean flag as to whether a deployment script should be generated

 .PARAMETER Deploy
 Boolean flag as to whether a deployment should occur

 .PARAMETER DacPacFilename
 Full path as to where we can find the DacPac to use

 .PARAMETER TargetServer
 Name of the server to run the DacPac against

 .PARAMETER TargetDatabase
 Name of the database to run the DacPac against

 .PARAMETER UseIntegratedSecurity
 Flag as to whether we should use integrate security or not

 .PARAMETER UserName
 If we are not using integrated security, we should use this user name to connect to the server

 .PARAMETER Password
 If we are not using integrated security, we should use this password to connect to the server

 .PARAMETER PublishProfile
 Full path to the publish profile we should use

 .EXAMPLE
 Invoke-DacPacUtility

#>
Function Invoke-DacPacUtility {

	Param(
		[string]$DacPacFilename,
		[string]$PublishProfile,
		[bool]$Report,
		[bool]$Script,
		[bool]$Deploy,
		[string]$TargetServer,
		[string]$TargetDatabase,
		[bool]$UseIntegratedSecurity,
		[string]$UserName,
		[string]$Password
	)

	# We output the parameters (excluding password) so that we can see what was supplied for debuging if required.  Useful for variable scoping problems
	Write-Verbose ("Invoke-DacPacUtility called.  Parameter values supplied:")
	Write-Verbose ("    Dacpac Filename:                  {0}" -f $DacPacFilename)
	Write-Verbose ("    Dacpac Profile:                   {0}" -f $PublishProfile)
	Write-Verbose ("    Target server:                    {0}" -f $TargetServer)
	Write-Verbose ("    Target database:                  {0}" -f $TargetDatabase)
	Write-Verbose ("    Using integrated security:        {0}" -f $UseIntegratedSecurity)
	Write-Verbose ("    Username:                         {0}" -f $UserName)
	Write-Verbose ("    Report:                           {0}" -f $Report)
	Write-Verbose ("    Script:                           {0}" -f $Script)
	Write-Verbose ("    Deploy:                           {0}" -f $Deploy)

	$DateTime = ((Get-Date).ToUniversalTime().ToString("yyyyMMddHHmmss"))

	Add-DACAssemblies

	Try {
		$dacPac = [Microsoft.SqlServer.Dac.DacPackage]::Load($DacPacFilename)
		$connectionString = (Get-ConnectionString -ServerName $TargetServer -Database $TargetDatabase -UseIntegratedSecurity $UseIntegratedSecurity -UserName $UserName -Password $Password)
		$dacServices = New-Object Microsoft.SqlServer.Dac.DacServices -ArgumentList $connectionString

		# Register the object events and output them to the verbose stream
		Register-ObjectEvent -InputObject $dacServices -EventName "ProgressChanged" -SourceIdentifier "ProgressChanged" -Action { Write-Verbose ("DacServices: {0}" -f $EventArgs.Message) } | Out-Null
		Register-ObjectEvent -InputObject $dacServices -EventName "Message" -SourceIdentifier "Message" -Action { Write-Host ($EventArgs.Message.Message) } | Out-Null

        $OutputFileName = Join-Path (Split-Path $PublishProfile) "Deployment";
        New-item $OutputFileName -ItemType "directory" -Force

		# Load the publish profile if supplied
		Write-Verbose ("Attempting to load the publish profile: {0}" -f $PublishProfile)

		#Load the publish profile
		$dacProfile = [Microsoft.SqlServer.Dac.DacProfile]::Load($PublishProfile)
		Write-Verbose ("Loaded publish profile: {0}" -f $PublishProfile)

		# Deploy the dacpac
		If ($Deploy)
		{
			Write-Host ("Starting deployment of dacpac against server: {0}, database: {1}" -f $TargetServer, $dacProfile.TargetDatabaseName)
			Write-Host ("using profile: {0}" -f $PublishProfile)
            $options = New-Object Microsoft.SqlServer.Dac.PublishOptions;
            #$options = New-Object Microsoft.SqlServer.Dac.DacDeployOptions;
            $options.GenerateDeploymentScript = $Script;
            $options.GenerateDeploymentReport = $Report;
            $options.DeployOptions = $dacProfile.DeployOptions;

            $result = $dacServices.Publish($dacPac, $TargetDatabase, $options);
            #$result = $dacServices.Deploy($dacPac, $TargetDatabase, $options);

            if ($Report)
            {
			    $reportArtifact = ("{0}\Report_{1}.xml" -f $OutputFileName, $DateTime)
                $result.DeploymentReport | Out-File $reportArtifact
                Write-Host "Output file: $reportArtifact"
            }

            if ($Script)
            {
			    $scriptArtifact = ("{0}\Script_{1}.sql" -f $OutputFileName, $DateTime)
                $result.DatabaseScript | Out-File $scriptArtifact
                Write-Host "Output file: $scriptArtifact"
            }

			Write-Host ("Dacpac deployment complete.")
		}
        else
        {
            if ($Report)
            {
			    $reportArtifact = ("{0}\Report_{1}.xml" -f $OutputFileName, $DateTime)
        	    Write-Host ("Create report for deployment of dacpac against server: {0}, database: {1}" -f $TargetServer, $dacProfile.TargetDatabaseName)
                $dacServices.GenerateDeployReport($dacPac, $TargetDatabase, $dacProfile.DeployOptions) | Out-File $reportArtifact
                Write-Host "Output file: $reportArtifact"
            }
            if ($Script)
            {
			    $scriptArtifact = ("{0}\Script_{1}.sql" -f $OutputFileName, $DateTime)
        	    Write-Host ("Create script for deployment of dacpac against server: {0}, database: {1}" -f $TargetServer, $dacProfile.TargetDatabaseName)
                $dacServices.GenerateDeployScript($dacPac, $TargetDatabase, $dacProfile.DeployOptions) | Out-File $scriptArtifact
                Write-Host "Output file: $scriptArtifact"
            }
        }
		
	}
	Catch {
        Write-Host $Error[0].Exception.ParentContainsErrorRecordException;
		Throw ("Deployment failed: {0} `r`nReason: {1}" -f $_.Exception.Message, $_.Exception.InnerException.Message)
	}
    Finally {
		Unregister-Event -SourceIdentifier "ProgressChanged"
		Unregister-Event -SourceIdentifier "Message"
    }
}

function Get-ScriptDirectory {
    if ($psise) {Split-Path -Path $psise.CurrentFile.FullPath}
    else {$global:PSScriptRoot}
}

# This is modified version of DACPAC deploy template for Octopus
# https://library.octopusdeploy.com/step-template/actiontemplate-sql-deploy-dacpac

# Get the supplied parameters
$SourcePath = Get-ScriptDirectory
$SourcePath = "x:\!WORK\!Moje\2018-10-08 SQLRelay\Demo4"
$TargetServer = "localhost\SQL2016"
$TargetDatabase = "CRM_DEV"
$ProjectName = "CRM"
$UseIntegratedSecurity = $true;
$Username = ""
$Password = ""
$Report = $true
$Script = $true
$Deploy = $true

$SourcePath = $SourcePath + "\" + $ProjectName
$PublishProfile = Join-Path $SourcePath "\$ProjectName.publish.xml"
$DACPACPackageName = Join-Path $SourcePath "bin\Release\$ProjectName.dacpac"
#$DACPACPackageName = Join-Path $DACPACPackageName "$ProjectName.dacpac"

$VerbosePreference="Continue";
Write-Verbose ("    SourcePath:                           {0}" -f $SourcePath)

# Invoke the DacPac utility
Invoke-DacPacUtility -Verbose -DacPacFilename $DACPACPackageName -PublishProfile $PublishProfile -Report $Report -Script $Script -Deploy $Deploy -TargetServer $TargetServer -TargetDatabase $TargetDatabase -UseIntegratedSecurity $UseIntegratedSecurity #-Username $Username -Password $Password



