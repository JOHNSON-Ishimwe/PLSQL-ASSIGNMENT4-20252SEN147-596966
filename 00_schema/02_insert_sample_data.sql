INSERT INTO departments VALUES (10, 'Information Technology');
INSERT INTO departments VALUES (20, 'Business Administration');
INSERT INTO departments VALUES (30, 'Education');

INSERT INTO students VALUES (1001,'Aline','Uwase','aline.uwase@auca.ac.rw',10,'ACTIVE',DATE '2024-09-01');
INSERT INTO students VALUES (1002,'Jean','Mugisha','jean.mugisha@auca.ac.rw',10,'ACTIVE',DATE '2024-09-01');
INSERT INTO students VALUES (1003,'Grace','Ineza','grace.ineza@auca.ac.rw',10,'ACTIVE',DATE '2025-01-15');
INSERT INTO students VALUES (1004,'Eric','Habimana','eric.habimana@auca.ac.rw',20,'ACTIVE',DATE '2024-09-01');
INSERT INTO students VALUES (1005,'Diane','Mukamana','diane.mukamana@auca.ac.rw',20,'ACTIVE',DATE '2025-01-15');
INSERT INTO students VALUES (1006,'Patrick','Niyonzima','patrick.niyonzima@auca.ac.rw',20,'SUSPENDED',DATE '2023-09-01');
INSERT INTO students VALUES (1007,'Sandrine','Uwimana','sandrine.uwimana@auca.ac.rw',30,'ACTIVE',DATE '2025-09-01');
INSERT INTO students VALUES (1008,'David','Nkurunziza','david.nkurunziza@auca.ac.rw',30,'ACTIVE',DATE '2025-09-01');
INSERT INTO students VALUES (1009,'Claire','Ishimwe','claire.ishimwe@auca.ac.rw',10,'GRADUATED',DATE '2022-09-01');
INSERT INTO students VALUES (1010,'Olivier','Bizimana','olivier.bizimana@auca.ac.rw',10,'ACTIVE',DATE '2025-09-01');


INSERT INTO courses VALUES ('INSY8311','Database Development with PL/SQL',3,10,3);
INSERT INTO courses VALUES ('INSY8212','Web Technologies',3,10,40);
INSERT INTO courses VALUES ('INSY8101','Intro to Programming',4,10,40);
INSERT INTO courses VALUES ('BUS7101','Principles of Management',3,20,50);
INSERT INTO courses VALUES ('BUS7205','Financial Accounting',3,20,50);
INSERT INTO courses VALUES ('EDU6101','Educational Psychology',2,30,35);


INSERT INTO enrollments VALUES (seq_enrollment.NEXTVAL,1001,'INSY8101','2026-SPRING',88.5,'A','COMPLETED');
INSERT INTO enrollments VALUES (seq_enrollment.NEXTVAL,1002,'INSY8101','2026-SPRING',72.0,'B','COMPLETED');
INSERT INTO enrollments VALUES (seq_enrollment.NEXTVAL,1003,'INSY8101','2026-SPRING',55.0,'D','COMPLETED');
INSERT INTO enrollments VALUES (seq_enrollment.NEXTVAL,1004,'BUS7101' ,'2026-SPRING',64.0,'C','COMPLETED');
INSERT INTO enrollments VALUES (seq_enrollment.NEXTVAL,1005,'BUS7101' ,'2026-SPRING',45.0,'F','COMPLETED');
INSERT INTO enrollments VALUES (seq_enrollment.NEXTVAL,1007,'EDU6101' ,'2026-SPRING',91.0,'A','COMPLETED');
INSERT INTO enrollments VALUES (seq_enrollment.NEXTVAL,1008,'EDU6101' ,'2026-SPRING',79.5,'B','COMPLETED');


INSERT INTO enrollments (enrollment_id,student_id,course_id,semester) VALUES (seq_enrollment.NEXTVAL,1001,'INSY8311','2026-FALL');
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester) VALUES (seq_enrollment.NEXTVAL,1002,'INSY8311','2026-FALL');
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester) VALUES (seq_enrollment.NEXTVAL,1003,'INSY8311','2026-FALL');  -- INSY8311 now FULL (3/3)
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester) VALUES (seq_enrollment.NEXTVAL,1001,'INSY8212','2026-FALL');
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester) VALUES (seq_enrollment.NEXTVAL,1002,'INSY8212','2026-FALL');
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester) VALUES (seq_enrollment.NEXTVAL,1004,'BUS7205' ,'2026-FALL');
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester) VALUES (seq_enrollment.NEXTVAL,1005,'BUS7205' ,'2026-FALL');
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester) VALUES (seq_enrollment.NEXTVAL,1010,'INSY8212','2026-FALL');


INSERT INTO grade_staging VALUES (seq_staging.NEXTVAL,1001,'INSY8311','2026-FALL',85);
INSERT INTO grade_staging VALUES (seq_staging.NEXTVAL,1002,'INSY8311','2026-FALL',67.5);
INSERT INTO grade_staging VALUES (seq_staging.NEXTVAL,1003,'INSY8311','2026-FALL',150);
INSERT INTO grade_staging VALUES (seq_staging.NEXTVAL,1001,'INSY8212','2026-FALL',92);
INSERT INTO grade_staging VALUES (seq_staging.NEXTVAL,1002,'INSY8212','2026-FALL',58);
INSERT INTO grade_staging VALUES (seq_staging.NEXTVAL,9999,'INSY8212','2026-FALL',70);

COMMIT;