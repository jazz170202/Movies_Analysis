SELECT
    employees.FirstName || ' ' || employees.LastName AS Employee,
    SUM(invoice_items.Quantity * invoice_items.UnitPrice) AS Sales
FROM invoices
JOIN invoice_items ON invoices.InvoiceId = invoice_items.InvoiceId
JOIN customers ON invoices.CustomerId = customers.CustomerId
JOIN employees ON customers.SupportRepId = employees.EmployeeId
GROUP BY employees.EmployeeId
ORDER BY Sales DESC;