-- ============================================================
-- WorkforceIQ | 50+ Analytical SQL Queries
-- File        : 05_analytical_queries.sql
-- Database    : MySQL 8.0+
-- Description : Interview-ready analytical queries covering
--               aggregations, window functions, CTEs, subqueries,
--               joins, and advanced analytics
-- ============================================================

USE hr_analytics;

-- ============================================================
-- SECTION A: BASIC AGGREGATIONS (Q1–Q15)
-- ============================================================

-- Q1: Total employee count
SELECT COUNT(*) AS TotalEmployees FROM employees;

-- Q2: Active vs resigned vs terminated breakdown
SELECT
    EmployeeStatus,
    COUNT(*) AS Employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS Percentage
FROM employees
GROUP BY EmployeeStatus;

-- Q3: Average salary across the company
SELECT
    ROUND(AVG(BasicSalary), 0)  AS AvgBasicSalary,
    ROUND(AVG(NetSalary), 0)    AS AvgNetSalary,
    ROUND(AVG(Bonus), 0)        AS AvgBonus,
    ROUND(AVG(BonusPercent), 2) AS AvgBonusPct
FROM salary;

-- Q4: Highest and lowest paid employees
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Designation,
    s.BasicSalary,
    s.NetSalary,
    s.SalaryBand
FROM employees  e
JOIN salary     s ON e.EmployeeID = s.EmployeeID
ORDER BY s.BasicSalary DESC
LIMIT 10;

-- Q5: Lowest paid employees
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Designation,
    s.BasicSalary,
    s.SalaryBand
FROM employees e
JOIN salary    s ON e.EmployeeID = s.EmployeeID
WHERE e.EmployeeStatus = 'Active'
ORDER BY s.BasicSalary ASC
LIMIT 10;

-- Q6: Average employee age and experience
SELECT
    ROUND(AVG(Age), 1)        AS AvgAge,
    ROUND(AVG(Experience), 1) AS AvgExperience,
    MIN(Age)                  AS YoungestAge,
    MAX(Age)                  AS OldestAge,
    MIN(Experience)           AS MinExperience,
    MAX(Experience)           AS MaxExperience
FROM employees;

-- Q7: Employee count by department
SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN EmployeeStatus = 'Active' THEN 1 ELSE 0 END)   AS Active,
    SUM(CASE WHEN EmployeeStatus = 'Resigned' THEN 1 ELSE 0 END) AS Resigned
FROM employees
GROUP BY Department
ORDER BY TotalEmployees DESC;

-- Q8: Gender ratio across the company
SELECT
    Gender,
    COUNT(*) AS Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2) AS GenderPct
FROM employees
GROUP BY Gender;

-- Q9: Gender ratio by department
SELECT
    Department,
    SUM(CASE WHEN Gender = 'Male'   THEN 1 ELSE 0 END) AS Males,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Females,
    ROUND(SUM(CASE WHEN Gender='Female' THEN 1 ELSE 0 END)*100.0
          / NULLIF(COUNT(*),0), 2)                     AS FemalePct
FROM employees
GROUP BY Department
ORDER BY FemalePct DESC;

-- Q10: Education level distribution
SELECT
    Education,
    COUNT(*) AS Employees,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2) AS Pct,
    ROUND(AVG(s.BasicSalary), 0) AS AvgSalary
FROM employees e
JOIN salary s ON e.EmployeeID = s.EmployeeID
GROUP BY Education
ORDER BY AVG(s.BasicSalary) DESC;

