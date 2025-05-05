---Which payor was the most profitable for Penda Health in 2022?(Assume a gross average margin of 30% per visit)
with pay as(select 
	a.VisitCode,
	Amount,
	Payor,
	VisitDateTime,
	case when Payor in ('Insurance Company A', 'Insurance Company B') and Amount < 100  then 100 else Amount end as y
	from penda.dbo.[BI_Analyst_Assessment_Data_2023 3] a
	join penda.dbo.diagnosis d
	on a.VisitCode = d.VisitCode
	join penda.dbo.health h
	on a.VisitCode = h.VisitCode 
)
select 
	Payor,
	sum(y) as revenue,
	sum(y)*0.3 as profit
	from pay
	where DATEPART(year, VisitDateTime) = 2022
	group by Payor
	order by sum(y)*0.3 desc

------Which Medical Center was the least profitable for Penda Health in 2022?(Assume a gross average margin of 30% per visit)
with med as(select 
	a.VisitCode,
	Amount,
	MedicalCenter,
	Payor,
	VisitDateTime,
	case when Payor in ('Insurance Company A', 'Insurance Company B') and Amount < 100  then 100 else Amount end as y
	from penda.dbo.[BI_Analyst_Assessment_Data_2023 3] a
	join penda.dbo.diagnosis d
	on a.VisitCode = d.VisitCode
	join penda.dbo.health h
	on a.VisitCode = h.VisitCode
)
select 
	MedicalCenter,
	sum(y) as revenue,
	sum(y)*0.3 as profit
	from med
	where DATEPART(year, VisitDateTime) = 2022
	group by MedicalCenter
	order by sum(y)*0.3


---What was the average spend per visit for visits that had a diagnosis for acute gastritis?
with diag as(select 
	--a.VisitCode,
	Amount,
	Payor,
	VisitDateTime,
	Diagnosis,
	case when Payor in ('Insurance Company A', 'Insurance Company B') and Amount < 100 and Diagnosis = 'acute gastritis'  then 100 else Amount end as y
	from penda.dbo.[BI_Analyst_Assessment_Data_2023 3] a
	join penda.dbo.diagnosis d
	on a.VisitCode = d.VisitCode
	join penda.dbo.health h
	on a.VisitCode = h.VisitCode 
)
select 
	Diagnosis,
	count(*) total_visits,
	sum(y) total_amount,
	sum(y)/count(*) avg_per_visit
	from diag
	where Diagnosis = 'acute gastritis'
	group by Diagnosis


---What was the most common diagnosis in 2022 for Tassia and Embakasi branches combined
select 
	count(Diagnosis),
	Diagnosis
	from penda.dbo.[BI_Analyst_Assessment_Data_2023 3] a
	join penda.dbo.diagnosis d
	on a.VisitCode = d.VisitCode
	join penda.dbo.health h
	on a.VisitCode = h.VisitCode
	where datepart(year, VisitDateTime) = 2022
	and MedicalCenter in ('Tassia', 'Embakasi')
	group by Diagnosis
	order by count(Diagnosis) desc

---How many visits did Kimathi Street and Pipeline medical centres have from May 2022 to September 2022?
select 
	count(a.VisitCode)
	from penda.dbo.[BI_Analyst_Assessment_Data_2023 3] a
	join penda.dbo.diagnosis d
	on a.VisitCode = d.VisitCode
	join penda.dbo.health h
	on a.VisitCode = h.VisitCode
	where MedicalCenter in ('Kimathi Street', 'Pipeline' )
	and VisitDateTime >= '2022-05-01' and VisitDateTime < '2022-10-01'

---At Penda Health we have a blended healthcare model where patients can get treatment physically or virtually. How many Unique patients experienced a blended healthcare approach
select
	count(*)
	from(select 
	PatientCode,
	VisitCategory,
	rank() over(partition by PatientCode order by VisitCategory) ranking 
	from penda.dbo.[BI_Analyst_Assessment_Data_2023 3] a
	join penda.dbo.diagnosis d
	on a.VisitCode = d.VisitCode
	join penda.dbo.health h
	on a.VisitCode = h.VisitCode
	where VisitCategory = 'In-person Visit' or VisitCategory ='Telemedicine Visit'
	)fs
	where ranking > 1

---Calculate the Net Promoter Score for Q3 in 2022(Note that valid NPS scores range from 0 to 100)
select 
	sum(NPS_Score)
	from penda.dbo.[BI_Analyst_Assessment_Data_2023 3] a
	join penda.dbo.diagnosis d
	on a.VisitCode = d.VisitCode
	join penda.dbo.health h
	on a.VisitCode = h.VisitCode
	where NPS_Score is not null
	and VisitDateTime >= '2022-07-01' and VisitDateTime < '2022-10-01'

---In 2022, how many visits in Penda Health were second visits?
select 
	count(distinct PatientCode) 
	from(select 
	PatientCode,
	a.VisitCode,
	VisitDateTime,
	rank() over (partition by PatientCode order by VisitDateTime) as ranking
	from penda.dbo.[BI_Analyst_Assessment_Data_2023 3] a
	join penda.dbo.diagnosis d
	on a.VisitCode = d.VisitCode
	join penda.dbo.health h
	on a.VisitCode = h.VisitCode
	where datepart(year, VisitDateTime) = 2022
	)ts
	where ranking = 2




---How many visits in April 2022 happened with 30 days of the preceding visit by the same patient
select
	count(distinct VisitCode)
	from(select 
	PatientCode,
	a.VisitCode,
	VisitDateTime,
	lag(VisitDateTime) over (partition by PatientCode order by VisitDateTime) prev 
	from penda.dbo.[BI_Analyst_Assessment_Data_2023 3] a
	join penda.dbo.diagnosis d
	on a.VisitCode = d.VisitCode
	join penda.dbo.health h
	on a.VisitCode = h.VisitCode
	where VisitDateTime >= '2022-04-01' and VisitDateTime < '2022-05-01'
	)vs
	where prev is not null 
	and DATEDIFF(day, prev, VisitDateTime) > 0 and DATEDIFF(day, prev, VisitDateTime) <= 30
	
	