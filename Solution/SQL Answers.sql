-- Q1. Total Discharges
select count(*) as Total_Discharges
	from vw_AdmissionData
	where OUTCOME = 'Discharge'

--Q2. Average daily discharge rate
--Total discharges divide by total length of stay

select	
	 cast (( select count(*) as Total_Discharges
		from vw_AdmissionData
		where OUTCOME = 'Discharge') as float) / cast (( select sum(Duration_Of_Stay) as Total_Length_Of_Stay
			from vw_AdmissionData) as float)

--casting, this is to give us numeric value in 2 decimal place and multiplying by 100 to convert to percentage
	
	select	
			CAST( cast (( select count(*) as Total_Discharges
				from vw_AdmissionData
				where OUTCOME = 'Discharge') as float) / cast (( select sum(Duration_Of_Stay) as Total_Length_Of_Stay
							from vw_AdmissionData) as float) as decimal(10,2))*100 as Average_Daily_Discharge_Rate
--Q3. Average length of stay(ALOS)
--Total length of stay divide by total discharges
--Reverse of Q2
	
	select
		cast(( select sum(Duration_Of_Stay) as Total_Length_Of_Stay
				from vw_AdmissionData) as float) / cast((select count(*) as Total_Discharges
				from vw_AdmissionData
				where OUTCOME = 'Discharge') as float) as Average_Length_Of_Stay
--rounding up
	select
			round(cast(( select sum(Duration_Of_Stay) as Total_Length_Of_Stay
				from vw_AdmissionData) as float) / cast((select count(*) as Total_Discharges
				from vw_AdmissionData
				where OUTCOME = 'Discharge') as float),0) as Average_Length_Of_Stay
	
	--alternative ways of calculating Average length  of stay
	select sum(Duration_Of_Stay)/sum(case when outcome = 'Discharge' then 1.0 else 0.0 end) as Avg_Length_Of_Stay
			from vw_AdmissionData

--rounding up
	select round(sum(Duration_Of_Stay)/sum(case when outcome = 'Discharge' then 1.0 else 0.0 end),0) as Avg_Length_Of_Stay
			from vw_AdmissionData


/* Q4. Distribution of discharges by Age group
 < 16 peadiatric
 16 < 65 Adult
 >= 65 Senior Citizen */

select case
			when AGE < 16 then 'Peadiatric'
			when Age < 65 then 'Adult'
			when Age >= 65 then 'Senior Citizen'
			else 'Unknown'
		End as Age_Group, COUNT(*) As Age_Distribution
	from vw_AdmissionData
	where OUTCOME = 'Discharge'
	Group by case
				when AGE < 16 then 'Peadiatric'
				when Age < 65 then 'Adult'
				when Age >= 65 then 'Senior Citizen'
				else 'Unknown'
			End 
	order by 2 desc


/* Q5. Distribution of discharge by Gender */

select Gender, count(*) as Gender_Distribution
	from vw_AdmissionData
	where OUTCOME = 'Discharge'
	Group by Gender
	order by count(*) DESC

/*Q6. distribution of discharge by day of the week */

select DATEPART(weekday,D_O_D) as Day_Of_Week, count(*) As Day_Distribution
	from vw_AdmissionData
	where outcome = 'Discharge'
	Group by DATEPART(Weekday,D_O_D)
	order by 2 Desc


/* To get the day of week in word or name, we re-write and remove the null value */
-- Get Date Name
select FORMAT(D_O_D, 'ddd') as Day_Of_Week, count(*) as Day_Distribution
from vw_AdmissionData
where outcome = 'Discharge' and D_O_D is not null
group by FORMAT(D_O_D,'ddd')
order by 2 desc
