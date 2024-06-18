--Mansi V Malvi							SQL PROJECT

create database project
use project
select * from Hr_data1
-----------------------------------------------------------------------------------
--Q1.Compare an employee's performance rating with the average rating of their peers in the same department.--
select
e.emp_no as EmployeeNumber,
e.Department,
e.Performance_Rating as EmployeePerformanceRating,
d.AvgPerformanceRating as AverageDepartmentPerformanceRating,
CASE
when e.Performance_Rating > d.AvgPerformanceRating then 'Above Average'
when e.Performance_Rating = d.AvgPerformanceRating then 'Average'
else 'Below Average'
end as PerformanceComparison
from
Hr_data1 e
JOIN
(select Department, AVG (Performance_Rating) as AvgPerformanceRating
from Hr_data1
group by Department) d on e.Department = d.Department
-----------------------------------------------------------------------------------
--Q2.	Analyze the trend of employee attrition over time--
select
Years_At_Company as Time_Period, COUNT(*) as Total_Employees,
SUM(case when Attrition = 1 then 1 else 0 end) as Attrition_Count,
(CAST (SUM(case when Attrition = 1 then 1 else 0 end)as float) / COUNT(*)*100) as Attrition_Rate
from
Hr_data1
group by
Years_At_Company
order by
Time_Period;
-----------------------------------------------------------------------------------
--Q3. Predict the likelihood of an employee leaving based on their age, job role, and performance rating--
select distinct * from Hr_data1 
where CONCAT(Age,Job_Role, Performance_Rating)
in 
(select distinct CONCAT(a.Age, a.Job_Role, a.Performance_Rating) p
from Hr_data1 a,
((select Age, Job_Role, Performance_Rating 
from Hr_data1 where Attrition=0) --Attrited Employees
intersect
(select Age, Job_Role, Performance_Rating
from Hr_data1
where Attrition=1
group by emp_no, Age, Job_Role, Performance_Rating, Attrition))b -- Non-attrited employees(inner subquery)
where CONCAT (a.Age, a.Job_Role, a.Performance_Rating)=CONCAT(b.Age, b.Job_Role, b.Performance_Rating))
and Attrition=0
order by Age--Outer subquery
-----------------------------------------------------------------------------------
--Q4. Compare the attrition rate between different departments--
Select Department, COUNT(*) as TotalEmployees, 
SUM(CASE when Attrition =1 then 1 else 0 end) as AttritionCount,
(SUM(CASE when Attrition =1 then 1 else 0 end) * 1.0/count (*)*100) as AttritionRate
from Hr_Data1
group by department
order by AttritionRate;
-----------------------------------------------------------------------------------
--Q5. Create Notification Alerts: Set up notification alerts in the database system to trigger 
--when specific conditions are met (e.g., sudden increase in attrition rate, take a threshold of >=10%)--
ALTER TRIGGER trg_Attrition_Rate_Increase
on Hr_data1
after insert, update, delete
as
begin
    declare @TotalEmployees int;
    declare @AttritionCount int;
    declare @OldAttritionRate decimal(10,2);
    declare @NewAttritionRate decimal(10,2);
    declare @IncreasePercentage decimal(10,2);

    -- Get total number of employees
    select @TotalEmployees = COUNT(*) from Hr_data1;

    -- Get number of employees who left (attrition)
    select @AttritionCount = COUNT(*) from inserted where Attrition = 1;

    -- Calculate old attrition rate
    select @OldAttritionRate = (ISNULL((select COUNT(*) 
	from Hr_data1 where Attrition = 1), 0) * 100.0) / NULLIF(@TotalEmployees, 1);

    -- Calculate new attrition rate
    set @NewAttritionRate = ((@AttritionCount + ISNULL((select COUNT(*) 
	from Hr_data1 where Attrition = 1), 0)) * 100.0) / NULLIF(@TotalEmployees + (select COUNT(*) from inserted), 1);

    -- Calculate increase percentage
    set @IncreasePercentage = @NewAttritionRate - @OldAttritionRate;

    -- Check if the increase percentage exceeds 10%
    if @IncreasePercentage >= 17.0
    begin
        -- Print message
        print 'Warning: The attrition rate has increased by ' + CONVERT(varchar(10), @IncreasePercentage) + '%';
    end
end;

-----------------------------------------------------------------------------------
--Q6. Pivot data to compare the average hourly rate across different education fields--
Select 
[Technical Degree], [Marketing], [Life Sciences], [Medical], [Human Resources], [Other]
from (
select [Education_Field], [Hourly_Rate]
from Hr_data1
)
as SourceTable
PIVOT
(
avg ([Hourly_Rate])
for [Education_Field] in ([Technical Degree], [Marketing], [Life Sciences], [Medical], [Human Resources], [Other])
)
as PivotTable;

--
select COUNT(*) + COUNT (*)

select 1 where null = null 