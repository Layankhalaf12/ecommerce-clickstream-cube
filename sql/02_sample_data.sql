-- Sample rows so the views and the cube have data to show.

USE WideWorldImportersDW;
GO

INSERT INTO dbo.DateDim (DateID, FullDate, DayNumber, MonthNumber, YearNumber, MonthName, IsWeekend) VALUES
(20251025, '2025-10-25', 25, 10, 2025, 'October', 'Y'),
(20251026, '2025-10-26', 26, 10, 2025, 'October', 'Y'),
(20251027, '2025-10-27', 27, 10, 2025, 'October', 'N');

INSERT INTO dbo.TimeDim (TimeID, HourNumber, MinuteNumber, SecondNumber, AMPM, PartOfDay) VALUES
(120000, 12, 0, 0, 'PM', 'Afternoon'),
(130000, 13, 0, 0, 'PM', 'Afternoon'),
(150000, 15, 0, 0, 'PM', 'Afternoon');

INSERT INTO dbo.CustomerDim (CustomerName, Country, Region, City, PostalCode, DeviceType) VALUES
('Zaina',  'Canada', 'ON', 'Toronto',     'M5A1A1', 'Desktop'),
('Hassan', 'Canada', 'ON', 'Mississauga', 'L5B3Y2', 'Mobile');

INSERT INTO dbo.ProductDim (SKU, ProductName, Subcategory, Category, Brand, Status) VALUES
('SKU1001', 'Laptop',     'Computers', 'Electronics', 'TechBrand',  'Active'),
('SKU2001', 'Headphones', 'Audio',     'Electronics', 'SoundBrand', 'Active'),
('UNK',     'Unknown',    NULL,        NULL,          NULL,         'Active');

INSERT INTO dbo.EmployeeDim (EmployeeID, FullName, Department, RoleTitle) VALUES
('E01', 'Ali Saleh', 'Support',   'Agent'),
('E02', 'Mary Chen', 'Marketing', 'Analyst');

INSERT INTO dbo.PromotionDim (PromotionCode, PromotionName, PromotionType, StartDate, EndDate) VALUES
('NONE', 'No Promotion', 'None',    NULL, NULL),
('P10',  '10% OFF',      'Percent', NULL, NULL),
('P20',  '20% OFF',      'Percent', NULL, NULL);

INSERT INTO dbo.PageDim (PageSource, PageFunction, PageTemplate) VALUES
('Static', 'Home',    'TemplateA'),
('Static', 'Product', 'TemplateC'),
('Static', 'Cart',    'TemplateC');

INSERT INTO dbo.EventDim (EventType, EventContent) VALUES
('Purchase',  NULL),
('AddToCart', NULL),
('Checkout',  NULL);

INSERT INTO dbo.SessionDim (SessionID, SessionType, SuccessStatus, CustomerStatus) VALUES
('SESS001', 'Web',    'Completed', 'Existing'),
('SESS002', 'Mobile', 'Completed', 'New');

INSERT INTO dbo.ReferralDim (ReferralType) VALUES
('Search'), ('Email'), ('Social');

INSERT INTO dbo.FactClickstreamSession
(DateID, TimeID, SessionKey, ReferralKey, CustomerKey, PromotionKey, EmployeeKey, ProductKey,
 PageKey_Entry, PageKey_Exit, EventKey_Last,
 TotalPagesViewed, TotalSessionSeconds, OrdersPlaced, OrderQuantity, OrderDollarAmount, SessionId_Natural) VALUES
(20251025, 120000, 1, 1, 1, 2, 1, 1, 1, 3, 1, 6, 420, 1, 1, 1199.99, 'SESS001'),
(20251026, 130000, 2, 3, 2, 1, 2, 2, 1, 2, 2, 4, 180, 0, 0,    0.00, 'SESS002'),
(20251027, 150000, 2, 2, 2, 3, 2, 2, 2, 3, 1, 3, 240, 1, 2,  159.98, 'SESS002');
GO
