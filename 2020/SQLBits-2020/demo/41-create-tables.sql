CREATE SCHEMA Dimension;
GO

CREATE SCHEMA Fact;
GO

CREATE SCHEMA Integration;
GO


CREATE TABLE [Dimension].[Customer] ([Customer Key] Int NOT NULL
,[WWI Customer ID] Int NOT NULL
,[Customer] NVarchar(100) NOT NULL
,[Bill To Customer] NVarchar(100) NOT NULL
,[Category] NVarchar(50) NOT NULL
,[Buying Group] NVarchar(50) NOT NULL
,[Primary Contact] NVarchar(50) NOT NULL
,[Postal Code] NVarchar(10) NOT NULL
,[Valid From] DateTime2 NOT NULL
,[Valid To] DateTime2 NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Dimension].[Date] ([Date] Date NOT NULL
,[Day Number] Int NOT NULL
,[Day] NVarchar(10) NOT NULL
,[Month] NVarchar(10) NOT NULL
,[Short Month] NVarchar(3) NOT NULL
,[Calendar Month Number] Int NOT NULL
,[Calendar Month Label] NVarchar(20) NOT NULL
,[Calendar Year] Int NOT NULL
,[Calendar Year Label] NVarchar(10) NOT NULL
,[Fiscal Month Number] Int NOT NULL
,[Fiscal Month Label] NVarchar(20) NOT NULL
,[Fiscal Year] Int NOT NULL
,[Fiscal Year Label] NVarchar(10) NOT NULL
,[ISO Week Number] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Dimension].[Employee] ([Employee Key] Int NOT NULL
,[WWI Employee ID] Int NOT NULL
,[Employee] NVarchar(50) NOT NULL
,[Preferred Name] NVarchar(50) NOT NULL
,[Is Salesperson] Bit NOT NULL
,[Photo] Varbinary(8000) NULL
,[Valid From] DateTime2 NOT NULL
,[Valid To] DateTime2 NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Dimension].[Payment Method] ([Payment Method Key] Int NOT NULL
,[WWI Payment Method ID] Int NOT NULL
,[Payment Method] NVarchar(50) NOT NULL
,[Valid From] DateTime2 NOT NULL
,[Valid To] DateTime2 NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Dimension].[Stock Item] ([Stock Item Key] Int NOT NULL
,[WWI Stock Item ID] Int NOT NULL
,[Stock Item] NVarchar(100) NOT NULL
,[Color] NVarchar(20) NOT NULL
,[Selling Package] NVarchar(50) NOT NULL
,[Buying Package] NVarchar(50) NOT NULL
,[Brand] NVarchar(50) NOT NULL
,[Size] NVarchar(20) NOT NULL
,[Lead Time Days] Int NOT NULL
,[Quantity Per Outer] Int NOT NULL
,[Is Chiller Stock] Bit NOT NULL
,[Barcode] NVarchar(50) NULL
,[Tax Rate] Decimal(18,3) NOT NULL
,[Unit Price] Decimal(18,2) NOT NULL
,[Recommended Retail Price] Decimal(18,2) NULL
,[Typical Weight Per Unit] Decimal(18,3) NOT NULL
,[Photo] Varbinary(8000) NULL
,[Valid From] DateTime2 NOT NULL
,[Valid To] DateTime2 NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Dimension].[Supplier] ([Supplier Key] Int NOT NULL
,[WWI Supplier ID] Int NOT NULL
,[Supplier] NVarchar(100) NOT NULL
,[Category] NVarchar(50) NOT NULL
,[Primary Contact] NVarchar(50) NOT NULL
,[Supplier Reference] NVarchar(20) NULL
,[Payment Days] Int NOT NULL
,[Postal Code] NVarchar(10) NOT NULL
,[Valid From] DateTime2 NOT NULL
,[Valid To] DateTime2 NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Dimension].[Transaction Type] ([Transaction Type Key] Int NOT NULL
,[WWI Transaction Type ID] Int NOT NULL
,[Transaction Type] NVarchar(50) NOT NULL
,[Valid From] DateTime2 NOT NULL
,[Valid To] DateTime2 NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Fact].[Movement] ([Movement Key] BigInt NOT NULL
,[Date Key] Date NOT NULL
,[Stock Item Key] Int NOT NULL
,[Customer Key] Int NULL
,[Supplier Key] Int NULL
,[Transaction Type Key] Int NOT NULL
,[WWI Stock Item Transaction ID] Int NOT NULL
,[WWI Invoice ID] Int NULL
,[WWI Purchase Order ID] Int NULL
,[Quantity] Int NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Fact].[Order] ([Order Key] BigInt NOT NULL
,[City Key] Int NOT NULL
,[Customer Key] Int NOT NULL
,[Stock Item Key] Int NOT NULL
,[Order Date Key] Date NOT NULL
,[Picked Date Key] Date NULL
,[Salesperson Key] Int NOT NULL
,[Picker Key] Int NULL
,[WWI Order ID] Int NOT NULL
,[WWI Backorder ID] Int NULL
,[Description] NVarchar(100) NOT NULL
,[Package] NVarchar(50) NOT NULL
,[Quantity] Int NOT NULL
,[Unit Price] Decimal(18,2) NOT NULL
,[Tax Rate] Decimal(18,3) NOT NULL
,[Total Excluding Tax] Decimal(18,2) NOT NULL
,[Tax Amount] Decimal(18,2) NOT NULL
,[Total Including Tax] Decimal(18,2) NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Fact].[Purchase] ([Purchase Key] BigInt NOT NULL
,[Date Key] Date NOT NULL
,[Supplier Key] Int NOT NULL
,[Stock Item Key] Int NOT NULL
,[WWI Purchase Order ID] Int NULL
,[Ordered Outers] Int NOT NULL
,[Ordered Quantity] Int NOT NULL
,[Received Outers] Int NOT NULL
,[Package] NVarchar(50) NOT NULL
,[Is Order Finalized] Bit NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Fact].[Sale] ([Sale Key] BigInt NOT NULL
,[City Key] Int NOT NULL
,[Customer Key] Int NOT NULL
,[Bill To Customer Key] Int NOT NULL
,[Stock Item Key] Int NOT NULL
,[Invoice Date Key] Date NOT NULL
,[Delivery Date Key] Date NULL
,[Salesperson Key] Int NOT NULL
,[WWI Invoice ID] Int NOT NULL
,[Description] NVarchar(100) NOT NULL
,[Package] NVarchar(50) NOT NULL
,[Quantity] Int NOT NULL
,[Unit Price] Decimal(18,2) NOT NULL
,[Tax Rate] Decimal(18,3) NOT NULL
,[Total Excluding Tax] Decimal(18,2) NOT NULL
,[Tax Amount] Decimal(18,2) NOT NULL
,[Profit] Decimal(18,2) NOT NULL
,[Total Including Tax] Decimal(18,2) NOT NULL
,[Total Dry Items] Int NOT NULL
,[Total Chiller Items] Int NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Fact].[Stock Holding] ([Stock Holding Key] BigInt NOT NULL
,[Stock Item Key] Int NOT NULL
,[Quantity On Hand] Int NOT NULL
,[Bin Location] NVarchar(20) NOT NULL
,[Last Stocktake Quantity] Int NOT NULL
,[Last Cost Price] Decimal(18,2) NOT NULL
,[Reorder Level] Int NOT NULL
,[Target Stock Level] Int NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Fact].[Transaction] ([Transaction Key] BigInt NOT NULL
,[Date Key] Date NOT NULL
,[Customer Key] Int NULL
,[Bill To Customer Key] Int NULL
,[Supplier Key] Int NULL
,[Transaction Type Key] Int NOT NULL
,[Payment Method Key] Int NULL
,[WWI Customer Transaction ID] Int NULL
,[WWI Supplier Transaction ID] Int NULL
,[WWI Invoice ID] Int NULL
,[WWI Purchase Order ID] Int NULL
,[Supplier Invoice Number] NVarchar(20) NULL
,[Total Excluding Tax] Decimal(18,2) NOT NULL
,[Tax Amount] Decimal(18,2) NOT NULL
,[Total Including Tax] Decimal(18,2) NOT NULL
,[Outstanding Balance] Decimal(18,2) NOT NULL
,[Is Finalized] Bit NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Dimension].[City] ([City Key] Int NOT NULL
,[WWI City ID] Int NOT NULL
,[City] NVarchar(50) NOT NULL
,[State Province] NVarchar(50) NOT NULL
,[Country] NVarchar(60) NOT NULL
,[Continent] NVarchar(30) NOT NULL
,[Sales Territory] NVarchar(50) NOT NULL
,[Region] NVarchar(30) NOT NULL
,[Subregion] NVarchar(30) NOT NULL
,[Latest Recorded Population] BigInt NOT NULL
,[Valid From] DateTime2 NOT NULL
,[Valid To] DateTime2 NOT NULL
,[Lineage Key] Int NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Integration].[Lineage] ([Lineage Key] Int NOT NULL
,[Data Load Started] DateTime2 NOT NULL
,[Table Name] NVarchar(128) NOT NULL
,[Data Load Completed] DateTime2 NULL
,[Was Successful] Bit NOT NULL
,[Source System Cutoff Time] DateTime2 NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)

CREATE TABLE [Integration].[ETL Cutoff] ([Table Name] NVarchar(128) NOT NULL
,[Cutoff Time] DateTime2 NOT NULL
) WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)



