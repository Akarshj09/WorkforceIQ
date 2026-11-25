# Project Report
## WorkforceIQ
### GlobalTech Enterprises Ltd. | August 2024

---

## 1. Project Summary

| Field | Details |
|---|---|
| **Project Name** | WorkforceIQ |
| **Organization** | GlobalTech Enterprises Ltd. |
| **Duration** | 8 Weeks |
| **Team Size** | 4 (1 BA, 1 Data Analyst, 1 SQL Developer, 1 Power BI Developer) |
| **Status** | Completed — Live in Production |
| **Tools Used** | Python, MySQL, Power BI, Excel, Power Query, DAX |
| **Records Processed** | 10,200 employees; 30,600 performance & attendance records |

---

## 2. Executive Summary

GlobalTech Enterprises Ltd. identified a critical gap in workforce intelligence. HR data existed in siloed Excel reports across 10 business units, making it impossible to answer key business questions within 24 hours. Report generation took 3–5 business days, decisions were reactive, and ₹2.4 crore in annual value was being lost due to delayed action on attrition and suboptimal recruitment spend.

This project delivered a **centralized, interactive HR Analytics platform** that consolidates data from all 7 HR data domains — employees, salary, performance, attendance, recruitment, exits, and departments — into a single, self-service Power BI dashboard with 9 specialized pages and 60+ visuals.

The platform has been adopted by 25 HR users in Month 1, reducing report generation time from 3 days to under 5 minutes.

---

## 3. Problem Analysis

### 3.1 Root Cause Analysis

| Pain Point | Root Cause | Impact |
|---|---|---|
| 3-day reporting lag | Manual Excel consolidation | Delayed decision-making |
| 18% attrition not caught early | No real-time monitoring | ₹65K avg replacement cost × 1,827 exits |
| Recruitment spending inefficiency | No channel ROI visibility | ₹2.89 crore/year with 40% in Consultancy |
| Pay equity issues | No gender pay gap tracking | 4.2% gap violating policy |
| Promotion stagnation | No systematic tracking | 487 high performers never promoted |

### 3.2 Business Impact Calculation

```
Annual Attrition Cost:
  1,827 exits × ₹65,000 avg replacement cost = ₹11.9 Crore

Addressable (15% reduction target):
  274 prevented exits × ₹65,000 = ₹1.78 Crore savings

Recruitment Optimization (shift 20% spend from Consultancy to Referral):
  Current Consultancy: ₹1.15 Crore → Referral saves ₹78K per 10 roles
  Annual savings potential: ₹38 Lakhs

Total Projected Value from Analytics Platform: ₹2.16 Crore/year
Dashboard Development Cost: ₹8 Lakhs
ROI: 2,700% over 12 months
```

---

## 4. Solution Design

### 4.1 Architecture Decision

We evaluated three architecture options:

| Option | Tool Stack | Cost | Performance | Chosen? |
|---|---|---|---|---|
| A | Excel Only | Low | Poor (manual refresh) | ❌ |
| B | Tableau + PostgreSQL | High | Excellent | ❌ (license cost) |
| C | Power BI + MySQL + Excel | Medium | Excellent | ✅ |

Option C was selected for its cost-effectiveness, native MS Office integration, and Power BI Pro license availability.

### 4.2 Data Architecture

**Star Schema** was chosen over a flat table because:
- Enables faster query performance for aggregations
- Supports clean many-to-one relationships
- Simplifies DAX calculations in Power BI
- Scalable — dimensions grow independently of fact tables

### 4.3 Dataset Design

| Table | Rows | Key Purpose |
|---|---|---|
| employees | 10,200 | Master employee records |
| departments | 10 | Department dimension |
| salary | 10,200 | Compensation data |
| attendance | 30,600 | 3 years × 10,200 employees |
| performance | 30,600 | 3 years × 10,200 employees |
| recruitment | 10,200 | One record per hire |
| exit_records | 1,827 | 17.9% of total workforce |

---

## 5. Implementation

### 5.1 Phase 1: Data Engineering (Week 1–2)

**Activities:**
- Defined data model and schema
- Created 7 MySQL tables with constraints, FK relationships, and indexes
- Developed Python dataset generator (10,200 realistic employee records)
- Wrote 52 analytical SQL queries covering all HR KPIs
- Created 12 analytical views and 6 stored procedures

**Challenges:**
- Date range validation issues in Python generator (experience vs. age conflicts)
- Resolved by adding guard conditions and clamping functions

### 5.2 Phase 2: ETL Pipeline (Week 3)

**Activities:**
- Built Power Query transformation pipeline (10 transformation steps)
- Created custom M language Date dimension table
- Implemented Merge Queries to join salary + employee attributes
- Built incremental refresh logic for attendance and performance

### 5.3 Phase 3: Data Model & DAX (Week 4)

**Activities:**
- Built star schema in Power BI with 8 relationships
- Developed 40 DAX measures (headcount, attrition, salary, performance, recruitment, attendance)
- Configured Row-Level Security for 5 user roles
- Performance-optimized measures using CALCULATE with filter context

