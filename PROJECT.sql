#-----------Job Portal Management System - MySQL Capstone Project-----------
#create database and use database
create database project;
use project;

#create table----
create table Candidates(candidate_id int  primary key, full_name char(30), phone bigint UNIQUE, email  varchar(20) UNIQUE, city varchar(20));
desc Candidates;

create table  Employers(employer_id  int primary key, company_name char(20), industry char(20));
desc Employers;

create table Jobs(job_id  int primary key, employer_id int,foreign key (employer_id) references Employers(employer_id), title char(20), location char(20), salary int) ;
desc Jobs;

create table  Applications(application_id int  primary key, candidate_id int , foreign key (candidate_id) references Candidates(candidate_id), job_id int,Foreign key(job_id) references Jobs(job_id) , application_date date, status varchar(20)); 
desc Applications;
create table  Interviews(interview_id int primary key, application_id int,  Foreign Key(application_id)references Applications(application_id) , interview_date date, mode char(20), result char(20));
desc Interviews;
 # insert the values into candidates 
INSERT INTO Candidates VALUES 
(1,'Aarav','900000001','c1@mail.com','Hyderabad'), 
(2,'Bhavya','900000002','c2@mail.com','Vijayawada'), 
(3,'Charan','900000003','c3@mail.com','Vizag'), 
(4,'Divya','900000004','c4@mail.com','Guntur'), 
(5,'Esha','900000005','c5@mail.com','Warangal'), 
(6,'Farhan','900000006','c6@mail.com','Nellore'), 
(7,'Gopi','900000007','c7@mail.com','Kurnool'), 
(8,'Hari','900000008','c8@mail.com','Tirupati'), 
(9,'Isha','900000009','c9@mail.com','Chennai'), 
(10,'John','900000010','c10@mail.com','Bengaluru'); 
#insert the values into Employers
INSERT INTO Employers VALUES 
(101,'TechNova','IT'),
(102,'DataWave','Analytics'),
(103,'CloudEdge','Cloud'), 
(104,'FinCore','Finance'),
(105,'HealthSoft','Healthcare'); 
#insert the values into jobs
INSERT INTO Jobs VALUES 
(1001,101,'Python Developer','Hyderabad',650000), 
(1002,101,'SQL Developer','Hyderabad',550000), 
(1003,102,'Data Analyst','Vizag',600000), 
(1004,103,'Cloud Engineer','Bengaluru',850000), 
(1005,104,'BI Developer','Chennai',700000), 
(1006,105,'ML Engineer','Hyderabad',950000);
#insert the values into applications
INSERT INTO Applications VALUES 
(1,1,1001,'2026-07-01','Applied'), 
(2,2,1003,'2026-07-02','Shortlisted'), 
(3,3,1002,'2026-07-02','Rejected'), 
(4,4,1004,'2026-07-03','Interview'), 
(5,5,1005,'2026-07-03','Selected'), 
(6,6,1006,'2026-07-04','Applied'), 
(7,7,1001,'2026-07-05','Interview'), 
(8,8,1002,'2026-07-06','Shortlisted'), 
(9,9,1004,'2026-07-07','Applied'), 
(10,10,1006,'2026-07-08','Selected');

#insert the values into interviews
INSERT INTO Interviews VALUES 
(201,2,'2026-07-05','Online','Pending'), 
(202,4,'2026-07-06','Offline','Pending'), 
(203,5,'2026-07-07','Online','Selected'), 
(204,7,'2026-07-08','Offline','Rejected'), 
(205,8,'2026-07-09','Online','Pending'), 
(206,10,'2026-07-10','Offline','Selected'); 
#to fetch the tables--
select * from candidates;
select * from employers;
select * from jobs;
select * from applications;
select * from interviews;

