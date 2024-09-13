# Databricks notebook source
# MAGIC %md-sandbox
# MAGIC
# MAGIC <div style="text-align: center; line-height: 0; padding-top: 9px;">
# MAGIC   <img src="https://azureplayer.net/wp-content/uploads/2023/01/AzurePlayerLogo_h120.png" alt="AzurePlayer Blog" style="width: 600px">
# MAGIC </div>

# COMMAND ----------

# MAGIC %md
# MAGIC
# MAGIC # Delta Lake 101
# MAGIC
# MAGIC There are more and more file formats nowadays: Parquet format is not the best shiny star any longer. Now, the Delta Lake takes the prim.  
# MAGIC Why people do confuse it with Parquet and always talk about files in this case?  
# MAGIC In this session, we'll take a look at the evolution of ETL into ELT and its storage aspect, which explain why it is "a must" for modern data warehouse solutions and how is it related Delta Lake technology in cloud environments like Databricks or Synapse Analytics. Finally, we'll check what's Delta-Parquet creature presented in Microsoft Fabric OneLake recently.   
# MAGIC We will see also what data layers (stages) are commonly set up and why they make sense.
# MAGIC
# MAGIC ## Preparation
# MAGIC 1. Run cluster
# MAGIC 2. Clear output from notebook 1-04 onwards
# MAGIC
# MAGIC ## Demo Agenda
# MAGIC The following files (notebooks) are part of the demo session.
# MAGIC | Notebook | Objectives |
# MAGIC | --- | --- |
# MAGIC | 1-01 - just RUN all    |  Convert CSV to Parquet and to Delta   |
# MAGIC | 1-03 - just show | Create table with location |
# MAGIC | 1-04 | Read, insert & update data (DML) |
# MAGIC | (skip for now) | Transaction Log & DESCRIBE command |
# MAGIC | 2-03 | Time Travel |
# MAGIC | 2-05 | Schema validation & enforcement |
# MAGIC | 3-05 (opt) | Compact files / partition |
# MAGIC

# COMMAND ----------

# MAGIC %md-sandbox
# MAGIC &copy; 2023 Kamil Nowinski<br/>
# MAGIC
