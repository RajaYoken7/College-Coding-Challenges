SNO 1. Create a view to display test ID, technician ID and test request ID.

SQL> CREATE VIEW test_basic_info AS
  2  SELECT test_id, technician_id, test_request_id
  3  FROM test;

View created.

SQL> SELECT * FROM TEST_BASIC_INFO;

TEST_ID    TECHNICIAN_ID    TEST_REQUEST_ID
---------- --------------- ---------------
T001       TECH01          TR001
T002       TECH02          TR002
T003       TECH01          TR003
T004       TECH03          TR001
T005       TECH02          TR004
T006       TECH04          TR005

6 rows selected.

SNO 2. Create a view to display tests handled by a specific technician (e.g., technician_id = 'TECH01').

SQL> CREATE VIEW test_tech01 AS
  2  SELECT test_id, technician_id, test_request_id
  3  FROM test
  4  WHERE technician_id = 'TECH01';

View created.

SQL> SELECT * FROM TEST_TECH01;

TEST_ID    TECHNICIAN_ID    TEST_REQUEST_ID
---------- --------------- ---------------
T001       TECH01          TR001
T003       TECH01          TR003
T007       TECH01          TR006
T009       TECH01          TR008
T012       TECH01          TR010
T015       TECH01          TR012

6 rows selected.

SNO 3. Create a view to show which technician handled which test request.

SQL> CREATE VIEW technician_test_details AS
  2  SELECT t.technician_id,
  3         tr.test_request_id,
  4         tr.request_status
  5  FROM test t
  6  JOIN test_request tr
  7  ON t.test_request_id = tr.test_request_id;

View created.

SQL> SELECT * FROM TECHNICIAN_TEST_DETAILS;

TECHNICIAN_ID  TEST_REQUEST_ID  REQUEST_STATUS
-------------- ----------------  ----------------
TECH01         TR001             APPROVED
TECH02         TR002             PENDING
TECH01         TR003             COMPLETED
TECH03         TR004             APPROVED
TECH02         TR005             REJECTED
TECH04         TR006             APPROVED

6 rows selected.

SNO 4. Create a view to count number of tests handled by each technician.

SQL> CREATE VIEW technician_test_count AS
  2  SELECT technician_id,
  3         COUNT(*) AS total_tests
  4  FROM test
  5  GROUP BY technician_id;

View created.

SQL> SELECT * FROM TECHNICIAN_TEST_COUNT;

TECHNICIAN_ID  TOTAL_TESTS
-------------- -----------
TECH01                  4
TECH02                  3
TECH03                  1
TECH04                  1
TECH05                  1

5 rows selected.

SNO 5. Create a view to display technicians who handled more than 3 tests (using existing view).

SQL> CREATE VIEW technician_above_3 AS
  2  SELECT technician_id, total_tests
  3  FROM technician_test_count
  4  WHERE total_tests > 3;

View created.

SQL> SELECT * FROM TECHNICIAN_ABOVE_3;

TECHNICIAN_ID  TOTAL_TESTS
-------------- -----------
TECH01                  4

1 row selected.

SNO 6. Create a view to display technicians along with their head technician name.

SQL> CREATE VIEW technician_head_view AS
  2  SELECT t1.technician_id AS technician,
  3         t2.technician_id AS head_technician
  4  FROM technician t1
  5  LEFT JOIN technician t2
  6  ON t1.head_id = t2.technician_id;

View created.

SQL> SELECT * FROM TECHNICIAN_HEAD_VIEW;

TECHNICIAN      HEAD_TECHNICIAN
--------------- -----------------
TECH02          TECH01
TECH03          TECH01
TECH04          TECH02
TECH05          TECH02
TECH01
TECH06

6 rows selected.

SNO 7. Update a simple view (test_tech01) and verify that changes are reflected in the original table.

SQL> UPDATE test_tech01
  2  SET test_request_id = 'TR999'
  3  WHERE test_id = 'T001';

1 row updated.

SQL> SELECT * FROM test_tech01
  2  WHERE test_id = 'T001';

TEST_ID    TECHNICIAN_ID    TEST_REQUEST_ID
---------- --------------- ---------------
T001       TECH01          TR999


