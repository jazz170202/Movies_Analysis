SELECT
    strftime('%Y', invoices.InvoiceDate) AS Year,
    strftime('%m', invoices.InvoiceDate) AS Month,
    SUM(invoice_items.Quantity * invoice_items.UnitPrice) AS Sales
FROM invoices
JOIN invoice_items ON invoices.InvoiceId = invoice_items.InvoiceId
GROUP BY Year, Month
ORDER BY Sales DESC;