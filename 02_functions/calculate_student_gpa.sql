SET SERVEROUTPUT ON CREATE OR REPLACE FUNCTION calculate_student_gpa (
    p_student_id IN NUMBER,
    p_semester   IN VARCHAR2
) RETURN NUMBER IS
    v_total_points NUMBER(5,2) := 0;
    v_total_credits NUMBER(3) := 0;
    v_gpa          NUMBER(3,2) := 0.00;
BEGIN
    FOR r IN (
        SELECT e.marks, c.credits 
        FROM enrollments e
        JOIN courses c ON e.course_id = c.course_id
        WHERE e.student_id = p_student_id
          AND e.semester = p_semester
          AND e.status = 'COMPLETED'
          AND e.marks IS NOT NULL
    ) LOOP
        -- Grade point conversion (A=4.0, B=3.0, C=2.0, D=1.0, F=0.0)
        DECLARE
            v_gp NUMBER(2,1);
        BEGIN
            IF r.marks >= 80 THEN v_gp := 4.0;
            ELSIF r.marks >= 70 THEN v_gp := 3.0;
            ELSIF r.marks >= 60 THEN v_gp := 2.0;
            ELSIF r.marks >= 50 THEN v_gp := 1.0;
            ELSE v_gp := 0.0;
            END IF;

            v_total_points  := v_total_points + (v_gp * r.credits);
            v_total_credits := v_total_credits + r.credits;
        END;
    END LOOP;

    IF v_total_credits > 0 THEN
        v_gpa := v_total_points / v_total_credits;
    END IF;

    RETURN ROUND(v_gpa, 2);
END calculate_student_gpa;
/