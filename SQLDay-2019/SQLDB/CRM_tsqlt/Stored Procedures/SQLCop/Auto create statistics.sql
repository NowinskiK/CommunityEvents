CREATE PROCEDURE [SQLCop].[test Auto create statistics]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://www.sql-server-performance.com/tips/optimizing_indexes_general_p1.aspx
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

    Select @Output = @OUtput + 'Database not set to Auto Create Statistics' + Char(13) + Char(10)
    Where  DatabaseProperty(db_name(), 'IsAutoCreateStatistics') = 0
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://www.sql-server-performance.com/tips/optimizing_indexes_general_p1.aspx'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;