-- =====================================================================
-- test_error_cases.sql | Validates Exception Handling & Business Rules
-- =====================================================================
SET SERVEROUTPUT ON

PROMPT === Error Test 1: Registering a Suspended Student (ID 1006) ===
BEGIN
    register_student(p_student_id => 1006, p_course_id => 'INSY8212', p_semester => '2026-FALL');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Caught Expected Error: ' || SQLERRM);
END;
/

PROMPT === Error Test 2: Registering into a Full Course (INSY8311 capacity is 3) ===
BEGIN
    -- Students 1001, 1002, 1003 already filled INSY8311. Try registering 1010.
    register_student(p_student_id => 1010, p_course_id => 'INSY8311', p_semester => '2026-FALL');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Caught Expected Error: ' || SQLERRM);
END;
/

PROMPT === Error Test 3: Updating marks out of range (>100) ===
BEGIN
    update_marks(p_enrollment_id => 1000, p_new_marks => 120);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Caught Expected Error: ' || SQLERRM);
END;
/