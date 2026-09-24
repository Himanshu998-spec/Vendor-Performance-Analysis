/* Vendor Performance Analysis - SQL Query Extracted from Vendor_Performance_Analysis.ipynb
Database: VendorPerformanceDB | Server: HIMANSHU\SQLEXPRESS
These SQL statements were executed from Jupyter through SQLAlchemy.
CSV loading and vendor_performance saving used Python/Pandas to_sql. */

-- ================= CELL 11 =================
SELECT 
    t.name AS table_name,
    SUM(p.rows) AS row_count
FROM sys.tables t
INNER JOIN sys.partitions p
    ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY t.name;
GO

-- ================= CELL 12 =================
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'begin_inventory',
    'end_inventory',
    'purchase_prices',
    'purchases',
    'sales',
    'vendor_invoice'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO

-- ================= CELL 16 =================
SELECT
    'purchases' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT InventoryId) AS unique_inventory_ids,
    COUNT(DISTINCT VendorNumber) AS unique_vendors
FROM purchases

UNION ALL

SELECT
    'sales',
    COUNT(*),
    COUNT(DISTINCT InventoryId),
    COUNT(DISTINCT VendorNo)
FROM sales

UNION ALL

SELECT
    'purchase_prices',
    COUNT(*),
    COUNT(DISTINCT Brand),
    COUNT(DISTINCT VendorNumber)
FROM purchase_prices

UNION ALL

SELECT
    'vendor_invoice',
    COUNT(*),
    COUNT(DISTINCT PONumber),
    COUNT(DISTINCT VendorNumber)
FROM vendor_invoice

UNION ALL

SELECT
    'begin_inventory',
    COUNT(*),
    COUNT(DISTINCT InventoryId),
    COUNT(DISTINCT Brand)
FROM begin_inventory

UNION ALL

SELECT
    'end_inventory',
    COUNT(*),
    COUNT(DISTINCT InventoryId),
    COUNT(DISTINCT Brand)
FROM end_inventory;
GO

-- ================= CELL 20 =================
SELECT *
FROM end_inventory
WHERE City IS NULL;
GO

-- ================= CELL 21 =================
SELECT 
    Store,
    City,
    COUNT(*) AS record_count
FROM end_inventory
WHERE Store = 46
GROUP BY Store, City
ORDER BY record_count DESC;
GO

-- ================= CELL 22 =================
SELECT
    Store,
    City,
    COUNT(*) AS record_count
FROM begin_inventory
WHERE Store = 46
GROUP BY Store, City
ORDER BY record_count DESC;
GO

-- ================= CELL 23 =================
SELECT
    Store,
    COUNT(DISTINCT City) AS unique_city_count
FROM begin_inventory
WHERE City IS NOT NULL
GROUP BY Store
HAVING COUNT(DISTINCT City) > 1
ORDER BY Store;
GO

-- ================= CELL 24 =================
SELECT *
FROM purchases
WHERE Size IS NULL;
GO

-- ================= CELL 25 =================
SELECT
    Brand,
    Description,
    VendorNumber,
    Size,
    Volume,
    PurchasePrice
FROM purchase_prices
WHERE
    (Brand = 3121 AND VendorNumber = 12546)
    OR
    (Brand = 5678 AND VendorNumber = 12546)
    OR
    (Brand = 15365 AND VendorNumber = 9552)
ORDER BY Brand;
GO

-- ================= CELL 26 =================
SELECT *
FROM purchase_prices
WHERE Description IS NULL
   OR Size IS NULL
   OR Volume IS NULL;
GO

-- ================= CELL 27 =================
SELECT TOP 20
    InventoryId,
    Store,
    Brand,
    Description,
    Size,
    VendorNumber,
    VendorName,
    PurchasePrice,
    Quantity,
    Dollars
FROM purchases
WHERE Brand = 4202
  AND VendorNumber = 480
ORDER BY PurchasePrice;
GO

-- ================= CELL 28 =================
SELECT TOP 20
    Brand,
    Description,
    Size,
    VendorNumber,
    VendorName,
    PurchasePrice,
    Quantity,
    Dollars
FROM purchases
WHERE Brand = 4202
  AND VendorNumber = 480
ORDER BY PurchasePrice;
GO

