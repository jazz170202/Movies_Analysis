SELECT
    COUNT(tracks.TrackId) AS Number_tracks,
    genres.Name AS Genre_name
FROM tracks
LEFT JOIN genres ON tracks.GenreId = genres.GenreId
GROUP BY genres.Name
ORDER BY Number_tracks DESC;