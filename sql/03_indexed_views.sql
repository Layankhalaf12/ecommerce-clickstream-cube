-- Indexed (materialized) summary views for fast aggregates.

USE WideWorldImportersDW;
GO

-- Sessions and ordered quantity per product
CREATE VIEW dbo.ProductSummary
WITH SCHEMABINDING
AS
SELECT
    ProductKey,
    COUNT_BIG(*)                       AS SessionCount,
    SUM(OrdersPlaced * OrderQuantity)  AS TotalProductOrdered
FROM dbo.FactClickstreamSession
GROUP BY ProductKey;
GO

CREATE UNIQUE CLUSTERED INDEX IX_ProductSummary
    ON dbo.ProductSummary (ProductKey);
GO

-- Daily totals: sessions, page views, time on site, orders, revenue
CREATE VIEW dbo.VDailySessionSummary
WITH SCHEMABINDING
AS
SELECT
    DateID,
    COUNT_BIG(*)              AS SessionCount,
    SUM(TotalPagesViewed)     AS PagesViewed,
    SUM(TotalSessionSeconds)  AS SessionSeconds,
    SUM(OrdersPlaced)         AS OrdersPlaced,
    SUM(OrderQuantity)        AS OrderQuantity,
    SUM(OrderDollarAmount)    AS OrderRevenue
FROM dbo.FactClickstreamSession
GROUP BY DateID;
GO

CREATE UNIQUE CLUSTERED INDEX IX_VDailySessionSummary
    ON dbo.VDailySessionSummary (DateID);
GO

SELECT * FROM dbo.ProductSummary       ORDER BY ProductKey;
SELECT * FROM dbo.VDailySessionSummary ORDER BY DateID;