-- Q11: Overall attrition rate
SELECT
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN EmployeeStatus = 'Resigned' THEN 1 ELSE 0 END) AS TotalAttrition,
    ROUND(SUM(CASE WHEN EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0
          / COUNT(*), 2) AS AttritionRatePct
FROM employees;

-- Q12: Attrition rate by department
SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN EmployeeStatus = 'Resigned' THEN 1 ELSE 0 END) AS Attrition,
    ROUND(SUM(CASE WHEN EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0
          / COUNT(*), 2) AS AttritionPct
FROM employees
GROUP BY Department
ORDER BY AttritionPct DESC;

-- Q13: Average salary by department
SELECT
    e.Department,
    COUNT(e.EmployeeID) AS Headcount,
    ROUND(AVG(s.BasicSalary), 0) AS AvgSalary,
    ROUND(MIN(s.BasicSalary), 0) AS MinSalary,
    ROUND(MAX(s.BasicSalary), 0) AS MaxSalary,
    ROUND(SUM(s.BasicSalary), 0) AS TotalSalaryBill
FROM employees e
JOIN salary    s ON e.EmployeeID = s.EmployeeID
GROUP BY e.Department
ORDER BY AvgSalary DESC;

-- Q14: Promotion rate by department and year
SELECT
    e.Department,
    p.Year,
    COUNT(p.PerfID)                                          AS TotalEmployees,
    SUM(p.Promoted)                                         AS Promoted,
    ROUND(SUM(p.Promoted)*100.0 / NULLIF(COUNT(p.PerfID),0), 2) AS PromotionRatePct
FROM employees   e
JOIN performance p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Department, p.Year
ORDER BY p.Year DESC, PromotionRatePct DESC;

-- Q15: Recruitment source analysis
SELECT
    RecruitmentSource,
    COUNT(*) AS TotalHires,
    ROUND(AVG(HiringCost), 0)        AS AvgHiringCost,
    SUM(HiringCost)                  AS TotalCost,
    ROUND(AVG(TimeToHire_Days), 1)   AS AvgDaysToHire
FROM recruitment
GROUP BY RecruitmentSource
ORDER BY TotalHires DESC;

-- ============================================================
-- SECTION B: ATTRITION & EXIT ANALYSIS (Q16–Q24)
-- ============================================================

-- Q16: Attrition by experience band
SELECT
    CASE
        WHEN e.Experience < 2  THEN '0–1 Years'
        WHEN e.Experience < 5  THEN '2–4 Years'
        WHEN e.Experience < 10 THEN '5–9 Years'
        WHEN e.Experience < 15 THEN '10–14 Years'
        ELSE '15+ Years'
    END AS ExperienceBand,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END) AS Attrition,
    ROUND(SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0
          / COUNT(*), 2) AS AttritionPct
FROM employees e
GROUP BY ExperienceBand
ORDER BY MIN(Experience);

-- Q17: Attrition by salary band
SELECT
    s.SalaryBand,
    COUNT(e.EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END) AS Attrition,
    ROUND(SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0
          / COUNT(e.EmployeeID), 2) AS AttritionPct
FROM employees e
JOIN salary    s ON e.EmployeeID = s.EmployeeID
GROUP BY s.SalaryBand
ORDER BY s.SalaryBand;

-- Q18: Monthly attrition trend (2022–2024)
SELECT
    YEAR(ExitDate)      AS Year,
    MONTH(ExitDate)     AS Month,
    MONTHNAME(ExitDate) AS MonthName,
    COUNT(*)            AS Attrition
FROM exit_records
WHERE YEAR(ExitDate) BETWEEN 2022 AND 2024
GROUP BY YEAR(ExitDate), MONTH(ExitDate), MONTHNAME(ExitDate)
ORDER BY Year, Month;

-- Q19: Top exit reasons
SELECT
    ExitReason,
    COUNT(*) AS Count,
    ROUND(COUNT(*)*100.0 / (SELECT COUNT(*) FROM exit_records), 2) AS Pct
FROM exit_records
GROUP BY ExitReason
ORDER BY Count DESC;

-- Q20: Average tenure of resigned employees
SELECT
    e.Department,
    COUNT(ex.ExitID)                    AS Resigned,
    ROUND(AVG(ex.TenureDays)/365.0, 1) AS AvgTenureYears,
    MIN(ex.TenureDays)                  AS MinTenureDays,
    MAX(ex.TenureDays)                  AS MaxTenureDays
FROM employees   e
JOIN exit_records ex ON e.EmployeeID = ex.EmployeeID
GROUP BY e.Department
ORDER BY AvgTenureYears;