-- ================= CELL 29 =================
SELECT
    Approval,
    COUNT(*) AS record_count
FROM vendor_invoice
GROUP BY Approval
ORDER BY record_count DESC;
GO

-- ================= CELL 30 =================
SELECT
    VendorNumber,
    VendorName,
    SUM(Quantity) AS TotalPurchaseQuantity,
    SUM(Dollars) AS TotalPurchaseDollars,
    AVG(PurchasePrice) AS AveragePurchasePrice,
    COUNT(DISTINCT PONumber) AS TotalPurchaseOrders
FROM purchases
GROUP BY
    VendorNumber,
    VendorName
ORDER BY TotalPurchaseDollars DESC;
GO

-- ================= CELL 31 =================
SELECT
    VendorNo AS VendorNumber,
    VendorName,
    SUM(SalesQuantity) AS TotalSalesQuantity,
    SUM(SalesDollars) AS TotalSalesDollars,
    AVG(SalesPrice) AS AverageSalesPrice,
    COUNT(DISTINCT Brand) AS UniqueBrandsSold
FROM sales
GROUP BY
    VendorNo,
    VendorName
ORDER BY TotalSalesDollars DESC;
GO

-- ================= CELL 32 =================
SELECT
    VendorNumber,
    VendorName,
    SUM(Dollars) AS InvoiceDollars,
    SUM(Freight) AS TotalFreight,
    COUNT(DISTINCT PONumber) AS InvoicePOCount
FROM vendor_invoice
GROUP BY
    VendorNumber,
    VendorName
ORDER BY InvoiceDollars DESC;
GO

-- ================= CELL 33 =================
SELECT
    VendorNumber,
    VendorName,
    AVG(PurchasePrice) AS AvgListedPurchasePrice,
    COUNT(DISTINCT Brand) AS ProductCount
FROM purchase_prices
GROUP BY
    VendorNumber,
    VendorName
ORDER BY AvgListedPurchasePrice DESC;
GO

-- ================= CELL 34 =================
WITH vendor_list AS (
    SELECT DISTINCT VendorNumber
    FROM purchases

    UNION

    SELECT DISTINCT VendorNo AS VendorNumber
    FROM sales

    UNION

    SELECT DISTINCT VendorNumber
    FROM vendor_invoice

    UNION

    SELECT DISTINCT VendorNumber
    FROM purchase_prices
)

SELECT
    v.VendorNumber,

    CASE WHEN p.VendorNumber IS NOT NULL THEN 1 ELSE 0 END AS InPurchases,
    CASE WHEN s.VendorNo IS NOT NULL THEN 1 ELSE 0 END AS InSales,
    CASE WHEN i.VendorNumber IS NOT NULL THEN 1 ELSE 0 END AS InInvoice,
    CASE WHEN pp.VendorNumber IS NOT NULL THEN 1 ELSE 0 END AS InPurchasePrices

FROM vendor_list v

LEFT JOIN (
    SELECT DISTINCT VendorNumber
    FROM purchases
) p
    ON v.VendorNumber = p.VendorNumber

LEFT JOIN (
    SELECT DISTINCT VendorNo
    FROM sales
) s
    ON v.VendorNumber = s.VendorNo

LEFT JOIN (
    SELECT DISTINCT VendorNumber
    FROM vendor_invoice
) i
    ON v.VendorNumber = i.VendorNumber

LEFT JOIN (
    SELECT DISTINCT VendorNumber
    FROM purchase_prices
) pp
    ON v.VendorNumber = pp.VendorNumber

ORDER BY v.VendorNumber;
GO

