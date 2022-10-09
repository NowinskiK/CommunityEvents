﻿CREATE PROCEDURE tSQLt.Private_CompareTablesFailIfUnequalRowsExists
 @UnequalRowsExist INT,
 @ResultTable NVARCHAR(MAX),
 @ResultColumn NVARCHAR(MAX),
 @ColumnList NVARCHAR(MAX),
 @FailMsg NVARCHAR(MAX)
AS
BEGIN
  IF @UnequalRowsExist > 0
  BEGIN
   DECLARE @TableToTextResult NVARCHAR(MAX);
   DECLARE @OutputColumnList NVARCHAR(MAX);
   SELECT @OutputColumnList = '[_m_],' + @ColumnList;
   EXEC tSQLt.TableToText @TableName = @ResultTable, @OrderBy = @ResultColumn, @PrintOnlyColumnNameAliasList = @OutputColumnList, @txt = @TableToTextResult OUTPUT;
   
   DECLARE @Message NVARCHAR(MAX);
   SELECT @Message = @FailMsg + CHAR(13) + CHAR(10);

    EXEC tSQLt.Fail @Message, @TableToTextResult;
  END;
END