-- Q21: Attrition by gender
SELECT
    e.Gender,
    COUNT(*)                                                       AS Total,
    SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END)  AS Resigned,
    ROUND(SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0
          / COUNT(*), 2) AS AttritionPct
FROM employees e
GROUP BY e.Gender;

-- Q22: Re-hire eligibility breakdown
SELECT
    ReHireEligible,
    COUNT(*) AS Count,
    ROUND(AVG(LastPerformanceRating), 2) AS AvgLastRating,
    ROUND(AVG(TenureDays)/365.0, 1)     AS AvgTenureYears
FROM exit_records
GROUP BY ReHireEligible;

-- Q23: Employees at flight-risk (active, low satisfaction, low salary)
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Designation,
    e.Experience,
    s.BasicSalary,
    s.SalaryBand,
    p.SatisfactionScore,
    p.PerformanceRating
FROM employees   e
JOIN salary      s ON e.EmployeeID = s.EmployeeID
JOIN performance p ON e.EmployeeID = p.EmployeeID AND p.Year = 2024
WHERE e.EmployeeStatus = 'Active'
  AND p.SatisfactionScore < 2.5
  AND s.BasicSalary < 50000
ORDER BY p.SatisfactionScore, s.BasicSalary;

-- Q24: Retention rate by recruitment source
SELECT
    e.RecruitmentSource,
    COUNT(e.EmployeeID) AS TotalHired,
    SUM(CASE WHEN e.EmployeeStatus='Active'   THEN 1 ELSE 0 END) AS Retained,
    SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN 1 ELSE 0 END) AS Lost,
    ROUND(SUM(CASE WHEN e.EmployeeStatus='Active' THEN 1 ELSE 0 END)*100.0
          / COUNT(e.EmployeeID), 2) AS RetentionRatePct
FROM employees e
GROUP BY e.RecruitmentSource
ORDER BY RetentionRatePct DESC;

-- ============================================================
-- SECTION C: SALARY ANALYTICS (Q25–Q32)
-- ============================================================

-- Q25: Salary percentile distribution
SELECT
    e.Department,
    ROUND(MIN(s.BasicSalary), 0)                 AS Min,
    ROUND(AVG(s.BasicSalary), 0)                 AS Mean,
    ROUND(MAX(s.BasicSalary), 0)                 AS Max,
    ROUND(STDDEV(s.BasicSalary), 0)              AS StdDev,
    COUNT(e.EmployeeID)                          AS Headcount
FROM employees e
JOIN salary    s ON e.EmployeeID = s.EmployeeID
GROUP BY e.Department;

-- Q26: Salary vs performance correlation (group level)
SELECT
    p.PerformanceRating,
    p.RatingLabel,
    COUNT(DISTINCT p.EmployeeID)         AS Employees,
    ROUND(AVG(s.BasicSalary), 0)        AS AvgSalary,
    ROUND(AVG(s.BonusPercent), 2)       AS AvgBonusPct
FROM performance p
JOIN salary      s ON p.EmployeeID = s.EmployeeID
WHERE p.Year = 2024
GROUP BY p.PerformanceRating, p.RatingLabel
ORDER BY p.PerformanceRating DESC;

-- Q27: Total monthly payroll
SELECT
    ROUND(SUM(s.NetSalary), 0)    AS TotalMonthlyPayroll,
    ROUND(SUM(s.BasicSalary), 0)  AS TotalBasic,
    ROUND(SUM(s.Bonus), 0)        AS TotalBonus,
    ROUND(SUM(s.Deductions), 0)   AS TotalDeductions
FROM salary s
JOIN employees e ON s.EmployeeID = e.EmployeeID
WHERE e.EmployeeStatus = 'Active';

-- Q28: Band A employees with high performance (upgrade candidates)
SELECT
    e.EmployeeID, e.Name, e.Department,
    e.Experience, s.BasicSalary,
    p.PerformanceRating, p.SatisfactionScore
FROM employees   e
JOIN salary      s ON e.EmployeeID = s.EmployeeID
JOIN performance p ON e.EmployeeID = p.EmployeeID AND p.Year = 2024
WHERE s.SalaryBand = 'Band A'
  AND p.PerformanceRating >= 4
  AND e.EmployeeStatus = 'Active'
