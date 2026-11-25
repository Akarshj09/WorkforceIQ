import sqlite3
import pandas as pd
import os

print("="*60)
print(" WORKFORCEIQ - TERMINAL DASHBOARD ")
print("="*60)
print("Loading data into local SQLite database...\n")

# Connect to in-memory SQLite database
conn = sqlite3.connect(':memory:')

# Define dataset paths
data_dir = 'Dataset'
csv_files = {
    'employees': 'employees.csv',
    'departments': 'departments.csv',
    'salary': 'salary.csv',
    'attendance': 'attendance.csv',
    'performance': 'performance.csv',
    'recruitment': 'recruitment.csv',
    'exit_records': 'exit_records.csv'
}

# Load all CSVs into SQLite tables
for table_name, file_name in csv_files.items():
    file_path = os.path.join(data_dir, file_name)
    if os.path.exists(file_path):
        df = pd.read_csv(file_path)
        df.to_sql(table_name, conn, index=False, if_exists='replace')
    else:
        print(f"Error: Could not find {file_path}")
        exit(1)

print("Data loaded successfully! Running analytical queries...\n")

def run_query(title, query):
    print("\n" + "-"*60)
    print(f" ---> {title} <--- ")
    print("-"*60)
    try:
        result = pd.read_sql_query(query, conn)
        if result.empty:
            print("No data found.")
        else:
            print(result.to_string(index=False))
    except Exception as e:
        print(f"Error executing query: {e}")
    print("\n")

# --- Query 1: Executive Summary ---
query1 = """
SELECT 
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN EmployeeStatus='Active' THEN 1 ELSE 0 END) AS ActiveEmployees,
    ROUND(SUM(CASE WHEN EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2) AS AttritionRatePct
FROM employees;
"""
run_query("EXECUTIVE SUMMARY (KPIs)", query1)

# --- Query 2: Attrition by Department ---
query2 = """
SELECT 
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN EmployeeStatus='Resigned' THEN 1 ELSE 0 END) AS Resigned,
    ROUND(SUM(CASE WHEN EmployeeStatus='Resigned' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2) AS AttritionPct
FROM employees
GROUP BY Department
ORDER BY AttritionPct DESC;
"""
run_query("ATTRITION BY DEPARTMENT", query2)

# --- Query 3: Average Salary by Department ---
query3 = """
SELECT 
    e.Department,
    ROUND(AVG(s.BasicSalary), 0) AS AvgSalary,
    MIN(s.BasicSalary) AS MinSalary,
    MAX(s.BasicSalary) AS MaxSalary
FROM employees e
JOIN salary s ON e.EmployeeID = s.EmployeeID
WHERE e.EmployeeStatus = 'Active'
GROUP BY e.Department
ORDER BY AvgSalary DESC;
"""
run_query("SALARY BENCHMARKING BY DEPARTMENT", query3)

# --- Query 4: Gender Pay Gap ---
query4 = """
SELECT 
    Gender,
    COUNT(*) AS Headcount,
    ROUND(AVG(s.BasicSalary), 0) AS AvgSalary
FROM employees e
JOIN salary s ON e.EmployeeID = s.EmployeeID
WHERE e.EmployeeStatus = 'Active'
GROUP BY Gender;
"""
run_query("GENDER PAY GAP ANALYSIS", query4)

# --- Query 5: Top 3 Exit Reasons ---
query5 = """
SELECT 
    ExitReason,
    COUNT(*) AS Count,
    ROUND(COUNT(*)*100.0 / (SELECT COUNT(*) FROM exit_records), 2) AS Percentage
FROM exit_records
GROUP BY ExitReason
ORDER BY Count DESC
LIMIT 3;
"""
run_query("TOP 3 REASONS EMPLOYEES LEAVE", query5)

# --- Query 6: Recruitment Source Efficiency ---
query6 = """
SELECT 
    e.RecruitmentSource,
    COUNT(*) AS TotalHires,
    ROUND(AVG(HiringCost), 0) AS AvgHiringCost,
    SUM(CASE WHEN EmployeeStatus='Active' THEN 1 ELSE 0 END)*100.0 / COUNT(*) AS RetentionRatePct
FROM employees e
JOIN recruitment r ON e.EmployeeID = r.EmployeeID
GROUP BY e.RecruitmentSource
ORDER BY RetentionRatePct DESC;
"""
run_query("RECRUITMENT SOURCE EFFICIENCY", query6)

print("="*60)
print(" Analysis Complete. ")
print("="*60)
conn.close()
