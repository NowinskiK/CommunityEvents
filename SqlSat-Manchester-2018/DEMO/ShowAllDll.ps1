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
		Write-Verbose ("   in: {0}" -f $Path)
		$File = (
			Get-ChildItem $Path -ErrorAction SilentlyContinue -Filter $FileName -Recurse |
			Sort-Object FullName -Descending |
			Select -First 1
			)

		If ($File)
		{
			Write-Host ("Found: {0}" -f $File.FullName)
            $fv = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($File.FullName).FileVersion
            Write-Host "version: $fv"
		}
	}

	Return $File
}


Function List-DACAssemblies {

	Write-Verbose "Loading the DacFX Assemblies"

	$SqlVersion = "140"
    $SearchPathList = @("${env:ProgramFiles(x86)}\Microsoft SQL Server\$SqlVersion\DAC", "${env:ProgramFiles(x86)}\Microsoft SQL Server\$SqlVersion", "${env:ProgramFiles}\Microsoft SQL Server\$SqlVersion" `
	                  , "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\140")
	$ScriptDomDLL = (Find-File -FileName "Microsoft.SqlServer.TransactSql.ScriptDom.dll" -PathList $SearchPathList)
	$DacDLL = (Find-File -FileName "Microsoft.SqlServer.Dac.dll" -PathList $SearchPathList)
	$sqlpackagexe = (Find-File -FileName "sqlpackage.exe" -PathList $SearchPathList)

}

$VerbosePreference="Continue";
List-DACAssemblies