ORDER BY p.PerformanceRating DESC, e.Experience DESC;

-- Q29: Salary comparison: MBA vs non-MBA
SELECT
    CASE WHEN e.Education IN ('MBA','PhD') THEN 'Postgraduate'
         ELSE 'Undergraduate' END AS EducationGroup,
    COUNT(e.EmployeeID)           AS Employees,
    ROUND(AVG(s.BasicSalary), 0)  AS AvgSalary,
    ROUND(AVG(s.NetSalary), 0)    AS AvgNetSalary
FROM employees e
JOIN salary    s ON e.EmployeeID = s.EmployeeID
GROUP BY EducationGroup;

-- Q30: Top 5 highest salaries per department using subquery
SELECT *
FROM (
    SELECT
        e.Department,
        e.Name,
        e.Designation,
        s.BasicSalary,
        RANK() OVER (PARTITION BY e.Department ORDER BY s.BasicSalary DESC) AS SalaryRank
    FROM employees e
    JOIN salary    s ON e.EmployeeID = s.EmployeeID
    WHERE e.EmployeeStatus = 'Active'
) ranked
WHERE SalaryRank <= 5
ORDER BY Department, SalaryRank;

-- Q31: Hiring cost vs retention ROI
SELECT
    e.Department,
    SUM(r.HiringCost)                            AS TotalHiringCost,
    SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN r.HiringCost ELSE 0 END) AS CostOnLostEmployees,
    ROUND(SUM(CASE WHEN e.EmployeeStatus='Resigned' THEN r.HiringCost ELSE 0 END)*100.0
          / NULLIF(SUM(r.HiringCost),0), 2)      AS WastedCostPct
FROM employees  e
JOIN recruitment r ON e.EmployeeID = r.EmployeeID
GROUP BY e.Department
ORDER BY WastedCostPct DESC;

-- Q32: Salary growth proxy (years in same band vs experience)
SELECT
    e.Department,
    e.Designation,
    ROUND(AVG(e.Experience), 1) AS AvgExp,
    ROUND(AVG(s.BasicSalary), 0) AS AvgSalary,
    s.SalaryBand,
    COUNT(*) AS Headcount
FROM employees e
JOIN salary    s ON e.EmployeeID = s.EmployeeID
WHERE e.EmployeeStatus = 'Active'
GROUP BY e.Department, e.Designation, s.SalaryBand
ORDER BY e.Department, AVG(s.BasicSalary) DESC;

-- ============================================================
-- SECTION D: PERFORMANCE & TRAINING (Q33–Q40)
-- ============================================================

-- Q33: Training hours vs promotion rate
SELECT
    CASE
        WHEN p.TrainingHours = 0       THEN '0 Hours'
        WHEN p.TrainingHours <= 10     THEN '1–10 Hours'
        WHEN p.TrainingHours <= 20     THEN '11–20 Hours'
        WHEN p.TrainingHours <= 40     THEN '21–40 Hours'
        ELSE '40+ Hours'
    END AS TrainingBand,
    COUNT(p.PerfID)                                          AS Employees,
    SUM(p.Promoted)                                         AS Promoted,
    ROUND(SUM(p.Promoted)*100.0 / NULLIF(COUNT(p.PerfID),0),2) AS PromotionRatePct,
    ROUND(AVG(p.SatisfactionScore),2)                        AS AvgSatisfaction
FROM performance p
WHERE p.Year = 2024
GROUP BY TrainingBand
ORDER BY MIN(p.TrainingHours);

-- Q34: Average satisfaction score by department
SELECT
    e.Department,
    ROUND(AVG(p.SatisfactionScore), 2) AS AvgSatisfaction,
    MIN(p.SatisfactionScore)           AS MinSatisfaction,
    MAX(p.SatisfactionScore)           AS MaxSatisfaction
FROM employees   e
JOIN performance p ON e.EmployeeID = p.EmployeeID
WHERE p.Year = 2024
GROUP BY e.Department
ORDER BY AvgSatisfaction DESC;

