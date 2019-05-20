CREATE PROCEDURE [SQLCop].[test Missing Foreign Keys]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DataDesign/missing-foreign-key-constraints
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
    DECLARE @AcceptableSymbols VARCHAR(100)

    SET @AcceptableSymbols = '_$'
	SET @Output = ''

	SELECT  @Output = @Output + C.TABLE_SCHEMA + '.' + C.TABLE_NAME + '.' + C.COLUMN_NAME + Char(13) + Char(10)
	FROM    INFORMATION_SCHEMA.COLUMNS C          
	        INNER Join INFORMATION_SCHEMA.TABLES T            
	          ON C.TABLE_NAME = T.TABLE_NAME    
	          AND T.TABLE_TYPE = 'BASE TABLE'
	          AND T.TABLE_SCHEMA = C.TABLE_SCHEMA        
	        LEFT Join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE U            
	          ON C.TABLE_NAME = U.TABLE_NAME            
	          AND C.COLUMN_NAME = U.COLUMN_NAME
	          AND U.TABLE_SCHEMA = C.TABLE_SCHEMA
	WHERE   U.COLUMN_NAME IS Null          
			And C.TABLE_SCHEMA <> 'tSQLt'
	        AND C.COLUMN_NAME COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Like '%id'
	ORDER BY C.TABLE_SCHEMA, C.TABLE_NAME, C.COLUMN_NAME

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DataDesign/missing-foreign-key-constraints' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End			
  
END;