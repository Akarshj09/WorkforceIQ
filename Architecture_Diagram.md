# System Architecture Diagram
## WorkforceIQ Dashboard
### Version 1.0 | August 2024

---

## High-Level Architecture

```
╔══════════════════════════════════════════════════════════════════════╗
║                    WORKFORCEIQ ANALYTICS PLATFORM                    ║
║                        Architecture v1.0                             ║
╚══════════════════════════════════════════════════════════════════════╝

┌─────────────────────────────────────────────────────────────────────┐
│  LAYER 1: DATA SOURCES                                              │
│                                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │  HRIS    │  │ Payroll  │  │   PMS    │  │   ATS    │           │
│  │ (Legacy) │  │  System  │  │ (Perf.)  │  │ (Recruit)│           │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘           │
│       │              │              │              │                 │
│       └──────────────┴──────────────┴──────────────┘               │
│                               │                                     │
│                    [CSV Export / API Pull]                           │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER 2: DATA PROCESSING (Power Query / Python)                    │
│                                                                     │
│  ┌────────────────────────────────────────────────────────────┐     │
│  │  POWER QUERY ETL PIPELINE                                  │     │
│  │                                                            │     │
│  │  Raw CSVs → Remove Duplicates → Trim/Clean → Type Cast     │     │
│  │  → Merge Queries → Derive Columns → Filter Invalid Rows    │     │
│  │  → Load to Data Model                                      │     │
│  └────────────────────────────────────────────────────────────┘     │
│                                                                     │
│  Schedule: Daily 06:00 AM IST (automated via Power BI Service)     │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER 3: DATA STORAGE (MySQL 8.0 / PostgreSQL 14)                  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐        │
│  │  STAR SCHEMA                                            │        │
│  │                                                         │        │
│  │  Fact Tables:          Dimension Tables:                │        │
│  │  ├─ fact_employees     ├─ dim_departments               │        │
│  │  ├─ fact_salary        └─ dim_date                      │        │
│  │  ├─ fact_attendance                                     │        │
│  │  ├─ fact_performance   Views:                           │        │
│  │  ├─ fact_recruitment   ├─ vw_executive_summary          │        │
│  │  └─ fact_exit          ├─ vw_attrition_summary          │        │
│  │                        ├─ vw_department_kpis            │        │
│  │  Stored Procedures:    └─ (12 views total)              │        │
│  │  ├─ sp_department_report                                │        │
│  │  ├─ sp_attrition_analysis                               │        │
│  │  └─ (6 SPs total)                                       │        │
│  └─────────────────────────────────────────────────────────┘        │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER 4: SEMANTIC / ANALYTICS LAYER (Power BI Desktop)             │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐        │
│  │  DATA MODEL                                             │        │
│  │  ├─ 7 tables imported + 1 custom Date table             │        │
│  │  ├─ Relationships defined (Star Schema)                 │        │
│  │  ├─ 35+ DAX Measures                                    │        │
│  │  ├─ Row-Level Security (5 roles)                        │        │
│  │  └─ Performance optimizations (aggregations)            │        │
│  └─────────────────────────────────────────────────────────┘        │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER 5: PRESENTATION LAYER (Power BI Service)                     │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐        │
│  │  9-PAGE INTERACTIVE DASHBOARD                           │        │
│  │                                                         │        │
│  │  Page 1: Executive Dashboard                            │        │
│  │  Page 2: Employee Overview                              │        │
│  │  Page 3: Salary Dashboard                               │        │
│  │  Page 4: Attrition Dashboard                            │        │
│  │  Page 5: Recruitment Dashboard                          │        │
│  │  Page 6: Performance Dashboard                          │        │
│  │  Page 7: Attendance Dashboard                           │        │
│  │  Page 8: Diversity Dashboard                            │        │
│  │  Page 9: Business Insights                              │        │
│  │                                                         │        │
│  │  Features: Slicers | Cross-filtering | Drill-through   │        │
│  │            Bookmarks | Tooltips | Export               │        │
│  └─────────────────────────────────────────────────────────┘        │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER 6: CONSUMPTION / USERS                                        │
│                                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │  CHRO /  │  │  HR BPs  │  │  Dept    │  │  Finance │           │
│  │  C-Suite │  │          │  │  Heads   │  │  Team    │           │
│  │ (Exec.   │  │(Full     │  │(Dept-RLS)│  │(Salary   │           │
│  │  View)   │  │ Access)  │  │          │  │  Only)   │           │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘           │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Diagram

```
HRIS Export (daily)
      │
      │  employees.csv (10,200 rows)
      │  departments.csv (10 rows)
      ▼