-- Q35: Employees with consecutive high ratings (2022–2024)
SELECT
    p22.EmployeeID,
    e.Name,
    e.Department,
    e.Designation,
    p22.PerformanceRating AS Rating_2022,
    p23.PerformanceRating AS Rating_2023,
    p24.PerformanceRating AS Rating_2024
FROM performance p22
JOIN performance p23 ON p22.EmployeeID = p23.EmployeeID AND p23.Year = 2023
JOIN performance p24 ON p22.EmployeeID = p24.EmployeeID AND p24.Year = 2024
JOIN employees   e   ON p22.EmployeeID = e.EmployeeID
WHERE p22.Year = 2022
  AND p22.PerformanceRating >= 4
  AND p23.PerformanceRating >= 4
  AND p24.PerformanceRating >= 4
  AND e.EmployeeStatus = 'Active'
ORDER BY p24.PerformanceRating DESC;

-- Q36: Employees never promoted despite high performance
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Experience,
    ROUND(AVG(p.PerformanceRating), 2) AS AvgRating,
    SUM(p.Promoted)                    AS TotalPromotions,
    ROUND(AVG(p.SatisfactionScore), 2) AS AvgSatisfaction,
    s.BasicSalary
FROM employees   e
JOIN performance p ON e.EmployeeID = p.EmployeeID
JOIN salary      s ON e.EmployeeID = s.EmployeeID
WHERE e.EmployeeStatus = 'Active'
  AND e.Experience >= 5
GROUP BY e.EmployeeID, e.Name, e.Department, e.Experience, s.BasicSalary
HAVING AVG(p.PerformanceRating) >= 4.0
   AND SUM(p.Promoted) = 0
ORDER BY AvgRating DESC;

-- Q37: Performance distribution by education
SELECT
    e.Education,
    ROUND(AVG(p.PerformanceRating),2)  AS AvgRating,
    ROUND(AVG(p.SatisfactionScore),2)  AS AvgSatisfaction,
    ROUND(AVG(p.TrainingHours),1)      AS AvgTrainingHours,
    COUNT(DISTINCT e.EmployeeID)        AS Employees
FROM employees   e
JOIN performance p ON e.EmployeeID = p.EmployeeID
WHERE p.Year = 2024
GROUP BY e.Education
ORDER BY AvgRating DESC;

-- Q38: Satisfaction trend 2022 → 2024
SELECT
    e.Department,
    ROUND(AVG(CASE WHEN p.Year=2022 THEN p.SatisfactionScore END),2) AS Satisfaction_2022,
    ROUND(AVG(CASE WHEN p.Year=2023 THEN p.SatisfactionScore END),2) AS Satisfaction_2023,
    ROUND(AVG(CASE WHEN p.Year=2024 THEN p.SatisfactionScore END),2) AS Satisfaction_2024
FROM employees   e
JOIN performance p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Department;

-- Q39: Top 10 training intensive departments
SELECT
    e.Department,
    ROUND(AVG(p.TrainingHours),1) AS AvgTrainingHrs,
    SUM(p.TrainingHours)          AS TotalTrainingHrs,
    COUNT(DISTINCT e.EmployeeID)  AS Employees
FROM employees   e
JOIN performance p ON e.EmployeeID = p.EmployeeID AND p.Year = 2024
GROUP BY e.Department
ORDER BY AvgTrainingHrs DESC;

-- Q40: Manager feedback distribution
SELECT
    ManagerFeedback,
    COUNT(*)                                                    AS Count,
    ROUND(COUNT(*)*100.0 / SUM(COUNT(*)) OVER(), 2)            AS Pct,
    ROUND(AVG(PerformanceRating),2)                             AS AvgRating,
    SUM(Promoted)                                               AS Promoted
FROM performance
WHERE Year = 2024
GROUP BY ManagerFeedback
ORDER BY Count DESC;

-- ============================================================
-- SECTION E: WINDOW FUNCTIONS (Q41–Q50)
-- ============================================================

-- Q41: ROW_NUMBER – Rank employees by salary within department
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    s.BasicSalary,
    ROW_NUMBER() OVER (PARTITION BY e.Department
                       ORDER BY s.BasicSalary DESC) AS SalaryRank
