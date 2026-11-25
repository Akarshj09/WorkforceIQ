# Excel HR Analytics Workbook — Implementation Guide

**File:** `HR_Analytics_Master.xlsx`
**Sheets:** 12 tabs | **Records:** 10,200 employees

---

## 📁 Workbook Structure

| Sheet Name | Purpose |
|---|---|
| `RAW_Employees` | Original imported data (do not edit) |
| `RAW_Salary` | Original salary data |
| `RAW_Performance` | Original performance data |
| `CLEAN_Employees` | Cleaned, validated employee data |
| `LOOKUP_Tables` | Drop-down lists, department codes |
| `Pivot_Attrition` | Attrition pivot analysis |
| `Pivot_Salary` | Salary distribution analysis |
| `Pivot_Performance` | Performance & training pivots |
| `Pivot_Recruitment` | Recruitment source analysis |
| `FORMULAS` | Advanced formula examples |
| `DASHBOARD` | Executive HR dashboard |
| `DATA_VALIDATION` | Rules sheet |

---

## 🧹 Step 1: Data Cleaning

### 1.1 Remove Duplicates

```
1. Select the entire CLEAN_Employees sheet (Ctrl+A)
2. Data tab → Remove Duplicates
3. Check "EmployeeID" as unique key column
4. Click OK — Excel removes duplicate rows
```

### 1.2 TRIM — Remove Leading/Trailing Spaces

Apply to Name, City, Designation columns:

```excel
=TRIM(RAW_Employees!B2)
```

Fill down entire column, then Paste Special → Values to freeze.

### 1.3 Handle Missing Values

**Check for blanks:**
```excel
=COUNTBLANK(A2:A10201)
```

**Replace blanks in ExitDate with "N/A":**
```excel
=IF(ISBLANK(L2), "N/A", L2)
```

**Fill missing Satisfaction Scores with department average:**
```excel
=IF(ISBLANK(P2), AVERAGEIF($D$2:$D$10201, D2, $P$2:$P$10201), P2)
```

### 1.4 Flash Fill — Extract First Name

1. In a helper column, type the first name from the Name column manually for row 2
2. In row 3 start typing — Excel Flash Fill predicts the pattern
3. Press **Ctrl+E** to apply Flash Fill to all rows

### 1.5 Text to Columns — Split Full Name

```
1. Select the Name column
2. Data → Text to Columns
3. Choose: Delimited → Space
4. This creates FirstName and LastName columns
```

### 1.6 Standardize Gender Values

**Find & Replace:**
- `M` → `Male`
- `F` → `Female`

Or using formula:
```excel
=IF(C2="M","Male", IF(C2="F","Female", C2))
```

### 1.7 Convert Text Dates to Date Format

```excel
=DATEVALUE(TEXT(K2, "YYYY-MM-DD"))
```

Or: Select column → Format Cells → Date → choose YYYY-MM-DD format.

---

## 🎨 Step 2: Conditional Formatting

### 2.1 Highlight High Attrition Departments (in pivot)

```
1. Select AttritionPct column
2. Home → Conditional Formatting → Color Scales
3. Red-Yellow-Green scale (Red = high attrition)
```

### 2.2 Highlight Low Salary Employees

```
Rule: Cell Value < 40000
Format: Red fill, white bold text
```

### 2.3 Performance Rating Color Code

| Rating | Format |
|---|---|
| 5 — Outstanding | Green fill |
| 4 — Good | Light green |
| 3 — Average | Yellow |
| 2 — Below Average | Orange |
| 1 — Poor | Red fill |

### 2.4 Data Bars for Salary Column

```
Home → Conditional Formatting → Data Bars → Solid Fill (Blue)
```

---

## ✅ Step 3: Data Validation

### 3.1 Department Dropdown

```
1. Select the Department column
2. Data → Data Validation → List
3. Source: Technology, HR, Finance, Sales, Marketing, Operations, Legal, Customer Support, Product Management, Supply Chain
```

### 3.2 Gender Dropdown

```
Source: Male, Female, Non-Binary
```

### 3.3 Status Dropdown

```
Source: Active, Resigned, Terminated, Retired
```

### 3.4 Salary Range Validation

```
Allow: Whole number
Minimum: 20000
Maximum: 500000
Error Alert: "Salary must be between ₹20,000 and ₹5,00,000"
```

### 3.5 Date Validation

```
Allow: Date
Start Date: 01-01-2000
End Date: today (=TODAY())
```

---

## 📊 Step 4: Pivot Tables

### 4.1 Attrition by Department

```
1. Insert → PivotTable → From CLEAN_Employees sheet
2. Rows: Department
3. Values: Count of EmployeeID (rename → Total Employees)
4. Add Calculated Field:
   - Resigned Count: =COUNTIFS(Status, "Resigned")
   - Attrition %: =Resigned/Total*100
```

**Slicers:** Gender, Year, Education

### 4.2 Salary Distribution by Department

```
Rows: Department
Columns: SalaryBand
Values: Average of BasicSalary, Count of EmployeeID
```

### 4.3 Performance Rating Distribution

```
Rows: RatingLabel
Columns: Department
Values: Count of PerfID
```

### 4.4 Recruitment Source Analysis

```
Rows: RecruitmentSource
Values: Count of EmployeeID, Average HiringCost, Average TimeToHire
```

### 4.5 Hiring Trend by Year/Month

```
Rows: JoiningYear (group by year)
Columns: JoiningMonth (group by month)
Values: Count of EmployeeID
```

---

## 📐 Step 5: Advanced Formulas

### 5.1 XLOOKUP — Look up employee salary by ID

