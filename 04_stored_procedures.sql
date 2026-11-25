-- ============================================================
-- WorkforceIQ | Stored Procedures
-- File        : 04_stored_procedures.sql
-- Description : 6 stored procedures for HR analytics
-- ============================================================

USE hr_analytics;

DELIMITER $$

-- ─────────────────────────────────────────────────────────────
-- SP 1: sp_department_report
-- Full department KPI report for a given department ID
-- Usage: CALL sp_department_report(1);
-- ─────────────────────────────────────────────────────────────
DROP PROCEDURE IF EXISTS sp_department_report$$
CREATE PROCEDURE sp_department_report(IN p_dept_id TINYINT UNSIGNED)
BEGIN
    -- Validate input
    IF NOT EXISTS (SELECT 1 FROM departments WHERE DepartmentID = p_dept_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department not found';
    END IF;

    -- Summary KPIs
    SELECT
        d.DepartmentName,
        d.DepartmentHead,
        d.Location,
        COUNT(e.EmployeeID)                                          AS TotalEmployees,
        SUM(CASE WHEN e.EmployeeStatus='Active'   THEN 1 ELSE 0 END) AS ActiveEmployees,
        SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END) AS Attrition,
        ROUND(AVG(s.BasicSalary),0)                                  AS AvgSalary,
        ROUND(AVG(e.Experience),1)                                   AS AvgExperience,
        ROUND(AVG(p.SatisfactionScore),2)                            AS AvgSatisfaction,
        ROUND(AVG(p.PerformanceRating),2)                            AS AvgRating,
        ROUND(AVG(a.AttendancePercent),2)                            AS AvgAttendance
    FROM departments d
    JOIN employees   e ON d.DepartmentID = e.DepartmentID
    JOIN salary      s ON e.EmployeeID   = s.EmployeeID
    LEFT JOIN performance p ON e.EmployeeID = p.EmployeeID AND p.Year = 2024
    LEFT JOIN attendance  a ON e.EmployeeID = a.EmployeeID AND a.Year = 2024
    WHERE d.DepartmentID = p_dept_id
    GROUP BY d.DepartmentName, d.DepartmentHead, d.Location;

    -- Gender distribution
    SELECT
        Gender,
        COUNT(*) AS EmployeeCount,
        ROUND(COUNT(*)*100.0 / SUM(COUNT(*)) OVER(), 2) AS GenderPct
    FROM employees
    WHERE DepartmentID = p_dept_id
    GROUP BY Gender;

    -- Salary band distribution
    SELECT
        s.SalaryBand,
        COUNT(e.EmployeeID) AS Employees,
        ROUND(AVG(s.BasicSalary),0) AS AvgSalary
    FROM employees e
    JOIN salary s ON e.EmployeeID = s.EmployeeID
    WHERE e.DepartmentID = p_dept_id
    GROUP BY s.SalaryBand
    ORDER BY s.SalaryBand;
END$$

-- ─────────────────────────────────────────────────────────────
-- SP 2: sp_attrition_analysis
-- Attrition breakdown for a given year
-- Usage: CALL sp_attrition_analysis(2023);
-- ─────────────────────────────────────────────────────────────
DROP PROCEDURE IF EXISTS sp_attrition_analysis$$
CREATE PROCEDURE sp_attrition_analysis(IN p_year SMALLINT UNSIGNED)
BEGIN
    -- Overall attrition rate
    SELECT
        COUNT(DISTINCT e.EmployeeID)                                  AS TotalEmployees,
        COUNT(DISTINCT ex.EmployeeID)                                 AS TotalAttrition,
        ROUND(COUNT(DISTINCT ex.EmployeeID)*100.0
              / NULLIF(COUNT(DISTINCT e.EmployeeID),0), 2)            AS AttritionRatePct
    FROM employees e
    LEFT JOIN exit_records ex ON e.EmployeeID = ex.EmployeeID
                              AND YEAR(ex.ExitDate) = p_year;

    -- Attrition by department
    SELECT
        e.Department,
        COUNT(DISTINCT e.EmployeeID)          AS TotalEmployees,
        COUNT(DISTINCT ex.EmployeeID)         AS Attrition,
        ROUND(COUNT(DISTINCT ex.EmployeeID)*100.0
              / NULLIF(COUNT(DISTINCT e.EmployeeID),0), 2) AS AttritionPct
    FROM employees e
    LEFT JOIN exit_records ex ON e.EmployeeID = ex.EmployeeID
                              AND YEAR(ex.ExitDate) = p_year
    GROUP BY e.Department
    ORDER BY AttritionPct DESC;

    -- Attrition by exit reason
    SELECT
        ExitReason,
        COUNT(*) AS Count,
        ROUND(COUNT(*)*100.0 / SUM(COUNT(*)) OVER(), 2) AS Pct
    FROM exit_records
    WHERE YEAR(ExitDate) = p_year
    GROUP BY ExitReason
    ORDER BY Count DESC;
END$$

