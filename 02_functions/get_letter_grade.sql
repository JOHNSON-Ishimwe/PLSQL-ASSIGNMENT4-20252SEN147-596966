SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION get_letter_grade (
    p_marks IN NUMBER
) RETURN VARCHAR2 IS
BEGIN
    IF p_marks IS NULL THEN
        RETURN NULL;
    ELSIF p_marks >= 80 THEN
        RETURN 'A';
    ELSIF p_marks >= 70 THEN
        RETURN 'B';
    ELSIF p_marks >= 60 THEN
        RETURN 'C';
    ELSIF p_marks >= 50 THEN
        RETURN 'D';
    ELSE
        RETURN 'F';
    END IF;
END get_letter_grade;
/