```excel
=XLOOKUP(A2, Salary!A:A, Salary!C:C, "Not Found", 0)
```

**Use case:** HR enters EmployeeID in cell A2 → formula returns their BasicSalary automatically.

### 5.2 INDEX MATCH — Department head lookup

```excel
=INDEX(LOOKUP_Tables!B:B, MATCH(D2, LOOKUP_Tables!A:A, 0))
```

**Use case:** Given a DepartmentID, returns the Department Head name.

### 5.3 SUMIFS — Total salary for active employees in Technology

```excel
=SUMIFS(Salary!C:C, CLEAN_Employees!E:E, "Technology", CLEAN_Employees!M:M, "Active")
```

### 5.4 COUNTIFS — Count female employees in Sales with MBA

```excel
=COUNTIFS(Department, "Sales", Gender, "Female", Education, "MBA")
```

### 5.5 COUNTIFS — Attrition rate formula

```excel
=COUNTIFS(EmployeeStatus, "Resigned") / COUNTA(EmployeeID)
```

### 5.6 AVERAGEIFS — Avg salary of active male employees in Finance

```excel
=AVERAGEIFS(BasicSalary, Department, "Finance", Gender, "Male", Status, "Active")
```

### 5.7 Dynamic top performer name

```excel
=INDEX(Name, MATCH(MAX(PerformanceRating), PerformanceRating, 0))
```

### 5.8 IFERROR with XLOOKUP — Safe lookup

```excel
=IFERROR(XLOOKUP(A2, EmployeeID, SatisfactionScore), "Data Unavailable")
```

### 5.9 Attrition rate (formatted)

```excel
=TEXT(COUNTIF(Status,"Resigned")/COUNTA(Status), "0.00%")
```

### 5.10 Tenure in years

```excel
=IF(M2="Active", DATEDIF(K2, TODAY(), "Y"), DATEDIF(K2, L2, "Y"))
```

---

## 📈 Step 6: Pivot Charts

### Chart 1 — Attrition by Department (Bar Chart)

```
PivotChart from Pivot_Attrition
Chart Type: Clustered Bar
X-Axis: Department
Y-Axis: AttritionPct
Color: Red gradient
Add: Data Labels
```

### Chart 2 — Salary Distribution (Box Plot approximation)

```
Chart Type: Column Chart
X-Axis: SalaryBand
Y-Axis: Employee Count
Secondary Axis: Average Salary (Line)
```

### Chart 3 — Gender Diversity (Donut Chart)

```
Chart Type: Donut
Labels: Gender
Values: Employee Count
Colors: Blue (Male), Pink (Female), Purple (Non-Binary)
```

### Chart 4 — Monthly Hiring Trend (Line Chart)

```
Chart Type: Line with Markers
X-Axis: Month-Year
Y-Axis: New Hires
Add Trendline: Linear
```

### Chart 5 — Performance Rating Distribution (Pie Chart)

```
Chart Type: Pie
Labels: RatingLabel
Values: Count
Explode: "Outstanding" slice
```

---

## 🖥️ Step 7: Excel Dashboard

### Layout (Dashboard Sheet)

```
┌─────────────────────────────────────────────────────┐
│  WORKFORCEIQ DASHBOARD                 [Company Logo]│
│  Last Updated: [=TODAY()]                            │
├────────────┬────────────┬────────────┬──────────────┤
│ Total Emps │ Active     │ Attrition% │ Avg Salary   │
│  10,200    │  8,373     │  17.9%     │  ₹82,450     │
├────────────┴────────────┴────────────┴──────────────┤
│ [Attrition by Dept Bar Chart]  [Gender Donut Chart] │
│                                                     │
│ [Salary Band Distribution]  [Hiring Trend Line]     │
│                                                     │
│ [Performance Rating Pie]   [Top Performers Table]   │
└─────────────────────────────────────────────────────┘
```

### KPI Cards (using cell formatting)

```
Cell A3: =COUNTA(CLEAN_Employees!A:A)-1        → "Total Employees"
Cell C3: =COUNTIF(CLEAN_Employees!M:M,"Active") → "Active Employees"
Cell E3: =TEXT(Pivot_Attrition!C2,"0.00%")     → "Attrition Rate"
Cell G3: =AVERAGE(Salary!C:C)                  → "Avg Salary"
```

### Interactive Slicers

Connect these slicers to ALL pivot tables on the Dashboard:
- **Department** slicer
- **Year** slicer
- **Gender** slicer
- **EmployeeStatus** slicer

---

## ⚡ Power Query Steps (Get & Transform)

### Loading CSV Files

```
1. Data → Get Data → From File → From Folder
2. Select /Dataset/ folder
3. Power Query loads all 7 CSVs at once
```

### Power Query Transformations Applied

| Step | Action |
|---|---|
| 1 | Remove duplicate EmployeeIDs |
| 2 | Replace null ExitDate with "Active" |
| 3 | Change data types (Date, Integer, Decimal) |
| 4 | Split Name into FirstName / LastName |
| 5 | Trim whitespace from all text columns |
| 6 | Replace gender abbreviations with full values |
| 7 | Add TenureYears calculated column |
| 8 | Merge salary table into employees |
| 9 | Group by Department for summary |
| 10 | Filter to remove test/invalid records |

---

## 🎯 Best Practices Applied

- ✅ Never edit RAW sheets — all cleaning on CLEAN_ sheets
- ✅ Named Ranges for all major columns
- ✅ Structured Tables (Ctrl+T) for dynamic pivots
- ✅ Data Validation on all input cells
- ✅ Protected sheets (RAW data locked)
- ✅ Version documented in sheet footer
- ✅ Consistent color theme (corporate blue/grey)
