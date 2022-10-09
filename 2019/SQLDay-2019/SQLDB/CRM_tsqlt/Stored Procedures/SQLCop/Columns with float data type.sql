CREATE PROCEDURE [SQLCop].[test Columns with float data type]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/do-not-use-the-float-data-type
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''
			
	SELECT 	@Output = @Output + TABLE_SCHEMA + '.' + TABLE_NAME + '.' + COLUMN_NAME + Char(13) + Char(10)
	FROM	INFORMATION_SCHEMA.COLUMNS
	WHERE	DATA_TYPE IN ('float', 'real')
			AND TABLE_SCHEMA <> 'tSQLt'
	Order By TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/do-not-use-the-float-data-type' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
	    
END;