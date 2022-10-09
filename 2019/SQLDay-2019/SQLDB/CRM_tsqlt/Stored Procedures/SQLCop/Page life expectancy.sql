CREATE PROCEDURE [SQLCop].[test Page life expectancy]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DBAdmin/MSSQLServerAdmin/use-sys-dm_os_performance_counters-to-ge#PLE
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

	If Exists(Select 1 From fn_my_permissions(NULL, 'SERVER') WHERE permission_name = 'VIEW SERVER STATE')
		SELECT	@Output = @Output + Convert(VarChar(100), cntr_value) + Char(13) + Char(10)
		FROM	sys.dm_os_performance_counters  
		WHERE	counter_name collate SQL_LATIN1_GENERAL_CP1_CI_AI = 'Page life expectancy'
				AND OBJECT_NAME collate SQL_LATIN1_GENERAL_CP1_CI_AI like '%:Buffer Manager%'
				And cntr_value <= 300
	Else
		Set @Output = 'You do not have VIEW SERVER STATE permissions within this instance.'
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBAdmin/MSSQLServerAdmin/use-sys-dm_os_performance_counters-to-ge#PLE'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End 
END;