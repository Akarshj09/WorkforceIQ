-- ============================================================
-- WorkforceIQ | Database Schema
-- File        : 01_schema.sql
-- Database    : MySQL 8.0+ / PostgreSQL 14+
-- Description : Full DDL for HR Analytics star schema
-- Author      : HR Analytics Team
-- Version     : 1.0
-- Created     : 2024
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- DATABASE CREATION
-- ─────────────────────────────────────────────────────────────
CREATE DATABASE IF NOT EXISTS hr_analytics
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE hr_analytics;

-- ─────────────────────────────────────────────────────────────
-- DROP TABLES (for re-runs, in dependency order)
-- ─────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS exit_records;
DROP TABLE IF EXISTS recruitment;
DROP TABLE IF EXISTS performance;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS salary;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- ─────────────────────────────────────────────────────────────
-- TABLE 1: DEPARTMENTS (Dimension Table)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE departments (
    DepartmentID        TINYINT UNSIGNED    NOT NULL,
    DepartmentName      VARCHAR(60)         NOT NULL,
    DepartmentHead      VARCHAR(100)        NOT NULL,
    Location            VARCHAR(60)         NOT NULL,
    HeadCount           SMALLINT UNSIGNED   NOT NULL DEFAULT 0,
    Budget_INR_Lakhs    DECIMAL(10,2)       NOT NULL DEFAULT 0.00,
    CreatedAt           TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt           TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_departments PRIMARY KEY (DepartmentID),
    CONSTRAINT uq_department_name UNIQUE (DepartmentName)
) ENGINE=InnoDB COMMENT='Dimension: Company departments';

-- ─────────────────────────────────────────────────────────────
-- TABLE 2: EMPLOYEES (Fact/Dimension – central hub table)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE employees (
    EmployeeID          VARCHAR(10)         NOT NULL,
    Name                VARCHAR(100)        NOT NULL,
    Age                 TINYINT UNSIGNED    NOT NULL CHECK (Age BETWEEN 18 AND 70),
    Gender              ENUM('Male','Female','Non-Binary','Other') NOT NULL,
    DepartmentID        TINYINT UNSIGNED    NOT NULL,
    Department          VARCHAR(60)         NOT NULL,
    Designation         VARCHAR(100)        NOT NULL,
    Education           ENUM('High School','Diploma','Bachelor''s','Master''s','MBA','PhD') NOT NULL,
    Experience          TINYINT UNSIGNED    NOT NULL DEFAULT 0,
    City                VARCHAR(60)         NOT NULL,
    JoiningDate         DATE                NOT NULL,
    ExitDate            DATE                NULL,
    EmployeeStatus      ENUM('Active','Resigned','Terminated','Retired') NOT NULL DEFAULT 'Active',
    RecruitmentSource   VARCHAR(60)         NOT NULL,
    CreatedAt           TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt           TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_employees     PRIMARY KEY (EmployeeID),
    CONSTRAINT fk_emp_dept      FOREIGN KEY (DepartmentID)
                                REFERENCES departments(DepartmentID)
                                ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_exit_date    CHECK (ExitDate IS NULL OR ExitDate > JoiningDate)
) ENGINE=InnoDB COMMENT='Central employee master table';