SQL> SELECT test_id, technician_id, test_request_id
  2  FROM test
  3  WHERE test_id = 'T001';

TEST_ID    TECHNICIAN_ID    TEST_REQUEST_ID
---------- --------------- ---------------
T001       TECH01          TR999



SNO 8. Display technicians whose experience is less than the average experience of all technicians.

SQL> SELECT AVG(experience) FROM technician;

AVG(EXPERIENCE)
---------------
      6.16666667


SQL> SELECT technician_id, qualification, experience
  2  FROM technician
  3  WHERE experience < (SELECT AVG(experience) FROM technician);

TECHNICIAN_ID  QUALIFICATION        EXPERIENCE
-------------- -------------------  ----------
TECH02         DIPLOMA                      5
TECH04         ITI                          3
TECH05         DIPLOMA                      4
TECH07         BSC                          2
TECH08         ITI                          1
TECH10         DIPLOMA                      5

6 rows selected.

SNO 9. Insert a new record into a simple view (test_tech01) and verify that it is reflected in the original table.

SQL> INSERT INTO test_tech01 VALUES ('T020','TECH01','TR020');

1 row created.

SQL> SELECT * FROM test_tech01
  2  WHERE test_id = 'T020';

TEST_ID    TECHNICIAN_ID    TEST_REQUEST_ID
---------- --------------- ---------------
T020       TECH01          TR020


SQL> SELECT * FROM test
  2  WHERE test_id = 'T020';

TEST_ID    START_TIME  END_TIME    TEST_REQUEST_ID  TECHNICIAN_ID
---------- ----------- ----------- ---------------- ---------------
T020                              TR020            TECH01

1 row selected.

SNO 10. Attempt to insert into an aggregation view (technician_test_count) and delete from a simple view (test_tech01).

SQL> INSERT INTO technician_test_count VALUES ('TECH09',3);
INSERT INTO technician_test_count VALUES ('TECH09',3)
*
ERROR at line 1:
ORA-01733: virtual column not allowed here


SQL> DELETE FROM test_tech01
  2  WHERE test_id = 'T020';

1 row deleted.

SQL> SELECT * FROM test_tech01
  2  WHERE test_id = 'T020';

no rows selected


SQL> SELECT * FROM test
  2  WHERE test_id = 'T020';

no rows selected

SNO 11. Create an index on technician qualification and retrieve technicians with a specific qualification.

SQL> CREATE INDEX idx_tech_qualification
  2  ON technician(qualification);

Index created.

Elapsed 00:00:00.04

SQL> SELECT qualification
  2  FROM technician;

QUALIFICATION
---------------
BTECH
DIPLOMA
BTECH
ITI
DIPLOMA
BSC
ITI
DIPLOMA
BTECH
DIPLOMA
BSC
DIPLOMA

12 rows selected.

SNO 12. Create a unique index on oil_name in oil_type table.

SQL> CREATE UNIQUE INDEX idx_unique_oil_name
  2  ON oil_type(oil_name);

Index created.

Elapsed 00:00:00.09

SQL> SELECT oil_name
  2  FROM oil_type;

OIL_NAME
----------------
SERVO PRIME
HYTRANS 100
POWER OIL X
TRANSOL A
VOLTEX PRO
MEGATEX
THERMAL OIL Z

7 rows selected.

SNO 13. Create a bitmap index on request_status in test_request table.

SQL> CREATE BITMAP INDEX idx_request_status
  2  ON test_request(request_status);

Index created.z

Elapsed 00:00:00.05

SQL> SELECT request_status
  2  FROM test_request;

REQUEST_STATUS
----------------
PENDING
COMPLETED
PENDING
UNDER_PROGRESS
COMPLETED


5 rows selected.

SNO 14. Create a composite index on technician_id and test_request_id in test table and retrieve matching records.

SQL> CREATE INDEX idx_tech_request
  2  ON test(technician_id, test_request_id);

Index created.

Elapsed 00:00:00.09

SQL> SELECT technician_id, test_request_id
  2  FROM test;

TECHNICIAN_ID  TEST_REQUEST_ID
-------------- ----------------
TECH01         TR001
TECH02         TR002
TECH01         TR003
TECH03         TR004
TECH02         TR005
TECH04         TR006
TECH01         TR007

