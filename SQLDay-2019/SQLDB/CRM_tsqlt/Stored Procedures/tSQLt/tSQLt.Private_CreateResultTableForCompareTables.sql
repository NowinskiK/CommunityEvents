﻿CREATE PROCEDURE tSQLt.Private_CreateResultTableForCompareTables
 @ResultTable NVARCHAR(MAX),
 @ResultColumn NVARCHAR(MAX),
 @BaseTable NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Cmd NVARCHAR(MAX);
  SET @Cmd = '
     SELECT ''='' AS ' + @ResultColumn + ', Expected.* INTO ' + @ResultTable + ' 
       FROM tSQLt.Private_NullCellTable N 
       LEFT JOIN ' + @BaseTable + ' AS Expected ON N.I <> N.I 
     TRUNCATE TABLE ' + @ResultTable + ';' --Need to insert an actual row to prevent IDENTITY property from transfering (IDENTITY_COL can't be NULLable);
  EXEC(@Cmd);
END
