# Data Dictionary
## WorkforceIQ
### Version 1.0 | August 2024

---

## Overview

This document defines all tables, columns, data types, valid values, and business rules for the WorkforceIQ data model.

**Database:** `hr_analytics`
**Tables:** 7
**Total Columns:** 71

---

## Table 1: `departments` (Dimension)

**Purpose:** Master list of all company departments. Parent dimension for the star schema.

| Column | Data Type | Nullable | PK/FK | Description | Sample Values |
|---|---|---|---|---|---|
| DepartmentID | TINYINT UNSIGNED | NO | PK | Unique department identifier (1–10) | 1, 2, 3 |
| DepartmentName | VARCHAR(60) | NO | — | Full department name | Technology, HR, Finance |
| DepartmentHead | VARCHAR(100) | NO | — | Full name of department head | Rajesh Kumar |
| Location | VARCHAR(60) | NO | — | Primary city for department | Mumbai, Delhi |
| HeadCount | SMALLINT UNSIGNED | NO | — | Current approved headcount | 1250 |
| Budget_INR_Lakhs | DECIMAL(10,2) | NO | — | Annual HR budget in INR Lakhs | 156250.00 |
| CreatedAt | TIMESTAMP | NO | — | Record creation timestamp | 2024-01-01 |
| UpdatedAt | TIMESTAMP | NO | — | Last update timestamp | 2024-08-01 |

**Business Rules:**
- DepartmentID must be between 1 and 10
- DepartmentName is unique
- HeadCount must match COUNT of employees in that department (±10% tolerance)

---

## Table 2: `employees` (Central Hub)

**Purpose:** Master employee record — single source of truth for all employee attributes.

| Column | Data Type | Nullable | PK/FK | Description | Valid Values |
|---|---|---|---|---|---|
| EmployeeID | VARCHAR(10) | NO | PK | Unique employee identifier | EMP00001 – EMP10200 |
| Name | VARCHAR(100) | NO | — | Full legal name | Aarav Sharma |
| Age | TINYINT UNSIGNED | NO | — | Current age in years | 18 – 70 |
| Gender | ENUM | NO | — | Gender identity | Male, Female, Non-Binary, Other |
| DepartmentID | TINYINT UNSIGNED | NO | FK→departments | Department reference | 1 – 10 |
| Department | VARCHAR(60) | NO | — | Denormalized dept name | Technology |
| Designation | VARCHAR(100) | NO | — | Current job title | Senior Analyst |
| Education | ENUM | NO | — | Highest qualification | High School, Diploma, Bachelor's, Master's, MBA, PhD |
| Experience | TINYINT UNSIGNED | NO | — | Total work experience (years) | 0 – 35 |
| City | VARCHAR(60) | NO | — | Current posting city | Mumbai |
| JoiningDate | DATE | NO | — | Date of joining | 2019-06-01 |
| ExitDate | DATE | YES | — | Date of exit (NULL if active) | 2023-12-15 or NULL |
| EmployeeStatus | ENUM | NO | — | Current employment status | Active, Resigned, Terminated, Retired |
| RecruitmentSource | VARCHAR(60) | NO | — | How employee was recruited | LinkedIn, Employee Referral |
| CreatedAt | TIMESTAMP | NO | — | Record created | 2024-01-01 |
| UpdatedAt | TIMESTAMP | NO | — | Last modified | 2024-08-01 |

**Business Rules:**
- ExitDate must be NULL if EmployeeStatus = 'Active'
- ExitDate must be > JoiningDate if not NULL
- Age must correspond logically to Experience (Experience ≤ Age - 18)
- EmployeeID format: EMP + 5-digit zero-padded integer

---

## Table 3: `salary` (Fact)

**Purpose:** Employee compensation details including base salary, bonuses, and deductions.

