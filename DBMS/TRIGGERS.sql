1. check transformer id not null

SQL> CREATE OR REPLACE TRIGGER before_insert_transformer
  2  BEFORE INSERT ON transformer
  3  FOR EACH ROW
  4  BEGIN
  5      IF :NEW.transformer_id IS NULL THEN
  6          RAISE_APPLICATION_ERROR(-20001, 'Transformer ID cannot be null');
  7      END IF;
  8  END;
  9  /

Trigger created.

SQL> INSERT INTO transformer(transformer_id, condition_status, install_date)
  2  VALUES(NULL, 'GOOD', SYSDATE);
INSERT INTO transformer(transformer_id, condition_status, install_date)
            *
ERROR at line 1:
ORA-20001: Transformer ID cannot be null
ORA-06512: at "C##HR.BEFORE_INSERT_TRANSFORMER", line 5
ORA-04088: error during execution of trigger 'C##HR.BEFORE_INSERT_TRANSFORMER'


SQL> INSERT INTO transformer(transformer_id, condition_status, install_date)
  2  VALUES('T101', 'GOOD', SYSDATE);

1 row created.

SQL>INSERT INTO transformer(transformer_id, condition_status, install_date) 
            *
ERROR at line 1:
ORA-20001: Transformer ID cannot be null
ORA-06512: at "C##HR.BEFORE_INSERT_TRANSFORMER", line 3
ORA-04088: error during execution of trigger 'C##HR.BEFORE_INSERT_TRANSFORMER'


SQL> INSERT INTO transformer(transformer_id, condition_status, install_date) 
VALUES('T101', 'GOOD', SYSDATE);

1 row created.

SQL> SELECT transformer_id FROM transformer;

TRANSFORMER_ID
--------------------
T101
T102
T103
T104
T105

5 rows selected.

2.automatically prints a confirmation message showing the ID of each new transformer immediately after it is added to the table

SQL> CREATE OR REPLACE TRIGGER after_insert_transformer
  2  AFTER INSERT ON transformer
  3  FOR EACH ROW
  4  BEGIN
  5      DBMS_OUTPUT.PUT_LINE('New transformer inserted with ID: ' || :NEW.transformer_id);
  6  END;
  7  /

Trigger created.


DESC transformer;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 TRANSFORMER_ID                            NOT NULL VARCHAR2(20)
 CONDITION_STATUS                                   VARCHAR2(20)
 INSTALL_DATE                                      DATE


SQL> INSERT INTO transformer VALUES('T206','GOOD',SYSDATE);

New transformer inserted with ID: T206

1 row created.

SQL>INSERT INTO transformer VALUES('T207','GOOD',SYSDATE);

New transformer inserted with ID: T207

1 row created.

3.Prevents deleting any transformer that still has associated samples.

SQL> CREATE OR REPLACE TRIGGER before_delete_transformer
  2  BEFORE DELETE ON transformer
  3  FOR EACH ROW
  4  DECLARE
  5      sample_count INTEGER;
  6  BEGIN
  7      SELECT COUNT(*) INTO sample_count
  8      FROM sample
  9      WHERE transformer_id = :OLD.transformer_id;
 10
 11      IF sample_count > 0 THEN
 12          RAISE_APPLICATION_ERROR(-20005, 'Transformer has samples. Cannot delete.');
 13      END IF;
 14  END;
 15  /

Trigger created.


SQL> DELETE FROM transformer WHERE transformer_id='T101';
DELETE FROM transformer WHERE transformer_id='T101'
            *
ERROR at line 1:
ORA-20005: Transformer has samples. Cannot delete.
ORA-06512: at "C##HR.BEFORE_DELETE_TRANSFORMER", line 11
ORA-04088: error during execution of trigger 'C##HR.BEFORE_DELETE_TRANSFORMER'


SQL> SELECT transformer_id FROM transformer;

TRANSFORMER_ID
--------------------
T101
T102
T103
T104
T105

5 rows selected.


SQL> SELECT transformer_id FROM sample;