**Key DAX Complexity:**
- Risk Score composite measure (multi-condition CALCULATE)
- YoY Salary Growth (dynamic year context)
- Gender Pay Gap (ratio calculation across two filter contexts)

### 5.4 Phase 4: Dashboard Development (Week 5–6)

**Activities:**
- Designed 9 dashboard pages with consistent dark corporate theme (#0D1B2A)
- Implemented 60+ visuals across all pages
- Configured report-level and page-level slicers
- Built Business Insights page with auto-generated KPI cards
- Applied conditional formatting and data labels

**Design Decisions:**
- Dark theme chosen for executive presentation quality
- Consistent accent color (#00B4D8) for all interactive elements
- KPI cards use color-coded trend indicators (🔴🟡🟢)

### 5.5 Phase 5: Documentation & Testing (Week 7–8)

**Activities:**
- Produced 7 documentation files (BRD, FRD, Data Dictionary, KPI Doc, User Guide, Architecture, Report)
- Validated all 52 SQL queries against dataset
- Cross-validated Power BI DAX measures against SQL aggregate outputs
- Conducted UAT with 3 HR Business Partners
- Delivered training session (45 min) to 25 HR users

---

## 6. Results & Business Insights

### 6.1 Key Findings from Analysis

**Attrition Insights:**
1. **Sales department** has the highest attrition at 23.1% — 5.2% above company average
2. **68% of Sales resignations** cite salary below ₹55,000 as primary reason
3. **First-year attrition** accounts for 31% of all exits — onboarding effectiveness issue
4. **Post-appraisal spikes** (January, July) — better transparency needed

**Salary Insights:**
1. **Gender pay gap** of 4.2% exists — violates equal pay policy
2. **312 Band A employees** (earning < ₹40K) have Performance Rating ≥ 4 — upgrade candidates
3. **Consultancy-hired** employees earn 8.2% more on average than LinkedIn-hired employees

**Performance Insights:**
1. Employees with **20+ training hours** have **3.2× higher promotion rate** (18.4% vs 5.7%)
2. **487 active employees** with 5+ years experience, rating ≥4, never promoted — disengagement risk
3. **Technology department** has highest avg satisfaction (3.81) — best practices to replicate

**Recruitment Insights:**
1. **Employee Referral** has highest retention rate (88.2%) at lowest avg cost (₹9,500)
2. **Consultancy** costs ₹65,000 avg with only 81% retention — worst ROI
3. **Average time-to-hire** of 42.3 days exceeds 35-day target — bottleneck in interview rounds

### 6.2 Recommendations Generated

| # | Recommendation | Priority | Expected Impact |
|---|---|---|---|
| R-01 | Revise Sales salaries above ₹55K threshold | P0 | Reduce Sales attrition by 15% |
| R-02 | Launch Band A salary review for Rating ≥4 employees | P0 | Retain 312 high-value employees |
| R-03 | Increase referral program incentive to ₹15,000 | P1 | Save ₹38L annually in hiring cost |
| R-04 | Mandate 20 min training hours annually | P1 | Improve promotion rate by 2% |
| R-05 | Address 487 stagnant high performers | P1 | Prevent disengagement exodus |
| R-06 | Conduct gender pay audit by designation | P1 | Close 4.2% pay gap |
| R-07 | Implement onboarding enhancement program | P2 | Reduce first-year attrition by 10% |

---

## 7. Lessons Learned

| Area | Lesson | Applied To Future |
|---|---|---|
| Data Quality | Always validate date ranges programmatically | Built guards in Python generator |
| Stakeholder Mgmt | HR BPs need training before adoption | Delivered 45-min hands-on session |
| DAX Performance | Avoid SUMX over large tables | Used CALCULATE + aggregated measures |
| Data Privacy | RLS must be defined before UAT | RLS configured in Week 4 before testing |
| Documentation | BRD before FRD — get business sign-off first | Applied sequencing discipline |

---

## 8. Future Roadmap

### Phase 2 (Q1 2025): Live Integration
- Replace CSV exports with API-based real-time HRIS integration
- Implement Power Automate alerts for attrition risk events
- Mobile-optimized dashboard layout

### Phase 3 (Q3 2025): Predictive Analytics
- Machine Learning attrition prediction model (Python + Azure ML)
- Succession planning module
- Natural Language Q&A integration in Power BI

### Phase 4 (2026): Full Workforce Intelligence Platform
- Employee journey mapping
- Skills gap analysis
- Scenario-based workforce planning (headcount modeling)

---

## 9. Conclusion

WorkforceIQ successfully transformed GlobalTech's HR function from **reactive and fragmented** to **proactive and data-driven**. The platform delivers:

- **Real-time visibility** into all workforce KPIs
- **Projected ₹2.16 crore annual value** from prevented attrition and hiring optimization
- **2,700% ROI** on ₹8 lakh development investment
- **Self-service capability** for 25 HR professionals
- **Portfolio-ready, enterprise-grade** solution demonstrating SQL, Power BI, Excel, and Business Analysis competencies

---

*Report prepared by: HR Analytics Center of Excellence*
*Reviewed by: CHRO | IT Director | Finance Controller*
*Classification: Internal — Confidential*