-- ================= CELL 35 =================
WITH vendor_list AS (
    SELECT DISTINCT VendorNumber
    FROM purchases

    UNION

    SELECT DISTINCT VendorNo AS VendorNumber
    FROM sales

    UNION

    SELECT DISTINCT VendorNumber
    FROM vendor_invoice

    UNION

    SELECT DISTINCT VendorNumber
    FROM purchase_prices
),
coverage AS (
    SELECT
        v.VendorNumber,
        CASE WHEN p.VendorNumber IS NOT NULL THEN 1 ELSE 0 END AS InPurchases,
        CASE WHEN s.VendorNo IS NOT NULL THEN 1 ELSE 0 END AS InSales,
        CASE WHEN i.VendorNumber IS NOT NULL THEN 1 ELSE 0 END AS InInvoice,
        CASE WHEN pp.VendorNumber IS NOT NULL THEN 1 ELSE 0 END AS InPurchasePrices
    FROM vendor_list v

    LEFT JOIN (
        SELECT DISTINCT VendorNumber
        FROM purchases
    ) p ON v.VendorNumber = p.VendorNumber

    LEFT JOIN (
        SELECT DISTINCT VendorNo
        FROM sales
    ) s ON v.VendorNumber = s.VendorNo

    LEFT JOIN (
        SELECT DISTINCT VendorNumber
        FROM vendor_invoice
    ) i ON v.VendorNumber = i.VendorNumber

    LEFT JOIN (
        SELECT DISTINCT VendorNumber
        FROM purchase_prices
    ) pp ON v.VendorNumber = pp.VendorNumber
)

SELECT
    COUNT(*) AS TotalUniqueVendors,
    SUM(InPurchases) AS VendorsInPurchases,
    SUM(InSales) AS VendorsInSales,
    SUM(InInvoice) AS VendorsInInvoice,
    SUM(InPurchasePrices) AS VendorsInPurchasePrices,

    SUM(
        CASE
            WHEN InPurchases = 1
             AND InSales = 1
             AND InInvoice = 1
             AND InPurchasePrices = 1
            THEN 1 ELSE 0
        END
    ) AS VendorsInAllFour

FROM coverage;
GO

-- ================= CELL 37 =================
SELECT
    p.VendorNumber,
    p.VendorName,

    -- Purchase Metrics
    p.TotalPurchaseQuantity,
    p.TotalPurchaseDollars,
    p.AveragePurchasePrice,
    p.TotalPurchaseOrders,

    -- Sales Metrics
    s.TotalSalesQuantity,
    s.TotalSalesDollars,
    s.AverageSalesPrice,
    s.UniqueBrandsSold,

    -- Invoice Metrics
    i.InvoiceDollars,
    i.TotalFreight,
    i.InvoicePOCount,

    -- Price Metrics
    pp.AvgListedPurchasePrice,
    pp.ProductCount,

    -- Business Metrics
    s.TotalSalesDollars - p.TotalPurchaseDollars AS GrossProfit,

    CASE
        WHEN s.TotalSalesDollars > 0
        THEN
            ((s.TotalSalesDollars - p.TotalPurchaseDollars)
            / s.TotalSalesDollars) * 100
        ELSE 0
    END AS ProfitMarginPercentage,

    CASE
        WHEN p.TotalPurchaseDollars > 0
        THEN
            (i.TotalFreight / p.TotalPurchaseDollars) * 100
        ELSE 0
    END AS FreightPercentage

FROM
(
    SELECT
        VendorNumber,
        VendorName,
        SUM(Quantity) AS TotalPurchaseQuantity,
        SUM(Dollars) AS TotalPurchaseDollars,
        AVG(PurchasePrice) AS AveragePurchasePrice,
        COUNT(DISTINCT PONumber) AS TotalPurchaseOrders
    FROM purchases
    GROUP BY VendorNumber, VendorName
) p

INNER JOIN
(
    SELECT
        VendorNo AS VendorNumber,
        VendorName,
        SUM(SalesQuantity) AS TotalSalesQuantity,
        SUM(SalesDollars) AS TotalSalesDollars,
        AVG(SalesPrice) AS AverageSalesPrice,
        COUNT(DISTINCT Brand) AS UniqueBrandsSold
    FROM sales
    GROUP BY VendorNo, VendorName
) s
    ON p.VendorNumber = s.VendorNumber

INNER JOIN
(
    SELECT
        VendorNumber,
        VendorName,
        SUM(Dollars) AS InvoiceDollars,
        SUM(Freight) AS TotalFreight,
        COUNT(DISTINCT PONumber) AS InvoicePOCount
    FROM vendor_invoice
    GROUP BY VendorNumber, VendorName
) i
    ON p.VendorNumber = i.VendorNumber

INNER JOIN
(
    SELECT
        VendorNumber,
        VendorName,
        AVG(PurchasePrice) AS AvgListedPurchasePrice,
        COUNT(DISTINCT Brand) AS ProductCount
    FROM purchase_prices
    GROUP BY VendorNumber, VendorName
) pp
    ON p.VendorNumber = pp.VendorNumber

