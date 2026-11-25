# Business Requirements Document (BRD)
## WorkforceIQ
### Version 1.0 | Classification: Internal | August 2024

---

## 1. Document Control

| Field | Details |
|---|---|
| **Project Name** | WorkforceIQ |
| **Document Type** | Business Requirements Document |
| **Version** | 1.0 |
| **Status** | Approved |
| **Prepared By** | HR Analytics Team |
| **Reviewed By** | CHRO, IT Director |
| **Approval Date** | August 2024 |

---

## 2. Executive Summary

GlobalTech Enterprises Ltd. operates across 10 business units with over 10,000 employees in India. HR data is currently scattered across Excel files, email reports, and legacy HRIS systems with no unified reporting layer.

This document defines the business requirements for implementing a centralized **WorkforceIQ** platform using Microsoft Power BI, backed by a structured SQL database and clean, validated datasets.

The solution will enable HR managers, department heads, and C-suite executives to make **data-driven workforce decisions** in real time.

---

## 3. Business Problem Statement

### 3.1 Current State

| Issue | Business Impact |
|---|---|
| HR data in 15+ separate Excel files | No single source of truth |
| Manual monthly reporting (3–5 days effort) | Delayed decision-making |
| No real-time attrition visibility | High replacement costs (~₹65K per hire) |
| No salary benchmarking tool | Pay inequity and flight risk |
| No recruitment channel performance data | Inefficient hiring spend |
| No satisfaction / retention correlation data | Reactive retention strategies |

### 3.2 Problem Statement

> *"The HR department cannot currently answer key workforce questions within 24 hours due to data fragmentation. This results in an estimated ₹2.4 crore annual cost in delayed decisions, undetected attrition, and suboptimal recruitment spending."*

---

## 4. Business Objectives

| # | Objective | Priority | KPI to Measure |
|---|---|---|---|
| BO-01 | Centralize all HR data | P0 | Single dashboard live in <30s |
| BO-02 | Monitor attrition in real time | P0 | Attrition rate tracked monthly |
| BO-03 | Improve recruitment efficiency | P1 | Reduce avg time-to-hire by 15% |
| BO-04 | Enable salary benchmarking | P1 | Pay gap < 5% within same role |
| BO-05 | Track performance trends | P1 | Promotion rate improved by 2% |
| BO-06 | Measure employee satisfaction | P2 | Satisfaction score ≥ 3.8/5 |
| BO-07 | Workforce diversity reporting | P2 | Female representation ≥ 40% |
| BO-08 | Self-service reporting for HRBPs | P2 | <5 min to generate any report |

---

## 5. Stakeholders

| Stakeholder | Role | Interest |
|---|---|---|
| CHRO | Executive Sponsor | Strategic workforce insights |
| HR Business Partners | Primary Users | Department-level analytics |
| Department Heads | Secondary Users | Team performance dashboards |
| Finance Team | Secondary Users | Payroll & budget analytics |
| IT / Data Team | Technical Owner | Data pipeline & maintenance |
| Recruitment Team | Secondary Users | Hiring efficiency metrics |
| C-Suite (CEO, CFO) | Consumers | Executive summary reports |

---

## 6. Scope

### 6.1 In Scope

- ✅ Consolidated employee master database (10,200+ records)
- ✅ Real-time attrition monitoring
- ✅ Salary distribution & benchmarking
- ✅ Performance & promotion analytics
- ✅ Recruitment source efficiency analysis
- ✅ Attendance & leave analytics
- ✅ Diversity & inclusion metrics
- ✅ 9-page interactive Power BI dashboard
- ✅ SQL analytical layer with 50+ queries
- ✅ Excel operational workbook

### 6.2 Out of Scope

- ❌ Integration with payroll processing systems
- ❌ Employee self-service portal
- ❌ Real-time HRIS API integration (Phase 2)
- ❌ Machine learning predictive models (Phase 3)
- ❌ Mobile app development

---

## 7. Business Requirements

### BR-01: Attrition Monitoring
- System shall display real-time attrition rate by department, gender, experience, and salary band
- System shall identify top 3 exit reasons monthly
- System shall flag departments exceeding 20% attrition threshold

### BR-02: Salary Analytics
- System shall display salary benchmarks by designation and department
- System shall identify pay gap between genders within same role
- System shall show salary band distribution across the organization

### BR-03: Recruitment Analytics
- System shall calculate cost-per-hire by recruitment source
- System shall display time-to-hire trends
- System shall compare retention rates by recruitment channel

### BR-04: Performance Management
- System shall show year-wise performance rating distribution
- System shall correlate training hours with promotion rates
- System shall identify employees with consistently high ratings but no promotion

### BR-05: Attendance Tracking
- System shall show annual attendance percentages by department
- System shall display overtime and leave utilization trends
- System shall flag employees with attendance below 80%

### BR-06: Diversity Reporting
- System shall show gender distribution across all departments and levels
- System shall display education diversity
- System shall track age group distribution

### BR-07: Self-Service Access
- HR managers shall be able to filter any view by Department, Year, Gender, Location without IT support
- All dashboards shall load within 5 seconds
- Reports shall be exportable to PDF and Excel

---

## 8. Assumptions

1. Source data is available in CSV format from existing HRIS
2. Power BI Pro licenses are available for HR team (est. 25 users)
3. Data refresh will be scheduled daily at 6:00 AM IST
4. Historical data available from FY 2015 onwards
5. Employee IDs are unique and consistent across all data sources

---

## 9. Constraints

1. Budget: ₹8 lakhs (tooling, development, training)
2. Timeline: 8 weeks from kickoff to go-live
3. Data Privacy: PII masking required in non-HR views
4. Infrastructure: No additional server provisioning allowed (Power BI cloud)

---

## 10. Risks

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| Data quality issues in source files | High | High | Validation layer in Power Query |
| Stakeholder adoption resistance | Medium | High | Training sessions + user guide |
| PII data exposure | Low | Critical | Row-level security in Power BI |
| Scope creep from executives | Medium | Medium | Change control process |
| Data refresh failures | Low | Medium | Monitoring alerts + fallback |

---

## 11. Success Criteria

| Criterion | Target |
|---|---|
| Dashboard adoption rate (Month 1) | ≥ 80% of HR team using weekly |
| Report generation time | < 5 minutes (vs 3 days currently) |
| Data accuracy vs source | ≥ 99.5% |
| User satisfaction score | ≥ 4.0 / 5.0 |
| Attrition detection lag | Reduced from 30 days to real-time |

---

*Document Owner: HR Analytics Center of Excellence*
*Next Review: February 2025*