FROM employees e
JOIN salary    s ON e.EmployeeID = s.EmployeeID
WHERE e.EmployeeStatus = 'Active';

-- Q42: RANK – Dense rank employees by performance within year
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    p.PerformanceRating,
    p.SatisfactionScore,
    RANK()       OVER (PARTITION BY e.Department ORDER BY p.PerformanceRating DESC) AS PerfRank,
    DENSE_RANK() OVER (PARTITION BY e.Department ORDER BY p.PerformanceRating DESC) AS PerfDenseRank
FROM employees   e
JOIN performance p ON e.EmployeeID = p.EmployeeID
WHERE p.Year = 2024;

-- Q43: NTILE – Salary quartiles
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    s.BasicSalary,
    NTILE(4) OVER (ORDER BY s.BasicSalary) AS SalaryQuartile
FROM employees e
JOIN salary    s ON e.EmployeeID = s.EmployeeID
WHERE e.EmployeeStatus = 'Active';

-- Q44: LAG – Month-over-month hiring comparison
WITH monthly_hiring AS (
    SELECT
        YEAR(JoiningDate)   AS yr,
        MONTH(JoiningDate)  AS mo,
        COUNT(*)            AS Hires
    FROM employees
    GROUP BY YEAR(JoiningDate), MONTH(JoiningDate)
)
SELECT
    yr, mo, Hires,
    LAG(Hires) OVER (ORDER BY yr, mo) AS PrevMonthHires,
    Hires - LAG(Hires) OVER (ORDER BY yr, mo) AS MoMChange
FROM monthly_hiring
ORDER BY yr, mo;

-- Q45: LEAD – Next quarter projection
WITH quarterly_att AS (
    SELECT
        e.Department,
        a.Year,
        ROUND(AVG(a.AttendancePercent), 2) AS AvgAtt
    FROM employees e
    JOIN attendance a ON e.EmployeeID = a.EmployeeID
    GROUP BY e.Department, a.Year
)
SELECT
    Department,
    Year,
    AvgAtt,
    LEAD(AvgAtt) OVER (PARTITION BY Department ORDER BY Year) AS NextYearAtt
FROM quarterly_att;

-- Q46: Running total hiring cost per department (CTE + window)
WITH dept_cost AS (
    SELECT
        e.Department,
        YEAR(r.JoiningDate)  AS Year,
        SUM(r.HiringCost)    AS YearlyCost
    FROM employees  e
    JOIN recruitment r ON e.EmployeeID = r.EmployeeID
    GROUP BY e.Department, YEAR(r.JoiningDate)
)
SELECT
    Department,
    Year,
    YearlyCost,
    SUM(YearlyCost) OVER (PARTITION BY Department ORDER BY Year) AS RunningTotalCost
FROM dept_cost;

-- Q47: CTE – Identify flight-risk employees (multi-factor)
WITH risk_scores AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.Department,
        e.Experience,
        s.BasicSalary,
        p.SatisfactionScore,
        p.PerformanceRating,
        a.AttendancePercent,
        -- Risk score: higher = more at risk
        (CASE WHEN p.SatisfactionScore < 2.5  THEN 3 ELSE 0 END +
         CASE WHEN s.BasicSalary < 45000      THEN 2 ELSE 0 END +
         CASE WHEN a.AttendancePercent < 80   THEN 2 ELSE 0 END +
         CASE WHEN p.PerformanceRating <= 2   THEN 1 ELSE 0 END)  AS RiskScore
    FROM employees   e
    JOIN salary      s ON e.EmployeeID = s.EmployeeID
    JOIN performance p ON e.EmployeeID = p.EmployeeID AND p.Year = 2024
    JOIN attendance  a ON e.EmployeeID = a.EmployeeID AND a.Year = 2024
    WHERE e.EmployeeStatus = 'Active'
)
SELECT *,
    CASE WHEN RiskScore >= 5 THEN 'High Risk'
         WHEN RiskScore >= 3 THEN 'Medium Risk'
         ELSE 'Low Risk' END AS RiskCategory