ORDER BY
    GrossProfit DESC;
GO

-- ================= CELL 40 =================
SELECT
    VendorNumber,
    VendorName,
    COUNT(*) AS RecordCount
FROM purchases
WHERE VendorNumber IN (1587, 2000)
GROUP BY
    VendorNumber,
    VendorName

UNION ALL

SELECT
    VendorNo AS VendorNumber,
    VendorName,
    COUNT(*) AS RecordCount
FROM sales
WHERE VendorNo IN (1587, 2000)
GROUP BY
    VendorNo,
    VendorName

UNION ALL

SELECT
    VendorNumber,
    VendorName,
    COUNT(*) AS RecordCount
FROM vendor_invoice
WHERE VendorNumber IN (1587, 2000)
GROUP BY
    VendorNumber,
    VendorName

UNION ALL

SELECT
    VendorNumber,
    VendorName,
    COUNT(*) AS RecordCount
FROM purchase_prices
WHERE VendorNumber IN (1587, 2000)
GROUP BY
    VendorNumber,
    VendorName

ORDER BY
    VendorNumber,
    VendorName;
GO

-- ================= CELL 41 =================
SELECT
    p.VendorNumber,
    p.VendorName,

    -- Purchase Metrics
    p.TotalPurchaseQuantity,
    p.TotalPurchaseDollars,
    p.AveragePurchasePrice,
    p.TotalPurchaseOrders,

    -- Sales Metrics
    s.TotalSalesQuantity,
    s.TotalSalesDollars,
    s.AverageSalesPrice,
    s.UniqueBrandsSold,

    -- Invoice Metrics
    i.InvoiceDollars,
    i.TotalFreight,
    i.InvoicePOCount,

    -- Price Metrics
    pp.AvgListedPurchasePrice,
    pp.ProductCount,

    -- Business Metrics
    s.TotalSalesDollars - p.TotalPurchaseDollars AS GrossProfit,

    CASE
        WHEN s.TotalSalesDollars > 0
        THEN
            ((s.TotalSalesDollars - p.TotalPurchaseDollars)
            / s.TotalSalesDollars) * 100
        ELSE 0
    END AS ProfitMarginPercentage,

    CASE
        WHEN p.TotalPurchaseDollars > 0
        THEN
            (i.TotalFreight / p.TotalPurchaseDollars) * 100
        ELSE 0
    END AS FreightPercentage

FROM
(
    SELECT
        VendorNumber,
        MAX(VendorName) AS VendorName,
        SUM(Quantity) AS TotalPurchaseQuantity,
        SUM(Dollars) AS TotalPurchaseDollars,
        AVG(PurchasePrice) AS AveragePurchasePrice,
        COUNT(DISTINCT PONumber) AS TotalPurchaseOrders
    FROM purchases
    GROUP BY VendorNumber
) p

INNER JOIN
(
    SELECT
        VendorNo AS VendorNumber,
        MAX(VendorName) AS VendorName,
        SUM(SalesQuantity) AS TotalSalesQuantity,
        SUM(SalesDollars) AS TotalSalesDollars,
        AVG(SalesPrice) AS AverageSalesPrice,
        COUNT(DISTINCT Brand) AS UniqueBrandsSold
    FROM sales
    GROUP BY VendorNo
) s
    ON p.VendorNumber = s.VendorNumber

INNER JOIN
(
    SELECT
        VendorNumber,
        MAX(VendorName) AS VendorName,
        SUM(Dollars) AS InvoiceDollars,
        SUM(Freight) AS TotalFreight,
        COUNT(DISTINCT PONumber) AS InvoicePOCount
    FROM vendor_invoice
    GROUP BY VendorNumber
) i
    ON p.VendorNumber = i.VendorNumber

INNER JOIN
(
    SELECT
        VendorNumber,
        MAX(VendorName) AS VendorName,
        AVG(PurchasePrice) AS AvgListedPurchasePrice,
        COUNT(DISTINCT Brand) AS ProductCount
    FROM purchase_prices
    GROUP BY VendorNumber
) pp
    ON p.VendorNumber = pp.VendorNumber

ORDER BY GrossProfit DESC;
GO

