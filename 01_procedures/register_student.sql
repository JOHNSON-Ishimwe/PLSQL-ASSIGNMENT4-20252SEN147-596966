SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE register_student (
    p_student_id IN NUMBER,
    p_course_id  IN VARCHAR2,
    p_semester   IN VARCHAR2
) IS
    v_status       students.status%TYPE;
    v_current_count NUMBER;
    v_max_capacity  courses.max_capacity%TYPE;
    
    e_not_active    EXCEPTION;
    e_course_full   EXCEPTION;
BEGIN
    -- 1. Verify student exists and is ACTIVE
    BEGIN
        SELECT status INTO v_status
        FROM students
        WHERE student_id = p_student_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Student ID ' || p_student_id || ' does not exist.');
    END;

    IF v_status <> 'ACTIVE' THEN
        RAISE e_not_active;
    END IF;

    -- 2. Check course capacity
    SELECT max_capacity INTO v_max_capacity
    FROM courses
    WHERE course_id = p_course_id;

    SELECT COUNT(*) INTO v_current_count
    FROM enrollments
    WHERE course_id = p_course_id AND semester = p_semester AND status = 'ENROLLED';

    IF v_current_count >= v_max_capacity THEN
        RAISE e_course_full;
    END IF;

    -- 3. Insert enrollment
    INSERT INTO enrollments (enrollment_id, student_id, course_id, semester, status)
    VALUES (seq_enrollment.NEXTVAL, p_student_id, p_course_id, p_semester, 'ENROLLED');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Successfully registered student ' || p_student_id || ' into ' || p_course_id);

EXCEPTION
    WHEN e_not_active THEN
        raise_application_error(-20002, 'Registration failed: Student status is ' || v_status || ' (Must be ACTIVE).');
    WHEN e_course_full THEN
        raise_application_error(-20003, 'Registration failed: Course ' || p_course_id || ' has reached maximum capacity (' || v_max_capacity || ').');
    WHEN DUP_VAL_ON_INDEX THEN
        raise_application_error(-20004, 'Registration failed: Student is already enrolled in this course for ' || p_semester);
END register_student;
/