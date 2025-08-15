# Analysis of best selling music tracks and sales prediction

**Introduction**

This project explores the Chinook music store database to uncover the best-selling artists, the performance of sales employees, the most popular music genres, and how sales trends shift over time. Using SQL, I analyzed track sales, employee contributions, and seasonal patterns, and applied a moving average to predict future trends. The goal was to understand what drives revenue in the music business and how sales might evolve. Dataset link: [Chinook Database](https://www.sqlitetutorial.net/sqlite-sample-database)

**Background**

As part of my journey to improve SQL analysis skills, I decided to work on the Chinook sample database. This dataset represents a digital media store, including information about customers, invoices, employees, tracks, albums, and artists. It’s perfect for practicing joins, aggregations, and analytical functions while answering real-world business questions.

**Tools I Used**

- **SQLite** – Chosen for its lightweight structure and ease of setup. Perfect for quick, local SQL analysis.
- **SQLiteStudio** – My main environment for running queries, exploring data, and testing logic efficiently.
- **SQL** – Used for data extraction, aggregation, ranking, and calculating moving averages for predictions.

**The Analysis**

Dataset: Chinook Sample Database – [Schema Reference](https://www.sqlitetutorial.net/sqlite-sample-database/)

---

**1. Who are the top-selling artists?**

This query calculates the total sales amount for each artist and ranks them by revenue.

It highlights the top 5 artists who generate the most income.

```sql
WITH invoice_select AS (
    SELECT
        invoice_items.TrackId,
        COUNT(invoice_items.TrackId) AS Number,
        SUM(invoice_items.Quantity * invoice_items.UnitPrice) AS Sales,
        artists.Name AS Artist
    FROM invoice_items
    JOIN tracks ON invoice_items.TrackId = tracks.TrackId
    JOIN albums ON tracks.AlbumId = albums.AlbumId
    JOIN artists ON albums.ArtistId = artists.ArtistId
    GROUP BY artists.ArtistId
    ORDER BY Sales DESC
)
SELECT
    Artist,
    Sales
FROM invoice_select
LIMIT 5;
```

<img width="958" height="503" alt="image" src="https://github.com/user-attachments/assets/f26542fb-e11e-4b01-8222-2ba132a3da1d" />            
<img width="717" height="452" alt="image (1)" src="https://github.com/user-attachments/assets/168abc07-d48f-4627-b9dc-241147e76132" />


**Key Insight:** A small group of artists contribute the majority of total sales, making them critical for business revenue.

---

**2. Which employees perform best in sales?**

This query links employees to the customers they support and calculates total sales they’ve generated.

```sql
SELECT
    employees.FirstName || ' ' || employees.LastName AS Employee,
    SUM(invoice_items.Quantity * invoice_items.UnitPrice) AS Sales
FROM invoices
JOIN invoice_items ON invoices.InvoiceId = invoice_items.InvoiceId
JOIN customers ON invoices.CustomerId = customers.CustomerId
JOIN employees ON customers.SupportRepId = employees.EmployeeId
GROUP BY employees.EmployeeId
ORDER BY Sales DESC;

```

<img width="959" height="503" alt="image (4)" src="https://github.com/user-attachments/assets/0a39defa-1c8c-4fa9-99e9-a6e3236b2993" />
<img width="754" height="452" alt="image (2)" src="https://github.com/user-attachments/assets/937f8565-d721-4f45-854e-f9a3cf4c3d51" />


**Key Insight:** The highest-performing employees handle significantly more sales, showing opportunities for recognition and sharing best practices with lower performers.

---

**3. Which genres dominate the music library?**

This query counts the number of tracks for each genre.

```sql
SELECT
    COUNT(tracks.TrackId) AS Number_tracks,
    genres.Name AS Genre_name
FROM tracks
LEFT JOIN genres ON tracks.GenreId = genres.GenreId
GROUP BY genres.Name
ORDER BY Number_tracks DESC;

```

<img width="958" height="504" alt="image" src="https://github.com/user-attachments/assets/de9424c2-ec39-4f4c-8f8c-ca3302d4c4c1" /> 
<img width="1979" height="1180" alt="image (3)" src="https://github.com/user-attachments/assets/5578c77d-21e7-4bf2-9ae9-4030575b62df" />



**Key Insight:** Certain genres dominate the store’s library, aligning with common music trends and possibly influencing sales focus.

---

**4. How do sales change month by month?**

This query aggregates sales by month to identify seasonal trends.

```sql
SELECT
    strftime('%Y', invoices.InvoiceDate) AS Year,
    strftime('%m', invoices.InvoiceDate) AS Month,
    SUM(invoice_items.Quantity * invoice_items.UnitPrice) AS Sales
FROM invoices
JOIN invoice_items ON invoices.InvoiceId = invoice_items.InvoiceId
GROUP BY Year, Month
ORDER BY Sales DESC;

```

<img width="958" height="502" alt="image" src="https://github.com/user-attachments/assets/e15d1543-f7be-4891-bea3-06ed59883227" />
<img width="2379" height="1180" alt="image (1)" src="https://github.com/user-attachments/assets/d24bee02-480f-47fe-972b-54be473146fb" />


**Key Insight:** Monthly trends reveal peak sales seasons, which can guide promotional campaigns.

---

**5. Predicting future sales trends with a moving average**

This query calculates yearly sales and applies a 3-year moving average.

```sql
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

```

<img width="959" height="503" alt="image (2)" src="https://github.com/user-attachments/assets/5caa51c6-5e26-4a50-b7d5-e097cf2b41f9" />
<img width="1399" height="947" alt="image (3)" src="https://github.com/user-attachments/assets/99775c15-bf70-47e2-8e0b-5b5fc596ab1f" />


**Key Insight:** The moving average smooths out yearly fluctuations, making it easier to see long-term growth or decline.

---

**What I Learned**

- SQL joins and aggregations are powerful for connecting multiple datasets into actionable insights.
- Top artists and top employees drive a large share of revenue.
- Seasonal sales patterns can help plan marketing campaigns.
- Analytical SQL functions (like moving averages) are valuable for predicting trends.

**Conclusions**

- **Revenue concentration** – A few artists dominate sales; losing them could heavily impact business.
- **Employee impact** – Certain employees consistently outperform others, suggesting the value of targeted coaching.
- **Genre strategy** – Popular genres should be stocked and promoted more.
- **Seasonal planning** – Marketing budgets should align with peak sales months.
- **Data-driven forecasting** – Moving averages provide a reliable baseline for predicting sales performance.