-- ================= CELL 45 =================
SELECT
    COUNT(DISTINCT p.VendorNumber) AS VendorCount,
    SUM(p.TotalPurchaseDollars) AS PurchaseDollars,
    SUM(s.TotalSalesDollars) AS SalesDollars,
    SUM(i.TotalFreight) AS FreightDollars

FROM
(
    SELECT
        VendorNumber,
        SUM(Dollars) AS TotalPurchaseDollars
    FROM purchases
    GROUP BY VendorNumber
) p

INNER JOIN
(
    SELECT
        VendorNo AS VendorNumber,
        SUM(SalesDollars) AS TotalSalesDollars
    FROM sales
    GROUP BY VendorNo
) s
    ON p.VendorNumber = s.VendorNumber

INNER JOIN
(
    SELECT
        VendorNumber,
        SUM(Freight) AS TotalFreight
    FROM vendor_invoice
    GROUP BY VendorNumber
) i
    ON p.VendorNumber = i.VendorNumber

INNER JOIN
(
    SELECT DISTINCT VendorNumber
    FROM purchase_prices
) pp
    ON p.VendorNumber = pp.VendorNumber;
GO

-- ================= CELL 47 =================
SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT VendorNumber) AS UniqueVendors
FROM vendor_performance;
GO

-- ================= CELL 49 =================
SELECT *
FROM vendor_performance
GO

-- ================= CELL 101 =================
SELECT
    COUNT(*) AS TotalInventoryRecords,
    COUNT(DISTINCT InventoryId) AS UniqueInventoryItems,
    SUM(onHand) AS TotalUnitsOnHand,
    SUM(onHand * Price) AS InventoryValue
FROM begin_inventory;
GO

-- ================= CELL 102 =================
SELECT
    COUNT(*) AS TotalInventoryRecords,
    COUNT(DISTINCT InventoryId) AS UniqueInventoryItems,
    SUM(onHand) AS TotalUnitsOnHand,
    SUM(onHand * Price) AS InventoryValue
FROM end_inventory;
GO

-- ================= CELL 104 =================
WITH BeginStore AS (
    SELECT
        Store,
        SUM(onHand) AS BeginUnits,
        SUM(onHand * Price) AS BeginInventoryValue
    FROM begin_inventory
    GROUP BY Store
),

EndStore AS (
    SELECT
        Store,
        SUM(onHand) AS EndUnits,
        SUM(onHand * Price) AS EndInventoryValue
    FROM end_inventory
    GROUP BY Store
),

StoreCity AS (
    SELECT
        Store,
        MAX(City) AS City
    FROM begin_inventory
    WHERE City IS NOT NULL
    GROUP BY Store
)

SELECT
    b.Store,
    c.City,
    b.BeginUnits,
    e.EndUnits,
    e.EndUnits - b.BeginUnits AS UnitChange,
    b.BeginInventoryValue,
    e.EndInventoryValue,
    e.EndInventoryValue - b.BeginInventoryValue AS ValueChange
FROM BeginStore b
INNER JOIN EndStore e
    ON b.Store = e.Store
LEFT JOIN StoreCity c
    ON b.Store = c.Store
ORDER BY ValueChange DESC;
GO

-- ================= CELL 107 =================
WITH BeginBrand AS (
    SELECT
        Brand,
        MAX(Description) AS Description,
        SUM(onHand) AS BeginUnits,
        SUM(onHand * Price) AS BeginInventoryValue
    FROM begin_inventory
    GROUP BY Brand
),

EndBrand AS (
    SELECT
        Brand,
        SUM(onHand) AS EndUnits,
        SUM(onHand * Price) AS EndInventoryValue
    FROM end_inventory
    GROUP BY Brand
)

SELECT
    b.Brand,
    b.Description,
    b.BeginUnits,
    e.EndUnits,
    e.EndUnits - b.BeginUnits AS UnitChange,
    b.BeginInventoryValue,
    e.EndInventoryValue,
    e.EndInventoryValue - b.BeginInventoryValue AS ValueChange
FROM BeginBrand b
INNER JOIN EndBrand e
    ON b.Brand = e.Brand
ORDER BY ValueChange DESC;
GO

