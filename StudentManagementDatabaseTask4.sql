-- TASK 1, 2, 3 and 4
-- TASK 1 : Student Management Database
-- 1) Create Database
create database if not exists StudentManagement;
use StudentManagement;

-- 2) Create Students Table
create table Students (
	StudentID int primary key auto_increment,
    Name varchar(50) not null,
    Gender char(1),
    Age int,
    Grade varchar(5),
    MathScore int,
    ScienceScore int,
    EnglishScore int
);

-- 3) Insert at least 10 records
insert into Students (Name, Gender, Age, Grade, MathScore, ScienceScore, EnglishScore) values
('Arun Kumar', 'M', 18, 'A', 92, 85, 78),
('Priya Sharma', 'F', 17, 'A', 88, 91, 95),
('Rahul Verma', 'M', 18, 'B', 75, 68, 72),
('Sneha Patel', 'F', 17, 'A', 95, 89, 92),
('Vikram Singh', 'M', 19, 'C', 55, 62, 58),
('Ananya Reddy', 'F', 18, 'B', 78, 82, 80),
('Karthik Nair', 'M', 17, 'A', 90, 87, 85),
('Divya Iyer', 'F', 18, 'B', 70, 75, 68),
('Suresh Rajan', 'M', 19, 'C', 48, 55, 52),
('Meera Krishnan', 'F', 17, 'A', 85, 90, 88),
('Ajay Menon', 'M', 18, 'B', 65, 70, 72),
('Lakshmi Devi', 'F', 18, 'A', 93, 88, 91);

-- 4) Required Queries
-- Query 1: Show all student details
select * from Students;
-- Query 2: Average score in each subject
select
	round(avg(MathScore), 2) as Avg_Math,
    round(avg(ScienceScore), 2) as Avg_Science,
    round(avg(EnglishScore), 2) as Avg_English
from Students;
-- Query 3: Top performer (highest total score)
select
	Name,
    MathScore + ScienceScore + EnglishScore as Total_Score
from Students
order by Total_Score desc
limit 1;
-- Query 4: Count students per grade
select
	Grade,
    count(*) as Number_of_Students
from Students
group by Grade
order by Grade;
-- Query 5: Average score by gender
select
	Gender,
    round(avg(MathScore), 2) as Avg_Math,
    round(avg(ScienceScore), 2) as Avg_Science,
    round(avg(EnglishScore), 2) as Avg_English,
    round(avg(MathScore + ScienceScore + EnglishScore), 2) as Avg_Total
from Students
group by Gender;
-- Query 6: Students with Math > 80
select
	Name,
    MathScore,
    Grade
from Students
where MathScore > 80
order by MathScore desc;
-- Query 7: Update a student's grade
-- Example: Update Rahul Verma's grade from B to A
update Students
set Grade = 'A'
where StudentID = 3;
-- Verify the update
select StudentID, Name, Grade
from Students
where StudentID = 3;

-- ====================================================
-- TASK 2: Courses & Enrollments
-- ====================================================
use StudentManagement;

-- 1) Create Courses Table
create table Courses (
	CourseID int primary key auto_increment,
    CourseName varchar(50) not null
);

-- 2) Create Enrollments Table
create table Enrollments (
	EnrollmentID int primary key auto_increment,
    StudentID int,
    CourseID int,
    Grade int,
    foreign key (StudentID) references Students(StudentID),
    foreign key (CourseID) references Courses(CourseID)
);

-- 3) Insert Courses
insert into Courses (CourseName) values
('Mathematics'),
('Science'),
('English'),
('Computer Science'),
('History');

-- 4) Insert Enrollments (sample data)
insert into Enrollments (StudentID, CourseID, Grade) values
(1, 1, 92), (1, 2, 85), (1, 3, 78),
(2, 1, 88), (2, 2, 91), (2, 3, 95), (2, 4, 89),
(3, 1, 75), (3, 2, 68), (3, 5, 72),
(4, 1, 95), (4, 2, 89), (4, 3, 92), (4, 4, 90),
(5, 1, 55), (5, 2, 62), (5, 5, 58),
(6, 1, 78), (6, 2, 82), (6, 3, 80),
(7, 1, 90), (7, 2, 87), (7, 4, 85),
(8, 1, 70), (8, 3, 75), (8, 5, 68),
(9, 1, 48), (9, 2, 55), (9, 5, 52),
(10, 1, 85), (10, 2, 90), (10, 3, 88), (10, 4, 86),
(11, 1, 65), (11, 3, 70), (11, 5, 72),
(12, 1, 93), (12, 2, 88), (12, 3, 91);

