-- ============================================================
-- WorkforceIQ | Sample INSERT Data
-- File        : 02_insert_data.sql
-- Description : Representative sample inserts (50 employees)
--               For full data: use LOAD DATA INFILE with CSVs
-- Note        : Full dataset in /Dataset/*.csv (10,200 rows)
-- ============================================================

USE hr_analytics;

-- ─────────────────────────────────────────────────────────────
-- DEPARTMENTS
-- ─────────────────────────────────────────────────────────────
INSERT INTO departments (DepartmentID, DepartmentName, DepartmentHead, Location, HeadCount, Budget_INR_Lakhs) VALUES
(1,  'Technology',        'Rajesh Kumar',  'Mumbai',    1250, 156250.00),
(2,  'Human Resources',   'Priya Sharma',  'Delhi',      520,  52000.00),
(3,  'Finance',           'Amit Verma',    'Bangalore',  780,  86450.00),
(4,  'Sales',             'Sneha Patel',   'Hyderabad', 1420, 115800.00),
(5,  'Marketing',         'Vivek Mehta',   'Chennai',    640,  72100.00),
(6,  'Operations',        'Kavita Singh',  'Pune',      1100,  89200.00),
(7,  'Legal',             'Arjun Nair',    'Mumbai',     310,  49600.00),
(8,  'Customer Support',  'Deepa Rao',     'Noida',     1180,  67400.00),
(9,  'Product Management','Rohan Gupta',   'Bangalore',  720,  91200.00),
(10, 'Supply Chain',      'Meera Joshi',   'Gurgaon',    830,  74500.00);

-- ─────────────────────────────────────────────────────────────
-- EMPLOYEES (50 representative records)
-- ─────────────────────────────────────────────────────────────
INSERT INTO employees
    (EmployeeID, Name, Age, Gender, DepartmentID, Department, Designation,
     Education, Experience, City, JoiningDate, ExitDate, EmployeeStatus, RecruitmentSource)
VALUES
('EMP00001','Aarav Sharma',32,'Male',1,'Technology','Senior Analyst','Master''s',8,'Mumbai','2016-03-15',NULL,'Active','LinkedIn'),
('EMP00002','Aditi Verma',28,'Female',2,'Human Resources','HR Business Partner','MBA',5,'Delhi','2019-07-22',NULL,'Active','Employee Referral'),
('EMP00003','Aisha Singh',35,'Female',3,'Finance','Finance Manager','MBA',12,'Bangalore','2012-11-10',NULL,'Active','Campus Hiring'),
('EMP00004','Amit Kumar',41,'Male',4,'Sales','Regional Sales Manager','Bachelor''s',16,'Hyderabad','2008-04-05',NULL,'Active','Job Portal'),
('EMP00005','Ananya Patel',26,'Female',5,'Marketing','Marketing Analyst','Bachelor''s',3,'Chennai','2021-09-01','2023-12-15','Resigned','LinkedIn'),
('EMP00006','Anil Mehta',38,'Male',6,'Operations','Operations Manager','Master''s',14,'Pune','2010-06-20',NULL,'Active','Consultancy'),
('EMP00007','Anjali Gupta',30,'Female',9,'Product Management','Product Manager','MBA',7,'Bangalore','2017-02-14',NULL,'Active','LinkedIn'),
('EMP00008','Arjun Nair',45,'Male',7,'Legal','Legal Manager','Bachelor''s',20,'Mumbai','2004-08-30',NULL,'Active','Walk-In'),
('EMP00009','Aryan Yadav',24,'Male',1,'Technology','Junior Analyst','Bachelor''s',1,'Noida','2023-06-12',NULL,'Active','Campus Hiring'),
('EMP00010','Ayesha Mishra',33,'Female',8,'Customer Support','Support Manager','Master''s',9,'Gurgaon','2015-01-19','2022-08-31','Resigned','Job Portal'),
('EMP00011','Bharat Tiwari',29,'Male',1,'Technology','Analyst','Bachelor''s',5,'Mumbai','2019-04-10',NULL,'Active','LinkedIn'),
('EMP00012','Deepak Pandey',36,'Male',3,'Finance','Senior Financial Analyst','Master''s',11,'Bangalore','2013-09-25',NULL,'Active','Employee Referral'),
('EMP00013','Deepika Rao',27,'Female',5,'Marketing','Marketing Specialist','Bachelor''s',4,'Chennai','2020-11-03','2024-05-20','Resigned','LinkedIn'),
('EMP00014','Divya Nair',31,'Female',2,'Human Resources','HR Specialist','MBA',7,'Delhi','2017-07-17',NULL,'Active','Campus Hiring'),
('EMP00015','Gaurav Iyer',43,'Male',10,'Supply Chain','SCM Director','MBA',19,'Gurgaon','2005-03-08',NULL,'Active','Consultancy'),
('EMP00016','Gurpreet Singh',37,'Male',4,'Sales','Sales Manager','Bachelor''s',13,'Hyderabad','2011-05-14',NULL,'Active','Job Portal'),
('EMP00017','Harish Reddy',25,'Male',6,'Operations','Operations Analyst','Bachelor''s',2,'Pune','2022-08-22',NULL,'Active','Company Website'),
('EMP00018','Ishaan Pillai',39,'Male',1,'Technology','Lead Analyst','Master''s',15,'Mumbai','2009-12-05',NULL,'Active','LinkedIn'),
('EMP00019','Jaya Bose',34,'Female',8,'Customer Support','Support Team Lead','Bachelor''s',10,'Noida','2014-02-28',NULL,'Active','Employee Referral'),
('EMP00020','Karan Das',22,'Male',9,'Product Management','Associate PM','Bachelor''s',0,'Bangalore','2024-01-15',NULL,'Active','Campus Hiring'),
('EMP00021','Kavita Ghosh',48,'Female',7,'Legal','Senior Legal Manager','Bachelor''s',23,'Mumbai','2001-06-10',NULL,'Active','Walk-In'),
('EMP00022','Kishore Chatterjee',30,'Male',10,'Supply Chain','Supply Chain Analyst','Master''s',6,'Gurgaon','2018-09-19',NULL,'Active','LinkedIn'),
('EMP00023','Komal Banerjee',28,'Female',2,'Human Resources','HR Executive','Bachelor''s',4,'Delhi','2020-03-25','2023-11-30','Resigned','Job Portal'),
('EMP00024','Krishna Mukherjee',52,'Male',3,'Finance','CFO','MBA',27,'Bangalore','1997-08-12',NULL,'Active','Walk-In'),
('EMP00025','Lakshmi Sen',40,'Female',5,'Marketing','CMO','MBA',16,'Chennai','2008-10-06',NULL,'Active','Consultancy'),
('EMP00026','Manish Roy',26,'Male',1,'Technology','Analyst','Bachelor''s',3,'Mumbai','2021-05-17',NULL,'Active','LinkedIn'),
('EMP00027','Meera Malhotra',35,'Female',9,'Product Management','Senior Product Manager','MBA',11,'Bangalore','2013-07-23',NULL,'Active','Employee Referral'),
('EMP00028','Mihir Kapoor',29,'Male',4,'Sales','Senior Sales Executive','Bachelor''s',5,'Hyderabad','2019-11-04','2023-07-15','Resigned','LinkedIn'),
('EMP00029','Mohan Khanna',44,'Male',6,'Operations','Senior Operations Manager','Master''s',20,'Pune','2004-04-18',NULL,'Active','Walk-In'),
('EMP00030','Neha Arora',32,'Female',8,'Customer Support','Senior Support Executive','Bachelor''s',8,'Noida','2016-08-09',NULL,'Active','Company Website'),
('EMP00031','Nikhil Bhatia',27,'Male',1,'Technology','Analyst','Bachelor''s',4,'Mumbai','2020-06-30',NULL,'Active','Campus Hiring'),
('EMP00032','Nisha Chopra',36,'Female',7,'Legal','Legal Associate','Bachelor''s',11,'Mumbai','2013-12-02','2021-09-20','Resigned','Job Portal'),
('EMP00033','Pankaj Dhawan',41,'Male',10,'Supply Chain','Supply Chain Manager','Master''s',16,'Gurgaon','2008-02-14',NULL,'Active','Employee Referral'),
('EMP00034','Pooja Saxena',24,'Female',5,'Marketing','Marketing Analyst','Bachelor''s',1,'Chennai','2023-04-10',NULL,'Active','LinkedIn'),
('EMP00035','Pradeep Agarwal',49,'Male',3,'Finance','Finance Manager','MBA',24,'Bangalore','2000-09-15',NULL,'Active','Walk-In'),
('EMP00036','Priya Srivastava',31,'Female',2,'Human Resources','HR Manager','MBA',7,'Delhi','2017-03-27',NULL,'Active','LinkedIn'),
('EMP00037','Rahul Tripathi',38,'Male',4,'Sales','Regional Sales Manager','Bachelor''s',14,'Hyderabad','2010-11-08',NULL,'Active','Consultancy'),
('EMP00038','Raj Shukla',23,'Male',6,'Operations','Operations Analyst','Diploma',1,'Pune','2023-07-20',NULL,'Active','Walk-In'),
('EMP00039','Rajesh Dwivedi',55,'Male',1,'Technology','Director','PhD',30,'Mumbai','1994-05-03',NULL,'Active','Walk-In'),
('EMP00040','Ravi Dubey',33,'Male',9,'Product Management','Product Manager','MBA',9,'Bangalore','2015-10-12',NULL,'Active','Employee Referral'),
('EMP00041','Rekha Sinha',46,'Female',7,'Legal','General Counsel','Bachelor''s',21,'Mumbai','2003-01-22',NULL,'Active','Walk-In'),
('EMP00042','Rohan Patil',28,'Male',8,'Customer Support','Support Executive','Bachelor''s',4,'Noida','2020-09-14','2024-02-28','Resigned','LinkedIn'),
('EMP00043','Rohini Desai',30,'Female',10,'Supply Chain','Senior Analyst','Master''s',7,'Gurgaon','2017-06-05',NULL,'Active','Campus Hiring'),
('EMP00044','Sachin Shah',34,'Male',1,'Technology','Senior Analyst','Master''s',10,'Mumbai','2014-08-19',NULL,'Active','LinkedIn'),
('EMP00045','Sanjay Jain',39,'Male',3,'Finance','Senior Finance Manager','MBA',14,'Bangalore','2010-04-26','2023-03-31','Resigned','Consultancy'),
('EMP00046','Sangeeta Bajaj',35,'Female',2,'Human Resources','HR Director','MBA',11,'Delhi','2013-10-15',NULL,'Active','Employee Referral'),
('EMP00047','Sara Goel',25,'Female',5,'Marketing','Marketing Analyst','Bachelor''s',2,'Chennai','2022-03-08',NULL,'Active','LinkedIn'),
('EMP00048','Shalini Mittal',42,'Female',4,'Sales','VP Sales','MBA',18,'Hyderabad','2006-07-14',NULL,'Active','Walk-In'),
('EMP00049','Shivam Tandon',26,'Male',1,'Technology','Junior Analyst','Bachelor''s',3,'Mumbai','2021-12-01',NULL,'Active','Campus Hiring'),
('EMP00050','Shreya Walia',29,'Female',6,'Operations','Operations Specialist','Bachelor''s',5,'Pune','2019-08-27','2023-06-30','Resigned','Job Portal');

-- ─────────────────────────────────────────────────────────────
-- SALARY RECORDS (50 sample rows)
-- ─────────────────────────────────────────────────────────────
INSERT INTO salary (SalaryID, EmployeeID, BasicSalary, Bonus, Deductions, NetSalary, BonusPercent, SalaryBand, EffectiveDate, Currency) VALUES
('SAL00001','EMP00001',98500.00,16745.00,14775.00,100470.00,17.0,'Band C','2016-03-15','INR'),
('SAL00002','EMP00002',67200.00,10080.00,10080.00,67200.00,15.0,'Band B','2019-07-22','INR'),
('SAL00003','EMP00003',125000.00,25000.00,18750.00,131250.00,20.0,'Band D','2012-11-10','INR'),
('SAL00004','EMP00004',115000.00,18400.00,17250.00,116150.00,16.0,'Band D','2008-04-05','INR'),
('SAL00005','EMP00005',52000.00,7800.00,7800.00,52000.00,15.0,'Band B','2021-09-01','INR'),
('SAL00006','EMP00006',108000.00,19440.00,16200.00,111240.00,18.0,'Band D','2010-06-20','INR'),
('SAL00007','EMP00007',122000.00,24400.00,18300.00,128100.00,20.0,'Band D','2017-02-14','INR'),
('SAL00008','EMP00008',130000.00,26000.00,19500.00,136500.00,20.0,'Band D','2004-08-30','INR'),
('SAL00009','EMP00009',38000.00,3800.00,5700.00,36100.00,10.0,'Band A','2023-06-12','INR'),
('SAL00010','EMP00010',88000.00,13200.00,13200.00,88000.00,15.0,'Band C','2015-01-19','INR'),
('SAL00011','EMP00011',68000.00,8840.00,10200.00,66640.00,13.0,'Band B','2019-04-10','INR'),
('SAL00012','EMP00012',95000.00,14250.00,14250.00,95000.00,15.0,'Band C','2013-09-25','INR'),
('SAL00013','EMP00013',55000.00,7700.00,8250.00,54450.00,14.0,'Band B','2020-11-03','INR'),
('SAL00014','EMP00014',72000.00,10800.00,10800.00,72000.00,15.0,'Band C','2017-07-17','INR'),
('SAL00015','EMP00015',185000.00,37000.00,27750.00,194250.00,20.0,'Band D','2005-03-08','INR'),
('SAL00016','EMP00016',105000.00,15750.00,15750.00,105000.00,15.0,'Band D','2011-05-14','INR'),
('SAL00017','EMP00017',42000.00,5040.00,6300.00,40740.00,12.0,'Band B','2022-08-22','INR'),
('SAL00018','EMP00018',118000.00,23600.00,17700.00,123900.00,20.0,'Band D','2009-12-05','INR'),
('SAL00019','EMP00019',78000.00,11700.00,11700.00,78000.00,15.0,'Band C','2014-02-28','INR'),
('SAL00020','EMP00020',45000.00,4500.00,6750.00,42750.00,10.0,'Band B','2024-01-15','INR'),
('SAL00021','EMP00021',145000.00,29000.00,21750.00,152250.00,20.0,'Band D','2001-06-10','INR'),
('SAL00022','EMP00022',65000.00,8450.00,9750.00,63700.00,13.0,'Band B','2018-09-19','INR'),
('SAL00023','EMP00023',48000.00,5760.00,7200.00,46560.00,12.0,'Band B','2020-03-25','INR'),
('SAL00024','EMP00024',250000.00,50000.00,37500.00,262500.00,20.0,'Band D','1997-08-12','INR'),
('SAL00025','EMP00025',220000.00,44000.00,33000.00,231000.00,20.0,'Band D','2008-10-06','INR'),
('SAL00026','EMP00026',62000.00,7440.00,9300.00,60140.00,12.0,'Band B','2021-05-17','INR'),
('SAL00027','EMP00027',135000.00,27000.00,20250.00,141750.00,20.0,'Band D','2013-07-23','INR'),
('SAL00028','EMP00028',72000.00,10800.00,10800.00,72000.00,15.0,'Band C','2019-11-04','INR'),
('SAL00029','EMP00029',142000.00,28400.00,21300.00,149100.00,20.0,'Band D','2004-04-18','INR'),
('SAL00030','EMP00030',75000.00,11250.00,11250.00,75000.00,15.0,'Band C','2016-08-09','INR'),
('SAL00031','EMP00031',60000.00,7200.00,9000.00,58200.00,12.0,'Band B','2020-06-30','INR'),
('SAL00032','EMP00032',88000.00,13200.00,13200.00,88000.00,15.0,'Band C','2013-12-02','INR'),
('SAL00033','EMP00033',128000.00,25600.00,19200.00,134400.00,20.0,'Band D','2008-02-14','INR'),
('SAL00034','EMP00034',48000.00,5760.00,7200.00,46560.00,12.0,'Band B','2023-04-10','INR'),
('SAL00035','EMP00035',195000.00,39000.00,29250.00,204750.00,20.0,'Band D','2000-09-15','INR'),
('SAL00036','EMP00036',98000.00,14700.00,14700.00,98000.00,15.0,'Band C','2017-03-27','INR'),
('SAL00037','EMP00037',118000.00,17700.00,17700.00,118000.00,15.0,'Band D','2010-11-08','INR'),
('SAL00038','EMP00038',36000.00,3600.00,5400.00,34200.00,10.0,'Band A','2023-07-20','INR'),
('SAL00039','EMP00039',210000.00,42000.00,31500.00,220500.00,20.0,'Band D','1994-05-03','INR'),
('SAL00040','EMP00040',128000.00,25600.00,19200.00,134400.00,20.0,'Band D','2015-10-12','INR'),
('SAL00041','EMP00041',168000.00,33600.00,25200.00,176400.00,20.0,'Band D','2003-01-22','INR'),
('SAL00042','EMP00042',42000.00,5040.00,6300.00,40740.00,12.0,'Band B','2020-09-14','INR'),
('SAL00043','EMP00043',82000.00,12300.00,12300.00,82000.00,15.0,'Band C','2017-06-05','INR'),
('SAL00044','EMP00044',105000.00,15750.00,15750.00,105000.00,15.0,'Band C','2014-08-19','INR'),
('SAL00045','EMP00045',148000.00,29600.00,22200.00,155400.00,20.0,'Band D','2010-04-26','INR'),
('SAL00046','EMP00046',145000.00,29000.00,21750.00,152250.00,20.0,'Band D','2013-10-15','INR'),
('SAL00047','EMP00047',50000.00,6000.00,7500.00,48500.00,12.0,'Band B','2022-03-08','INR'),
('SAL00048','EMP00048',195000.00,39000.00,29250.00,204750.00,20.0,'Band D','2006-07-14','INR'),
('SAL00049','EMP00049',40000.00,4000.00,6000.00,38000.00,10.0,'Band A','2021-12-01','INR'),
('SAL00050','EMP00050',62000.00,7440.00,9300.00,60140.00,12.0,'Band B','2019-08-27','INR');

-- ─────────────────────────────────────────────────────────────
-- ATTENDANCE RECORDS (sample 2024)
-- ─────────────────────────────────────────────────────────────
INSERT INTO attendance (AttendanceID, EmployeeID, Year, WorkingDays, DaysPresent, Leaves, Absences, OvertimeHours, WFHDays, AttendancePercent) VALUES
('ATT00001','EMP00001',2024,250,235,12,3,45,40,94.0),
('ATT00002','EMP00002',2024,250,238,10,2,20,30,95.2),
('ATT00003','EMP00003',2024,250,230,15,5,35,50,92.0),
('ATT00004','EMP00004',2024,250,225,18,7,60,25,90.0),
('ATT00006','EMP00006',2024,250,242,6,2,80,20,96.8),
('ATT00007','EMP00007',2024,250,240,8,2,55,45,96.0),
('ATT00008','EMP00008',2024,250,220,20,10,30,15,88.0),
('ATT00009','EMP00009',2024,250,245,4,1,10,60,98.0),
('ATT00011','EMP00011',2024,250,238,10,2,25,35,95.2),
('ATT00012','EMP00012',2024,250,232,14,4,40,30,92.8),
('ATT00014','EMP00014',2024,250,241,8,1,15,40,96.4),
('ATT00015','EMP00015',2024,250,218,22,10,50,10,87.2),
('ATT00016','EMP00016',2024,250,228,16,6,70,20,91.2),
('ATT00017','EMP00017',2024,250,244,5,1,8,55,97.6),
('ATT00018','EMP00018',2024,250,226,18,6,55,25,90.4),
('ATT00019','EMP00019',2024,250,237,11,2,20,30,94.8),
('ATT00020','EMP00020',2024,250,248,2,0,5,65,99.2),
('ATT00021','EMP00021',2024,250,215,25,10,25,10,86.0),
('ATT00022','EMP00022',2024,250,240,8,2,30,35,96.0),
('ATT00024','EMP00024',2024,250,210,28,12,40,5,84.0),
('ATT00025','EMP00025',2024,250,220,22,8,45,8,88.0),
('ATT00026','EMP00026',2024,250,243,6,1,12,50,97.2),
('ATT00027','EMP00027',2024,250,233,14,3,50,40,93.2),
('ATT00029','EMP00029',2024,250,222,20,8,60,12,88.8),
('ATT00030','EMP00030',2024,250,236,12,2,18,32,94.4),
('ATT00031','EMP00031',2024,250,242,7,1,15,48,96.8),
('ATT00033','EMP00033',2024,250,228,16,6,55,18,91.2),
('ATT00034','EMP00034',2024,250,246,3,1,8,58,98.4),
('ATT00035','EMP00035',2024,250,212,28,10,35,8,84.8),
('ATT00036','EMP00036',2024,250,238,10,2,22,35,95.2),
('ATT00037','EMP00037',2024,250,225,18,7,65,22,90.0),
('ATT00038','EMP00038',2024,250,247,2,1,6,60,98.8),
('ATT00039','EMP00039',2024,250,208,30,12,40,5,83.2),
('ATT00040','EMP00040',2024,250,235,12,3,45,38,94.0),
('ATT00041','EMP00041',2024,250,218,22,10,30,10,87.2),
('ATT00043','EMP00043',2024,250,240,8,2,25,42,96.0),
('ATT00044','EMP00044',2024,250,232,14,4,48,30,92.8),
('ATT00046','EMP00046',2024,250,228,16,6,28,25,91.2),
('ATT00047','EMP00047',2024,250,245,4,1,10,55,98.0),
('ATT00048','EMP00048',2024,250,215,25,10,50,8,86.0),
('ATT00049','EMP00049',2024,250,244,5,1,12,58,97.6),
('ATT00050','EMP00050',2024,250,238,10,2,20,35,95.2);

-- ─────────────────────────────────────────────────────────────
-- PERFORMANCE RECORDS (sample 2024)
-- ─────────────────────────────────────────────────────────────
INSERT INTO performance (PerfID, EmployeeID, Year, PerformanceRating, RatingLabel, TrainingHours, Promoted, SatisfactionScore, GoalsMetPercent, ManagerFeedback) VALUES
('PRF00001','EMP00001',2024,4,'Good',35,0,4.2,82,'Meets Expectations'),
('PRF00002','EMP00002',2024,5,'Outstanding',48,1,4.8,96,'Exceeds Expectations'),
('PRF00003','EMP00003',2024,4,'Good',32,0,4.0,80,'Meets Expectations'),
('PRF00004','EMP00004',2024,3,'Average',20,0,3.5,68,'Meets Expectations'),
('PRF00006','EMP00006',2024,4,'Good',28,1,4.1,78,'Exceeds Expectations'),
('PRF00007','EMP00007',2024,5,'Outstanding',52,1,4.9,98,'Exceptional'),
('PRF00008','EMP00008',2024,3,'Average',18,0,3.2,65,'Meets Expectations'),
('PRF00009','EMP00009',2024,4,'Good',40,0,4.3,85,'Exceeds Expectations'),
('PRF00011','EMP00011',2024,3,'Average',22,0,3.6,70,'Meets Expectations'),
('PRF00012','EMP00012',2024,4,'Good',38,0,4.0,82,'Meets Expectations'),
('PRF00014','EMP00014',2024,5,'Outstanding',55,1,4.7,95,'Exceptional'),
('PRF00015','EMP00015',2024,3,'Average',15,0,3.0,60,'Meets Expectations'),
('PRF00016','EMP00016',2024,4,'Good',30,1,4.2,80,'Exceeds Expectations'),
('PRF00017','EMP00017',2024,4,'Good',42,0,4.4,88,'Exceeds Expectations'),
('PRF00018','EMP00018',2024,3,'Average',25,0,3.4,68,'Meets Expectations'),
('PRF00019','EMP00019',2024,4,'Good',35,0,4.1,82,'Meets Expectations'),
('PRF00020','EMP00020',2024,5,'Outstanding',50,0,4.6,95,'Exceptional'),
('PRF00021','EMP00021',2024,2,'Below Average',10,0,2.5,45,'Needs Improvement'),
('PRF00022','EMP00022',2024,3,'Average',24,0,3.7,72,'Meets Expectations'),
('PRF00024','EMP00024',2024,3,'Average',12,0,3.0,58,'Meets Expectations'),
('PRF00025','EMP00025',2024,4,'Good',28,0,4.0,78,'Meets Expectations'),
('PRF00026','EMP00026',2024,4,'Good',38,0,4.2,85,'Exceeds Expectations'),
('PRF00027','EMP00027',2024,5,'Outstanding',58,1,4.8,97,'Exceptional'),
('PRF00029','EMP00029',2024,3,'Average',20,0,3.3,65,'Meets Expectations'),
('PRF00030','EMP00030',2024,4,'Good',32,0,4.0,80,'Meets Expectations'),
('PRF00031','EMP00031',2024,4,'Good',36,0,4.1,83,'Exceeds Expectations'),
('PRF00033','EMP00033',2024,3,'Average',22,0,3.5,70,'Meets Expectations'),
('PRF00034','EMP00034',2024,5,'Outstanding',44,0,4.5,92,'Exceeds Expectations'),
('PRF00035','EMP00035',2024,2,'Below Average',8,0,2.2,42,'Needs Improvement'),
('PRF00036','EMP00036',2024,4,'Good',36,0,4.3,82,'Meets Expectations'),
('PRF00037','EMP00037',2024,4,'Good',30,1,4.0,78,'Exceeds Expectations'),
('PRF00038','EMP00038',2024,5,'Outstanding',48,0,4.7,95,'Exceptional'),
('PRF00039','EMP00039',2024,3,'Average',18,0,3.1,62,'Meets Expectations'),
('PRF00040','EMP00040',2024,4,'Good',40,0,4.2,84,'Exceeds Expectations'),
('PRF00041','EMP00041',2024,3,'Average',16,0,3.0,60,'Meets Expectations'),
('PRF00043','EMP00043',2024,4,'Good',34,0,4.0,80,'Meets Expectations'),
('PRF00044','EMP00044',2024,4,'Good',38,1,4.3,85,'Exceeds Expectations'),
('PRF00046','EMP00046',2024,5,'Outstanding',52,1,4.8,96,'Exceptional'),
('PRF00047','EMP00047',2024,4,'Good',40,0,4.4,88,'Exceeds Expectations'),
('PRF00048','EMP00048',2024,3,'Average',20,0,3.5,68,'Meets Expectations'),
('PRF00049','EMP00049',2024,4,'Good',38,0,4.1,83,'Exceeds Expectations'),
('PRF00050','EMP00050',2024,3,'Average',22,0,3.6,70,'Meets Expectations');

-- ─────────────────────────────────────────────────────────────
-- RECRUITMENT RECORDS (sample)
-- ─────────────────────────────────────────────────────────────
INSERT INTO recruitment (RecruitmentID, EmployeeID, RecruitmentSource, HiringCost, TimeToHire_Days, InterviewRounds, OfferAccepted, JoiningDate, RecruiterName, JobPortalUsed) VALUES
('REC00001','EMP00001','LinkedIn',32000.00,45,4,'Yes','2016-03-15','Anjali Mehta','LinkedIn'),
('REC00002','EMP00002','Employee Referral',9500.00,18,2,'Yes','2019-07-22','Vikram Das','N/A'),
('REC00003','EMP00003','Campus Hiring',14000.00,30,3,'Yes','2012-11-10','Priya Anand','N/A'),
('REC00004','EMP00004','Job Portal',28000.00,52,4,'Yes','2008-04-05','Ravi Rao','Job Portal'),
('REC00005','EMP00005','LinkedIn',35000.00,38,3,'Yes','2021-09-01','Anjali Mehta','LinkedIn'),
('REC00006','EMP00006','Consultancy',65000.00,72,5,'Yes','2010-06-20','Neha Sharma','N/A'),
('REC00007','EMP00007','LinkedIn',38000.00,42,4,'Yes','2017-02-14','Anjali Mehta','LinkedIn'),
('REC00008','EMP00008','Walk-In',5500.00,12,2,'Yes','2004-08-30','Divya Singh','N/A'),
('REC00009','EMP00009','Campus Hiring',11000.00,25,2,'Yes','2023-06-12','Pooja Kapoor','N/A'),
('REC00010','EMP00010','Job Portal',24000.00,48,3,'Yes','2015-01-19','Ravi Rao','Job Portal'),
('REC00011','EMP00011','LinkedIn',30000.00,40,3,'Yes','2019-04-10','Anjali Mehta','LinkedIn'),
('REC00012','EMP00012','Employee Referral',8000.00,15,2,'Yes','2013-09-25','Vikram Das','N/A'),
('REC00013','EMP00013','LinkedIn',33000.00,35,3,'Yes','2020-11-03','Anjali Mehta','LinkedIn'),
('REC00014','EMP00014','Campus Hiring',13000.00,28,3,'Yes','2017-07-17','Pooja Kapoor','N/A'),
('REC00015','EMP00015','Consultancy',72000.00,85,5,'Yes','2005-03-08','Neha Sharma','N/A'),
('REC00016','EMP00016','Job Portal',26000.00,50,4,'Yes','2011-05-14','Ravi Rao','Job Portal'),
('REC00017','EMP00017','Company Website',12000.00,22,2,'Yes','2022-08-22','Amit Bajaj','Company Website'),
('REC00018','EMP00018','LinkedIn',36000.00,44,4,'Yes','2009-12-05','Anjali Mehta','LinkedIn'),
('REC00019','EMP00019','Employee Referral',7500.00,14,2,'Yes','2014-02-28','Vikram Das','N/A'),
('REC00020','EMP00020','Campus Hiring',10000.00,20,2,'Yes','2024-01-15','Pooja Kapoor','N/A'),
('REC00021','EMP00021','Walk-In',4500.00,10,2,'Yes','2001-06-10','Divya Singh','N/A'),
('REC00022','EMP00022','LinkedIn',28000.00,36,3,'Yes','2018-09-19','Anjali Mehta','LinkedIn'),
('REC00023','EMP00023','Job Portal',22000.00,42,3,'Yes','2020-03-25','Ravi Rao','Job Portal'),
('REC00024','EMP00024','Walk-In',6000.00,8,3,'Yes','1997-08-12','Divya Singh','N/A'),
('REC00025','EMP00025','Consultancy',68000.00,80,5,'Yes','2008-10-06','Neha Sharma','N/A'),
('REC00026','EMP00026','LinkedIn',31000.00,38,3,'Yes','2021-05-17','Anjali Mehta','LinkedIn'),
('REC00027','EMP00027','Employee Referral',9000.00,16,2,'Yes','2013-07-23','Vikram Das','N/A'),
('REC00028','EMP00028','LinkedIn',34000.00,40,3,'Yes','2019-11-04','Anjali Mehta','LinkedIn'),
('REC00029','EMP00029','Walk-In',5000.00,11,2,'Yes','2004-04-18','Divya Singh','N/A'),
('REC00030','EMP00030','Company Website',14000.00,24,3,'Yes','2016-08-09','Amit Bajaj','Company Website');

-- ─────────────────────────────────────────────────────────────
-- EXIT RECORDS (sample)
-- ─────────────────────────────────────────────────────────────
INSERT INTO exit_records (ExitID, EmployeeID, ExitDate, ExitReason, TenureDays, NoticeServed, ExitInterviewDone, ReHireEligible, LastPerformanceRating) VALUES
('EXT00001','EMP00005','2023-12-15','Better Opportunity',849,'Yes','Yes','Yes',3),
('EXT00002','EMP00010','2022-08-31','Salary Dissatisfaction',2780,'Yes','Yes','Maybe',3),
('EXT00003','EMP00013','2024-05-20','Better Opportunity',1294,'Yes','Yes','Yes',4),
('EXT00004','EMP00023','2023-11-30','Personal Reasons',1345,'Partial','No','No',3),
('EXT00005','EMP00028','2023-07-15','Better Opportunity',1349,'Yes','Yes','Yes',3),
('EXT00006','EMP00032','2021-09-20','Better Opportunity',2848,'Partial','Yes','Maybe',3),
('EXT00007','EMP00042','2024-02-28','Work-Life Balance',1262,'Yes','Yes','Yes',2),
('EXT00008','EMP00045','2023-03-31','Better Opportunity',4722,'Yes','Yes','Yes',3),
('EXT00009','EMP00050','2023-06-30','Salary Dissatisfaction',1402,'Yes','Yes','Maybe',3);

-- ─────────────────────────────────────────────────────────────
-- HOW TO LOAD FULL DATASET (10,200 rows)
-- Run after importing CSVs from /Dataset/ folder:
-- ─────────────────────────────────────────────────────────────
/*
LOAD DATA INFILE '/path/to/Dataset/departments.csv'
INTO TABLE departments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(DepartmentID, DepartmentName, DepartmentHead, Location, HeadCount, Budget_INR_Lakhs);

LOAD DATA INFILE '/path/to/Dataset/employees.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(EmployeeID, Name, Age, Gender, DepartmentID, Department, Designation,
 Education, Experience, City, JoiningDate, @ExitDate, EmployeeStatus, RecruitmentSource)
SET ExitDate = NULLIF(@ExitDate, '');

LOAD DATA INFILE '/path/to/Dataset/salary.csv'
INTO TABLE salary
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/Dataset/attendance.csv'
INTO TABLE attendance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/Dataset/performance.csv'
INTO TABLE performance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/Dataset/recruitment.csv'
INTO TABLE recruitment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/Dataset/exit_records.csv'
INTO TABLE exit_records
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
*/
