CREATE PROCEDURE [SQLCop].[test Views with order by]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DataDesign/create-a-sorted-view-in-sql-server-2005--2008
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT	@Output = @Output + sysusers.name + '.' + sysobjects.name + Char(13) + Char(10)
	FROM	sysobjects
			INNER JOIN syscomments
			  ON sysobjects.id = syscomments.id
			INNER JOIN sysusers
			  ON sysobjects.uid = sysusers.uid
	WHERE	xtype = 'V'
			and syscomments.text COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI like '%order by%'
			and sysusers.name <> 'tSQLt'
	ORDER BY sysusers.name,sysobjects.name

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DataDesign/create-a-sorted-view-in-sql-server-2005--2008' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End	  
END;