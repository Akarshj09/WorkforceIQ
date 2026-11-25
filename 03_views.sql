-- ============================================================
-- WorkforceIQ | Analytical Views
-- File        : 03_views.sql
-- Description : 12 production views for reporting & Power BI
-- ============================================================

USE hr_analytics;

-- ─────────────────────────────────────────────────────────────
-- VIEW 1: vw_employee_master
-- Full employee profile combining all dimension attributes
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_employee_master AS
SELECT
    e.EmployeeID,
    e.Name,
    e.Age,
    e.Gender,
    e.Department,
    e.DepartmentID,
    e.Designation,
    e.Education,
    e.Experience,
    e.City,
    e.JoiningDate,
    e.ExitDate,
    e.EmployeeStatus,
    e.RecruitmentSource,
    s.BasicSalary,
    s.Bonus,
    s.NetSalary,
    s.SalaryBand,
    s.BonusPercent,
    d.DepartmentHead,
    d.Budget_INR_Lakhs  AS DeptBudget,
    YEAR(e.JoiningDate) AS JoiningYear,
    TIMESTAMPDIFF(YEAR, e.JoiningDate, CURDATE()) AS TenureYears
FROM employees e
JOIN salary      s ON e.EmployeeID = s.EmployeeID
JOIN departments d ON e.DepartmentID = d.DepartmentID;

-- ─────────────────────────────────────────────────────────────
-- VIEW 2: vw_attrition_summary
-- One row per resigned/terminated employee with exit context
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_attrition_summary AS
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Designation,
    e.Gender,
    e.Experience,
    e.City,
    s.BasicSalary,
    s.SalaryBand,
    ex.ExitDate,
    ex.ExitReason,
    ex.TenureDays,
    ROUND(ex.TenureDays / 365.0, 1)     AS TenureYears,
    ex.NoticeServed,
    ex.ExitInterviewDone,
    ex.ReHireEligible,
    ex.LastPerformanceRating,
    YEAR(ex.ExitDate)                    AS ExitYear,
    MONTH(ex.ExitDate)                   AS ExitMonth,
    MONTHNAME(ex.ExitDate)               AS ExitMonthName
FROM employees  e
JOIN exit_records ex ON e.EmployeeID = ex.EmployeeID
JOIN salary       s  ON e.EmployeeID = s.EmployeeID;

-- ─────────────────────────────────────────────────────────────
-- VIEW 3: vw_department_kpis
-- Department-level aggregated KPIs
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_department_kpis AS
SELECT
    d.DepartmentID,
    d.DepartmentName,
    d.DepartmentHead,
    d.Location,
    COUNT(e.EmployeeID)                         AS TotalEmployees,
    SUM(CASE WHEN e.EmployeeStatus='Active' THEN 1 ELSE 0 END) AS ActiveEmployees,
    SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END) AS ResignedEmployees,
    ROUND(SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0
          / NULLIF(COUNT(e.EmployeeID),0), 2)   AS AttritionRatePct,
    ROUND(AVG(s.BasicSalary), 0)                AS AvgBasicSalary,
    ROUND(AVG(s.NetSalary), 0)                  AS AvgNetSalary,
    MAX(s.BasicSalary)                          AS MaxSalary,
    MIN(s.BasicSalary)                          AS MinSalary,
    ROUND(AVG(e.Experience), 1)                 AS AvgExperienceYears,
    ROUND(AVG(e.Age), 1)                        AS AvgAge,
    SUM(r.HiringCost)                           AS TotalHiringCost,
    ROUND(AVG(r.TimeToHire_Days), 1)            AS AvgTimeToHire
FROM departments d
LEFT JOIN employees  e ON d.DepartmentID = e.DepartmentID
LEFT JOIN salary     s ON e.EmployeeID   = s.EmployeeID
LEFT JOIN recruitment r ON e.EmployeeID  = r.EmployeeID
GROUP BY d.DepartmentID, d.DepartmentName, d.DepartmentHead, d.Location;

-- ─────────────────────────────────────────────────────────────
-- VIEW 4: vw_performance_summary
-- Latest year performance per employee
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_performance_summary AS
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Designation,
    e.Gender,
    e.Experience,
    p.Year,
    p.PerformanceRating,
    p.RatingLabel,
    p.TrainingHours,
    p.Promoted,
    p.SatisfactionScore,
    p.GoalsMetPercent,
    p.ManagerFeedback,
    s.BasicSalary,
    s.SalaryBand,
    a.AttendancePercent
