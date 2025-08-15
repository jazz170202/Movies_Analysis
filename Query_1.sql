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