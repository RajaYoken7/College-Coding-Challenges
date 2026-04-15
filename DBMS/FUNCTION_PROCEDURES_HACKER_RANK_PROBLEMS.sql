SQL> SET SERVEROUTPUT ON;



SELF - I


A) This procedure retrieves and displays technician details along with their test start time by joining the technician and test tables using a cursor.

SQL> CREATE OR REPLACE PROCEDURE display_all_technicians
  2  IS
  3      CURSOR tech_cursor IS
  4          SELECT T.technician_id,
  5                 T.qualification,
  6                 T.skills,
  7                 TS.start_time,
  8                 T.experience
  9          FROM technician T
 10          JOIN test TS
 11          ON T.technician_id = TS.technician_id;
 12
 13      v_id        technician.technician_id%TYPE;
 14      v_name      technician.qualification%TYPE;
 15      v_job       technician.skills%TYPE;
 16      v_start     test.start_time%TYPE;
 17      v_exp       technician.experience%TYPE;
 18
 19  BEGIN
 20      OPEN tech_cursor;
 21      LOOP
 22          FETCH tech_cursor INTO v_id, v_name, v_job, v_start, v_exp;
 23          EXIT WHEN tech_cursor%NOTFOUND;
 24
 25          DBMS_OUTPUT.PUT_LINE('Technician ID : ' || v_id);
 26          DBMS_OUTPUT.PUT_LINE('Qualification : ' || v_name);
 27          DBMS_OUTPUT.PUT_LINE('Skill         : ' || v_job);
 28          DBMS_OUTPUT.PUT_LINE('Test Start    : ' || v_start);
 29          DBMS_OUTPUT.PUT_LINE('Experience    : ' || v_exp);
 30          DBMS_OUTPUT.PUT_LINE('---------------------------');
 31      END LOOP;
 32
 33      CLOSE tech_cursor;
 34
 35      DBMS_OUTPUT.PUT_LINE('PL/SQL procedure successfully completed.');
 36  END display_all_technicians;
 37  /

Procedure created.

SQL> BEGIN
  2      display_all_technicians;
  3  END;
  4  /

Technician ID : T101
Qualification : DIPLOMA EEE
Skill         : OIL TESTING
Test Start    : 15-JAN-26
Experience    : 5
---------------------------
Technician ID : T102
Qualification : BE ECE
Skill         : INSPECTION
Test Start    : 16-JAN-26
Experience    : 7
---------------------------
Technician ID : T103
Qualification : ITI ELECTRICAL
Skill         : MAINTENANCE
Test Start    : 17-JAN-26
Experience    : 6
---------------------------
Technician ID : T104
Qualification : BE EEE
Skill         : TESTING
Test Start    : 18-JAN-26
Experience    : 10
---------------------------
Technician ID : T105
Qualification : DIPLOMA MECH
Skill         : FIELD WORK
Test Start    : 20-DEC-25
Experience    : 5
---------------------------
Technician ID : T106
Qualification : BSC PHYSICS
Skill         : LAB WORK
Test Start    : 21-DEC-25
Experience    : 3
---------------------------
Technician ID : T107
Qualification : BE MECH
Skill         : TECHNICAL SUPPORT
Test Start    : 10-JAN-26
Experience    : 8
---------------------------

PL/SQL procedure successfully completed.


B) This function returns a cursor displaying technician ID, job title (skills), test request priority, and test start time by joining technician, test, and test_request tables.

SQL> CREATE OR REPLACE FUNCTION get_job_titles
  2      RETURN SYS_REFCURSOR
  3  IS
  4      v_cursor SYS_REFCURSOR;
  5  BEGIN
  6      OPEN v_cursor FOR
  7          SELECT T.technician_id,
  8                 T.skills              AS job_title,
  9                 TR.priority           AS job_priority,
 10                 TS.start_time         AS test_start
 11          FROM technician T
 12          JOIN test TS
 13          ON T.technician_id = TS.technician_id
 14          JOIN test_request TR
 15          ON TS.test_request_id = TR.test_request_id
 16          ORDER BY TR.priority;
 17
 18      RETURN v_cursor;
 19  END get_job_titles;
 20  /
Function created.


TECHNICIAN_ID | JOB TITLE           | JOB PRIORITY | TEST START
--------------|---------------------|--------------|------------
T101          | OIL TESTING         | HIGH         | 15-JAN-26
T102          | INSPECTION          | MEDIUM       | 16-JAN-26
T103          | MAINTENANCE         | LOW          | 17-JAN-26
T104          | TESTING             | HIGH         | 18-JAN-26
T105          | FIELD WORK          | MEDIUM       | 20-DEC-25
T106          | LAB WORK            | LOW          | 21-DEC-25
T107          | TECHNICAL SUPPORT   | HIGH         | 10-JAN-26


