﻿
CREATE VIEW tSQLt.Tests
AS
  SELECT classes.SchemaId, classes.Name AS TestClassName, 
         procs.object_id AS ObjectId, procs.name AS Name
    FROM tSQLt.TestClasses classes
    JOIN sys.procedures procs ON classes.SchemaId = procs.schema_id
   WHERE LOWER(procs.name) LIKE 'test%';
