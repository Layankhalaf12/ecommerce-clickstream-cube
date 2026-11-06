-- E-commerce Clickstream Data Warehouse
-- Star schema: 1 fact table + 10 dimensions, in the dbo schema of WideWorldImportersDW.
-- Run against SQL Server. Dimensions are created first so the fact table's foreign keys resolve.

USE WideWorldImportersDW;
GO

-- ---------- Dimensions ----------

CREATE TABLE dbo.DateDim
(
    DateID       INT          NOT NULL PRIMARY KEY,   -- yyyymmdd
    FullDate     DATE         NOT NULL,
    DayNumber    INT          NOT NULL,
    MonthNumber  INT          NOT NULL,
    YearNumber   INT          NOT NULL,
    MonthName    VARCHAR(20)  NULL,
    IsWeekend    CHAR(1)      NOT NULL                -- 'Y' / 'N'
);

CREATE TABLE dbo.TimeDim
(
    TimeID        INT          NOT NULL PRIMARY KEY,  -- hhmmss
    HourNumber    INT          NOT NULL,
    MinuteNumber  INT          NOT NULL,
    SecondNumber  INT          NOT NULL,
    AMPM          CHAR(2)      NOT NULL,
    PartOfDay     VARCHAR(20)  NULL
);

CREATE TABLE dbo.CustomerDim
(
    CustomerKey   INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName  NVARCHAR(100) NOT NULL,
    Country       NVARCHAR(60)  NULL,
    Region        NVARCHAR(60)  NULL,
    City          NVARCHAR(60)  NULL,
    PostalCode    NVARCHAR(20)  NULL,
    DeviceType    NVARCHAR(40)  NULL
);

CREATE TABLE dbo.ProductDim
(
    ProductKey    INT IDENTITY(1,1) PRIMARY KEY,
    SKU           NVARCHAR(60)  NULL,
    ProductName   NVARCHAR(200) NOT NULL,
    Subcategory   NVARCHAR(100) NULL,
    Category      NVARCHAR(100) NULL,
    Brand         NVARCHAR(100) NULL,
    Status        NVARCHAR(30)  NULL
);

CREATE TABLE dbo.EmployeeDim
(
    EmployeeKey   INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID    VARCHAR(30)   NOT NULL,
    FullName      NVARCHAR(120) NULL,
    Department    NVARCHAR(100) NULL,
    RoleTitle     NVARCHAR(100) NULL
);

CREATE TABLE dbo.PromotionDim
(
    PromotionKey   INT IDENTITY(1,1) PRIMARY KEY,
    PromotionCode  NVARCHAR(60)  NULL,
    PromotionName  NVARCHAR(200) NULL,
    PromotionType  NVARCHAR(40)  NULL,
    StartDate      DATE          NULL,
    EndDate        DATE          NULL
);

CREATE TABLE dbo.PageDim
(
    PageKey        INT IDENTITY(1,1) PRIMARY KEY,
    PageSource     NVARCHAR(50)  NULL,
    PageFunction   NVARCHAR(100) NULL,
    PageTemplate   NVARCHAR(50)  NULL,
    ItemType       NVARCHAR(100) NULL,
    GraphicType    NVARCHAR(100) NULL,
    AnimationType  NVARCHAR(100) NULL,
    SoundType      NVARCHAR(100) NULL,
    PageFileName   NVARCHAR(255) NULL
);

CREATE TABLE dbo.EventDim
(
    EventKey      INT IDENTITY(1,1) PRIMARY KEY,
    EventType     NVARCHAR(100) NOT NULL,
    EventContent  NVARCHAR(100) NULL
);

CREATE TABLE dbo.SessionDim
(
    SessionKey      BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionID       NVARCHAR(64)  NOT NULL,
    SessionType     NVARCHAR(40)  NULL,
    LocalContext    NVARCHAR(100) NULL,
    SessionContext  NVARCHAR(500) NULL,
    ActionSequence  NVARCHAR(500) NULL,
    SuccessStatus   NVARCHAR(50)  NULL,
    CustomerStatus  NVARCHAR(200) NULL
);

CREATE TABLE dbo.ReferralDim
(
    ReferralKey      INT IDENTITY(1,1) PRIMARY KEY,
    ReferralType     NVARCHAR(60)  NULL,
    ReferringURL     NVARCHAR(500) NULL,
    ReferringSite    NVARCHAR(255) NULL,
    ReferringDomain  NVARCHAR(255) NULL,
    SearchType       NVARCHAR(100) NULL,
    Specification    NVARCHAR(500) NULL,
    Target           NVARCHAR(200) NULL
);
GO

-- ---------- Fact ----------
-- Grain: one row per event within a session (timestamped).

CREATE TABLE dbo.FactClickstreamSession
(
    FactSessionID        BIGINT IDENTITY(1,1) PRIMARY KEY,
    DateID               INT    NOT NULL CONSTRAINT FK_Fact_Date      REFERENCES dbo.DateDim(DateID),
    TimeID               INT    NOT NULL CONSTRAINT FK_Fact_Time      REFERENCES dbo.TimeDim(TimeID),
    SessionKey           BIGINT NOT NULL CONSTRAINT FK_Fact_Session   REFERENCES dbo.SessionDim(SessionKey),
    ReferralKey          INT    NULL     CONSTRAINT FK_Fact_Referral  REFERENCES dbo.ReferralDim(ReferralKey),
    CustomerKey          INT    NULL     CONSTRAINT FK_Fact_Customer  REFERENCES dbo.CustomerDim(CustomerKey),
    PromotionKey         INT    NULL     CONSTRAINT FK_Fact_Promotion REFERENCES dbo.PromotionDim(PromotionKey),
    EmployeeKey          INT    NULL     CONSTRAINT FK_Fact_Employee  REFERENCES dbo.EmployeeDim(EmployeeKey),
    ProductKey           INT    NULL     CONSTRAINT FK_Fact_Product   REFERENCES dbo.ProductDim(ProductKey),
    PageKey_Entry        INT    NULL     CONSTRAINT FK_Fact_PageEntry REFERENCES dbo.PageDim(PageKey),
    PageKey_Exit         INT    NULL     CONSTRAINT FK_Fact_PageExit  REFERENCES dbo.PageDim(PageKey),
    EventKey_Last        INT    NULL     CONSTRAINT FK_Fact_EventLast REFERENCES dbo.EventDim(EventKey),

    -- Additive measures
    TotalPagesViewed     INT            NOT NULL DEFAULT 0,
    TotalSessionSeconds  INT            NOT NULL DEFAULT 0,
    OrdersPlaced         INT            NOT NULL DEFAULT 0,
    OrderQuantity        INT            NOT NULL DEFAULT 0,
    OrderDollarAmount    DECIMAL(12,2)  NOT NULL DEFAULT 0,

    -- Degenerate dimension (natural session id)
    SessionId_Natural    VARCHAR(64)    NULL
);
GO
