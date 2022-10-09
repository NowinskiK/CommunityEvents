CREATE PROCEDURE [SQLCop].[test Unnamed Constraints]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/how-to-name-default-constraints-and-how-
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT	@Output = @Output + CONSTRAINT_SCHEMA + '.' + CONSTRAINT_NAME + Char(13) + Char(10)
	From	INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
	Where	CONSTRAINT_NAME collate sql_latin1_general_CP1_CI_AI Like '%[_][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]'
			And TABLE_NAME <> 'sysdiagrams'
			And CONSTRAINT_SCHEMA <> 'tSQLt'
	Order By CONSTRAINT_SCHEMA,CONSTRAINT_NAME

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/how-to-name-default-constraints-and-how-' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End	  
		
END;