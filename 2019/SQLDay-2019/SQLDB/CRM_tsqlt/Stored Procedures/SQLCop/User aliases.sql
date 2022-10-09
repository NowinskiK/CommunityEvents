CREATE PROCEDURE [SQLCop].[test User Aliases]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://www.mssqltips.com/tip.asp?tip=1675
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
    Set @Output = ''

    Select @Output = @Output + Name + Char(13) + Char(10)
    From   sysusers 
    Where  IsAliased = 1 
    Order By Name
        
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://www.mssqltips.com/tip.asp?tip=1675'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End 
END;