﻿
CREATE PROCEDURE tSQLt.Private_CreateFakeOfTable
  @SchemaName NVARCHAR(MAX),
  @TableName NVARCHAR(MAX),
  @OrigTableFullName NVARCHAR(MAX),
  @Identity BIT,
  @ComputedColumns BIT,
  @Defaults BIT
AS
BEGIN
   DECLARE @Cmd NVARCHAR(MAX);
   DECLARE @Cols NVARCHAR(MAX);
   
   SELECT @Cols = 
   (
    SELECT
       ',' +
       QUOTENAME(name) + 
       cc.ColumnDefinition +
       dc.DefaultDefinition + 
       id.IdentityDefinition +
       CASE WHEN cc.IsComputedColumn = 1 OR id.IsIdentityColumn = 1 
            THEN ''
            ELSE ' NULL'
       END
      FROM sys.columns c
     CROSS APPLY tSQLt.Private_GetDataTypeOrComputedColumnDefinition(c.user_type_id, c.max_length, c.precision, c.scale, c.collation_name, c.object_id, c.column_id, @ComputedColumns) cc
     CROSS APPLY tSQLt.Private_GetDefaultConstraintDefinition(c.object_id, c.column_id, @Defaults) AS dc
     CROSS APPLY tSQLt.Private_GetIdentityDefinition(c.object_id, c.column_id, @Identity) AS id
     WHERE object_id = OBJECT_ID(@OrigTableFullName)
     ORDER BY column_id
     FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)');
    
   SELECT @Cmd = 'CREATE TABLE ' + @SchemaName + '.' + @TableName + '(' + STUFF(@Cols,1,1,'') + ')';
   
   EXEC (@Cmd);
END;


