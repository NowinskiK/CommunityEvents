-- Databricks notebook source
-- MAGIC %run ../utils/_DeltaLakeInit

-- COMMAND ----------

SELECT COUNT(*) FROM silver.stackoverflow_badges 

-- COMMAND ----------

-- MAGIC %python
-- MAGIC delta_location = f"dbfs:/{session}/delta/badges/"
-- MAGIC df = spark.read.parquet(delta_location)
-- MAGIC