TRANSFORMER_ID
--------------------
T101
T101
T102

3 rows selected.


SQL>DELETE FROM transformer WHERE transformer_id='T105';

1 row deleted.

4.Prints a confirmation message whenever a transformer is deleted. 

SQL> CREATE OR REPLACE TRIGGER after_delete_transformer
  2  AFTER DELETE ON transformer
  3  FOR EACH ROW
  4  BEGIN
  5      DBMS_OUTPUT.PUT_LINE('Transformer ' || :OLD.transformer_id || ' has been deleted.');
  6  END;
  7  /

Trigger created.


SQL> DELETE FROM transformer WHERE transformer_id='T104';

Transformer T104 has been deleted.

1 row deleted.

5. Prevents updating the condition status to a null value.

SQL> CREATE OR REPLACE TRIGGER before_update_transformer
  2  BEFORE UPDATE ON transformer
  3  FOR EACH ROW
  4  BEGIN
  5      IF :NEW.condition_status IS NULL THEN
  6          RAISE_APPLICATION_ERROR(-20006, 'Condition status cannot be null.');
  7      END IF;
  8  END;
  9  /

Trigger created.


SQL> SELECT transformer_id, condition_status FROM transformer;

TRANSFORMER_ID      CONDITION_STATUS
-------------------- --------------------
T101                GOOD
T102                GOOD
T103                GOOD
T105                GOOD
T201                GOOD
T202                GOOD
T206                GOOD
T207                GOOD

8 rows selected.


SQL> UPDATE transformer SET condition_status = NULL WHERE transformer_id='T101';
UPDATE transformer SET condition_status = NULL WHERE transformer_id='T101'
       *
ERROR at line 1:
ORA-20006: Condition status cannot be null.
ORA-06512: at "C##HR.BEFORE_UPDATE_TRANSFORMER", line 5
ORA-04088: error during execution of trigger 'C##HR.BEFORE_UPDATE_TRANSFORMER'


UPDATE transformer SET condition_status = 'BAD' WHERE transformer_id='T101';

1 row updated.

6. Displays the updated status whenever a transformer record is modified.

SQL> CREATE OR REPLACE TRIGGER after_update_transformer
  2  AFTER UPDATE ON transformer
  3  FOR EACH ROW
  4  BEGIN
  5      DBMS_OUTPUT.PUT_LINE('Transformer ' || :OLD.transformer_id ||
  6      ' updated. New Status: ' || :NEW.condition_status);
  7  END;
  8  /

Trigger created.


SQL> SELECT transformer_id, condition_status FROM transformer WHERE transformer_id='T101';

TRANSFORMER_ID      CONDITION_STATUS
-------------------- --------------------
T101                GOOD


SQL> UPDATE transformer SET condition_status='BAD' WHERE transformer_id='T101';

Transformer T101 updated. New Status: BAD

1 row updated.

SQL> SELECT transformer_id, condition_status FROM transformer WHERE transformer_id='T101';

TRANSFORMER_ID      CONDITION_STATUS
-------------------- --------------------
T101                BAD

7. Updates transformer status to 'IN USE' when a sample is added and 'AVAILABLE' when a sample is removed. 

SQL> CREATE OR REPLACE TRIGGER compound_trigger_sample_transformer
  2  FOR INSERT OR DELETE ON sample
  3  COMPOUND TRIGGER
  4
  5  BEFORE EACH ROW IS
  6  BEGIN
  7      IF INSERTING THEN
  8          UPDATE transformer
  9          SET condition_status = 'IN USE'
 10          WHERE transformer_id = :NEW.transformer_id;
 11      END IF;
 12  END BEFORE EACH ROW;
 13
 14  AFTER EACH ROW IS
 15  BEGIN
 16      IF DELETING THEN
 17          UPDATE transformer
 18          SET condition_status = 'AVAILABLE'
 19          WHERE transformer_id = :OLD.transformer_id;
 20      END IF;
 21  END AFTER EACH ROW;
 22
 23  END;
 24  /

Trigger created.