-- ================= CELL 109 =================
WITH BeginInventory AS (
    SELECT
        SUM(onHand) AS BeginUnits,
        SUM(onHand * Price) AS BeginInventoryValue
    FROM begin_inventory
),
EndInventory AS (
    SELECT
        SUM(onHand) AS EndUnits,
        SUM(onHand * Price) AS EndInventoryValue
    FROM end_inventory
),
SalesSummary AS (
    SELECT
        SUM(SalesQuantity) AS TotalSalesQuantity,
        SUM(SalesDollars) AS TotalSalesDollars
    FROM sales
)
SELECT
    b.BeginUnits,
    e.EndUnits,
    b.BeginInventoryValue,
    e.EndInventoryValue,
    s.TotalSalesQuantity,
    s.TotalSalesDollars,
    (b.BeginInventoryValue + e.EndInventoryValue) / 2.0 AS AverageInventoryValue,
    (b.BeginUnits + e.EndUnits) / 2.0 AS AverageInventoryUnits,
    s.TotalSalesDollars /
        NULLIF((b.BeginInventoryValue + e.EndInventoryValue) / 2.0, 0)
        AS SalesToAverageInventoryRatio,
    s.TotalSalesQuantity /
        NULLIF((b.BeginUnits + e.EndUnits) / 2.0, 0)
        AS UnitTurnoverRatio
FROM BeginInventory b
CROSS JOIN EndInventory e
CROSS JOIN SalesSummary s;
GO

-- ================= CELL 110 =================
WITH BeginStore AS (
    SELECT
        Store,
        MAX(City) AS City,
        SUM(onHand) AS BeginUnits,
        SUM(onHand * Price) AS BeginInventoryValue
    FROM begin_inventory
    GROUP BY Store
),
EndStore AS (
    SELECT
        Store,
        SUM(onHand) AS EndUnits,
        SUM(onHand * Price) AS EndInventoryValue
    FROM end_inventory
    GROUP BY Store
),
SalesStore AS (
    SELECT
        Store,
        SUM(SalesQuantity) AS SalesQuantity,
        SUM(SalesDollars) AS SalesDollars
    FROM sales
    GROUP BY Store
)
SELECT
    b.Store,
    b.City,
    b.BeginUnits,
    e.EndUnits,
    b.BeginInventoryValue,
    e.EndInventoryValue,
    s.SalesQuantity,
    s.SalesDollars,
    (b.BeginInventoryValue + e.EndInventoryValue) / 2.0
        AS AverageInventoryValue,
    (b.BeginUnits + e.EndUnits) / 2.0
        AS AverageInventoryUnits,
    s.SalesDollars /
        NULLIF(
            (b.BeginInventoryValue + e.EndInventoryValue) / 2.0,
            0
        ) AS SalesToAverageInventoryRatio,
    s.SalesQuantity /
        NULLIF(
            (b.BeginUnits + e.EndUnits) / 2.0,
            0
        ) AS UnitTurnoverRatio
FROM BeginStore b
INNER JOIN EndStore e
    ON b.Store = e.Store
INNER JOIN SalesStore s
    ON b.Store = s.Store
ORDER BY SalesToAverageInventoryRatio DESC;
GO

-- ================= CELL 117 =================
WITH InventorySummary AS (
    SELECT
        Brand,
        MAX(Description) AS Description,
        SUM(onHand) AS TotalInventoryUnits,
        SUM(onHand * Price) AS InventoryValue
    FROM begin_inventory
    GROUP BY Brand
),
SalesSummary AS (
    SELECT
        Brand,
        SUM(SalesQuantity) AS SalesQuantity,
        SUM(SalesDollars) AS SalesDollars
    FROM sales
    GROUP BY Brand
)
SELECT
    i.Brand,
    i.Description,
    i.TotalInventoryUnits,
    i.InventoryValue,
    s.SalesQuantity,
    s.SalesDollars,
    s.SalesDollars /
        NULLIF(i.InventoryValue, 0) AS InventorySalesRatio
FROM InventorySummary i
INNER JOIN SalesSummary s
    ON i.Brand = s.Brand
ORDER BY InventorySalesRatio DESC;
GO

/* DYNAMIC SQL CELLS RETAINED IN THE NOTEBOOK
Cells 13, 14, 15, 17, 18, 19 generate SQL dynamically with Python loops/f-strings.
They are not copied as standalone executable SQL because table/column names are inserted at runtime.
*/