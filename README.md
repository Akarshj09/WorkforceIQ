# WorkforceIQ

> **An end-to-end HR Analytics platform built for a 10,000+ employee multinational organization — covering attrition, salary, performance, recruitment, attendance, and diversity analytics.**

[![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?logo=mysql)](https://www.mysql.com/)
[![PowerBI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi)](https://powerbi.microsoft.com/)
[![Python](https://img.shields.io/badge/Python-3.13-green?logo=python)](https://www.python.org/)
[![Excel](https://img.shields.io/badge/Excel-Advanced-brightgreen?logo=microsoft-excel)](https://www.microsoft.com/excel)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success)]()
[![Records](https://img.shields.io/badge/Dataset-10%2C200%20Employees-informational)]()

---

## 📋 Table of Contents

- [Problem Statement](#problem-statement)
- [Project Objectives](#project-objectives)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Dataset](#dataset)
- [SQL Analysis](#sql-analysis)
- [Power BI Dashboard](#power-bi-dashboard)
- [Excel Workbook](#excel-workbook)
- [Business Insights](#business-insights)
- [KPIs Tracked](#kpis-tracked)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Documentation](#documentation)
- [Future Improvements](#future-improvements)
- [Interview Context](#interview-context)

---

## 🎯 Problem Statement

GlobalTech Enterprises Ltd. (10,000+ employees across 10 departments, 10 cities) had HR data fragmented across 15+ Excel files and legacy systems. Key problems:

| Pain Point | Business Impact |
|---|---|
| 3–5 day manual reporting cycle | Delayed workforce decisions |
| No real-time attrition monitoring | ₹65K avg cost per undetected exit |
| No recruitment channel ROI data | ₹2.89 Cr spent with unclear returns |
| No gender pay gap tracking | 4.2% gap violating equity policy |
| No satisfaction-attrition correlation | Reactive retention strategy |

> **Estimated annual cost of inaction: ₹2.4 Crore**

---

## 🎯 Project Objectives

1. ✅ Centralize all HR data into a single analytics platform
2. ✅ Monitor attrition in real time with departmental breakdown
3. ✅ Benchmark salaries and identify pay equity issues
4. ✅ Measure performance-to-promotion correlation
5. ✅ Analyze recruitment channel efficiency and ROI
6. ✅ Track attendance, overtime, and leave patterns
7. ✅ Generate automated business insights and recommendations
8. ✅ Enable self-service reporting for 25 HR stakeholders

---

## 🛠 Tech Stack

| Tool | Version | Purpose |
|---|---|---|
| **Python** | 3.13 | Dataset generation (10,200 employee records) |
| **MySQL** | 8.0 | Relational database (7 tables, star schema) |
| **Power BI Desktop** | Jun 2024 | Data model, DAX, 9-page dashboard |
| **Power Query (M)** | Latest | ETL pipeline, data transformation |
| **DAX** | — | 40 business measures |
| **Microsoft Excel** | 365 | Operational workbook, pivot tables, formulas |
| **GitHub** | — | Version control, portfolio hosting |

---

## 🏗 Architecture

```
[CSV Data Sources] → [Power Query ETL] → [MySQL Star Schema]
       → [Power BI Semantic Layer (DAX + RLS)] → [9-Page Dashboard]
                                                 → [25 HR Users]
```

**Full architecture diagram:** [`Documentation/Architecture_Diagram.md`](Documentation/Architecture_Diagram.md)

---

## 📊 Dataset

**Generated via Python** — realistic distributions, relational foreign keys, controlled attrition patterns.

| File | Rows | Description |
|---|---|---|
| `employees.csv` | 10,200 | Master employee records |
| `departments.csv` | 10 | Department dimension |
| `salary.csv` | 10,200 | Compensation data (BasicSalary, Bonus, Band) |
| `attendance.csv` | 30,600 | Annual attendance (2022–2024) |
| `performance.csv` | 30,600 | Annual performance reviews (2022–2024) |
| `recruitment.csv` | 10,200 | Hiring data (source, cost, time-to-hire) |
| `exit_records.csv` | 1,827 | Exit interviews (17.9% attrition) |

**Key Columns:** EmployeeID, Name, Age, Gender, Department, Designation, Education, Experience, City, JoiningDate, ExitDate, BasicSalary, Bonus, PerformanceRating, Promoted, SatisfactionScore, TrainingHours, AttendancePercent, RecruitmentSource, HiringCost, ExitReason

---

## 🛢 SQL Analysis

**Files:** `SQL/01_schema.sql` through `SQL/05_analytical_queries.sql`

### Schema
- 7 tables with foreign key constraints and 20+ indexes
- Star schema: employees as central hub
- Full DDL with `CHECK`, `UNIQUE`, `ON UPDATE CASCADE`

### Analytical Queries (52 total)
| Category | Count | Examples |
|---|---|---|
| Basic Aggregations | 15 | Avg salary, gender ratio, education distribution |
| Attrition Analysis | 9 | Dept attrition, exit reasons, flight-risk employees |
| Salary Analytics | 8 | Salary percentiles, gender pay gap, payroll totals |
| Performance & Training | 8 | Promotion rates, satisfaction trends, training ROI |
| Window Functions | 12 | ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, NTILE |

### Views (12 total)
`vw_employee_master` | `vw_attrition_summary` | `vw_department_kpis` | `vw_performance_summary` | `vw_recruitment_analysis` | `vw_salary_bands` | `vw_monthly_hiring_trend` | `vw_attendance_dashboard` | `vw_diversity_metrics` | `vw_promotion_analysis` | `vw_top_performers` | `vw_executive_summary`

### Stored Procedures (6 total)
`sp_department_report` | `sp_attrition_analysis` | `sp_performance_review` | `sp_salary_benchmark` | `sp_hiring_pipeline` | `sp_employee_360`

---

## 📈 Power BI Dashboard

**File:** `PowerBI/PowerBI_Dashboard_Design.md`

### 9 Pages

| Page | Description | Key Visuals |
|---|---|---|
| 1. Executive | 7 KPI cards + trend overview | Cards, Bar, Line, Donut, Gauge |
| 2. Employee Overview | Demographics & distribution | Treemap, Histogram, Map |
| 3. Salary | Compensation analysis | Scatter, Heatmap, Tables |
| 4. Attrition | Turnover deep-dive | Bar, Line, Donut, Table |
| 5. Recruitment | Hiring efficiency | Line, Bar, Donut, Table |
| 6. Performance | Ratings & promotions | Scatter, Distribution, Table |
| 7. Attendance | Leave & overtime | Bar, Donut, Table |
| 8. Diversity | DEI metrics | 100% Stacked, Map, Scatter |
| 9. Insights | Auto-generated recommendations | Cards, Comparison Table |

### DAX Measures (40 total)
Complete in `PowerBI/PowerBI_Dashboard_Design.md`

**Sample measures:**
```dax
[Attrition Rate]    = DIVIDE([Resigned Employees], [Total Employees], 0)
[Promotion Rate]    = DIVIDE([Total Promotions], COUNTROWS(performance), 0)
[Retention Rate]    = 1 - [Attrition Rate]
[Avg Salary]        = AVERAGE(salary[BasicSalary])
[Avg Satisfaction]  = AVERAGE(performance[SatisfactionScore])
[Total Hiring Cost] = SUM(recruitment[HiringCost])
```

### Filters Available
Department | Designation | Gender | Location | Year | Experience | Status | Education | Salary Band | Recruitment Source

### Row-Level Security
5 roles: HR_Admin | HR_Manager | Dept_Head | Exec_View | Recruiter

---

## 📊 Excel Workbook

**Guide:** `Excel/HR_Analytics_Workbook_Guide.md`

### Techniques Implemented

| Category | Features |
|---|---|
| **Data Cleaning** | Remove Duplicates, TRIM, Flash Fill, Text to Columns |
| **Data Validation** | Dropdowns for Department, Gender, Status; Date & Range constraints |
| **Conditional Formatting** | Color scales, Data Bars, Icon sets, Rule-based highlighting |
| **Formulas** | XLOOKUP, INDEX-MATCH, SUMIFS, COUNTIFS, AVERAGEIFS, IFERROR |
| **Pivot Tables** | Attrition, Salary, Performance, Recruitment, Hiring Trend |
| **Pivot Charts** | Bar, Donut, Line, Pie — with Slicers |
| **Dashboard** | KPI cards, linked charts, interactive slicers |
| **Power Query** | 10-step transformation pipeline |

---

## 💡 Business Insights Generated

| # | Insight | Impact |
|---|---|---|
| 1 | Sales attrition at 23.1% — highest dept (company avg: 17.9%) | Salary revision needed |
| 2 | 68% of Sales exits cite salary < ₹55,000 as primary reason | Compensation benchmark |
| 3 | Employees with 20+ training hours: 3.2× higher promotion rate | Mandate training minimum |
| 4 | Employee Referral: 88.2% retention at ₹9,500 avg cost | Increase referral incentives |
| 5 | Consultancy hiring: ₹65,000 avg cost, 81% retention — worst ROI | Reduce consultancy share |
| 6 | 312 flight-risk employees (RiskScore ≥ 3) identified | HRBP intervention required |
| 7 | 487 high performers with 5+ years, never promoted | Lateral growth framework needed |
| 8 | 4.2% gender pay gap across matched roles | Pay equity audit required |
| 9 | First-year attrition = 31% of all exits | Onboarding program enhancement |
| 10 | Technology dept has highest satisfaction (3.81) — best practices opportunity | Knowledge transfer |

---

## 📐 KPIs Tracked (28 total)

| KPI | Current | Target | Status |
|---|---|---|---|
| Total Employees | 10,200 | 10,500 | 🟡 |
| Attrition Rate | 17.9% | ≤15% | 🟡 |
| Avg Basic Salary | ₹82,450 | ≥₹78,000 | 🟢 |
| Avg Performance Rating | 3.52/5 | ≥3.5 | 🟢 |
| Avg Satisfaction | 3.52/5 | ≥3.8 | 🟡 |
| Promotion Rate | 3.5% | 5–8% | 🔴 |
| Avg Time to Hire | 42.3 days | ≤35 days | 🔴 |
| Gender Pay Gap | 4.2% | <3% | 🔴 |
| Avg Attendance | 94.1% | ≥93% | 🟢 |
| Referral Retention Rate | 88.2% | ≥85% | 🟢 |

---

## 📁 Project Structure

```
WorkforceIQ/
│
├── Dataset/
│   ├── employees.csv           # 10,200 employee master records
│   ├── departments.csv         # 10 department dimension records
│   ├── salary.csv              # Compensation data
│   ├── attendance.csv          # 30,600 annual attendance records
│   ├── performance.csv         # 30,600 annual performance records
│   ├── recruitment.csv         # Hiring data per employee
│   ├── exit_records.csv        # 1,827 attrition records
│   └── generate_dataset.py     # Python dataset generator
│
├── SQL/
│   ├── 01_schema.sql           # DDL: 7 tables, FK, indexes
│   ├── 02_insert_data.sql      # Sample INSERTs + LOAD DATA guide
│   ├── 03_views.sql            # 12 analytical views
│   ├── 04_stored_procedures.sql# 6 stored procedures
│   └── 05_analytical_queries.sql # 52 interview-level queries
│
├── Excel/
│   └── HR_Analytics_Workbook_Guide.md
│
├── PowerBI/
│   └── PowerBI_Dashboard_Design.md
│
├── Documentation/
│   ├── BRD.md                  # Business Requirements Document
│   ├── FRD.md                  # Functional Requirements Document
│   ├── Data_Dictionary.md      # 71-column data dictionary
│   ├── KPI_Document.md         # 28 KPI definitions
│   ├── Dashboard_User_Guide.md # End-user guide
│   ├── Architecture_Diagram.md # 6-layer architecture
│   └── Project_Report.md       # Full project report
│
├── Dashboard Images/           # Power BI screenshots (add after build)
│
├── Presentation/               # Executive PPT (add after build)
│
├── Career/
│   ├── Resume_Bullet_Points.md # ATS-optimized resume bullets
│   └── Interview_Preparation.md# 18 Q&A for interviews
│
├── README.md                   # This file
└── LICENSE                     # MIT License
```

---

## 🚀 Getting Started

### Prerequisites
- Python 3.9+
- MySQL 8.0 or PostgreSQL 14+
- Power BI Desktop (free)
- Microsoft Excel 365 (or 2019+)

### Step 1: Generate Dataset
```bash
cd Dataset/
python generate_dataset.py
# Generates 7 CSV files
```

### Step 2: Set Up Database
```sql
-- In MySQL Workbench or terminal:
SOURCE SQL/01_schema.sql;
SOURCE SQL/02_insert_data.sql;
SOURCE SQL/03_views.sql;
SOURCE SQL/04_stored_procedures.sql;
-- Run analytical queries as needed:
SOURCE SQL/05_analytical_queries.sql;
```

### Step 3: Load to Excel
```
1. Open Excel → Data → Get Data → From File → From Folder
2. Select the /Dataset/ folder
3. Follow HR_Analytics_Workbook_Guide.md for cleaning steps
```

### Step 4: Build Power BI Dashboard
```
1. Open Power BI Desktop
2. Get Data → Text/CSV → Select all 7 CSV files
3. Follow PowerBI/PowerBI_Dashboard_Design.md for model and measures
4. Publish to Power BI Service
```

---

## 📚 Documentation

| Document | Purpose |
|---|---|
| [BRD](Documentation/BRD.md) | Business requirements, objectives, stakeholders |
| [FRD](Documentation/FRD.md) | Functional specs, dashboard requirements, security |
| [Data Dictionary](Documentation/Data_Dictionary.md) | All 71 columns defined |
| [KPI Document](Documentation/KPI_Document.md) | 28 KPIs with targets and formulas |
| [Dashboard User Guide](Documentation/Dashboard_User_Guide.md) | End-user navigation guide |
| [Architecture Diagram](Documentation/Architecture_Diagram.md) | 6-layer system architecture |
| [Project Report](Documentation/Project_Report.md) | Complete implementation report |

---

## 🔮 Future Improvements

| Phase | Feature | Timeline |
|---|---|---|
| Phase 2 | Live HRIS API integration (replace CSV) | Q1 2025 |
| Phase 2 | Power Automate alerts for flight-risk employees | Q1 2025 |
| Phase 3 | ML attrition prediction model (scikit-learn) | Q3 2025 |
| Phase 3 | NLP Q&A interface in Power BI | Q3 2025 |
| Phase 4 | Succession planning module | 2026 |
| Phase 4 | Scenario-based workforce planning | 2026 |

---

## 🎤 Interview Context

This project was designed for **Business Analyst interviews** at consulting and analytics firms. See:

- **[Resume Bullet Points](Career/Resume_Bullet_Points.md)** — ATS-optimized bullets for 5 role types
- **[Interview Preparation](Career/Interview_Preparation.md)** — 18 Q&A covering BA, Power BI, SQL, Excel, and scenarios

**Project ROI:** ₹8 lakh investment → ₹2.16 Crore identified savings = **2,700% ROI**

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

*Built with ❤️ for data-driven HR decision making*
*⭐ Star this repo if it helped your job search!*