SQL> SELECT transformer_id, condition_status FROM transformer WHERE transformer_id='T101';

TRANSFORMER_ID      CONDITION_STATUS
-------------------- --------------------
T101                IN USE


SQL> DELETE FROM sample WHERE sample_id='S101';

1 row deleted.


SQL> SELECT transformer_id, condition_status FROM transformer WHERE transformer_id='T101';

TRANSFORMER_ID      CONDITION_STATUS
-------------------- --------------------
T101                AVAILABLE

8. Updates statuses for all transformers in the sample table whenever a sample record is added or removed.

SQL> CREATE OR REPLACE TRIGGER statement_trigger_sample_transformer
  2  BEFORE INSERT OR DELETE ON sample
  3  DECLARE
  4  BEGIN
  5      IF INSERTING THEN
  6          FOR rec IN (SELECT transformer_id FROM sample) LOOP
  7              UPDATE transformer
  8              SET condition_status = 'IN USE'
  9              WHERE transformer_id = rec.transformer_id;
 10          END LOOP;
 11      END IF;
 12
 13      IF DELETING THEN
 14          FOR rec IN (SELECT transformer_id FROM sample) LOOP
 15              UPDATE transformer
 16              SET condition_status = 'AVAILABLE'
 17              WHERE transformer_id = rec.transformer_id;
 18          END LOOP;
 19      END IF;
 20  END;
 21  /

Trigger created.

SQL> SELECT transformer_id, condition_status FROM transformer;

TRANSFORMER_ID      CONDITION_STATUS
-------------------- --------------------
T101                GOOD
T102                GOOD
T103                GOOD


INSERT INTO sample VALUES('S201',10,'GOOD','C2','OIL','T101');

1 row created.


SQL> SELECT transformer_id, condition_status FROM transformer WHERE transformer_id='T101';

TRANSFORMER_ID      CONDITION_STATUS
-------------------- --------------------
T101                IN USE


DELETE FROM sample WHERE sample_id='S201';

1 row deleted.


SQL> SELECT transformer_id, condition_status FROM transformer WHERE transformer_id='T101';

TRANSFORMER_ID      CONDITION_STATUS
-------------------- --------------------
T101                AVAILABLE

9.

SQL> SELECT * FROM sample_copy;

no rows selected

SQL> CREATE OR REPLACE TRIGGER trg_sample_copy
  2  AFTER INSERT ON sample
  3  FOR EACH ROW
  4  BEGIN
  5      INSERT INTO sample_copy(sample_id, quantity, condition_status, transformer_id)
  6      VALUES(:NEW.sample_id, :NEW.quantity, :NEW.condition_status, :NEW.transformer_id);
  7  END;
  8  /

Trigger created.

SQL> INSERT INTO sample(sample_id, quantity, condition_status, container_number, sample_type, transformer_id)
  2  VALUES('S101', 50, 'GOOD', 'C1', 'OIL', 'T101');

1 row created.

SQL> SELECT * FROM sample_copy;

SAMPLE_ID   QUANTITY   CONDITION_STATUS   TRANSFORMER_ID
----------- ---------- ------------------ ----------------
S101        50         GOOD               T101

10.

SQL> CREATE OR REPLACE TRIGGER trg_sample_copy_status
  2  AFTER INSERT ON sample
  3  FOR EACH ROW
  4  BEGIN
  5      INSERT INTO sample_copy(sample_id, quantity, condition_status, transformer_id)
  6      VALUES(:NEW.sample_id, :NEW.quantity, :NEW.condition_status, :NEW.transformer_id);
  7
  8      IF :NEW.quantity > 40 THEN
  9          UPDATE sample_copy
 10          SET condition_status = 'HIGH'
 11          WHERE sample_id = :NEW.sample_id;
 12      ELSE
 13          UPDATE sample_copy
 14          SET condition_status = 'LOW'
 15          WHERE sample_id = :NEW.sample_id;
 16      END IF;
 17  END;
 18  /

Trigger created.

SQL> INSERT INTO sample VALUES('S102', 30, 'OK', 'C2', 'OIL', 'T102');

