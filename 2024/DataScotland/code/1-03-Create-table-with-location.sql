-- Databricks notebook source
-- MAGIC %run ../utils/_DeltaLakeInit

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Control data location
-- MAGIC If you specify only the table name and location,
-- MAGIC the table in the metastore automatically inherits the schema, partitioning, and table properties of the existing data.  
-- MAGIC **This functionality can be used to “import” data into the metastore.**

-- COMMAND ----------

-- MAGIC %python
-- MAGIC delta_location = f"{session}/delta/badges/"
-- MAGIC print(delta_location)
-- MAGIC spark.conf.set('v.badges_delta_location', delta_location)

-- COMMAND ----------

DROP TABLE IF EXISTS silver.stackoverflow_badges

-- COMMAND ----------

CREATE TABLE silver.stackoverflow_badges
USING DELTA
LOCATION 'dbfs:/${v.badges_delta_location}'

-- COMMAND ----------

SELECT * FROM silver.stackoverflow_badges

-- COMMAND ----------

--Query the table
SELECT `Name`, COUNT(*) as RowCount
FROM silver.stackoverflow_badges
GROUP BY `Name`
ORDER BY RowCount DESC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # Optional: Try to create table with location & schema provided

-- COMMAND ----------

CREATE TABLE silver.stackoverflow_badges_2 (
  `Id` INT,
  `Name` STRING,
  `Points` INT,
  `CreatedOn` TIMESTAMP
)
USING DELTA
LOCATION '/${v.badges_delta_location}'

-- COMMAND ----------

-- One column missed
CREATE TABLE silver.stackoverflow_badges_missed_col (
  `Id` INT,
  `Name` STRING,
  `Points` INT
)
USING DELTA
LOCATION '/${v.badges_delta_location}'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # Clean

-- COMMAND ----------

--DROP TABLE IF EXISTS silver.stackoverflow_badges
DROP TABLE IF EXISTS silver.stackoverflow_badges_2

-- COMMAND ----------

-- MAGIC %md
-- MAGIC https://docs.delta.io/latest/delta-batch.html
