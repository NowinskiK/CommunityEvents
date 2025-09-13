# Connect to the database and create a table
Write-Host 'Attempting to connect to the database...'

& SQLCMD.EXE -U 'kamil@azureplayer.net' -S $databaseProperties.ServerFqdn -d $databaseProperties.DatabaseName -G -Q "CREATE TABLE test2 (id int)"





# & SQLCMD.EXE -U 'kamil@azureplayer.net' -S $databaseProperties.ServerFqdn -d $databaseProperties.DatabaseName -G -Q "SELECT 1"

