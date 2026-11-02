SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE import_grades_bulk IS
    CURSOR c_staging IS
        SELECT stage_id, student_id, course_id, semester, marks FROM grade_staging;
    
    TYPE t_staging IS TABLE OF c_staging%ROWTYPE;
    l_stages t_staging;
    
    v_err_count NUMBER := 0;
BEGIN
    OPEN c_staging;
    LOOP
        FETCH c_staging BULK COLLECT INTO l_stages LIMIT 100;
        EXIT WHEN l_stages.COUNT = 0;

        BEGIN
            FORALL i IN 1..l_stages.COUNT SAVE EXCEPTIONS
                UPDATE enrollments
                SET marks = l_stages(i).marks,
                    grade = get_letter_grade(l_stages(i).marks),
                    status = 'COMPLETED'
                WHERE student_id = l_stages(i).student_id
                  AND course_id  = l_stages(i).course_id
                  AND semester   = l_stages(i).semester;
        EXCEPTION
            WHEN OTHERS THEN
                v_err_count := SQL%BULK_EXCEPTIONS.COUNT;
                FOR j IN 1..v_err_count LOOP
                    DBMS_OUTPUT.PUT_LINE('Bulk Import Error on index ' || 
                        SQL%BULK_EXCEPTIONS(j).error_index || 
                        ' | Oracle Error Code: ' || SQL%BULK_EXCEPTIONS(j).error_code);
                END LOOP;
        END;
    END LOOP;
    CLOSE c_staging;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Bulk grade import completed with ' || v_err_count || ' error(s).');
END import_grades_bulk;
/