CREATE PROCEDURE [SQLCop].[test Auto update statistics]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://www.microsoft.com/technet/abouttn/flash/tips/tips_070604.mspx
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''
	
    Select @Output = @Output + 'Database not set to Auto Update Statistics' + Char(13) + Char(10)
    Where  DatabaseProperty(db_name(), 'IsAutoUpdateStatistics') = 0
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://www.microsoft.com/technet/abouttn/flash/tips/tips_070604.mspx'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;