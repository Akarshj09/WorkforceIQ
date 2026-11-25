# KPI Document
## WorkforceIQ
### Version 1.0 | August 2024

---

## 1. Overview

This document defines all Key Performance Indicators (KPIs) tracked in WorkforceIQ. Each KPI includes its business definition, calculation formula, target, data source, and refresh frequency.

**Total KPIs:** 28 | **Dashboard Pages:** 9 | **Refresh:** Daily

---

## 2. KPI Categories

| Category | KPI Count | Dashboard Page |
|---|---|---|
| Headcount & Workforce | 5 | Executive, Employee Overview |
| Attrition & Retention | 6 | Attrition Dashboard |
| Salary & Compensation | 5 | Salary Dashboard |
| Performance | 4 | Performance Dashboard |
| Recruitment | 4 | Recruitment Dashboard |
| Attendance | 4 | Attendance Dashboard |

---

## 3. Headcount & Workforce KPIs

### KPI-01: Total Employees

| Field | Details |
|---|---|
| **Definition** | Total number of employees in the organization (all statuses) |
| **Formula** | `COUNT(EmployeeID)` |
| **DAX Measure** | `[Total Employees] = COUNTROWS(employees)` |
| **Target** | 10,500 by end FY2025 |
| **Current Value** | 10,200 |
| **Frequency** | Real-time |
| **Owner** | HR Operations |

### KPI-02: Active Employees

| Field | Details |
|---|---|
| **Definition** | Currently employed staff (EmployeeStatus = Active) |
| **Formula** | `COUNT(EmployeeID WHERE Status = 'Active')` |
| **DAX Measure** | `[Active Employees]` |
| **Target** | ≥ 85% of Total Employees |
| **Current Value** | 8,373 (82.1%) |
| **Frequency** | Daily |
| **Owner** | HR Operations |

### KPI-03: Average Age

| Field | Details |
|---|---|
| **Definition** | Mean age of all active employees |
| **Formula** | `AVG(Age) WHERE Status = 'Active'` |
| **Target** | 30–38 years (balanced workforce) |
| **Current Value** | 33.7 years |
| **Alert** | Flag if > 45 (succession risk) |

### KPI-04: Average Experience

| Field | Details |
|---|---|
| **Definition** | Mean years of professional experience (active employees) |
| **Formula** | `AVG(Experience) WHERE Status = 'Active'` |
| **Target** | 7–10 years |
| **Current Value** | 8.4 years |

### KPI-05: New Hires (Current Year)

| Field | Details |
|---|---|
| **Definition** | Employees who joined in the current calendar year |
| **Formula** | `COUNT(EmployeeID WHERE YEAR(JoiningDate) = CurrentYear)` |
| **Target** | ≥ 800 per year (growth plan) |
| **Frequency** | Monthly |

---

## 4. Attrition & Retention KPIs

### KPI-06: Attrition Rate

| Field | Details |
|---|---|
| **Definition** | Percentage of employees who resigned in a given period |
| **Formula** | `(Resigned Employees / Total Employees) × 100` |
| **DAX Measure** | `[Attrition Rate]` |
| **Target** | ≤ 15% annually |
| **Current Value** | 17.9% |
| **Benchmark** | Industry: 18–22% (IT/Services) |
| **Status** | 🟡 Within acceptable range |
| **Alert Threshold** | > 20% triggers executive review |

### KPI-07: Department-wise Attrition Rate

| Field | Details |
|---|---|
| **Definition** | Attrition rate calculated for each department individually |
| **Formula** | `(Dept Resigned / Dept Total) × 100` |
| **Target** | No department > 20% |
| **High-Risk Depts** | Sales (23.1%), Customer Support (21.4%) |

### KPI-08: Retention Rate

| Field | Details |
|---|---|
| **Definition** | Percentage of employees who stayed (complement of attrition) |
| **Formula** | `1 - Attrition Rate` |
| **DAX Measure** | `[Retention Rate]` |
| **Target** | ≥ 85% |
| **Current Value** | 82.1% |