SELF - II


A) This procedure displays the technician with the highest experience for each skill by using cursors to iterate through each group.

SQL> CREATE OR REPLACE PROCEDURE highest_salary_per_dept
  2  IS
  3      CURSOR dept_cursor IS
  4          SELECT DISTINCT skills FROM technician;
  5
  6      CURSOR emp_cursor (p_dept VARCHAR2) IS
  7          SELECT qualification, experience
  8          FROM technician
  9          WHERE skills = p_dept
 10          AND experience = (
 11              SELECT MAX(experience)
 12              FROM technician
 13              WHERE skills = p_dept
 14          );
 15
 16      v_dept    technician.skills%TYPE;
 17      v_name    technician.qualification%TYPE;
 18      v_salary  technician.experience%TYPE;
 19
 20  BEGIN
 21      OPEN dept_cursor;
 22      LOOP
 23          FETCH dept_cursor INTO v_dept;
 24          EXIT WHEN dept_cursor%NOTFOUND;
 25
 26          DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept);
 27
 28          OPEN emp_cursor(v_dept);
 29          LOOP
 30              FETCH emp_cursor INTO v_name, v_salary;
 31              EXIT WHEN emp_cursor%NOTFOUND;
 32
 33              DBMS_OUTPUT.PUT_LINE('  Highest Experience Technician : ' || v_name);
 34              DBMS_OUTPUT.PUT_LINE('  Experience                    : ' || v_salary);
 35          END LOOP;
 36          CLOSE emp_cursor;
 37
 38          DBMS_OUTPUT.PUT_LINE('----------------------');
 39      END LOOP;
 40      CLOSE dept_cursor;
 41  END highest_salary_per_dept;
 42  /

Procedure created.

SQL> BEGIN
  2      highest_salary_per_dept;
  3  END;
  4  /Department: FIELD WORK

Department: OIL TESTING
  Highest Experience Technician : DIPLOMA EEE
  Experience                    : 5
----------------------
Department: INSPECTION
  Highest Experience Technician : BE ECE
  Experience                    : 7
----------------------
Department: MAINTENANCE
  Highest Experience Technician : ITI ELECTRICAL
  Experience                    : 6
----------------------
Department: TESTING
  Highest Experience Technician : BE EEE
  Experience                    : 10
----------------------
Department: FIELD WORK
  Highest Experience Technician : DIPLOMA MECH
  Experience                    : 5
----------------------
Department: LAB WORK
  Highest Experience Technician : BSC PHYSICS
  Experience                    : 3
----------------------
Department: TECHNICAL SUPPORT
  Highest Experience Technician : BE MECH
  Experience                    : 8
----------------------

PL/SQL procedure successfully completed.


B)This function returns a cursor displaying each transformer and the average sample quantity collected from it.

SQL> CREATE OR REPLACE FUNCTION get_avg_sample_per_transformer
  2      RETURN SYS_REFCURSOR
  3  IS
  4      v_cursor SYS_REFCURSOR;
  5  BEGIN
  6      OPEN v_cursor FOR
  7          SELECT S.transformer_id,
  8                 ROUND(AVG(S.quantity), 2) AS avg_quantity
  9          FROM sample S
 10          GROUP BY S.transformer_id
 11          ORDER BY S.transformer_id;
 12
 13      RETURN v_cursor;
 14  END get_avg_sample_per_transformer;
 15  /

Function created.

SQL> DECLARE
  2      v_cursor SYS_REFCURSOR;
  3      v_trans  sample.transformer_id%TYPE;
  4      v_avg    NUMBER;
  5  BEGIN
  6      DBMS_OUTPUT.PUT_LINE('Transformer ID        | Avg Sample Quantity');
  7      DBMS_OUTPUT.PUT_LINE('--------------------- | -------------------');
  8
  9      v_cursor := get_avg_sample_per_transformer;
 10
 11      LOOP
 12          FETCH v_cursor INTO v_trans, v_avg;
 13          EXIT WHEN v_cursor%NOTFOUND;
 14
 15          DBMS_OUTPUT.PUT_LINE(RPAD(v_trans, 22) || '| ' || v_avg);
 16      END LOOP;
 17
 18      CLOSE v_cursor;
 19  END;
 20  /


Transformer ID        | Avg Sample Quantity
--------------------- | -------------------
TR001                 | 12
TR002                 | 18
TR003                 | 10
TR004                 | 15
TR005                 | 20
PL/SQL procedure successfully completed.



SELF - III
	

A) Write a PL/SQL procedure to return the department name with the maximum number of employees.

