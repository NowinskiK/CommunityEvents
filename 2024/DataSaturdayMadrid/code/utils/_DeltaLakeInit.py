# Databricks notebook source
session = "madrid24"
akv_name = "kv-sqlplayer"
akv_name = "kv-blog-dev2"

# COMMAND ----------

storage_account = 'sqlplayer2019'
spark.conf.set(
    f"fs.azure.account.key.{storage_account}.dfs.core.windows.net",
    dbutils.secrets.get(scope=akv_name, key="sqlplayer-blob-key"))

# COMMAND ----------

storage_account_2020 = 'sqlplayer2020'
spark.conf.set(
    f"fs.azure.account.key.{storage_account_2020}.dfs.core.windows.net",
    dbutils.secrets.get(scope=akv_name, key=f"{storage_account_2020}-key"))

# COMMAND ----------

# https://docs.databricks.com/en/storage/azure-storage.html#language-Account%C2%A0key

# COMMAND ----------

spark.conf.set('v.session', session)
spark.conf.set('v.storage_account', storage_account)
spark.conf.set('v.storage_account_2020', storage_account_2020)

print ("Variables initiated.")

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE DATABASE IF NOT EXISTS LakeDb;
# MAGIC CREATE DATABASE IF NOT EXISTS Bronze;
# MAGIC CREATE DATABASE IF NOT EXISTS Silver;
# MAGIC CREATE DATABASE IF NOT EXISTS Gold;

# COMMAND ----------

# MAGIC %sql
# MAGIC USE CATALOG hive_metastore;
# MAGIC
# MAGIC CREATE DATABASE IF NOT EXISTS LakeDb;
# MAGIC CREATE DATABASE IF NOT EXISTS Bronze;
# MAGIC CREATE DATABASE IF NOT EXISTS Silver;
# MAGIC CREATE DATABASE IF NOT EXISTS Gold;

# COMMAND ----------



# COMMAND ----------

# MAGIC %run ./common