7 rows selected.


SNO 15. Create a function-based index on LOWER(qualification) in technician table and retrieve matching records.

SQL> CREATE INDEX idx_lower_qualification
  2  ON technician(LOWER(qualification));

Index created.

Elapsed 00:00:00.03

SQL> SELECT LOWER(qualification)
  2  FROM technician;

LOWER(QUALIFICATION)
--------------------
btech
diploma
btech
iti
diploma
bsc
iti
diploma
btech
diploma
bsc
diploma

12 rows selected.

SNO 16. Create an index on condition_status in transformer table.

SQL> CREATE INDEX idx_transformer_status
  2  ON transformer(condition_status);

Index created.

Elapsed 00:00:00.07

SQL> SELECT condition_status
  2  FROM transformer;

CONDITION_STATUS
----------------
GOOD
GOOD
NEEDS_SERVICE
GOOD
CRITICAL
GOOD
NEEDS_SERVICE
MAINTENANCE

8 rows selected.

SNO 17. Create a view to categorize technicians based on experience level using CASE expression.

SQL> CREATE VIEW TechnicianExperienceProfile AS
  2  SELECT
  3  technician_id,
  4  qualification,
  5  experience,
  6  CASE
  7  WHEN experience >= 10 THEN 'EXPERT'
  8  WHEN experience >= 5 THEN 'INTERMEDIATE'
  9  ELSE 'JUNIOR'
 10  END AS exp_level
 11  FROM technician;

View created.


SQL> SELECT technician_id, qualification, experience, exp_level
  2  FROM TechnicianExperienceProfile;

TECHNICIAN_ID  QUALIFICATION   EXPERIENCE EXP_LEVEL
-------------- --------------- ---------- ------------
TECH01         BTECH                 12    EXPERT
TECH02         DIPLOMA                5    INTERMEDIATE
TECH03         BTECH                 15    EXPERT
TECH04         ITI                    3    JUNIOR
TECH05         DIPLOMA                4    JUNIOR
TECH06         BSC                    6    INTERMEDIATE
TECH07         ITI                    2    JUNIOR
TECH08         DIPLOMA                7    INTERMEDIATE
TECH09         BTECH                 11    EXPERT
TECH10         DIPLOMA                5    INTERMEDIATE
TECH11         BSC                    1    JUNIOR
TECH12         DIPLOMA                8    INTERMEDIATE

12 rows selected.


SNO 18. Create a view to assign serial numbers to tests ordered by start_time (latest first).

SQL> CREATE VIEW OrderedTests AS
  2  SELECT
  3  ROW_NUMBER() OVER (ORDER BY start_time DESC) AS test_serial_no,
  4  test_id,
  5  technician_id,
  6  start_time
  7  FROM test;

View created.


SQL> SELECT test_serial_no, test_id, technician_id, start_time
  2  FROM OrderedTests;

TEST_SERIAL_NO  TEST_ID   TECHNICIAN_ID  START_TIME
--------------  --------  --------------- -----------
             1  T010      TECH03          25-JAN-26
             2  T008      TECH02          22-JAN-26
             3  T007      TECH01          20-JAN-26
             4  T005      TECH04          18-JAN-26
             5  T003      TECH01          15-JAN-26
             6  T002      TECH02          12-JAN-26
             7  T001      TECH01          10-JAN-26

7 rows selected.


SNO 19. Create a view to display top 5 highest cost test types.

SQL> CREATE VIEW top_costly_test_types AS
  2  SELECT
  3  test_type_id,
  4  testing_cost,
  5  standard
  6  FROM test_type
  7  ORDER BY testing_cost DESC
  8  FETCH FIRST 5 ROWS ONLY;

View created.


SQL> SELECT test_type_id, testing_cost, standard
  2  FROM top_costly_test_types;

TEST_TYPE_ID   TESTING_COST   STANDARD
-------------- -------------  ----------------
TT05                 15000    IEC-60296
TT03                 12000    ASTM-D877
TT08                 10000    IS-335
TT02                  9000    IEC-60156
TT07                  8500    ASTM-D1816

5 rows selected.