### KPI-09: Average Tenure of Resigned Employees

| Field | Details |
|---|---|
| **Definition** | Mean duration between joining and exit date for resigned employees |
| **Formula** | `AVG(TenureDays / 365) WHERE Status = 'Resigned'` |
| **Target** | > 2 years (indicates reasonable return on hiring investment) |
| **Current Value** | 2.8 years |
| **Alert** | < 1 year average tenure = onboarding failure |

### KPI-10: Flight Risk Employees

| Field | Details |
|---|---|
| **Definition** | Active employees with high likelihood of resignation (composite score) |
| **Formula** | Score ≥ 3: (SatisfactionScore < 2.5: +3pts) + (Salary < ₹45K: +2pts) + (Attendance < 80%: +2pts) + (Rating ≤ 2: +1pt) |
| **Target** | < 5% of active workforce |
| **Current Value** | 312 employees (3.7%) |
| **Action** | Flagged for HRBP intervention |

### KPI-11: Re-hire Eligible %

| Field | Details |
|---|---|
| **Definition** | % of resigned employees eligible for re-hiring |
| **Formula** | `(ReHireEligible = 'Yes' / Total Resigned) × 100` |
| **Target** | > 60% |
| **Current Value** | 64.2% |

---

## 5. Salary & Compensation KPIs

### KPI-12: Average Basic Salary

| Field | Details |
|---|---|
| **Definition** | Mean monthly gross salary of all active employees |
| **Formula** | `AVG(BasicSalary) WHERE Status = 'Active'` |
| **Target** | Annual growth ≥ 8% |
| **Current Value** | ₹82,450/month |
| **Benchmark** | ₹78,000 industry avg (India IT/Services 2024) |

### KPI-13: Salary Band Distribution

| Field | Details |
|---|---|
| **Definition** | % of employees in each salary band |
| **Target Distribution** | Band A: ≤15% | Band B: 30% | Band C: 35% | Band D: 20% |
| **Current Distribution** | A: 18% | B: 32% | C: 33% | D: 17% |
| **Action** | Band A above target — review pay equity |

### KPI-14: Gender Pay Gap

| Field | Details |
|---|---|
| **Definition** | Difference in avg salary between Male and Female employees |
| **Formula** | `(AVG(Salary Male) - AVG(Salary Female)) / AVG(Salary Male) × 100` |
| **Target** | < 3% within same designation |
| **Current Value** | 4.2% overall (needs attention) |
| **Status** | 🔴 Action Required |

### KPI-15: Total Payroll (Monthly)

| Field | Details |
|---|---|
| **Definition** | Total monthly net salary for all active employees |
| **Formula** | `SUM(NetSalary) WHERE Status = 'Active'` |
| **Current Value** | ₹68.9 Crore/month |
| **Budget Threshold** | ≤ ₹72 Crore/month |

### KPI-16: Average Bonus Percentage

| Field | Details |
|---|---|
| **Definition** | Mean annual bonus as % of basic salary |
| **Formula** | `AVG(BonusPercent)` |
| **Target** | 15–20% for high performers |
| **Current Value** | 14.8% |

---

## 6. Performance KPIs

### KPI-17: Average Performance Rating

| Field | Details |
|---|---|
| **Definition** | Mean performance rating across all reviewed employees |
| **Formula** | `AVG(PerformanceRating)` on scale 1–5 |
| **Target** | ≥ 3.5 |
| **Current Value** | 3.52 |
| **Status** | 🟢 On Target |

### KPI-18: Promotion Rate

| Field | Details |
|---|---|
| **Definition** | % of employees promoted in a given year |
| **Formula** | `SUM(Promoted) / COUNT(Employees) × 100` |
| **Target** | 5–8% annually |
| **Current Value** | 3.5% |
| **Status** | 🟡 Below Target — review promotion criteria |

### KPI-19: Average Satisfaction Score

