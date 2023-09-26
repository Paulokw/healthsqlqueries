/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
  TOP (1000) [ProspectiveBuyerKey] -----,[ProspectAlternateKey]
  , 
  [FirstName] -----,[MiddleName]
  , 
  [LastName], 
  CONCAT(firstname, ', ', lastname) as fullname, 
  LEFT(BirthDate, 11) as birthdate, 
  [MaritalStatus], 
  [Gender] ----,[EmailAddress]
  , 
  [YearlyIncome], 
  [TotalChildren], 
  [NumberChildrenAtHome], 
  [Education], 
  [Occupation], 
  [HouseOwnerFlag], 
  [NumberCarsOwned] ----,[AddressLine1]
  ----,[AddressLine2]
  , 
  [City] ----,[StateProvinceCode]
  ----,[PostalCode]
  , 
  [Phone] ----,[Salutation]
  ----,[Unknown]
  
FROM 
  [AdventureWorksDW2022].[dbo].[ProspectiveBuyer]
WHERE Gender='F' AND YearlyIncome >= 40000 AND MaritalStatus = 'S'
ORDER BY YearlyIncome asc