FROM employees  e
JOIN performance p ON e.EmployeeID = p.EmployeeID
JOIN salary      s ON e.EmployeeID = s.EmployeeID
LEFT JOIN attendance a ON e.EmployeeID = a.EmployeeID AND p.Year = a.Year;

-- ─────────────────────────────────────────────────────────────
-- VIEW 5: vw_recruitment_analysis
-- Cost and efficiency of each recruitment channel
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_recruitment_analysis AS
SELECT
    r.RecruitmentSource,
    COUNT(r.RecruitmentID)               AS TotalHires,
    ROUND(AVG(r.HiringCost), 0)          AS AvgHiringCost,
    SUM(r.HiringCost)                    AS TotalHiringCost,
    ROUND(AVG(r.TimeToHire_Days), 1)     AS AvgTimeToHire,
    ROUND(AVG(r.InterviewRounds), 1)     AS AvgInterviewRounds,
    SUM(CASE WHEN e.EmployeeStatus='Active'   THEN 1 ELSE 0 END) AS RetainedEmployees,
    SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END) AS AttritionFromSource,
    ROUND(SUM(CASE WHEN e.EmployeeStatus='Active' THEN 1 ELSE 0 END)*100.0
          / NULLIF(COUNT(r.RecruitmentID),0), 2)  AS RetentionRatePct
FROM recruitment r
JOIN employees e ON r.EmployeeID = e.EmployeeID
GROUP BY r.RecruitmentSource
ORDER BY TotalHires DESC;

-- ─────────────────────────────────────────────────────────────
-- VIEW 6: vw_salary_bands
-- Salary distribution across bands and departments
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_salary_bands AS
SELECT
    e.Department,
    s.SalaryBand,
    COUNT(e.EmployeeID)          AS EmployeeCount,
    ROUND(AVG(s.BasicSalary),0)  AS AvgSalary,
    MIN(s.BasicSalary)           AS MinSalary,
    MAX(s.BasicSalary)           AS MaxSalary,
    ROUND(SUM(s.BasicSalary),0)  AS TotalSalaryBill,
    ROUND(AVG(s.BonusPercent),2) AS AvgBonusPct
FROM employees e
JOIN salary s ON e.EmployeeID = s.EmployeeID
GROUP BY e.Department, s.SalaryBand
ORDER BY e.Department, s.SalaryBand;

-- ─────────────────────────────────────────────────────────────
-- VIEW 7: vw_monthly_hiring_trend
-- Year/Month hiring trend for trend charts
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_monthly_hiring_trend AS
SELECT
    YEAR(JoiningDate)        AS HiringYear,
    MONTH(JoiningDate)       AS HiringMonth,
    MONTHNAME(JoiningDate)   AS MonthName,
    Department,
    COUNT(EmployeeID)        AS NewHires,
    SUM(COUNT(EmployeeID)) OVER (PARTITION BY YEAR(JoiningDate)
                                 ORDER BY MONTH(JoiningDate)) AS CumulativeHires
FROM employees
GROUP BY YEAR(JoiningDate), MONTH(JoiningDate), MONTHNAME(JoiningDate), Department
ORDER BY HiringYear, HiringMonth;

-- ─────────────────────────────────────────────────────────────
-- VIEW 8: vw_attendance_dashboard
-- Annual attendance metrics per employee
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_attendance_dashboard AS
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Designation,
    a.Year,
    a.WorkingDays,
    a.DaysPresent,
    a.Leaves,
    a.Absences,
    a.OvertimeHours,
    a.WFHDays,
    a.AttendancePercent,
    ROUND(a.Leaves  / a.WorkingDays * 100, 2)    AS LeavePct,
    ROUND(a.Absences/ a.WorkingDays * 100, 2)    AS AbsencePct,
    CASE
        WHEN a.AttendancePercent >= 95 THEN 'Excellent'
        WHEN a.AttendancePercent >= 85 THEN 'Good'
        WHEN a.AttendancePercent >= 75 THEN 'Average'
        ELSE 'Below Average'
    END AS AttendanceCategory
FROM employees  e
JOIN attendance a ON e.EmployeeID = a.EmployeeID;

-- ─────────────────────────────────────────────────────────────
-- VIEW 9: vw_diversity_metrics
-- Workforce diversity breakdown
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_diversity_metrics AS
SELECT
    Department,
    Gender,
    Education,
    City,
    COUNT(EmployeeID)    AS EmployeeCount,
    ROUND(AVG(Age),1)    AS AvgAge,
    ROUND(AVG(Experience),1) AS AvgExperience,
    SUM(CASE WHEN EmployeeStatus='Active' THEN 1 ELSE 0 END) AS ActiveCount
