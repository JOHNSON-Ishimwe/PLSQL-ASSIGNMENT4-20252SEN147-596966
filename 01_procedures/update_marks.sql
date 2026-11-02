SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE update_marks (
    p_enrollment_id IN NUMBER,
    p_new_marks     IN NUMBER
) IS
    v_old_marks  enrollments.marks%TYPE;
    v_grade      VARCHAR2(2);
BEGIN
    IF p_new_marks < 0 OR p_new_marks > 100 THEN
        raise_application_error(-20005, 'Marks must be between 0 and 100.');
    END IF;

    -- Get existingarks
    SELECT marks INTO v_old_marks
    FROM enrollments
    WHERE enrollment_id = p_enrollment_id;

    -- Calculategrade using function
    v_grade := get_letter_grade(p_new_marks);

    -- Updateenrollment
    UPDATE enrollments
    SET marks = p_new_marks,
        grade = v_grade,
        status = 'COMPLETED'
    WHERE enrollment_id = p_enrollment_id;

    -- LOG TOaudit table
    INSERT INTO grade_audit (audit_id, enrollment_id, old_marks, new_marks, changed_on)
    VALUES (seq_audit.NEXTVAL, p_enrollment_id, v_old_marks, p_new_marks, SYSDATE);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Marks updated successfully for enrollment ' || p_enrollment_id || '. Grade assigned: ' || v_grade);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error(-20006, 'Enrollment ID ' || p_enrollment_id || ' not found.');
END update_marks;
/