CREATE PROCEDURE [SQLCop].[test Instant File Initialization]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://www.bradmcgehee.com/2010/07/instant-file-initialization-speeds-sql-server/#more-1704
	
    SET NOCOUNT ON

	DECLARE @Output VarChar(max)
	SET @Output = ''

    CREATE TABLE #Output(Value VarChar(8000))

	If Exists(select * from sys.configurations Where name='xp_cmdshell' and value_in_use = 1)
		Begin
			If Is_SrvRoleMember('sysadmin') = 1
				Begin
					Insert Into #Output EXEC ('xp_cmdshell ''whoami /priv''');

					If Not Exists(Select 1 From #Output Where Value LIKE '%SeManageVolumePrivilege%')
						Select @Output = 'Instant File Initialization disabled'
					Else
						Select	@Output = 'Instant File Initialization disabled'
						From	#Output
						Where	Value LIKE '%SeManageVolumePrivilege%'
								And Value Like '%disabled%'
				End
			Else
				Set @Output = 'You do not have the appropriate permissions to run xp_cmdshell'
		End
	Else
		Begin
			Set @Output = 'xp_cmdshell must be enabled to determine if instant file initialization is enabled.'
		End
	Drop Table #Output

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://www.bradmcgehee.com/2010/07/instant-file-initialization-speeds-sql-server/#more-1704'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End  
END;