FROM employees
GROUP BY Department, Gender, Education, City;

-- ─────────────────────────────────────────────────────────────
-- VIEW 10: vw_promotion_analysis
-- Promotion rates by department, experience, training hours
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_promotion_analysis AS
SELECT
    e.Department,
    e.Designation,
    e.Gender,
    e.Education,
    p.Year,
    p.TrainingHours,
    CASE WHEN e.Experience < 2  THEN '0-1 Years'
         WHEN e.Experience < 5  THEN '2-4 Years'
         WHEN e.Experience < 10 THEN '5-9 Years'
         WHEN e.Experience < 15 THEN '10-14 Years'
         ELSE '15+ Years' END  AS ExperienceBand,
    COUNT(p.PerfID)                                      AS TotalEmployees,
    SUM(p.Promoted)                                      AS Promoted,
    ROUND(SUM(p.Promoted)*100.0/NULLIF(COUNT(p.PerfID),0),2) AS PromotionRatePct,
    ROUND(AVG(p.PerformanceRating),2)                    AS AvgRating,
    ROUND(AVG(p.TrainingHours),1)                        AS AvgTrainingHours
FROM employees  e
JOIN performance p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Department, e.Designation, e.Gender, e.Education, p.Year,
         p.TrainingHours,
         CASE WHEN e.Experience < 2  THEN '0-1 Years'
              WHEN e.Experience < 5  THEN '2-4 Years'
              WHEN e.Experience < 10 THEN '5-9 Years'
              WHEN e.Experience < 15 THEN '10-14 Years'
              ELSE '15+ Years' END;

-- ─────────────────────────────────────────────────────────────
-- VIEW 11: vw_top_performers
-- Top 10% performers by rating and goals met
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_top_performers AS
WITH ranked AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.Department,
        e.Designation,
        p.Year,
        p.PerformanceRating,
        p.SatisfactionScore,
        p.GoalsMetPercent,
        p.TrainingHours,
        s.BasicSalary,
        s.NetSalary,
        RANK() OVER (PARTITION BY p.Year
                     ORDER BY p.PerformanceRating DESC, p.GoalsMetPercent DESC) AS PerfRank
    FROM employees  e
    JOIN performance p ON e.EmployeeID = p.EmployeeID
    JOIN salary      s ON e.EmployeeID = s.EmployeeID
    WHERE e.EmployeeStatus = 'Active'
)
SELECT * FROM ranked WHERE PerfRank <= 50;

-- ─────────────────────────────────────────────────────────────
-- VIEW 12: vw_executive_summary
-- Single-row executive KPIs for the latest year
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_executive_summary AS
SELECT
    COUNT(DISTINCT e.EmployeeID)                                     AS TotalEmployees,
    SUM(CASE WHEN e.EmployeeStatus='Active' THEN 1 ELSE 0 END)       AS ActiveEmployees,
    SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END)     AS TotalAttrition,
    ROUND(SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0
          / COUNT(DISTINCT e.EmployeeID), 2)                         AS AttritionRatePct,
    ROUND(AVG(s.BasicSalary), 0)                                     AS AvgBasicSalary,
    ROUND(AVG(s.NetSalary), 0)                                       AS AvgNetSalary,
    ROUND(AVG(e.Age), 1)                                             AS AvgAge,
    ROUND(AVG(e.Experience), 1)                                      AS AvgExperience,
    ROUND(AVG(p.SatisfactionScore), 2)                               AS AvgSatisfactionScore,
    ROUND(AVG(p.PerformanceRating), 2)                               AS AvgPerformanceRating,
    ROUND(SUM(p.Promoted)*100.0/NULLIF(COUNT(DISTINCT p.EmployeeID),0),2) AS PromotionRatePct,
    ROUND(AVG(a.AttendancePercent), 2)                               AS AvgAttendancePct,
    SUM(r.HiringCost)                                                AS TotalHiringCost,
    ROUND(AVG(r.TimeToHire_Days),1)                                  AS AvgTimeToHire
FROM employees  e
JOIN salary      s ON e.EmployeeID = s.EmployeeID
JOIN performance p ON e.EmployeeID = p.EmployeeID AND p.Year = 2024
JOIN attendance  a ON e.EmployeeID = a.EmployeeID AND a.Year = 2024
JOIN recruitment r ON e.EmployeeID = r.EmployeeID;
