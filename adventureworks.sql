--1. Ventes par région : Afficher le total des ventes par région pour l'année 2014.
SELECT 
ST.Name AS Region, 
SUM(SOH.SubTotal) AS TotalVentes
FROM 
Sales.SalesOrderHeader SOH
INNER JOIN 
Sales.SalesTerritory ST ON SOH.TerritoryID = ST.TerritoryID
WHERE 
YEAR(SOH.OrderDate) = 2014
GROUP BY 
ST.Name
ORDER BY 
TotalVentes DESC; 

--2. Clients actifs : Afficher les clients ayant passé des commandes récemment (2014).
SELECT
C.CustomerID, 
P.Firstname,
P.LastName,
MAX(SOH.OrderDate) AS DerniereCommande
FROM
Sales.Customer C
INNER JOIN
Sales.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
LEFT JOIN 
Person.Person P ON C.PersonID = P.BusinessEntityID
GROUP BY 
C.CustomerID,
P.FirstName,
P.LastName
HAVING
MAX(SOH.OrderDate) >= '2014-01-01'
ORDER BY 
DerniereCommande DESC;

--3.Ventes par catégorie de produit : Afficher les ventes totales pour chaque catégorie de produit.
SELECT
PC.Name AS CategorieProduit, 
SUM(SOD.LineTotal) AS TotalVentes
FROM 
Sales.SalesOrderDetail SOD
INNER JOIN 
Production.Product P
ON SOD.ProductID = P.ProductID
INNER JOIN 
Production.productSubcategory PSC
ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
INNER JOIN 
Production.ProductCategory PC
ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY 
PC.Name
ORDER BY 
TotalVentes DESC;

--4.Ventes par agent de vente : Afficher les ventes totales réalisées par chaque agent de vente.
SELECT 
P.FirstName AS Prenom, 
P.LastName AS NOM,
SUM(SOH.SubTotal) AS TotalVentes
FROM
Sales.SalesOrderHeader SOH
INNER JOIN 
Person.Person P
ON SOH.SalesPersonID = P.BusinessEntityID
GROUP BY 
P.FirstName, 
P.LastName
ORDER BY 
TotalVentes DESC; 

--5.Top 5 des produits : Afficher les 5 produits les plus rentables (en termes de revenus générés).
SELECT TOP 5 
P.Name AS NomProduit,
SUM(SOD.LineTotal) AS RevenuTotal
FROM
Sales.SalesOrderDetail SOD
INNER JOIN
Production.Product P ON SOD.ProductID = P.ProductID
GROUP BY 
P.Name
ORDER BY 
RevenuTotal DESC; 

--6.Ventes par segment de client : Fournir une requête affichant le total des ventes pour chaque segment de clients.
SELECT 
CASE 
WHEN C.StoreID IS NOT NULL THEN 'B2B - Revendeurs (Magasins)'
WHEN C.PersonID IS NOT NULL THEN 'B2C - Particuliers (Internet)'
ELSE 'Autre'
END AS SegmentClient,
SUM(SOH.SubTotal) AS TotalVentes
FROM 
Sales.SalesOrderHeader SOH
INNER JOIN 
Sales.Customer C 
ON SOH.CustomerID = C.CustomerID
GROUP BY 
CASE 
WHEN C.StoreID IS NOT NULL THEN 'B2B - Revendeurs (Magasins)'
WHEN C.PersonID IS NOT NULL THEN 'B2C - Particuliers (Internet)'
ELSE 'Autre'
END
ORDER BY 
TotalVentes DESC;

--7.Segmentation des clients par montant dépensé : Créer des segments de clients basés sur le montant total dépensé (par exemple, bas, moyen, élevé).
WITH TotalParClient AS (
SELECT 
CustomerID, 
SUM(SubTotal) AS MontantTotal
FROM 
Sales.SalesOrderHeader
GROUP BY 
CustomerID
), 
ClientsSegementes AS (
SELECT
CustomerID, 
MontantTotal, 
CASE
WHEN MontantTotal >= 100000 THEN '3 - Elevé (>100k)'
WHEN MontantTotal >= 1000 THEN '2 - Moyen (10k à 100k)'
ELSE '1 - Bas (<10k)'
END AS SegmentDepense
FROM
TotalParClient
)
SELECT
SegmentDepense, 
COUNT(CustomerID) AS NombreDeClients, 
SUM(MontantTotal) AS ChiffreAffairesTotal
FROM 
ClientsSegementes
GROUP BY 
SegmentDepense
ORDER BY 
SegmentDepense DESC; 

--8.Top 10 des clients : Identifier les 10 clients ayant généré le plus de revenus.
SELECT TOP 10 
C.CustomerID, 
P.FirstName AS Prenom, 
P.LastName AS Nom, 
SUM(SOH.SubTotal) AS RevenuTotal
FROM
Sales.Customer C
INNER JOIN 
Sales.SalesOrderHeader SOH
ON C.CustomerID = SOH.CustomerID
LEFT JOIN
Person.Person P
ON C.PersonID = P.BusinessEntityID
GROUP BY 
C.CustomerID, 
P.FirstName,
P.LastName
ORDER BY 
RevenuTotal DESC; 