FROM risk_scores
WHERE RiskScore >= 3
ORDER BY RiskScore DESC;

-- Q48: Subquery – Departments above average attrition
SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN EmployeeStatus='Resigned' THEN 1 ELSE 0 END) AS Resigned,
    ROUND(SUM(CASE WHEN EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0
          / COUNT(*), 2) AS AttritionPct
FROM employees
GROUP BY Department
HAVING AttritionPct > (
    SELECT ROUND(SUM(CASE WHEN EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0
                 / COUNT(*), 2)
    FROM employees
)
ORDER BY AttritionPct DESC;

-- Q49: CTE + RANK – Top 3 performers per department
WITH ranked_perf AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.Department,
        p.PerformanceRating,
        p.SatisfactionScore,
        p.GoalsMetPercent,
        RANK() OVER (PARTITION BY e.Department
                     ORDER BY p.PerformanceRating DESC, p.GoalsMetPercent DESC) AS Rnk
    FROM employees   e
    JOIN performance p ON e.EmployeeID = p.EmployeeID
    WHERE p.Year = 2024 AND e.EmployeeStatus = 'Active'
)
SELECT * FROM ranked_perf WHERE Rnk <= 3;

-- Q50: Multi-join analytics: Full employee KPI card
SELECT
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Designation,
    e.Gender,
    e.Education,
    e.Experience,
    e.City,
    e.EmployeeStatus,
    e.RecruitmentSource,
    s.BasicSalary,
    s.NetSalary,
    s.SalaryBand,
    p.PerformanceRating,
    p.RatingLabel,
    p.SatisfactionScore,
    p.Promoted,
    p.TrainingHours,
    a.AttendancePercent,
    a.OvertimeHours,
    r.HiringCost,
    r.TimeToHire_Days
FROM employees   e
JOIN salary      s ON e.EmployeeID = s.EmployeeID
JOIN performance p ON e.EmployeeID = p.EmployeeID AND p.Year = 2024
JOIN attendance  a ON e.EmployeeID = a.EmployeeID AND a.Year = 2024
JOIN recruitment r ON e.EmployeeID = r.EmployeeID
WHERE e.EmployeeStatus = 'Active'
ORDER BY e.Department, s.BasicSalary DESC;

-- Q51: Percentage of employees promoted at least once (any year)
SELECT
    e.Department,
    COUNT(DISTINCT e.EmployeeID) AS TotalActive,
    COUNT(DISTINCT CASE WHEN p.Promoted = 1 THEN e.EmployeeID END) AS EverPromoted,
    ROUND(COUNT(DISTINCT CASE WHEN p.Promoted=1 THEN e.EmployeeID END)*100.0
          / NULLIF(COUNT(DISTINCT e.EmployeeID),0), 2) AS PromotedPct
FROM employees   e
JOIN performance p ON e.EmployeeID = p.EmployeeID
WHERE e.EmployeeStatus = 'Active'
GROUP BY e.Department
ORDER BY PromotedPct DESC;

-- Q52: Attendance vs performance quadrant analysis
SELECT
    CASE WHEN a.AttendancePercent >= 90 AND p.PerformanceRating >= 4 THEN 'Star Performer'
         WHEN a.AttendancePercent >= 90 AND p.PerformanceRating  < 4 THEN 'Present But Underperforming'
         WHEN a.AttendancePercent  < 90 AND p.PerformanceRating >= 4 THEN 'High Performer Low Attendance'
         ELSE 'Needs Intervention' END AS Quadrant,
    COUNT(*)                           AS Employees,
    ROUND(AVG(s.BasicSalary),0)        AS AvgSalary
FROM employees   e
JOIN attendance  a ON e.EmployeeID = a.EmployeeID AND a.Year = 2024
JOIN performance p ON e.EmployeeID = p.EmployeeID AND p.Year = 2024
JOIN salary      s ON e.EmployeeID = s.EmployeeID
WHERE e.EmployeeStatus = 'Active'
GROUP BY Quadrant
ORDER BY Employees DESC;

-- ============================================================
-- END OF ANALYTICAL QUERIES
-- Total queries: 52
-- ============================================================
