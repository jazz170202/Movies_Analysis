WITH yearly_sales AS (
    SELECT
        strftime('%Y', invoices.InvoiceDate) AS Year,
        SUM(invoice_items.Quantity * invoice_items.UnitPrice) AS Sales
    FROM invoice_items
    JOIN invoices ON invoice_items.InvoiceId = invoices.InvoiceId
    GROUP BY Year
    ORDER BY Sales DESC
)
SELECT
    Year,
    Sales,
    AVG(Sales) OVER (
        ORDER BY CAST(Year AS INTEGER)
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3_year
FROM yearly_sales;