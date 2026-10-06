chinook-queries.sql

GitHub - LucasMcL/15-sql_queries_02-chinook

1) SELECT FirstName || ' ' || LastName AS NomComplet, CustomerId, Country 
FROM Customer 
WHERE Country <> 'USA';

2) SELECT * 
FROM Customer 
WHERE Country = 'Brazil';

3)SELECT c.FirstName || ' ' || c.LastName AS NomComplet, i.InvoiceId, i.InvoiceDate, i.BillingCountry 
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
WHERE c.Country = 'Brazil';

4) SELECT * 
FROM Employee 
WHERE Title = 'Sales Support Agent';

5) SELECT DISTINCT BillingCountry 
FROM Invoice;

6) SELECT e.FirstName || ' ' || e.LastName AS AgentDeVente, i.* 
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId;

7) SELECT i.Total, c.FirstName || ' ' || c.LastName AS Client, c.Country, e.FirstName || ' ' || e.LastName AS AgentDeVente 
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId;

8) SELECT strftime('%Y', InvoiceDate) AS Annee, COUNT(InvoiceId) AS NombreFactures 
FROM Invoice
WHERE strftime('%Y', InvoiceDate) IN ('2009', '2011')
GROUP BY Annee;

9) SELECT strftime('%Y', InvoiceDate) AS Annee, SUM(Total) AS TotalVentes
FROM Invoice
WHERE strftime('%Y', InvoiceDate) IN ('2009', '2011')
GROUP BY Annee;

10) SELECT COUNT(*) AS NombreArticles 
FROM InvoiceLine 
WHERE InvoiceId = 37;

11) SELECT InvoiceId, COUNT(*) AS NombreArticles 
FROM InvoiceLine 
GROUP BY InvoiceId;

12) SELECT il.InvoiceLineId, t.Name AS NomDuMorceau 
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId;

13) SELECT il.InvoiceLineId, t.Name AS NomDuMorceau, ar.Name AS Artiste 
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId;

14) SELECT BillingCountry, COUNT(InvoiceId) AS NombreFactures 
FROM Invoice 
GROUP BY BillingCountry;

15) SELECT p.Name AS Playlist, COUNT(pt.TrackId) AS NombreMorceaux 
FROM Playlist p
JOIN PlaylistTrack pt ON p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId;

16) SELECT t.Name AS Morceau, al.Title AS Album, mt.Name AS TypeDeMedia, g.Name AS Genre
FROM Track t
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN MediaType mt ON t.MediaTypeId = mt.MediaTypeId
JOIN Genre g ON t.GenreId = g.GenreId;

17) SELECT i.*, COUNT(il.InvoiceLineId) AS NombreArticles 
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId;

18) SELECT e.FirstName || ' ' || e.LastName AS Agent, SUM(i.Total) AS TotalVentes
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId;

19) SELECT e.FirstName || ' ' || e.LastName AS Agent, SUM(i.Total) AS TotalVentes
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE strftime('%Y', i.InvoiceDate) = '2009'
GROUP BY e.EmployeeId
ORDER BY TotalVentes DESC
LIMIT 1;

20) SELECT e.FirstName || ' ' || e.LastName AS Agent, SUM(i.Total) AS TotalVentes
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE strftime('%Y', i.InvoiceDate) = '2010'
GROUP BY e.EmployeeId
ORDER BY TotalVentes DESC
LIMIT 1;

21) SELECT e.FirstName || ' ' || e.LastName AS Agent, SUM(i.Total) AS TotalVentes
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId
ORDER BY TotalVentes DESC
LIMIT 1;

22) SELECT e.FirstName || ' ' || e.LastName AS Agent, COUNT(c.CustomerId) AS NombreClients
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
GROUP BY e.EmployeeId;

23) SELECT BillingCountry AS Pays, SUM(Total) AS TotalVentes
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalVentes DESC
LIMIT 1;

24) SELECT t.Name AS Morceau, COUNT(il.InvoiceLineId) AS NombreAchats
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE strftime('%Y', i.InvoiceDate) = '2013'
GROUP BY t.TrackId
ORDER BY NombreAchats DESC
LIMIT 1;

25) SELECT t.Name AS Morceau, COUNT(il.InvoiceLineId) AS NombreAchats
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY t.TrackId
ORDER BY NombreAchats DESC
LIMIT 5;

26) SELECT ar.Name AS Artiste, COUNT(il.InvoiceLineId) AS NombreVentes
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY ar.ArtistId
ORDER BY NombreVentes DESC
LIMIT 3;

27) SELECT mt.Name AS TypeDeMedia, COUNT(il.InvoiceLineId) AS NombreAchats
FROM MediaType mt
JOIN Track t ON mt.MediaTypeId = t.MediaTypeId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY mt.MediaTypeId
ORDER BY NombreAchats DESC
LIMIT 1;






