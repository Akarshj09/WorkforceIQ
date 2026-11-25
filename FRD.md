# Functional Requirements Document (FRD)
## WorkforceIQ
### Version 1.0 | August 2024

---

## 1. Document Control

| Field | Details |
|---|---|
| **Project** | WorkforceIQ |
| **Document Type** | Functional Requirements Document |
| **Parent Document** | BRD v1.0 |
| **Prepared By** | Data Analytics Team |
| **Status** | Approved |

---

## 2. System Architecture

```
[CSV Data Sources]
      │
      ▼
[Power Query ETL Layer]
  - Data cleaning
  - Transformation
  - Type casting
      │
      ▼
[MySQL / PostgreSQL DB]
  - 7 tables
  - Star schema
  - 12 views
  - 6 stored procedures
      │
      ▼
[Power BI Semantic Layer]
  - Data model
  - 35+ DAX measures
  - Row-level security
      │
      ▼
[Power BI Service]
  - 9 dashboard pages
  - Scheduled refresh
  - Role-based access
      │
      ▼
[End Users]
  HR Managers | HRBPs | Dept Heads | C-Suite
```

---

## 3. Functional Requirements — Data Layer

### FR-D01: Data Ingestion
- **Trigger:** Daily at 06:00 AM IST (automated)
- **Sources:** 7 CSV files from HRIS export
- **Format:** UTF-8 encoded, comma-delimited
- **Validation:** Row count ≥ 10,000; no null EmployeeIDs

### FR-D02: Data Transformation (Power Query)
- Remove duplicate EmployeeIDs (keep latest record)
- Standardize Gender values to: Male / Female / Non-Binary
- Convert all date columns to `YYYY-MM-DD` format
- Trim whitespace from all VARCHAR columns
- Replace empty ExitDate with NULL (not "N/A")
- Derive `TenureYears` = (ExitDate OR TODAY()) - JoiningDate
- Derive `AgeGroup` based on Age column (5 bands)
- Derive `ExperienceBand` based on Experience column

### FR-D03: Star Schema Design
- **Fact Tables:** employees (hub), salary, attendance, performance, recruitment, exit_records
- **Dimension Tables:** departments, dim_Date
- **All foreign keys** must be enforced at database level
- **Indexes** on all join and filter columns

---

## 4. Functional Requirements — Dashboard

### FR-DB01: Executive Dashboard (Page 1)

| Visual | Type | Fields | Filter |
|---|---|---|---|
| Total Employees | KPI Card | COUNT(EmployeeID) | Year, Dept |
| Active Employees | KPI Card | Active count | Year, Dept |
| Attrition Rate | KPI Card | % Resigned | Year, Dept |
| Avg Salary | KPI Card | AVG(BasicSalary) | Dept, Band |
| Dept Headcount | Bar Chart | Dept, Count | Year |
| Attrition Trend | Line Chart | Month, Attrition% | Year |
| Gender Split | Donut | Gender, % | Dept |
| Salary Band Split | Donut | Band, Count | Dept |

**Performance SLA:** Load time < 3 seconds

### FR-DB02: Employee Overview (Page 2)

| Visual | Fields |
|---|---|
| Age Distribution Histogram | AgeGroup, Count |
| Experience Histogram | ExperienceBand, Count |
| Department Treemap | Dept, Headcount |
| Education Stacked Bar | Dept, Education |
| City Map | City, Count |
| Employee Detail Table | 8 columns, paginated 20/page |

### FR-DB03: Salary Dashboard (Page 3)

| Visual | Fields |
|---|---|
| Avg Salary by Dept | Bar Chart |
| Salary Band Donut | Band, Count |
| Salary vs Experience Scatter | Experience, BasicSalary |
| Salary Distribution Column | Salary range buckets |
| Top/Bottom 10 Table | Name, Dept, Salary |
| Dept × Band Matrix | Cross-tab |

### FR-DB04: Attrition Dashboard (Page 4)

| Visual | Fields |
|---|---|
| Attrition by Dept Bar | Dept, AttritionPct |
| Monthly Trend Line | Month, Resigned |
| Exit Reason Donut | ExitReason, Count |
| Attrition by Exp Band | ExperienceBand, AttritionPct |
| Attrition by Salary Band | SalaryBand, AttritionPct |
| Exit Records Table | 9 columns |

### FR-DB05: Recruitment Dashboard (Page 5)