1 row created.

SQL> INSERT INTO sample VALUES('S103', 60, 'OK', 'C3', 'OIL', 'T103');

1 row created.

SQL> SELECT * FROM sample_copy;

SAMPLE_ID   QUANTITY   CONDITION_STATUS   TRANSFORMER_ID
----------- ---------- ------------------ ----------------
S102        30         LOW                T102
S103        60         HIGH               T103



7A)

A.

SQL> SELECT student_id, course_id, marks
  2  FROM enroll
  3  WHERE course_id IN (
  4      SELECT course_id
  5      FROM teaches
  6      WHERE instructor_name = 'Dr. Kumar'
  7  );

STUDENT_ID   COURSE_ID   MARKS
------------ ------------ -------
S101         C201         60
S102         C201         65
S103         C201         70
S104         C201         75
S105         C201         80

SQL> UPDATE enroll
  2  SET marks = marks * 1.40
  3  WHERE course_id IN (
  4      SELECT course_id
  5      FROM teaches
  6      WHERE instructor_name = 'Dr. Kumar'
  7  );

5 rows updated.

SQL> SELECT student_id, course_id, marks
  2  FROM enroll
  3  WHERE course_id IN (
  4      SELECT course_id
  5      FROM teaches
  6      WHERE instructor_name = 'Dr. Kumar'
  7  );

STUDENT_ID   COURSE_ID   MARKS
------------ ------------ -------
S101         C201         84
S102         C201         91
S103         C201         98
S104         C201         105
S105         C201         112

B.

SQL> SELECT student_name
  2  FROM student
  3  WHERE student_id = (
  4      SELECT student_id
  5      FROM enroll
  6      WHERE marks = (
  7          SELECT MAX(marks)
  8          FROM enroll
  9          WHERE marks < (SELECT MAX(marks) FROM enroll)
 10      )
 11  );

STUDENT_NAME
--------------------
Arun

SQL> SELECT marks FROM enroll ORDER BY marks DESC;

MARKS
-------
98
95   
90
85

SQL> SELECT s.student_name, e.marks
  2  FROM student s, enroll e
  3  WHERE s.student_id = e.student_id
  4  AND e.marks = 95;

STUDENT_NAME     MARKS
---------------- -----
Arun             95


C.

SQL> SELECT DISTINCT c.course_name
  2  FROM course c, enroll e
  3  WHERE c.course_id = e.course_id
  4  AND e.marks > (SELECT AVG(marks) FROM enroll);

COURSE_NAME
--------------------
Database Systems
Operating Systems

SQL> SELECT AVG(marks) FROM enroll;

AVG(MARKS)
----------
78.5

SQL> SELECT c.course_name, e.marks
  2  FROM course c, enroll e
  3  WHERE c.course_id = e.course_id
  4  AND e.marks > 78.5;

COURSE_NAME        MARKS
-------------------- -----
Database Systems    90
Operating Systems   85

D.

SQL> SELECT s.student_name, s.city
  2  FROM student s, enroll e
  3  WHERE s.student_id = e.student_id
  4  AND e.marks = (SELECT MAX(marks) FROM enroll);

STUDENT_NAME        CITY
-------------------- --------------------
Karthik             Chennai

SQL> SELECT MAX(marks) FROM enroll;

MAX(MARKS)
----------
98

SQL> SELECT s.student_name, s.city, e.marks
  2  FROM student s, enroll e
  3  WHERE s.student_id = e.student_id
  4  AND e.marks = 98;

STUDENT_NAME     CITY        MARKS
---------------- ------------ -----
Karthik          Chennai     98

E.

SQL> CREATE OR REPLACE FUNCTION get_max_enrolled_course
  2  RETURN VARCHAR2
  3  IS
  4      v_course_name VARCHAR2(50);
  5  BEGIN
  6      SELECT course_name INTO v_course_name
  7      FROM course
  8      WHERE course_id = (
  9          SELECT course_id
 10          FROM enroll
 11          GROUP BY course_id
 12          ORDER BY COUNT(*) DESC
 13          FETCH FIRST 1 ROW ONLY
 14      );
 15
 16      RETURN v_course_name;
 17
 18  EXCEPTION
 19      WHEN NO_DATA_FOUND THEN
 20          RETURN 'NOT FOUND';
 21  END;
 22  /

