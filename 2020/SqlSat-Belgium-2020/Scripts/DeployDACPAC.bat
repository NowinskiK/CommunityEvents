echo off
echo --- DACPAC DEPLOYMENT SCRIPT - v.1.30 ---
set prg="c:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe"
rem set prg="c:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\130\sqlpackage.exe" 
set dir1=x:\DEV\AzureDevOps\SQLPlayer\MyDevOps2019\SQLDB
set output=x:\DEV\AzureDevOps\SQLPlayer\MyDevOps2019\Scripts\output
set targetenv=localhost

SET prgtmp=%prg:\=\\%
echo This DacFX will be used: %prg%
WMIC DATAFILE WHERE name=%prgtmp% get Version /format:Textvaluelist

set dir=%dir1%
set db=CRM

:common
set dacpac="%dir%\%db%\bin\Debug\%db%.dacpac"
set profile="%dir%\%db%\%targetenv%.%db%.publish.xml"

echo === Database: %db% ===
echo Start:        %date% %time%
echo Profile:      %profile%
echo Environment:  %targetenv%

rem %prg% /Action:Publish /SourceFile:%dacpac% /Profile:%profile% /dsp:"%output%\%db%.publish.sql" /drp:"%output%\%db%.report.xml" 

REM Publish with overriding target database name
%prg% /TargetDatabaseName:CRM_DEV /Action:Publish /SourceFile:%dacpac% /Profile:%profile% /dsp:"%output%\%db%.publish.sql" /drp:"%output%\%db%.report.xml" 


	
echo ------------------------------------------------------------------------------------------------------------------------

