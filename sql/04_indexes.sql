-- Nonclustered indexes on the fact table's most-used foreign keys.

USE WideWorldImportersDW;
GO

CREATE NONCLUSTERED INDEX IX_Fact_DateID     ON dbo.FactClickstreamSession (DateID);
CREATE NONCLUSTERED INDEX IX_Fact_TimeID     ON dbo.FactClickstreamSession (TimeID);
CREATE NONCLUSTERED INDEX IX_Fact_SessionKey ON dbo.FactClickstreamSession (SessionKey);
CREATE NONCLUSTERED INDEX IX_Fact_ProductKey ON dbo.FactClickstreamSession (ProductKey);
GO
