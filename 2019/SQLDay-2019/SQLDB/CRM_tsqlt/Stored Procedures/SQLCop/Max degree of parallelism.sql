CREATE PROCEDURE [SQLCop].[test Max degree of parallelism]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://sqlblog.com/blogs/adam_machanic/archive/2010/05/28/sql-university-parallelism-week-part-3-settings-and-options.aspx
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
    Set @Output = ''

    select @Output = 'Warning: Max degree of parallelism is setup to use all cores'
    from   sys.configurations
    where  name = 'max degree of parallelism'
           and value_in_use = 0
               
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://sqlblog.com/blogs/adam_machanic/archive/2010/05/28/sql-university-parallelism-week-part-3-settings-and-options.aspx'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End  
END;