#-----Queries-----
#1. List all jobs.
select * from jobs;
#2. Show applications with candidate names.
select c.full_name ,a.application_id,a.job_id,a.application_date,a.status from candidates c join applications a on c.candidate_id=a.candidate_id;
#4. Display employer names in uppercase/lowercase.
select distinct full_name ,upper(full_name)uppercase,lower(full_name)lowercase from Candidates;
#5. Show the first five characters of every company name.
select  company_name,substring(company_name ,1,5) from employers;
#6.Concatenate the candidate's name and city
select distinct concat(full_name,'--',city) from candidates;
#7.Replace the word Engineer with specialist  in job titles
select distinct title,replace(title,'Engineer','specialist')from jobs;
#8.find all jobs where the title contains the word Developer
select distinct title from jobs where title like '%Developer%';
#9.find jobs in Hyderabad
select distinct location,title from jobs where location like  'Hyderabad';
#10.Applications in last 7 days
select  * from applications where application_date >=date_sub(curdate(),interval 7 day);
#11.count job company-wise
select e.company_name,count(j.job_id) from employers e join jobs j on e.employer_id=j.employer_id group by e.company_name;
#12.Format applications dates in the format:Mon-Jul-26
select application_date,date_format(application_date,'%a-%b-%y') as formatted_date from applications;
#13.find candidates whose interviews are scheduled today
select c.full_name,i.interview_date from interviews i join applications a on i.application_id=a.application_id join candidates c on a.candidate_id=c.candidate_id where i.interview_date=curdate();
#14. Show the number of days since each application was submitted.
select application_date,datediff(curdate()) from applications ;
#15. Display the highest and lowest salary offered.
select distinct max(salary) as highest_salary,min(salary) as lowest_salary from jobs order by highest_salary,lowest_salary desc limit 1;
#16. Calculate the total salary budget offered by each company.
select e.company_name,sum(j.salary)as total_budget from Employers e join Jobs j on e.employer_id=j.employer_id group by e.company_name;
#17. Count applications by status.
select  status,count(status) from applications group by status;
#18. Employer with most jobs.
select e.company_name,count(j.job_id) as total_jobs from employers e join jobs j on e.employer_id=j.employer_id group by e.company_name;
#19. Candidate with most applications.
select c.full_name,count(a.application_id) as total_applicates from candidates c join applications a on a.candidate_id=c.candidate_id group by c.full_name;
#20. Selected candidates.
select  *from applications where status ='Selected';
#--21. Rejected applications--. 
select  *from applications where status ='Rejected';
#--22. Companies with more than one job--. 
SELECT e.company_name,COUNT(j.job_id) AS Total_Jobs FROM Employers e JOIN Jobs j ON e.employer_id = j.employer_id 
GROUP BY e.employer_id, e.company_name HAVING COUNT(j.job_id) > 1;
#--23. Show locations having more than two job openings--. 
SELECT location,COUNT(*) AS Total_Jobs FROM Jobs GROUP BY location HAVING COUNT(*) > 2;
#--24. Average salary by company. 
SELECT e.company_name,AVG(j.salary) AS Average_Salary FROM Employers e JOIN Jobs j ON e.employer_id = j.employer_id GROUP BY e.company_name;

#--25. Top 5 latest jobs. 
SELECT *FROM Jobs ORDER BY job_id DESC LIMIT 5;
#--26. Jobs in IT industry--.
select e.company_name,e.industry,j.title from employers e join jobs j on e.employer_id =j.employer_id where industry='IT';
#--27. Display candidate name, company name, and job title for every application.
select c.full_name,e.company_name,j.title from employers e join jobs j on e.employer_id=j.employer_id join Applications a on a.job_id=j.job_id join Candidates c on c.candidate_id=a.candidate_id ;
#28. Display interview details along with candidate and company information.
select c.full_name,e.company_name,e.industry,i.interview_id,i.interview_date,i.mode,i.result from employers e,Candidates c join Applications a on a.candidate_id=c.candidate_id join interviews i on i.application_id=a.application_id;
#-- 29. Display company names with the total number of applications received.
select e.company_name,count(a.application_id) as total_applications from  employers e join jobs j on e.employer_id=j.employer_id join Applications a on a.job_id=j.job_id join Candidates c on c.candidate_id=a.candidate_id group by e.company_name ;

#--30. Candidates without applications.
select c.full_name ,a.application_id from candidates c  join applications a  on c.candidate_id=a.candidate_id where application_id is null;
#--31. Display candidates who have never attended an interview.
select c.candidate_id,c.full_name from  Candidates c where  c.candidate_id not in (select a.candidate_id from Applications a join Interviews i on a.application_id = i.application_id);
#32. Create a view named Selected_Candidates showing selected candidates with company and job details.
create view Selected_Candidates as select c.full_name,e.company_name,j.title from employers e join jobs j on e.employer_id=j.employer_id join Applications a on a.job_id=j.job_id join Candidates c on c.candidate_id=a.candidate_id   where status ='Selected';
select * from Selected_Candidates;
#33. Create a view to display all active job postings.
create view Active_jobs as select * from jobs;
select  *  from Active_jobs;
#34. Retrieve data from the created views.
select * from Selected_Candidates;
select  *  from Active_jobs;
#35. Start a transaction and update application status to Interview Scheduled.
start transaction;
update Applications set status = 'Interview Scheduled' where  application_id = 1;
select * from applications;
#36. Roll back a transaction after deleting an application accidentally.
begin;
delete from applications where application_id = 3;
select * from applications;
rollback;
#37. Create a stored procedure to display all jobs offered by a particular employer.• Input: employer_id • Display job title, location, and salary.
#in stored procedure query
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetJobs`(in emp_id int)
BEGIN
select employer_id,title,location,salary from Jobs where employer_id = emp_id;
END
#to call procedure
call project.GetJobs(102);
#38. Create a stored procedure to display all applications with a particular status.• Input: status• For example, display all Shortlisted applications.
#stored procedure query
CREATE DEFINER=`root`@`localhost` PROCEDURE `getapplications`(in status1 VARCHAR(50))
BEGIN
select *from Applications where status = status1;
END

#to call procedure
call project.getapplications('selected');
#39. Create a trigger on the Applications table.
#• Whenever a new application is inserted, automatically store the application_id,candidate_id, job_id, and application date in an Application_Log table.