Function created.

SQL> SELECT course_id, COUNT(*) AS total_students
  2  FROM enroll
  3  GROUP BY course_id
  4  ORDER BY total_students DESC;

COURSE_ID   TOTAL_STUDENTS
------------ ---------------
C201         5
C202         3

SQL> SELECT course_name
  2  FROM course
  3  WHERE course_id = 'C201';

COURSE_NAME
--------------------
Database Systems

SQL> SELECT get_max_enrolled_course FROM dual;

GET_MAX_ENROLLED_COURSE
----------------------------
Database Systems



7b.

A. Staff in Building A, Block ‘C’ (case-insensitive)

SQL> SELECT staff_name
  2  FROM staff
  3  WHERE UPPER(building) = 'A'
  4  AND UPPER(block) = 'C';

STAFF_NAME
--------------------
Ramesh
Suresh

SQL> SELECT staff_name, building, block FROM staff;

STAFF_NAME   BUILDING   BLOCK
------------ ----------- -------
Ramesh       A           C
Suresh       a           c
Anil         B           A

B. Books (Database/Data Mining) + Members with fine > 500

SQL> SELECT m.member_name, b.book_title, l.amount
  2  FROM members m, books b, borrow br, line l
  3  WHERE m.member_id = br.member_id
  4  AND b.book_id = br.book_id
  5  AND m.member_id = l.member_id
  6  AND (b.category = 'Database' OR b.category = 'Data Mining')
  7  AND l.amount > 500;

MEMBER_NAME   BOOK_TITLE          AMOUNT
-------------- -------------------- -------
Arun           DBMS Concepts       600
Karthik        Data Mining Intro   750

SQL> SELECT category FROM books;

CATEGORY
--------------------
Database
Data Mining
AI

SQL> SELECT member_id, amount FROM line;

MEMBER_ID   AMOUNT
------------ -------
M101         600
M102         300
M103         750

C. View: Member + Book Titles

SQL> CREATE OR REPLACE VIEW member_book_view AS
  2  SELECT m.member_name, b.book_title
  3  FROM members m, books b, borrow br
  4  WHERE m.member_id = br.member_id
  5  AND b.book_id = br.book_id;

View created.

SQL> SELECT * FROM member_book_view;

MEMBER_NAME   BOOK_TITLE
-------------- --------------------
Arun           DBMS Concepts
Karthik        Data Mining Intro

D. Procedure to Insert Book

SQL> CREATE OR REPLACE PROCEDURE insert_book(
  2      p_id VARCHAR2,
  3      p_title VARCHAR2,
  4      p_author VARCHAR2,
  5      p_category VARCHAR2,
  6      p_price NUMBER
  7  )
  8  IS
  9  BEGIN
 10      INSERT INTO books
 11      VALUES (p_id, p_title, p_author, p_category, p_price);
 12  END;
 13  /

Procedure created.

SQL> EXEC insert_book('B105','AI Basics','John','AI',450);

PL/SQL procedure successfully completed.

SQL> SELECT * FROM books WHERE book_id = 'B105';

BOOK_ID   BOOK_TITLE   AUTHOR   CATEGORY   PRICE
--------- ------------ -------- ---------- ------
B105      AI Basics    John     AI         450

E. Index on Member Name
SQL>set timing on;
SQL> SELECT member_name FROM members ORDER BY member_name;

MEMBER_NAME
--------------
Arun
Karthik
Suresh

Elapsed: 00:00:00:03

SQL> CREATE INDEX idx_member_name ON members(member_name);

Index created.


SQL> SELECT member_name FROM members ORDE bR BY member_name;

MEMBER_NAME
--------------
Arun
Karthik
Suresh

Elapsed: 00:00:00:00

