-- Databricks notebook source
-- MAGIC %run ../utils/_DeltaLakeInit

-- COMMAND ----------

-- MAGIC %python
-- MAGIC badges_delta_location = f"{session}/delta/badges/"
-- MAGIC print(badges_delta_location)
-- MAGIC #--TODO: get above location from "location" property of DESCRIBE DETAIL

-- COMMAND ----------

DESCRIBE DETAIL silver.stackoverflow_badges

-- COMMAND ----------

-- MAGIC %python
-- MAGIC display(dbutils.fs.ls(badges_delta_location))
-- MAGIC # 12 items (files+folders)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # Read the table with SQL

-- COMMAND ----------

SELECT * FROM silver.stackoverflow_badges

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## UPDATE

-- COMMAND ----------

-- Update one record
UPDATE silver.stackoverflow_badges
SET Points = Points + 1282
WHERE Id = 82946

-- COMMAND ----------

SELECT * FROM silver.stackoverflow_badges WHERE Id = 82946

-- COMMAND ----------

DESCRIBE DETAIL silver.stackoverflow_badges
-- Check: numFiles

-- COMMAND ----------

-- MAGIC %python
-- MAGIC display(dbutils.fs.ls(badges_delta_location))
-- MAGIC # 12+1+1 = 14 files, but officially 8

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## INSERT

-- COMMAND ----------

-- Insert one record
INSERT INTO silver.stackoverflow_badges (`Id`, `Name`, `Points`, `CreatedOn`)
VALUES (0, 'Guru', 1000, '2023-10-07')


-- COMMAND ----------

-- MAGIC %python
-- MAGIC display(dbutils.fs.ls(badges_delta_location))
-- MAGIC # 14+1 = 15 files, ...

-- COMMAND ----------

DESCRIBE DETAIL silver.stackoverflow_badges
-- Now, number of files is 10 (including the new, tiny one)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## DELETE

-- COMMAND ----------

DELETE FROM silver.stackoverflow_badges WHERE Id = 0 OR Id = 81000

-- COMMAND ----------

-- MAGIC %python
-- MAGIC display(dbutils.fs.ls(badges_delta_location))
-- MAGIC # Now: 15 previous files + 1 deletion vector file...

-- COMMAND ----------

DESCRIBE DETAIL silver.stackoverflow_badges
-- 9 files again (one completely removed)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # Want to learn more? Check TransactionLog

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## GOTO: DESCRIBE

-- COMMAND ----------

-- MAGIC %python
-- MAGIC display(dbutils.fs.ls(f"/{badges_delta_location}/_delta_log/"))

-- COMMAND ----------

-- MAGIC %python
-- MAGIC path = f"/{badges_delta_location}/_delta_log/*.json"
-- MAGIC df1 = spark.read.json(path)
-- MAGIC display(df1)