Power Query ──► Clean & Validate ──► employees table (MySQL)
                                          │
Payroll Export (monthly)                  │
      │                                   │ JOIN on EmployeeID
      │  salary.csv (10,200 rows)         │
      ▼                                   │
Power Query ──► Validate ──► salary table ┤
                                          │
PMS Export (quarterly)                    │
      │  performance.csv (30,600 rows)    │
      ▼                                   │
Power Query ──► Validate ──► performance ─┤
                                          │
HRMS Export (daily)                       │
      │  attendance.csv (30,600 rows)     │
      ▼                                   │
Power Query ──► Validate ──► attendance ──┤
                                          │
ATS Export (weekly)                       │
      │  recruitment.csv (10,200 rows)    │
      ▼                                   ▼
Power Query ──► Validate ──► recruitment ──► SQL Views ──► Power BI ──► Dashboard
                                          │
Exit Survey (ad-hoc)                      │
      │  exit_records.csv (1,827 rows)    │
      ▼                                   │
Power Query ──► Validate ──► exit_records ┘
```

---

## Technology Stack

| Layer | Technology | Version | Purpose |
|---|---|---|---|
| Data Generation | Python | 3.13 | Dataset simulation |
| Data Storage | MySQL | 8.0 | Relational database |
| ETL | Power Query (M) | Latest | Data transformation |
| Analytics | Power BI Desktop | June 2024 | Data model + reports |
| Distribution | Power BI Service | Cloud | Dashboard hosting |
| Formula Engine | DAX | — | Business calculations |
| Source Control | GitHub | — | Version control |
| Documentation | Markdown | — | All docs in markdown |
| Spreadsheets | Microsoft Excel | 365 | Operational reporting |

---

## Security Architecture

```
Power BI Service
    │
    ├── Row-Level Security (RLS)
    │       ├── HR_Admin      → ALL data
    │       ├── HR_Manager    → Own dept only
    │       ├── Dept_Head     → Own team only
    │       ├── Exec_View     → Aggregated only
    │       └── Recruiter     → Hiring data only
    │
    ├── Dataset-level Security
    │       ├── Salary data: HR_Admin + Exec_View only
    │       └── PII (Names): HR_Admin + HR_Manager only
    │
    └── Workspace-level
            ├── Viewer: Can read
            ├── Contributor: Can edit
            └── Admin: Full control
```

---

## Data Refresh Architecture

```
Power BI Gateway (On-Premise)
    │
    ├── Scheduled Refresh: Daily 06:00 AM IST
    │       ├── employees table (Full refresh)
    │       ├── attendance table (Incremental: last 30 days)
    │       └── performance table (Incremental: current year)
    │
    ├── On-Demand Refresh: Manual trigger via Service
    │       └── exit_records (after new exit interviews)
    │
    └── Failure Alerts: Email to IT + HR Analytics team
            └── Retry: 3 attempts before alert
```

---

## Scalability Considerations

| Current | Phase 2 Target | Solution |
|---|---|---|
| 10,200 employees | 50,000 employees | Aggregation tables in SQL |
| 3 years history | 10 years history | Incremental refresh |
| 25 concurrent users | 200 concurrent users | Premium capacity |
| CSV source | Live API | Power BI DirectQuery |

---

*Architecture Owner: IT Data Engineering Team*
*Review Cycle: Annually or on major platform change*