-- Queries
-- Query 1: List all students enrolled in each course
select
	c.CourseName,
    s.Name as StudentName,
    e.Grade
from Enrollments e
join Students s on e.StudentID = s.StudentID
join Courses c on e.CourseID = c.CourseID
order by c.CourseName, s.Name;

-- Query 2: Average grade per course
select
	c.CourseName,
    round(avg(e.Grade), 2) as Average_Grade
from Enrollments e
join Courses c on e.CourseID = c.CourseID
group by c.CourseName
order by Average_Grade desc;

-- Query 3: Top 3 students overall (based on average grade)
select
	s.Name as StudentName,
    round(avg(e.Grade), 2) as Average_Grade
from Enrollments e
join Students s on e.StudentID = s.StudentID
group by s.StudentID, s.Name
order by Average_Grade desc
limit 3;

-- Query 4: Count students who failed (grade < 40)
select
	count(distinct e.StudentID) as Failed_Students_Count
from Enrollments e
where e.Grade < 40;

-- ==================================================================
-- TASK 3 : Advanced Queries (JOINs + GROUP BY + HAVING)
-- ==================================================================
use StudentManagement;
-- Query 1: Top student per course
select
	c.CourseName,
    s.Name as StudentName,
    e.Grade as Top_Grade
from Enrollments e
join Students s on e.StudentID = s.StudentID
join Courses c on e.CourseID = c.CourseID
where (e.CourseID, e.Grade) in (
	select CourseID, max(Grade)
    from Enrollments 
    group by CourseID
)
order by c.CourseName;

-- Query 2 : Pass rate per course (grade >= 40)
select
	c.CourseName,
    count(*) as Total_Students,
    sum(case when e.Grade >= 40 then 1 else 0 end) as Passed_Students,
    round(sum(case when e.Grade >= 40 then 1 else 0 end) * 100.0 / count(*), 2) as Pass_Rate_Percentage
from Enrollments e
join Courses c on e.CourseID = c.CourseID
group by c.CourseName
order by Pass_Rate_Percentage desc;

-- Query 3: Overall topper across all courses (highest average grade)
select
	s.Name as StudentName,
    round(avg(e.Grade), 2) as Average_Grade
from Enrollments e
join Students s on e.StudentID = s.StudentID
group by s.StudentID, s.Name
order by Average_Grade desc
limit 1;

-- Query 4: Students enrolled in multiple courses
select
	s.Name as StudentName,
    count(e.CourseID) as Total_Courses
from Enrollments e
join Students s on e.StudentID = s.StudentID
group by s.StudentID, s.Name
having count(e.CourseID) > 1
order by Total_Courses desc;

-- =============================================================
-- TASK 4: Analytical Reports
-- =============================================================
use StudentManagement;
-- 1) Average Grade by Gender
select
	s.Gender,
    round(avg(e.Grade), 2) as Average_Grade
from Students s
join Enrollments e on s.StudentID = e.StudentID
group by s.Gender;

-- 2) Pass Rate per Course (grade >= 40)
select
	c.CourseName,
    count(*) as Total_Students,
    sum(case when e.Grade >= 40 then 1 else 0 end) as Passed,
    round(sum(case when e.Grade >= 40 then 1 else 0 end) * 100.0 / count(*), 2) as Pass_Rate_Percentage
from Enrollments e
join Courses c on e.CourseID = c.CourseID
group by c.CourseName
order by Pass_Rate_Percentage desc;

-- 3) Top 3 Students Overall (based on average grade)
select
	s.Name as StudentName,
    round(avg(e.Grade), 2) as Average_Grade
from Enrollments e
join Students s on e.StudentID = s.StudentID
group by s.StudentID, s.Name
order by Average_Grade desc
limit 3;

-- 4) Students enrolled in more than 2 courses
select
	s.Name as StudentName,
    count(e.CourseID) as Total_Courses
from Enrollments e
join Students s on e.StudentID = s.StudentID
group by s.StudentID, s.Name
having count(e.CourseID) > 2
order by Total_Courses desc;