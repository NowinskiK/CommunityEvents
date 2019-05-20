param(
  [string]$DbAzureRegion,
  [string]$ResourceGroupName,
  [string]$SqlServerName,
  [string]$SqlDatabase
  )

Describe -Name 'Demo SQL Database' -Tags ('ARM','Database') -Fixture {
    Context -Name 'Resource Group' {
        It -name 'Passed Resource Group existence check' -test {
            Get-AzureRmResourceGroup -Name $ResourceGroupName | Should Not Be $null
        }
    }
    
    Context -Name 'Database' {
        $database = Get-AzureRmSqlDatabase -ServerName $SqlServerName -ResourceGroupName $ResourceGroupName -DatabaseName $SqlDatabase
        It -name 'Passed SQL Database existence check' -test {
            $database | Should Not be $null
        }
        It -name 'Passed SQL Database collation check' -test {
            $database.CollationName | Should be 'SQL_Latin1_General_CP1_CI_AS'
        }
        It -name 'Passed SQL Database status check' -test {
            $database.Status | Should be 'Online'
        }
        It -name 'Passed SQL Database Location check' -test {
            $database.Location | Should Be $DbAzureRegion
        }
    }
}

#Get-ExecutionPolicy
#Set-ExecutionPolicy Bypass -Scope Process
#https://marketplace.visualstudio.com/items?itemName=petergroenewegen.PeterGroenewegen-Xpirit-Vsts-Build-Pester&targetId=b2c58c47-cd85-4831-8398-ef9f5b93e786