| Column | Data Type | Nullable | PK/FK | Description | Valid Values |
|---|---|---|---|---|---|
| SalaryID | VARCHAR(10) | NO | PK | Unique salary record ID | SAL00001 – SAL10200 |
| EmployeeID | VARCHAR(10) | NO | FK→employees | Employee reference | EMP00001+ |
| BasicSalary | DECIMAL(12,2) | NO | — | Monthly gross salary (INR) | 20,000 – 5,00,000 |
| Bonus | DECIMAL(12,2) | NO | — | Annual bonus amount (INR) | 0 – 2,00,000 |
| Deductions | DECIMAL(12,2) | NO | — | Monthly deductions (PF, tax) | > 0 |
| NetSalary | DECIMAL(12,2) | NO | — | BasicSalary - Deductions + Bonus | > 0 |
| BonusPercent | DECIMAL(5,2) | NO | — | Bonus as % of BasicSalary | 5.00 – 25.00 |
| SalaryBand | ENUM | NO | — | Pay band classification | Band A (<40K), Band B (40–70K), Band C (70–110K), Band D (>110K) |
| EffectiveDate | DATE | NO | — | Date salary became effective | 2019-06-01 |
| Currency | CHAR(3) | NO | — | Currency code | INR |

**Salary Band Definitions:**

| Band | Monthly Basic Salary Range | Level |
|---|---|---|
| Band A | < ₹40,000 | Entry Level |
| Band B | ₹40,000 – ₹70,000 | Junior / Associate |
| Band C | ₹70,001 – ₹1,10,000 | Mid-Level |
| Band D | > ₹1,10,000 | Senior / Leadership |

---

## Table 4: `attendance` (Fact — Annual)

**Purpose:** Annual attendance summary per employee per year.

| Column | Data Type | Nullable | PK/FK | Description | Valid Values |
|---|---|---|---|---|---|
| AttendanceID | VARCHAR(10) | NO | PK | Unique attendance record | ATT000001+ |
| EmployeeID | VARCHAR(10) | NO | FK→employees | Employee reference | EMP00001+ |
| Year | SMALLINT UNSIGNED | NO | — | Calendar year of record | 2020 – 2024 |
| WorkingDays | SMALLINT UNSIGNED | NO | — | Total working days in year | 248 – 252 |
| DaysPresent | SMALLINT UNSIGNED | NO | — | Days employee was present | ≤ WorkingDays |
| Leaves | TINYINT UNSIGNED | NO | — | Approved leave days taken | 0 – 30 |
| Absences | TINYINT UNSIGNED | NO | — | Unapproved absences | 0 – 20 |
| OvertimeHours | SMALLINT UNSIGNED | NO | — | Total overtime hours | 0 – 200 |
| WFHDays | SMALLINT UNSIGNED | NO | — | Work-from-home days | 0 – 100 |
| AttendancePercent | DECIMAL(5,2) | NO | — | DaysPresent / WorkingDays × 100 | 0.00 – 100.00 |

**Derived Rule:** `DaysPresent + Leaves + Absences = WorkingDays` (approximately)

**Attendance Categories:**

| Category | AttendancePercent Range |
|---|---|
| Excellent | ≥ 95% |
| Good | 85% – 94.99% |
| Average | 75% – 84.99% |
| Below Average | < 75% |

---

## Table 5: `performance` (Fact — Annual)

**Purpose:** Annual performance review data per employee.

| Column | Data Type | Nullable | PK/FK | Description | Valid Values |
|---|---|---|---|---|---|
| PerfID | VARCHAR(10) | NO | PK | Unique performance record | PRF000001+ |
| EmployeeID | VARCHAR(10) | NO | FK→employees | Employee reference | EMP00001+ |
| Year | SMALLINT UNSIGNED | NO | — | Performance review year | 2020 – 2024 |
| PerformanceRating | TINYINT UNSIGNED | NO | — | Numeric rating (1–5) | 1, 2, 3, 4, 5 |
| RatingLabel | ENUM | NO | — | Rating description | Poor, Below Average, Average, Good, Outstanding |
| TrainingHours | SMALLINT UNSIGNED | NO | — | Training hours completed in year | 0 – 120 |
| Promoted | TINYINT(1) | NO | — | Was employee promoted this year? | 0 (No), 1 (Yes) |
| SatisfactionScore | DECIMAL(3,1) | NO | — | Employee satisfaction (annual survey) | 1.0 – 5.0 |
| GoalsMetPercent | TINYINT UNSIGNED | NO | — | % of annual goals achieved | 0 – 100 |
| ManagerFeedback | VARCHAR(50) | NO | — | Manager's qualitative label | Exceeds Expectations, Meets Expectations, etc. |

**Rating Scale:**

