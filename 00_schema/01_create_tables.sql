SET SERVEROUTPUT ON

BEGIN
  FOR t IN (SELECT table_name FROM user_tables
            WHERE table_name IN ('GRADE_AUDIT','GRADE_STAGING','ENROLLMENTS',
                                 'COURSES','STUDENTS','DEPARTMENTS')) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
  END LOOP;
  FOR s IN (SELECT sequence_name FROM user_sequences
            WHERE sequence_name IN ('SEQ_ENROLLMENT','SEQ_AUDIT','SEQ_STAGING')) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
  END LOOP;
END;
/

CREATE SEQUENCE seq_enrollment START WITH 1000 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_audit      START WITH 1    INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_staging    START WITH 1    INCREMENT BY 1 NOCACHE;

CREATE TABLE departments (
  dept_id    NUMBER(4)     CONSTRAINT pk_departments PRIMARY KEY,
  dept_name  VARCHAR2(60)  NOT NULL CONSTRAINT uq_dept_name UNIQUE
);

CREATE TABLE students (
  student_id    NUMBER(8)     CONSTRAINT pk_students PRIMARY KEY,
  first_name    VARCHAR2(40)  NOT NULL,
  last_name     VARCHAR2(40)  NOT NULL,
  email         VARCHAR2(100) NOT NULL CONSTRAINT uq_student_email UNIQUE,
  dept_id       NUMBER(4)     NOT NULL CONSTRAINT fk_student_dept REFERENCES departments(dept_id),
  status        VARCHAR2(10)  DEFAULT 'ACTIVE' NOT NULL
                CONSTRAINT ck_student_status CHECK (status IN ('ACTIVE','SUSPENDED','GRADUATED')),
  enrolled_date DATE          DEFAULT SYSDATE NOT NULL
);

CREATE TABLE courses (
  course_id     VARCHAR2(10)  CONSTRAINT pk_courses PRIMARY KEY,
  title         VARCHAR2(100) NOT NULL,
  credits       NUMBER(1)     NOT NULL CONSTRAINT ck_course_credits CHECK (credits BETWEEN 1 AND 6),
  dept_id       NUMBER(4)     NOT NULL CONSTRAINT fk_course_dept REFERENCES departments(dept_id),
  max_capacity  NUMBER(3)     DEFAULT 40 NOT NULL CONSTRAINT ck_course_cap CHECK (max_capacity > 0)
);

CREATE TABLE enrollments (
  enrollment_id NUMBER(10)    CONSTRAINT pk_enrollments PRIMARY KEY,
  student_id    NUMBER(8)     NOT NULL CONSTRAINT fk_enr_student REFERENCES students(student_id),
  course_id     VARCHAR2(10)  NOT NULL CONSTRAINT fk_enr_course  REFERENCES courses(course_id),
  semester      VARCHAR2(10)  NOT NULL,            -- e.g. 2026-FALL
  marks         NUMBER(5,2)   CONSTRAINT ck_enr_marks CHECK (marks BETWEEN 0 AND 100),
  grade         VARCHAR2(2),
  status        VARCHAR2(10)  DEFAULT 'ENROLLED' NOT NULL
                CONSTRAINT ck_enr_status CHECK (status IN ('ENROLLED','COMPLETED','DROPPED')),
  CONSTRAINT uq_enrollment UNIQUE (student_id, course_id, semester)
);

CREATE TABLE grade_audit (
  audit_id      NUMBER(10)  CONSTRAINT pk_grade_audit PRIMARY KEY,
  enrollment_id NUMBER(10)  NOT NULL CONSTRAINT fk_audit_enr REFERENCES enrollments(enrollment_id),
  old_marks     NUMBER(5,2),
  new_marks     NUMBER(5,2),
  changed_on    DATE DEFAULT SYSDATE NOT NULL
);

-- Staging table for the bulk mark import (BULK COLLECT / FORALL demo).
-- marks is deliberately wider so invalid values (e.g. 150) can be loaded here.
CREATE TABLE grade_staging (
  stage_id   NUMBER(10)   CONSTRAINT pk_grade_staging PRIMARY KEY,
  student_id NUMBER(8)    NOT NULL,
  course_id  VARCHAR2(10) NOT NULL,
  semester   VARCHAR2(10) NOT NULL,
  marks      NUMBER(8,2)
);

CREATE INDEX idx_enr_course_sem ON enrollments(course_id, semester);
CREATE INDEX idx_enr_student    ON enrollments(student_id);