| Visual | Fields |
|---|---|
| Monthly Hiring Line | Month, NewHires |
| Source Mix Donut | RecruitmentSource, Count |
| Cost per Source Bar | Source, AvgHiringCost |
| Time to Hire Bar | Source, AvgDays |
| Retention by Source Bar | Source, RetentionPct |

### FR-DB06: Performance Dashboard (Page 6)

| Visual | Fields |
|---|---|
| Rating Distribution Bar | Dept, Rating |
| Satisfaction Trend Line | Year, AvgSatisfaction |
| Training vs Promotion Scatter | TrainingHrs, PromotionRate |
| Goals Met Histogram | GoalsMet%, Count |
| Top Performers Table | Rank, Name, Rating, Salary |

### FR-DB07: Attendance Dashboard (Page 7)

| Visual | Fields |
|---|---|
| Attendance% Bar | Dept, AvgAttPct |
| Attendance Category Donut | Category, Count |
| Leave Trend Line | Month, AvgLeaves |
| Overtime Bar | Dept, TotalOT |
| Low Attendance Table | <80% employees |

### FR-DB08: Diversity Dashboard (Page 8)

| Visual | Fields |
|---|---|
| Gender Ratio 100% Stacked Bar | Dept, Gender |
| Age Group Column | AgeGroup, Count |
| Education Donut | Education, Count |
| India Filled Map | City, Count |
| Gender Pay Gap Scatter | AvgMaleSal vs AvgFemaleSal |

### FR-DB09: Business Insights (Page 9)

- Display 6 auto-calculated insight cards using DAX
- Show 3-year comparison table (2022/2023/2024)
- Color-coded: 🔴 Critical | 🟡 Warning | 🟢 Positive
- No manual input required — all driven by live DAX measures

---

## 5. Security Requirements

### FR-S01: Row-Level Security (RLS)

| Role | Data Access |
|---|---|
| HR_Admin | All departments, all data |
| HR_Manager | Own department only |
| Department_Head | Own dept employees only |
| Exec_View | Aggregated only, no PII |
| Recruiter | Recruitment + headcount only |

```dax
// RLS filter for HR_Manager role
[Department] = LOOKUPVALUE(
    UserRoleMapping[Department],
    UserRoleMapping[UserEmail], USERPRINCIPALNAME()
)
```

### FR-S02: PII Masking
- Employee Name visible only to HR_Admin and HR_Manager
- EmployeeID visible to all (no PII)
- Salary visible only to HR_Admin and Exec_View (aggregated)

---

## 6. Performance Requirements

| Requirement | Target |
|---|---|
| Dashboard initial load | < 5 seconds |
| Filter response time | < 2 seconds |
| Data refresh | Daily, < 15 min |
| Concurrent users | 50 simultaneous |
| Data volume | 10,000+ employees, 3 years history |

---

## 7. Non-Functional Requirements

- **Availability:** 99.5% uptime during business hours (8 AM – 8 PM IST)
- **Scalability:** Support up to 50,000 employees without architecture change
- **Auditability:** All data refresh logs retained for 90 days
- **Accessibility:** WCAG 2.1 AA compliant color contrast ratios
- **Browser Support:** Chrome 100+, Edge 100+, Firefox 100+

---

## 8. Data Refresh Schedule

| Table | Source | Frequency | Method |
|---|---|---|---|
| employees | HRIS Export | Daily 06:00 | Full refresh |
| salary | Payroll Export | Monthly 1st | Full refresh |
| performance | PMS Export | Quarterly | Incremental |
| attendance | HRMS Export | Daily 06:00 | Incremental |
| recruitment | ATS Export | Weekly | Incremental |
| exit_records | Exit Survey | As needed | Manual trigger |

---

## 9. Acceptance Criteria

| ID | Requirement | Acceptance Test |
|---|---|---|
| AC-01 | All 9 dashboard pages load | Load each page, verify < 5s |
| AC-02 | All 35 DAX measures calculate | Cross-check with SQL query results |
| AC-03 | RLS works correctly | Login as each role, verify data scope |
| AC-04 | Filters work across pages | Apply filter, verify all visuals update |
| AC-05 | Data matches source | Compare 10 sample employee records |
| AC-06 | Export to PDF/Excel | Export each page, verify formatting |

---

*Document Owner: Data Analytics Team*
*Reviewed by: CHRO, IT Architect*
