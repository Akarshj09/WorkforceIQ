# Dashboard User Guide
## WorkforceIQ
### Power BI Interactive Dashboard | Version 1.0 | August 2024

---

## 1. Introduction

Welcome to **WorkforceIQ** — your centralized workforce intelligence platform. This guide helps you navigate all 9 dashboard pages, use filters effectively, and interpret KPI results.

**Access:** Power BI Service → HR Analytics Workspace → WorkforceIQ Dashboard

---

## 2. Getting Started

### 2.1 Accessing the Dashboard

1. Open your browser → navigate to `app.powerbi.com`
2. Sign in with your company credentials
3. Click **Workspaces → HR Analytics → WorkforceIQ Dashboard**
4. Click **Open** to launch the report

### 2.2 Navigation

```
Use the TAB NAVIGATION BAR at the bottom:
[Executive] [Overview] [Salary] [Attrition] [Recruitment] [Performance] [Attendance] [Diversity] [Insights]
```

Click any tab to switch pages. Use **browser back button** or the **navigation arrows** on the toolbar.

### 2.3 User Roles & Access

| Your Role | Visible Data |
|---|---|
| HR Admin | All data, all departments |
| HR Business Partner | Your department only |
| Department Head | Your team's data |
| Executive | Aggregated summaries |

---

## 3. Using Filters & Slicers

### 3.1 Report-Level Filters (top of every page)

| Slicer | What It Filters | How to Use |
|---|---|---|
| **Year** | Data year (2015–2024) | Click year or drag slider |
| **Department** | Specific business unit | Click one or Ctrl+Click multiple |
| **Gender** | Male / Female / Non-Binary | Click checkboxes |
| **Location** | Employee city | Multi-select dropdown |

### 3.2 Page-Level Filters (specific to each page)

Each page has additional slicers. Examples:
- Attrition Page: **Exit Reason**, **Experience Band**
- Salary Page: **Salary Band**, **Education**
- Performance Page: **Rating Label**, **Promoted**

### 3.3 How to Clear Filters

- Click the **eraser icon** (⬜) on any slicer to clear it
- Use **Reset to Default** button (top-right of each page) to clear all filters

### 3.4 Cross-Filtering

Clicking any visual element (bar, donut slice, map pin) **automatically filters** all other visuals on the page.

**Example:** Click "Sales" bar in the department chart → all other charts show Sales-only data.

To deselect: click the same bar again or press **Ctrl+Z**.

---

## 4. Page-by-Page Guide

### 📊 Page 1 — Executive Dashboard

**Purpose:** High-level KPI overview for C-Suite and HR leadership.

**Key Visuals:**
| Visual | What It Shows | Insight Tip |
|---|---|---|
| KPI Cards (row 1) | 7 headline metrics | Compare vs target: green = good, red = alert |
| Department Bar Chart | Headcount by team | Longest bar = biggest team |
| Attrition Trend Line | Monthly attrition 2022–2024 | Look for seasonal spikes (Jan/Jul) |
| Gender Donut | Male/Female/NB split | Target: ≥40% female |
| Salary Band Donut | Pay band distribution | Band A > 15% = pay equity concern |

**Common Questions Answered Here:**
- *"How many people do we have?"* → Total Employees card
- *"Is attrition improving?"* → Attrition Trend line
- *"Are we growing?"* → YoY headcount bar chart

---

### 👥 Page 2 — Employee Overview

**Purpose:** Demographic and structural workforce analysis.

**Key Visuals:**
| Visual | Insight |
|---|---|
| Age Histogram | Identify if workforce is aging |
| Experience Histogram | Measure seniority distribution |
| Department Treemap | Proportional view of org size |
| City Map | Geographic spread of workforce |

**Pro Tips:**
- Click a city on the map → all charts filter to that city's employees
- Sort the employee table by **Experience DESC** to find veterans

---

### 💰 Page 3 — Salary Dashboard

**Purpose:** Compensation analysis, benchmarking, and pay equity monitoring.

**Key Visuals:**
| Visual | Insight |
|---|---|
| Dept Salary Bar | Compare avg salaries across teams |
| Salary vs Experience Scatter | Should show positive correlation |
| Top/Bottom 10 Tables | Identify outliers |
| Gender Pay Gap Scatter | Points far from diagonal = gap exists |