| Rating | Label | Description |
|---|---|---|
| 5 | Outstanding | Exceptional performance, role model |
| 4 | Good | Consistently exceeds targets |
| 3 | Average | Meets expectations |
| 2 | Below Average | Partially meets expectations |
| 1 | Poor | Significant improvement needed |

---

## Table 6: `recruitment` (Fact)

**Purpose:** Recruitment details for every employee hired.

| Column | Data Type | Nullable | PK/FK | Description | Valid Values |
|---|---|---|---|---|---|
| RecruitmentID | VARCHAR(10) | NO | PK | Unique recruitment record | REC00001+ |
| EmployeeID | VARCHAR(10) | NO | FK→employees | Employee reference | EMP00001+ |
| RecruitmentSource | VARCHAR(60) | NO | — | How candidate was sourced | LinkedIn, Employee Referral, Campus Hiring, Job Portal, Consultancy, Walk-In, Company Website |
| HiringCost | DECIMAL(10,2) | NO | — | Total cost to hire (INR) | 3,000 – 1,00,000 |
| TimeToHire_Days | TINYINT UNSIGNED | NO | — | Days from job posting to joining | 7 – 120 |
| InterviewRounds | TINYINT UNSIGNED | NO | — | Number of interview rounds | 1 – 6 |
| OfferAccepted | ENUM | NO | — | Was offer accepted? | Yes, No |
| JoiningDate | DATE | NO | — | Date candidate joined | Matches employees.JoiningDate |
| RecruiterName | VARCHAR(100) | NO | — | Name of recruiting HR | Any valid HR name |
| JobPortalUsed | VARCHAR(60) | NO | — | Specific portal name or N/A | LinkedIn, Job Portal, Company Website, N/A |

**Cost Benchmarks by Source:**

| Source | Typical Cost Range |
|---|---|
| Employee Referral | ₹5,000 – ₹15,000 |
| Walk-In | ₹3,000 – ₹10,000 |
| Campus Hiring | ₹8,000 – ₹20,000 |
| Company Website | ₹5,000 – ₹18,000 |
| LinkedIn | ₹15,000 – ₹45,000 |
| Job Portal | ₹12,000 – ₹35,000 |
| Consultancy | ₹30,000 – ₹80,000 |

---

## Table 7: `exit_records` (Fact)

**Purpose:** Exit interview and attrition details for every employee who left.

| Column | Data Type | Nullable | PK/FK | Description | Valid Values |
|---|---|---|---|---|---|
| ExitID | VARCHAR(10) | NO | PK | Unique exit record | EXT00001+ |
| EmployeeID | VARCHAR(10) | NO | FK→employees | Employee reference | EMP00001+ |
| ExitDate | DATE | NO | — | Official last working day | Must match employees.ExitDate |
| ExitReason | VARCHAR(60) | NO | — | Primary reason for leaving | Better Opportunity, Personal Reasons, Higher Studies, Relocation, Salary Dissatisfaction, Work-Life Balance, Health Issues, Retirement, Termination |
| TenureDays | SMALLINT UNSIGNED | NO | — | Total days from joining to exit | > 0 |
| NoticeServed | ENUM | NO | — | Notice period status | Yes, Partial, No |
| ExitInterviewDone | ENUM | NO | — | Was exit interview conducted? | Yes, No |
| ReHireEligible | ENUM | NO | — | Eligibility for re-hire | Yes, No, Maybe |
| LastPerformanceRating | TINYINT UNSIGNED | NO | — | Final performance rating | 1 – 5 |

---

## Derived / Calculated Fields (Power Query / DAX)

| Field Name | Source | Formula | Used In |
|---|---|---|---|
| TenureYears | employees | (ExitDate \| TODAY) - JoiningDate / 365 | Attrition Page |
| AgeGroup | employees | Age bucketed to 5 bands | Diversity Page |
| ExperienceBand | employees | Experience bucketed to 5 bands | Multiple Pages |
| AttritionRate | employees | Resigned / Total × 100 | Executive Page |
| AttendanceCategory | attendance | Category based on AttendancePercent | Attendance Page |
| RiskScore | employees + performance + salary | Composite score (0–8) | Insights Page |

---

*Data Dictionary maintained by: HR Analytics Center of Excellence*
*Data Governance Owner: CHRO*
