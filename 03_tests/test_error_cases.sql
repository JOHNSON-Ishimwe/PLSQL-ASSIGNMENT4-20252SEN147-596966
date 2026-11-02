-- =====================================================================
-- test_success_cases.sql | Validates successful execution paths
-- =====================================================================
SET SERVEROUTPUT ON

PROMPT === 1. Testing Student Registration (Active Student, Under Capacity) ===
BEGIN
    -- Student 1010 registering for INSY8311 in 2026-FALL
    register_student(p_student_id => 1010, p_course_id => 'INSY8212', p_semester => '2026-FALL');
END;
/

PROMPT === 2. Testing Mark Update and Audit Logging ===
BEGIN
    -- Update marks for enrollment 1008 (Student 1010 in INSY8212)
    -- First find the enrollment_id
    DECLARE
        v_enr_id NUMBER;
    BEGIN
        SELECT enrollment_id INTO v_enr_id 
        FROM enrollments 
        WHERE student_id = 1010 AND course_id = 'INSY8212' AND semester = '2026-FALL';
        
        update_marks(p_enrollment_id => v_enr_id, p_new_marks => 85.5);
    END;
END;
/

PROMPT === 3. Testing Bulk Grade Import ===
BEGIN
    import_grades_bulk;
END;
/

PROMPT === 4. Testing GPA Calculation Function ===
DECLARE
    v_gpa NUMBER;
BEGIN
    v_gpa := calculate_student_gpa(p_student_id => 1001, p_semester => '2026-SPRING');
    DBMS_OUTPUT.PUT_LINE('Student 1001 2026-SPRING GPA: ' || v_gpa);
END;
/
COMMIT;