**⚠️ Alert:** If Gender Pay Gap Scatter shows females consistently below the diagonal line, escalate to HR Director immediately.

---

### 📉 Page 4 — Attrition Dashboard

**Purpose:** Identify attrition hot spots and root causes.

**Key Visuals:**
| Visual | Insight |
|---|---|
| Dept Attrition Bar | Red bars > 20% need immediate action |
| Exit Reason Donut | Majority = "Better Opportunity"? Review compensation |
| Experience × Attrition | High attrition in 0–2yr band = onboarding issue |
| Monthly Trend | Peaks in Jan/Jul = post-appraisal resignations |

**Workflow for HR BP:**
1. Filter to your department
2. Check monthly trend for new spikes
3. Click exit reason → see which employees chose that reason
4. Export table → schedule retention conversations

---

### 🎯 Page 5 — Recruitment Dashboard

**Purpose:** Optimize recruitment channel spending and efficiency.

**Key Visuals:**
| Visual | Question It Answers |
|---|---|
| Source Mix Donut | Where are we hiring from? |
| Cost per Source Bar | Which source is most expensive? |
| Retention by Source | Which source produces the best employees? |
| Monthly Hiring Line | Are we on track with hiring plan? |

**Decision Rule:**
- If **Consultancy cost** > 3× **Referral cost** with similar retention → shift budget to referral incentives

---

### ⭐ Page 6 — Performance Dashboard

**Purpose:** Track team performance, promotion fairness, and training effectiveness.

**Promotion Analysis Tip:**
- Filter Training Hours to "20+ hours"
- Check Promotion Rate — should be significantly higher
- If not: training program effectiveness review needed

---

### 📅 Page 7 — Attendance Dashboard

**Purpose:** Monitor punctuality, leave patterns, and overtime health.

**Overtime Alert:**
- Depts with avg overtime > 80 hrs/year may face burnout
- Cross-filter with Satisfaction Score (Performance page) to confirm

---

### 🌍 Page 8 — Diversity Dashboard

**Purpose:** Measure and track DEI (Diversity, Equity & Inclusion) metrics.

**Gender Pay Gap Analysis:**
- The scatter chart shows Male vs Female avg salary per department
- Each dot = one department
- Dots above the diagonal: Males earn more
- Dots below the diagonal: Females earn more (rare)
- **Target:** All dots within 3% of diagonal

---

### 💡 Page 9 — Business Insights

**Purpose:** Auto-generated data-driven recommendations.

**How to Use:**
- Review each colored insight card (Red = Critical, Yellow = Warning, Green = Positive)
- The 3-year comparison table shows progress trends
- Use insights to prepare for leadership presentations
- All insights are backed by live DAX calculations — they update automatically

---

## 5. Exporting Reports

### Export to PDF

```
File → Export → Export to PDF
→ Select pages to include
→ Download PDF
```

### Export Data to Excel

```
Right-click any visual → Export data
→ Select "Underlying data" or "Summarized data"
→ Download .xlsx file
```

### Share a Dashboard

```
File → Share → Enter email addresses
→ Set expiry date
→ Choose: Can view / Can edit
```

---

## 6. Troubleshooting

| Issue | Solution |
|---|---|
| Dashboard not loading | Refresh browser / Check internet |
| Data looks outdated | Check last refresh time (bottom of page) |
| Filter not working | Check if you have the correct access role |
| Visuals appear blank | The filter combination returns no data — relax filters |
| Export fails | Check file download permissions in your browser |
| Can't see salary data | Your role may not have compensation access — contact HR Admin |

---

## 7. Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| Ctrl+Click (slicer) | Multi-select |
| Alt+F4 (visual) | Focus mode (full screen) |
| Ctrl+Z | Undo last filter |
| Tab | Navigate between visuals |
| Enter | Interact with focused visual |

---

## 8. Support

**Dashboard Owner:** HR Analytics Center of Excellence
**Technical Support:** IT Helpdesk → Power BI Support Ticket
**Data Issues:** Email `hr.analytics@company.com`
**Training:** HR Learning Portal → "Power BI for HR Users" course

---

*Last Updated: August 2024 | Version 1.0*
