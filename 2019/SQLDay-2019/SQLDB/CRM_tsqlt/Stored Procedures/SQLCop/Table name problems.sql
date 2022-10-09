CREATE PROCEDURE [SQLCop].[test Table name problems]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/do-not-use-spaces-or-other-invalid-chara
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
    DECLARE @AcceptableSymbols VARCHAR(100)

    SET @AcceptableSymbols = '_$'
	SET @Output = ''

	SELECT  @Output = @Output + TABLE_SCHEMA + '.' + TABLE_NAME + Char(13) + Char(10)
    FROM    INFORMATION_SCHEMA.TABLES
    WHERE   TABLE_NAME COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Like '%[^a-z' + @AcceptableSymbols + ']%'
			AND TABLE_SCHEMA <> 'tSQLt'
	ORDER BY TABLE_SCHEMA,TABLE_NAME

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/do-not-use-spaces-or-other-invalid-chara' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;