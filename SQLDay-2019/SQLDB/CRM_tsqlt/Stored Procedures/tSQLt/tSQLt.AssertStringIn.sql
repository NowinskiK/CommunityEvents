﻿
CREATE PROCEDURE tSQLt.AssertStringIn
  @Expected tSQLt.AssertStringTable READONLY,
  @Actual NVARCHAR(MAX),
  @Message NVARCHAR(MAX) = ''
AS
BEGIN
  IF(NOT EXISTS(SELECT 1 FROM @Expected WHERE value = @Actual))
  BEGIN
    DECLARE @ExpectedMessage NVARCHAR(MAX);
    SELECT value INTO #ExpectedSet FROM @Expected;
    EXEC tSQLt.TableToText @TableName = '#ExpectedSet', @OrderBy = 'value',@txt = @ExpectedMessage OUTPUT;
    SET @ExpectedMessage = ISNULL('<'+@Actual+'>','NULL')+CHAR(13)+CHAR(10)+'is not in'+CHAR(13)+CHAR(10)+@ExpectedMessage;
    EXEC tSQLt.Fail @Message, @ExpectedMessage;
  END;
END;
