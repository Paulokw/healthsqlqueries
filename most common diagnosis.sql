/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
  TOP (1000) [Diagnosis], 
  MedicalCenter, 
  COUNT(diagnosis) as diagnosis_count
FROM 
  [AdventureWorksLT2022].[dbo].[BI_Analyst_Assessment_Data_2023] 
  left join dbo.[BI_Analyst_Assessment_Data_2023 3] ON dbo.BI_Analyst_Assessment_Data_2023.VisitCode = dbo.[BI_Analyst_Assessment_Data_2023 3].VisitCode 
where 
  MedicalCenter IN ('Tassia', 'Embakasi') 
group by 
  Diagnosis, 
  MedicalCenter 
order by 
  diagnosis_count desc


  