SQL> CREATE OR REPLACE PROCEDURE get_max_employee_dept
  2  IS
  3      v_dept      technician.skills%TYPE;
  4      v_count     NUMBER;
  5  BEGIN
  6      SELECT skills, COUNT(technician_id)
  7      INTO v_dept, v_count
  8      FROM technician
  9      GROUP BY skills
 10      HAVING COUNT(technician_id) = (
 11          SELECT MAX(cnt)
 12          FROM (
 13              SELECT COUNT(technician_id) AS cnt
 14              FROM technician
 15              GROUP BY skills
 16          )
 17      );
 18
 19      DBMS_OUTPUT.PUT_LINE('Department (Skill) with Most Employees : ' || v_dept);
 20      DBMS_OUTPUT.PUT_LINE('Number of Employees                    : ' || v_count);
 21
 22  EXCEPTION
 23      WHEN NO_DATA_FOUND THEN
 24          DBMS_OUTPUT.PUT_LINE('No data found.');
 25      WHEN OTHERS THEN
 26          DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
 27  END get_max_employee_dept;
 28  /

Procedure created.

SQL> BEGIN
  2      get_max_employee_dept;
  3  END;
  4  /

Department (Skill) with Most Employees : FIELD WORK
Number of Employees                    : 2

PL/SQL procedure successfully completed.


B) This function returns technicians whose experience is below the average experience of a selected skill group (based on a specific technician).

SQL> CREATE OR REPLACE FUNCTION get_below_avg_exp_raja
  2      RETURN SYS_REFCURSOR
  3  IS
  4      v_cursor     SYS_REFCURSOR;
  5      v_skill      technician.skills%TYPE;
  6      v_avg_exp    NUMBER;
  7  BEGIN
  8      -- Get one reference skill (example: first technician with 'EEE')
  9      SELECT skills
 10      INTO v_skill
 11      FROM technician
 12      WHERE UPPER(qualification) LIKE '%EEE%'
 13      AND ROWNUM = 1;
 14
 15      -- Calculate average experience for that skill
 16      SELECT ROUND(AVG(experience), 2)
 17      INTO v_avg_exp
 18      FROM technician
 19      WHERE skills = v_skill;
 20
 21      -- Return technicians below that average
 22      OPEN v_cursor FOR
 23          SELECT technician_id,
 24                 qualification AS name,
 25                 skills        AS job_title,
 26                 experience    AS salary
 27          FROM technician
 28          WHERE experience < v_avg_exp;
 29
 30      RETURN v_cursor;
 31
 32  EXCEPTION
 33      WHEN NO_DATA_FOUND THEN
 34          RETURN NULL;
 35      WHEN OTHERS THEN
 36          RETURN NULL;
 37  END get_below_avg_exp_raja;
 38  /

Function created.

SQL> DECLARE
  2      v_cursor SYS_REFCURSOR;
  3      v_id     technician.technician_id%TYPE;
  4      v_name   technician.qualification%TYPE;
  5      v_job    technician.skills%TYPE;
  6      v_exp    technician.experience%TYPE;
  7  BEGIN
  8      DBMS_OUTPUT.PUT_LINE('Technicians with experience below selected skill average:');
  9      DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
 10
 11      v_cursor := get_below_avg_exp_raja;
 12
 13      IF v_cursor IS NULL THEN
 14          DBMS_OUTPUT.PUT_LINE('No data returned.');
 15          RETURN;
 16      END IF;
 17
 18      LOOP
 19          FETCH v_cursor INTO v_id, v_name, v_job, v_exp;
 20          EXIT WHEN v_cursor%NOTFOUND;
 21
 22          DBMS_OUTPUT.PUT_LINE('Technician ID : ' || v_id);
 23          DBMS_OUTPUT.PUT_LINE('Qualification : ' || v_name);
 24          DBMS_OUTPUT.PUT_LINE('Skill         : ' || v_job);
 25          DBMS_OUTPUT.PUT_LINE('Experience    : ' || v_exp);
 26          DBMS_OUTPUT.PUT_LINE('----------------------');
 27      END LOOP;
 28
 29      CLOSE v_cursor;
 30  END;
 31  /

Technicians with experience below selected skill average:
--------------------------------------------------------
Technician ID : T101
Qualification : DIPLOMA EEE
Skill         : OIL TESTING
Experience    : 5
----------------------
Technician ID : T106
Qualification : BSC PHYSICS
Skill         : LAB WORK
Experience    : 3
----------------------
Technician ID : T105
Qualification : DIPLOMA MECH
Skill         : FIELD WORK
Experience    : 5
----------------------
PL/SQL procedure successfully completed.

i want to run all these commands without error with same output give create and insert query to do it in sql plus single copy paste command