| Field | Details |
|---|---|
| **Definition** | Mean employee satisfaction from annual survey (1–5 scale) |
| **Formula** | `AVG(SatisfactionScore)` |
| **Target** | ≥ 3.8 |
| **Current Value** | 3.52 |
| **Status** | 🟡 Needs Improvement |
| **Benchmark** | Industry best: 4.1 (Tech sector) |

### KPI-20: % Outstanding Performers

| Field | Details |
|---|---|
| **Definition** | % of employees rated 5 (Outstanding) |
| **Formula** | `COUNT(Rating=5) / Total Employees × 100` |
| **Target** | 15–20% |
| **Current Value** | 14.8% |

---

## 7. Recruitment KPIs

### KPI-21: Average Time to Hire

| Field | Details |
|---|---|
| **Definition** | Average days from job posting to candidate joining |
| **Formula** | `AVG(TimeToHire_Days)` |
| **Target** | ≤ 35 days |
| **Current Value** | 42.3 days |
| **Status** | 🔴 Above Target |
| **Best Source** | Employee Referral (18 days avg) |

### KPI-22: Average Cost per Hire

| Field | Details |
|---|---|
| **Definition** | Average total recruitment cost per successfully hired employee |
| **Formula** | `SUM(HiringCost) / COUNT(EmployeeID)` |
| **Target** | ≤ ₹25,000 |
| **Current Value** | ₹28,400 |
| **Action** | Shift from Consultancy to Referral-led hiring |

### KPI-23: Recruitment Source Retention Rate

| Field | Details |
|---|---|
| **Definition** | % of employees from each source who are still active |
| **Best Performer** | Employee Referral (88.2% retention) |
| **Worst Performer** | Job Portal (79.1% retention) |

### KPI-24: Total Annual Hiring Cost

| Field | Details |
|---|---|
| **Definition** | Total spend on all recruitment activities in a year |
| **Target** | ≤ ₹2.5 Crore annually |
| **Current Value** | ₹2.89 Crore (FY2024) |

---

## 8. Attendance KPIs

### KPI-25: Average Attendance Rate

| Field | Details |
|---|---|
| **Definition** | Mean attendance % across all active employees |
| **Target** | ≥ 93% |
| **Current Value** | 94.1% |
| **Status** | 🟢 On Target |

### KPI-26: Average Annual Leave Days

| Field | Details |
|---|---|
| **Definition** | Average approved leave days per employee per year |
| **Target** | 15–20 days (within policy) |
| **Current Value** | 14.8 days |

### KPI-27: Total Overtime Hours

| Field | Details |
|---|---|
| **Definition** | Sum of all overtime hours across the workforce |
| **Target** | < 5 avg hours/month per employee |
| **Alert** | > 10 avg hours/month = workload issue |

### KPI-28: Below-threshold Attendance Employees

| Field | Details |
|---|---|
| **Definition** | Employees with attendance < 80% in any year |
| **Target** | < 2% of workforce |
| **Current Value** | 2.8% |
| **Action** | HRBP follow-up required |

---

## 9. KPI Dashboard Summary

| KPI | Current | Target | Status |
|---|---|---|---|
| Total Employees | 10,200 | 10,500 | 🟡 |
| Active Employees | 8,373 | ≥85% | 🟡 |
| Attrition Rate | 17.9% | ≤15% | 🟡 |
| Avg Salary | ₹82,450 | ≥₹78,000 | 🟢 |
| Avg Performance Rating | 3.52 | ≥3.5 | 🟢 |
| Avg Satisfaction | 3.52 | ≥3.8 | 🟡 |
| Promotion Rate | 3.5% | 5–8% | 🔴 |
| Avg Time to Hire | 42.3 days | ≤35 days | 🔴 |
| Gender Pay Gap | 4.2% | <3% | 🔴 |
| Avg Attendance | 94.1% | ≥93% | 🟢 |

**Legend:** 🟢 On Target | 🟡 Acceptable | 🔴 Action Required

---

*KPI Owner: HR Analytics Center of Excellence*
*Review Cycle: Quarterly*