-- ─────────────────────────────────────────────────────────────
-- TABLE 3: SALARY (Fact Table)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE salary (
    SalaryID            VARCHAR(10)         NOT NULL,
    EmployeeID          VARCHAR(10)         NOT NULL,
    BasicSalary         DECIMAL(12,2)       NOT NULL CHECK (BasicSalary > 0),
    Bonus               DECIMAL(12,2)       NOT NULL DEFAULT 0.00,
    Deductions          DECIMAL(12,2)       NOT NULL DEFAULT 0.00,
    NetSalary           DECIMAL(12,2)       NOT NULL,
    BonusPercent        DECIMAL(5,2)        NOT NULL DEFAULT 0.00,
    SalaryBand          ENUM('Band A','Band B','Band C','Band D') NOT NULL,
    EffectiveDate       DATE                NOT NULL,
    Currency            CHAR(3)             NOT NULL DEFAULT 'INR',
    CreatedAt           TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_salary        PRIMARY KEY (SalaryID),
    CONSTRAINT fk_salary_emp    FOREIGN KEY (EmployeeID)
                                REFERENCES employees(EmployeeID)
                                ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Employee compensation fact table';

-- ─────────────────────────────────────────────────────────────
-- TABLE 4: ATTENDANCE (Fact Table – annual rollup)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE attendance (
    AttendanceID        VARCHAR(10)         NOT NULL,
    EmployeeID          VARCHAR(10)         NOT NULL,
    Year                SMALLINT UNSIGNED   NOT NULL,
    WorkingDays         SMALLINT UNSIGNED   NOT NULL DEFAULT 250,
    DaysPresent         SMALLINT UNSIGNED   NOT NULL,
    Leaves              TINYINT UNSIGNED    NOT NULL DEFAULT 0,
    Absences            TINYINT UNSIGNED    NOT NULL DEFAULT 0,
    OvertimeHours       SMALLINT UNSIGNED   NOT NULL DEFAULT 0,
    WFHDays             SMALLINT UNSIGNED   NOT NULL DEFAULT 0,
    AttendancePercent   DECIMAL(5,2)        NOT NULL,
    CreatedAt           TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_attendance    PRIMARY KEY (AttendanceID),
    CONSTRAINT fk_att_emp       FOREIGN KEY (EmployeeID)
                                REFERENCES employees(EmployeeID)
                                ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT uq_emp_year      UNIQUE (EmployeeID, Year),
    CONSTRAINT chk_present      CHECK (DaysPresent <= WorkingDays)
) ENGINE=InnoDB COMMENT='Annual attendance fact table';

-- ─────────────────────────────────────────────────────────────
-- TABLE 5: PERFORMANCE (Fact Table – annual)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE performance (
    PerfID              VARCHAR(10)         NOT NULL,
    EmployeeID          VARCHAR(10)         NOT NULL,
    Year                SMALLINT UNSIGNED   NOT NULL,
    PerformanceRating   TINYINT UNSIGNED    NOT NULL CHECK (PerformanceRating BETWEEN 1 AND 5),
    RatingLabel         ENUM('Poor','Below Average','Average','Good','Outstanding') NOT NULL,
    TrainingHours       SMALLINT UNSIGNED   NOT NULL DEFAULT 0,
    Promoted            TINYINT(1)          NOT NULL DEFAULT 0,
    SatisfactionScore   DECIMAL(3,1)        NOT NULL CHECK (SatisfactionScore BETWEEN 1.0 AND 5.0),
    GoalsMetPercent     TINYINT UNSIGNED    NOT NULL CHECK (GoalsMetPercent BETWEEN 0 AND 100),
    ManagerFeedback     VARCHAR(50)         NOT NULL,
    CreatedAt           TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_performance   PRIMARY KEY (PerfID),
    CONSTRAINT fk_perf_emp      FOREIGN KEY (EmployeeID)
                                REFERENCES employees(EmployeeID)
                                ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Annual employee performance fact table';

-- ─────────────────────────────────────────────────────────────
-- TABLE 6: RECRUITMENT (Fact Table)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE recruitment (
    RecruitmentID       VARCHAR(10)         NOT NULL,
    EmployeeID          VARCHAR(10)         NOT NULL,
    RecruitmentSource   VARCHAR(60)         NOT NULL,
    HiringCost          DECIMAL(10,2)       NOT NULL DEFAULT 0.00,
    TimeToHire_Days     TINYINT UNSIGNED    NOT NULL DEFAULT 0,
    InterviewRounds     TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    OfferAccepted       ENUM('Yes','No')    NOT NULL DEFAULT 'Yes',
    JoiningDate         DATE                NOT NULL,
    RecruiterName       VARCHAR(100)        NOT NULL,
    JobPortalUsed       VARCHAR(60)         NOT NULL DEFAULT 'N/A',
    CreatedAt           TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_recruitment   PRIMARY KEY (RecruitmentID),
    CONSTRAINT fk_rec_emp       FOREIGN KEY (EmployeeID)
                                REFERENCES employees(EmployeeID)
                                ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Recruitment fact table';

-- ─────────────────────────────────────────────────────────────
-- TABLE 7: EXIT RECORDS (Fact Table)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE exit_records (
    ExitID                  VARCHAR(10)     NOT NULL,
    EmployeeID              VARCHAR(10)     NOT NULL,
    ExitDate                DATE            NOT NULL,
    ExitReason              VARCHAR(60)     NOT NULL,
    TenureDays              SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    NoticeServed            ENUM('Yes','Partial','No') NOT NULL DEFAULT 'Yes',
    ExitInterviewDone       ENUM('Yes','No')           NOT NULL DEFAULT 'Yes',
    ReHireEligible          ENUM('Yes','No','Maybe')   NOT NULL DEFAULT 'Maybe',
    LastPerformanceRating   TINYINT UNSIGNED NOT NULL CHECK (LastPerformanceRating BETWEEN 1 AND 5),
    CreatedAt               TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_exit          PRIMARY KEY (ExitID),
    CONSTRAINT fk_exit_emp      FOREIGN KEY (EmployeeID)
                                REFERENCES employees(EmployeeID)
                                ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Employee exit / attrition fact table';

-- ─────────────────────────────────────────────────────────────
-- INDEXES (for query performance)
-- ─────────────────────────────────────────────────────────────
-- Employees
CREATE INDEX idx_emp_dept        ON employees (DepartmentID);
CREATE INDEX idx_emp_status      ON employees (EmployeeStatus);
CREATE INDEX idx_emp_joining     ON employees (JoiningDate);
CREATE INDEX idx_emp_exit        ON employees (ExitDate);
CREATE INDEX idx_emp_gender      ON employees (Gender);
CREATE INDEX idx_emp_city        ON employees (City);
CREATE INDEX idx_emp_edu         ON employees (Education);
CREATE INDEX idx_emp_rec_src     ON employees (RecruitmentSource);

-- Salary
CREATE INDEX idx_sal_band        ON salary (SalaryBand);
CREATE INDEX idx_sal_net         ON salary (NetSalary);

-- Attendance
CREATE INDEX idx_att_year        ON attendance (Year);

-- Performance
CREATE INDEX idx_perf_year       ON performance (Year);
CREATE INDEX idx_perf_rating     ON performance (PerformanceRating);
CREATE INDEX idx_perf_promoted   ON performance (Promoted);

-- Recruitment
CREATE INDEX idx_rec_source      ON recruitment (RecruitmentSource);
CREATE INDEX idx_rec_joining     ON recruitment (JoiningDate);

-- Exit
CREATE INDEX idx_exit_date       ON exit_records (ExitDate);
CREATE INDEX idx_exit_reason     ON exit_records (ExitReason);

-- ─────────────────────────────────────────────────────────────
-- END OF SCHEMA
-- ─────────────────────────────────────────────────────────────