-- ─────────────────────────────────────────────────────────────
-- SP 3: sp_performance_review
-- Performance summary for a given year
-- Usage: CALL sp_performance_review(2024);
-- ─────────────────────────────────────────────────────────────
DROP PROCEDURE IF EXISTS sp_performance_review$$
CREATE PROCEDURE sp_performance_review(IN p_year SMALLINT UNSIGNED)
BEGIN
    -- Rating distribution
    SELECT
        RatingLabel,
        COUNT(*)                                                      AS Employees,
        ROUND(COUNT(*)*100.0 / SUM(COUNT(*)) OVER(), 2)              AS DistributionPct,
        ROUND(AVG(SatisfactionScore),2)                               AS AvgSatisfaction,
        ROUND(AVG(GoalsMetPercent),1)                                 AS AvgGoalsMet,
        SUM(Promoted)                                                 AS Promoted
    FROM performance
    WHERE Year = p_year
    GROUP BY RatingLabel
    ORDER BY AVG(PerformanceRating) DESC;

    -- Department-level performance
    SELECT
        e.Department,
        ROUND(AVG(p.PerformanceRating),2)     AS AvgRating,
        ROUND(AVG(p.SatisfactionScore),2)     AS AvgSatisfaction,
        ROUND(AVG(p.TrainingHours),1)         AS AvgTrainingHours,
        SUM(p.Promoted)                       AS Promotions,
        ROUND(SUM(p.Promoted)*100.0
              / NULLIF(COUNT(p.PerfID),0),2)  AS PromotionRatePct
    FROM employees  e
    JOIN performance p ON e.EmployeeID = p.EmployeeID
    WHERE p.Year = p_year
    GROUP BY e.Department
    ORDER BY AvgRating DESC;
END$$

-- ─────────────────────────────────────────────────────────────
-- SP 4: sp_salary_benchmark
-- Salary benchmarking for a designation
-- Usage: CALL sp_salary_benchmark('Senior Analyst');
-- ─────────────────────────────────────────────────────────────
DROP PROCEDURE IF EXISTS sp_salary_benchmark$$
CREATE PROCEDURE sp_salary_benchmark(IN p_designation VARCHAR(100))
BEGIN
    SELECT
        e.Department,
        e.Designation,
        COUNT(e.EmployeeID)          AS Headcount,
        MIN(s.BasicSalary)           AS MinSalary,
        ROUND(AVG(s.BasicSalary),0)  AS AvgSalary,
        MAX(s.BasicSalary)           AS MaxSalary,
        ROUND(STDDEV(s.BasicSalary),0) AS SalaryStdDev,
        MIN(s.NetSalary)             AS MinNetSalary,
        ROUND(AVG(s.NetSalary),0)    AS AvgNetSalary,
        MAX(s.NetSalary)             AS MaxNetSalary
    FROM employees e
    JOIN salary s ON e.EmployeeID = s.EmployeeID
    WHERE e.Designation LIKE CONCAT('%', p_designation, '%')
    GROUP BY e.Department, e.Designation
    ORDER BY AvgSalary DESC;
END$$

-- ─────────────────────────────────────────────────────────────
-- SP 5: sp_hiring_pipeline
-- Recruitment pipeline report for a given year
-- Usage: CALL sp_hiring_pipeline(2023);
-- ─────────────────────────────────────────────────────────────
DROP PROCEDURE IF EXISTS sp_hiring_pipeline$$
CREATE PROCEDURE sp_hiring_pipeline(IN p_year SMALLINT UNSIGNED)
BEGIN
    -- Monthly hiring trend
    SELECT
        MONTH(r.JoiningDate)     AS Month,
        MONTHNAME(r.JoiningDate) AS MonthName,
        e.Department,
        COUNT(r.RecruitmentID)   AS NewHires,
        ROUND(AVG(r.HiringCost),0) AS AvgCostPerHire,
        ROUND(AVG(r.TimeToHire_Days),1) AS AvgDaysToHire
    FROM recruitment r
    JOIN employees   e ON r.EmployeeID = e.EmployeeID
    WHERE YEAR(r.JoiningDate) = p_year
    GROUP BY MONTH(r.JoiningDate), MONTHNAME(r.JoiningDate), e.Department
    ORDER BY MONTH(r.JoiningDate);

    -- Source-level summary
    SELECT
        r.RecruitmentSource,
        COUNT(*)                      AS TotalHires,
        ROUND(AVG(r.HiringCost),0)    AS AvgCost,
        SUM(r.HiringCost)             AS TotalCost,
        ROUND(AVG(r.TimeToHire_Days),1) AS AvgDays
    FROM recruitment r
    WHERE YEAR(r.JoiningDate) = p_year
    GROUP BY r.RecruitmentSource
    ORDER BY TotalHires DESC;
END$$

-- ─────────────────────────────────────────────────────────────
-- SP 6: sp_employee_360
-- 360° view of a single employee
-- Usage: CALL sp_employee_360('EMP00001');
-- ─────────────────────────────────────────────────────────────
DROP PROCEDURE IF EXISTS sp_employee_360$$
CREATE PROCEDURE sp_employee_360(IN p_emp_id VARCHAR(10))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM employees WHERE EmployeeID = p_emp_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee not found';
    END IF;

    -- Profile
    SELECT e.*, s.BasicSalary, s.Bonus, s.NetSalary, s.SalaryBand
    FROM employees e
    JOIN salary s ON e.EmployeeID = s.EmployeeID
    WHERE e.EmployeeID = p_emp_id;

    -- Performance history
    SELECT Year, PerformanceRating, RatingLabel, TrainingHours,
           Promoted, SatisfactionScore, GoalsMetPercent, ManagerFeedback
    FROM performance
    WHERE EmployeeID = p_emp_id
    ORDER BY Year;

    -- Attendance history
    SELECT Year, WorkingDays, DaysPresent, Leaves, Absences,
           OvertimeHours, WFHDays, AttendancePercent
    FROM attendance
    WHERE EmployeeID = p_emp_id
    ORDER BY Year;
END$$

DELIMITER ;