--9.Clients par type de commande : Fournir une requête affichant les clients qui ont acheté des produits en ligne et ceux qui ont fait des achats en magasin.
WITH TypeAchat AS (
SELECT 
C.CustomerID,
SOH.SubTotal, 
CASE 
WHEN SOH.OnlineOrderFlag = 1 THEN 'En ligne (internetà'
ELSE 'En magasin (physique)'
END AS CanalDeVente
FROM 
Sales.Customer C
INNER JOIN 
Sales.SalesOrderHeader SOH
ON C.CustomerID = SOH.CustomerID
)
SELECT 
CanalDeVente, 
COUNT(DISTINCT CustomerID) AS NombreDeClients, 
SUM(SubTotal) AS ChiffreAffairesTotal
FROM 
TypeAchat
GROUP BY 
CanalDeVente
ORDER BY 
ChiffreAffairesTotal DESC; 

--10.Produits les plus populaires : Identifier les produits les plus achetés au cours des 12 derniers mois.
SELECT TOP 10
P.Name AS NomProduit, 
SUM(SOD.OrderQty) AS QuantiteVendue
FROM 
Sales.SalesOrderDetail SOD 
INNER JOIN
Sales.SalesOrderHeader SOH 
ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN 
Production.Product P
ON SOD.ProductID = P.ProductID
WHERE 
SOH.OrderDate >= '20130701'
AND SOH.OrderDate <= '20140630'
GROUP BY 
P.Name 
ORDER BY QuantiteVendue DESC; 

--11.Ventes par type de produit : Fournir une requête affichant les ventes par type de produit (par exemple, électronique, vêtements, etc.).
SELECT
PC.Name AS Categorie, 
PSC.Name AS SousCategorie,
SUM(SOD.LineTotal) AS TotalVentes
FROM
Sales.SalesOrderDetail SOD
INNER JOIN 
Production.Product P
ON SOD.ProductID = P.ProductID
INNER JOIN 
Production.ProductSubcategory PSC
ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
INNER JOIN 
Production.ProductCategory PC
ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY 
PC.Name, 
PSC.Name
ORDER BY 
Categorie ASC, 
TotalVentes DESC;

--12. Ventes totales par produit et par mois : Afficher les ventes totales de chaque produit sur une période de 12 mois (Juillet 2013 à Juin 2014).
SELECT 
P.Name AS NomProduit,
YEAR(SOH.OrderDate) AS Annee, 
MONTH(SOH.OrderDate) AS Mois, 
SUM(SOD.LineTotal) AS TotalVentes
FROM
Sales.SalesOrderDetail SOD
INNER JOIN 
Sales.SalesOrderHeader SOH
ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN 
Production.Product P
ON SOD.ProductID = P.ProductID
WHERE
SOH.OrderDate >= '20130701'
AND SOH.OrderDate <= '20140630'
GROUP BY 
P.Name, 
YEAR(SOH.OrderDate),
MONTH(SOH.OrderDate)
ORDER BY 
NomProduit ASC, 
Annee ASC, 
Mois ASC;

--13.Ventes par région et par produit : Afficher les ventes totales par produit pour chaque région.
SELECT 
ST.Name AS Region, 
P.Name AS NomProduit, 
SUM(SOD.LineTotal) AS TotalVentes
FROM
Sales.SalesOrderDetail SOD
INNER JOIN 
Sales.SalesOrderHeader SOH
ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN
Sales.SalesTerritory ST
ON SOH.TerritoryID = ST.TerritoryID
INNER JOIN 
Production.Product P
ON SOD.ProductID = P.ProductID
GROUP BY 
ST.Name, 
P.Name
ORDER BY 
Region ASC, 
TotalVentes DESC; 

--14.Taux de retour des produits : Calculer le taux de retour des produits
SELECT 
P.Name AS NomProduit,
SUM(POD.OrderQty) AS QuantiteAchetee, 
SUM(POD.REjectedQty) AS QuantiteRetournee, 
(SUM(POD.RejectedQty) / NULLIF(SUM(POD.OrderQty), 0)) * 100.0 AS TauxRetourPourcentage
FROM 
Purchasing.PurchaseOrderDetail POD
INNER JOIN 
Production.Product P
ON POD.ProductID = P.ProductID
GROUP BY 
P.Name 
HAVING
SUM(POD.RejectedQty) > 0 
ORDER BY 
TauxRetourPourcentage DESC; 

--15.Rentabilité par produit : Identifier les produits les plus rentables et ceux qui ne génèrent pas suffisamment de bénéfices.
WITH CalculFinancier AS (
SELECT 
P.Name AS NomProduit,
SUM(SOD.LineTotal) AS ChiffreAffaires,
SUM(P.StandardCost * SOD.OrderQty) AS CoutTotal
FROM 
Sales.SalesOrderDetail SOD
INNER JOIN 
Production.Product P 
ON SOD.ProductID = P.ProductID
GROUP BY 
P.Name
),
MargeProduit AS (
SELECT 
NomProduit,
ChiffreAffaires,
CoutTotal,
(ChiffreAffaires - CoutTotal) AS BeneficeNet
FROM 
CalculFinancier
)
SELECT 
NomProduit,
ChiffreAffaires,
BeneficeNet,
CASE 
WHEN BeneficeNet > 500000 THEN '1 - Top rentabilité (> 500k)'
WHEN BeneficeNet BETWEEN 50000 AND 500000 THEN '2 - Bonne rentabilité'
WHEN BeneficeNet > 0 AND BeneficeNet < 50000 THEN '3 - Faible rentabilité'
ELSE '4 - En perte (Non rentable)'
END AS StatutRentabilite
FROM 
MargeProduit
ORDER BY 
BeneficeNet DESC;