SET JOIN OP
1)Returns all unique `TRANSFORMER_ID` values from both `TRANSFORMER` and `SAMPLE` tables.

SQL> SELECT TRANSFORMER_ID FROM TRANSFORMER
  2  UNION
  3  SELECT TRANSFORMER_ID FROM SAMPLE;

TRANSFORMER_ID
--------------------
TRF001
TRF002
TRF003
TRF004
TRF005
TRF006
TRF007
TRF008

8 rows selected.

2)--UNION ALL - Combining transformer and sample transformer IDs including duplicates  

SQL> SELECT TRANSFORMER_ID FROM TRANSFORMER
  2  UNION ALL
  3  SELECT TRANSFORMER_ID FROM SAMPLE;

TRANSFORMER_ID
--------------------
TRF001
TRF002
TRF003
TRF004
TRF005
TRF003
TRF004
TRF006
TRF007
TRF008

10 rows selected.



3)--INTERSECT - Common transformer IDs in both TRANSFORMER and SAMPLE  

SQL> SELECT TRANSFORMER_ID FROM TRANSFORMER
  2  INTERSECT
  3  SELECT TRANSFORMER_ID FROM SAMPLE;

TRANSFORMER_ID
--------------------
TRF003
TRF004
TRF006

3 rows selected.



4)--INTERSECT - Common transformer IDs in TRANSFORMER and SAMPLE  

SQL> SELECT TRANSFORMER_ID FROM TRANSFORMER
  2  INTERSECT
  3  SELECT TRANSFORMER_ID FROM SAMPLE;

TRANSFORMER_ID
--------------------
TRF003
TRF004
TRF006

3 rows selected.



5)--MINUS - Transformer IDs present in TRANSFORMER but not in SAMPLE  

SQL> SELECT TRANSFORMER_ID FROM TRANSFORMER
  2  MINUS
  3  SELECT TRANSFORMER_ID FROM SAMPLE;

TRANSFORMER_ID
--------------------
TRF001
TRF002
TRF005
TRF007
TRF008

5 rows selected.



6)--MINUS - Transformer IDs present in SAMPLE but not in TRANSFORMER  

SQL> SELECT TRANSFORMER_ID FROM SAMPLE
  2  MINUS
  3  SELECT TRANSFORMER_ID FROM TRANSFORMER;

TRANSFORMER_ID
--------------------
TRF009
TRF010

2 rows selected.



7)--MINUS - Transformer IDs present in TRANSFORMER but not in SAMPLE  

SQL> SELECT TRANSFORMER_ID FROM TRANSFORMER
  2  MINUS
  3  SELECT TRANSFORMER_ID FROM SAMPLE;

TRANSFORMER_ID
--------------------
TRF001
TRF002
TRF005
TRF007
TRF008

5 rows selected.



8)--MINUS - Transformer IDs present in SAMPLE but not in TRANSFORMER  

SQL> SELECT TRANSFORMER_ID FROM SAMPLE
  2  MINUS
  3  SELECT TRANSFORMER_ID FROM TRANSFORMER;

TRANSFORMER_ID
--------------------
TRF009
TRF010

2 rows selected.



9)--EXCEPT (MINUS equivalent) - Transformer IDs present in SAMPLE but not in TRANSFORMER  

SQL> SELECT TRANSFORMER_ID FROM SAMPLE
  2  MINUS
  3  SELECT TRANSFORMER_ID FROM TRANSFORMER;

TRANSFORMER_ID
--------------------
TRF009
TRF010

2 rows selected.



--JOIN QUERIES
-------------------------------------------------------------------------

10)--CARTESIAN JOIN - Combining all rows from TRANSFORMER and SAMPLE  

SQL> SELECT * FROM TRANSFORMER, SAMPLE;

TRANSFORMER_ID CONDITION_STATUS INSTALL_D SAMPLE_ID  QUANTITY CONDITION_STATUS CONTAINER_NUMBER SAMPLE_TYPE TRANSFORMER_ID
-------------- ---------------- --------- ---------- -------- ---------------- ----------------  ----------- --------------
TRF001         GOOD             12-JAN-20 SM001      10       NORMAL           C001             OIL         TRF001
TRF001         GOOD             12-JAN-20 SM002      12       NORMAL           C002             OIL         TRF003
TRF002         FAIR             05-MAR-21 SM001      10       NORMAL           C001             OIL         TRF001
TRF002         FAIR             05-MAR-21 SM002      12       NORMAL           C002             OIL         TRF003
TRF003         GOOD             18-JUL-19 SM001      10       NORMAL           C001             OIL         TRF001
TRF003         GOOD             18-JUL-19 SM002      12       NORMAL           C002             OIL         TRF003

36 rows selected.



11)--CROSS JOIN - Combining all rows from TRANSFORMER and SAMPLE  

SQL> SELECT * FROM TRANSFORMER
  2  CROSS JOIN SAMPLE;

TRANSFORMER_ID CONDITION_STATUS INSTALL_D SAMPLE_ID  QUANTITY CONDITION_STATUS CONTAINER_NUMBER SAMPLE_TYPE TRANSFORMER_ID
-------------- ---------------- --------- ---------- -------- ---------------- ----------------  ----------- --------------
TRF001         GOOD             12-JAN-20 SM001      10       NORMAL           C001             OIL         TRF001
TRF001         GOOD             12-JAN-20 SM002      12       NORMAL           C002             OIL         TRF003
TRF002         FAIR             05-MAR-21 SM001      10       NORMAL           C001             OIL         TRF001
TRF002         FAIR             05-MAR-21 SM002      12       NORMAL           C002             OIL         TRF003
TRF003         GOOD             18-JUL-19 SM001      10       NORMAL           C001             OIL         TRF001
TRF003         GOOD             18-JUL-19 SM002      12       NORMAL           C002             OIL         TRF003

6 rows selected.




12)--INNER JOIN (old syntax) - Matching SAMPLE with TRANSFORMER using transformer_id  

SQL> SELECT *
  2  FROM TRANSFORMER T, SAMPLE S
  3  WHERE T.TRANSFORMER_ID = S.TRANSFORMER_ID;

TRANSFORMER_ID CONDITION_STATUS INSTALL_D SAMPLE_ID  QUANTITY CONDITION_STATUS CONTAINER_NUMBER SAMPLE_TYPE TRANSFORMER_ID
-------------- ---------------- --------- ---------- -------- ---------------- ----------------  ----------- --------------
TRF001         GOOD             12-JAN-20 SM001      10       NORMAL           C001             OIL         TRF001
TRF003         GOOD             18-JUL-19 SM002      12       NORMAL           C002             OIL         TRF003
TRF004         FAIR             11-NOV-18 SM003      15       CRITICAL         C003             OIL         TRF004
TRF006         GOOD             09-AUG-22 SM004      11       NORMAL           C004             OIL         TRF006

4 rows selected.




13)--INNER JOIN - Matching SAMPLE with TRANSFORMER using transformer_id  

SQL> SELECT *
  2  FROM TRANSFORMER T
  3  INNER JOIN SAMPLE S
  4  ON T.TRANSFORMER_ID = S.TRANSFORMER_ID;

TRANSFORMER_ID CONDITION_STATUS INSTALL_D SAMPLE_ID  QUANTITY CONDITION_STATUS CONTAINER_NUMBER SAMPLE_TYPE TRANSFORMER_ID
-------------- ---------------- --------- ---------- -------- ---------------- ----------------  ----------- --------------
TRF001         GOOD             12-JAN-20 SM001      10       NORMAL           C001             OIL         TRF001
TRF003         GOOD             18-JUL-19 SM002      12       NORMAL           C002             OIL         TRF003
TRF004         FAIR             11-NOV-18 SM003      15       CRITICAL         C003             OIL         TRF004
TRF006         GOOD             09-AUG-22 SM004      11       NORMAL           C004             OIL         TRF006

4 rows selected.



14)--JOIN - Matching SAMPLE with TRANSFORMER using transformer_id  

SQL> SELECT *
  2  FROM TRANSFORMER T
  3  JOIN SAMPLE S
  4  ON T.TRANSFORMER_ID = S.TRANSFORMER_ID;

TRANSFORMER_ID CONDITION_STATUS INSTALL_D SAMPLE_ID  QUANTITY CONDITION_STATUS CONTAINER_NUMBER SAMPLE_TYPE TRANSFORMER_ID
-------------- ---------------- --------- ---------- -------- ---------------- ----------------  ----------- --------------
TRF001         GOOD             12-JAN-20 SM001      10       NORMAL           C001             OIL         TRF001
TRF003         GOOD             18-JUL-19 SM002      12       NORMAL           C002             OIL         TRF003
TRF004         FAIR             11-NOV-18 SM003      15       CRITICAL         C003             OIL         TRF004
TRF006         GOOD             09-AUG-22 SM004      11       NORMAL           C004             OIL         TRF006

4 rows selected.



15)--NATURAL JOIN - Automatically joining SAMPLE and TRANSFORMER using common column TRANSFORMER_ID  

SQL> SELECT *
  2  FROM TRANSFORMER
  3  NATURAL JOIN SAMPLE;

TRANSFORMER_ID CONDITION_STATUS INSTALL_D SAMPLE_ID  QUANTITY CONDITION_STATUS_1 CONTAINER_NUMBER SAMPLE_TYPE
-------------- ---------------- --------- ---------- -------- ------------------ ---------------- -----------
TRF001         GOOD             12-JAN-20 SM001      10       NORMAL             C001             OIL
TRF003         GOOD             18-JUL-19 SM002      12       NORMAL             C002             OIL
TRF004         FAIR             11-NOV-18 SM003      15       CRITICAL           C003             OIL
TRF006         GOOD             09-AUG-22 SM004      11       NORMAL             C004             OIL

4 rows selected.



16)--NATURAL JOIN - Joining TEST and TEST_REQUEST using common column TEST_REQUEST_ID  

SQL> SELECT *
  2  FROM TEST
  3  NATURAL JOIN TEST_REQUEST;

TEST_REQUEST_ID TEST_ID START_TIME END_TIME  TECHNICIAN_ID PRIORITY REQUEST_DATE REQUEST_STATUS APPROVAL_ID
--------------- ------- ---------- -------- -------------- -------- ------------- -------------- -----------
TR1001          TS001   10-JAN-26  12-JAN-26 TECH001       HIGH     05-JAN-26    APPROVED       AP001
TR1002          TS002   11-JAN-26  13-JAN-26 TECH002       MEDIUM   06-JAN-26    APPROVED       AP002
TR1003          TS003   12-JAN-26  15-JAN-26 TECH003       HIGH     07-JAN-26    PENDING        AP003
TR1004          TS004   14-JAN-26  16-JAN-26 TECH004       LOW      08-JAN-26    APPROVED       AP004

4 rows selected.



17)--NATURAL JOIN - Joining TEST and TEST_TYPE using common column TEST_ID  

SQL> SELECT *
  2  FROM TEST
  3  NATURAL JOIN TEST_TYPE;

TEST_ID TEST_TYPE_ID START_TIME  END_TIME    DURATION TESTING_COST STANDARD METHOD        DESCRIPTION
------- ------------ ----------- ----------- -------- ------------- -------- ------------- ----------------
TS001   TT01         10-JAN-26   12-JAN-26   2        1500          IS2026   ASTM-D974     Acidity Test
TS002   TT02         11-JAN-26   13-JAN-26   2        2000          IS2026   ASTM-D877     Breakdown Test
TS003   TT03         12-JAN-26   15-JAN-26   3        1800          IS2026   ASTM-D1816    Dielectric Test
TS004   TT01         14-JAN-26   16-JAN-26   2        1500          IS2026   ASTM-D974     Acidity Test

4 rows selected.



18)--INNER JOIN - Matching TEST with TECHNICIAN using technician_id  

SQL> SELECT *
  2  FROM TEST T
  3  INNER JOIN TECHNICIAN TC
  4  ON T.TECHNICIAN_ID = TC.TECHNICIAN_ID;

TEST_ID  START_TIME  END_TIME   TEST_REQUEST_ID TECHNICIAN_ID QUALIFICATION EXPERIENCE EMAIL              SKILLS        PHONE_NO HEAD_ID
-------- ----------- ---------- --------------- ------------- ------------- ---------- ------------------ ------------- -------- -------
TS001    10-JAN-26   12-JAN-26   TR1001          TECH001       B.E           12         tech1@mail.com    OIL_ANALYSIS  9876543210 H001
TS002    11-JAN-26   13-JAN-26   TR1002          TECH002       M.E           8          tech2@mail.com    DIELECTRIC    9876543211 H001
TS003    12-JAN-26   15-JAN-26   TR1003          TECH003       B.E           14         tech3@mail.com    CHEM_TEST     9876543212 H002
TS004    14-JAN-26   16-JAN-26   TR1004          TECH004       Diploma       6          tech4@mail.com    SAMPLE_TEST   9876543213 H002

4 rows selected.



19)--LEFT OUTER JOIN - All TEST records with matching TECHNICIAN details  

SQL> SELECT *
  2  FROM TEST T
  3  LEFT OUTER JOIN TECHNICIAN TC
  4  ON T.TECHNICIAN_ID = TC.TECHNICIAN_ID;

TEST_ID  START_TIME  END_TIME   TEST_REQUEST_ID TECHNICIAN_ID QUALIFICATION EXPERIENCE EMAIL              SKILLS        PHONE_NO HEAD_ID
-------- ----------- ---------- --------------- ------------- ------------- ---------- ------------------ ------------- -------- -------
TS001    10-JAN-26   12-JAN-26   TR1001          TECH001       B.E           12         tech1@mail.com    OIL_ANALYSIS  9876543210 H001
TS002    11-JAN-26   13-JAN-26   TR1002          TECH002       M.E           8          tech2@mail.com    DIELECTRIC    9876543211 H001
TS003    12-JAN-26   15-JAN-26   TR1003          TECH003       B.E           14         tech3@mail.com    CHEM_TEST     9876543212 H002
TS004    14-JAN-26   16-JAN-26   TR1004          TECH009
TS005    15-JAN-26   17-JAN-26   TR1005          TECH004       Diploma       6          tech4@mail.com    SAMPLE_TEST   9876543213 H002

5 rows selected.



20)--RIGHT OUTER JOIN - All TECHNICIAN records with matching TEST details  

SQL> SELECT *
  2  FROM TEST T
  3  RIGHT OUTER JOIN TECHNICIAN TC
  4  ON T.TECHNICIAN_ID = TC.TECHNICIAN_ID;

TEST_ID  START_TIME  END_TIME   TEST_REQUEST_ID TECHNICIAN_ID QUALIFICATION EXPERIENCE EMAIL              SKILLS        PHONE_NO HEAD_ID
-------- ----------- ---------- --------------- ------------- ------------- ---------- ------------------ ------------- -------- -------
TS001    10-JAN-26   12-JAN-26   TR1001          TECH001       B.E           12         tech1@mail.com    OIL_ANALYSIS  9876543210 H001
TS002    11-JAN-26   13-JAN-26   TR1002          TECH002       M.E           8          tech2@mail.com    DIELECTRIC    9876543211 H001
TS003    12-JAN-26   15-JAN-26   TR1003          TECH003       B.E           14         tech3@mail.com    CHEM_TEST     9876543212 H002
                                    TECH005       B.E           15         tech5@mail.com    OIL_ANALYSIS  9876543214 H003
                                    TECH006       Diploma       5          tech6@mail.com    SAMPLE_TEST   9876543215 H003

5 rows selected.




21)--FULL OUTER JOIN - All records from TEST and TECHNICIAN  

SQL> SELECT *
  2  FROM TEST T
  3  FULL OUTER JOIN TECHNICIAN TC
  4  ON T.TECHNICIAN_ID = TC.TECHNICIAN_ID;

TEST_ID  START_TIME  END_TIME   TEST_REQUEST_ID TECHNICIAN_ID QUALIFICATION EXPERIENCE EMAIL              SKILLS        PHONE_NO HEAD_ID
-------- ----------- ---------- --------------- ------------- ------------- ---------- ------------------ ------------- -------- -------
TS001    10-JAN-26   12-JAN-26   TR1001          TECH001       B.E           12         tech1@mail.com    OIL_ANALYSIS  9876543210 H001
TS002    11-JAN-26   13-JAN-26   TR1002          TECH002       M.E           8          tech2@mail.com    DIELECTRIC    9876543211 H001
TS003    12-JAN-26   15-JAN-26   TR1003          TECH003       B.E           14         tech3@mail.com    CHEM_TEST     9876543212 H002
TS004    14-JAN-26   16-JAN-26   TR1004          TECH009
TS005    15-JAN-26   17-JAN-26   TR1005          TECH004       Diploma       6          tech4@mail.com    SAMPLE_TEST   9876543213 H002
                                    TECH005       B.E           15         tech5@mail.com    OIL_ANALYSIS  9876543214 H003

6 rows selected.



22)--SELF JOIN - Technician reporting to head in same branch (simulated)  

SQL> SELECT T1.TECHNICIAN_ID AS TECHNICIAN,
  2         T1.HEAD_ID       AS HEAD_ID,
  3         T2.TECHNICIAN_ID AS HEAD_TECHNICIAN
  4  FROM TECHNICIAN T1
  5  JOIN TECHNICIAN T2
  6  ON T1.HEAD_ID = T2.TECHNICIAN_ID;

TECHNICIAN  HEAD_ID  HEAD_TECHNICIAN
----------- -------- ----------------
TECH002     TECH001  TECH001
TECH003     TECH001  TECH001
TECH005     TECH003  TECH003
TECH006     TECH003  TECH003

4 rows selected.



23)--SELF JOIN - Technician and their head working under same head_id  

SQL> SELECT T1.TECHNICIAN_ID AS TECHNICIAN_NAME,
  2         T1.HEAD_ID       AS HEAD_ID,
  3         T2.TECHNICIAN_ID AS SUPERVISOR_NAME
  4  FROM TECHNICIAN T1
  5  JOIN TECHNICIAN T2
  6  ON T1.HEAD_ID = T2.TECHNICIAN_ID;

TECHNICIAN_NAME HEAD_ID  SUPERVISOR_NAME
--------------- -------- ----------------
TECH002         TECH001  TECH001
TECH003         TECH001  TECH001
TECH005         TECH003  TECH003
TECH006         TECH003  TECH003

4 rows selected.


24)--MULTIPLE TABLE JOIN - Test details with Technician and Test Request  

SQL> SELECT T.TEST_ID,
  2         TR.TEST_REQUEST_ID,
  3         TR.PRIORITY,
  4         TC.TECHNICIAN_ID,
  5         TC.QUALIFICATION
  6  FROM TEST T
  7  JOIN TEST_REQUEST TR
  8  ON T.TEST_REQUEST_ID = TR.TEST_REQUEST_ID
  9  JOIN TECHNICIAN TC
 10  ON T.TECHNICIAN_ID = TC.TECHNICIAN_ID;

TEST_ID  TEST_REQUEST_ID PRIORITY TECHNICIAN_ID QUALIFICATION
-------- --------------- -------- ------------- -------------
TS001    TR1001          HIGH     TECH001       B.E
TS002    TR1002          MEDIUM   TECH002       M.E
TS003    TR1003          HIGH     TECH003       B.E
TS004    TR1004          LOW      TECH004       Diploma

4 rows selected.

25)--INTERSECT ALL - Common transformer IDs in both TRANSFORMER and SAMPLE including duplicates  

SQL> SELECT TRANSFORMER_ID FROM TRANSFORMER
  2  INTERSECT ALL
  3  SELECT TRANSFORMER_ID FROM SAMPLE;

TRANSFORMER_ID
--------------------
TRF003
TRF004
TRF006

3 rows selected.

26)--JOIN USING - Matching SAMPLE with TRANSFORMER using USING (TRANSFORMER_ID)

SQL> SELECT *
  2  FROM TRANSFORMER
  3  JOIN SAMPLE
  4  USING (TRANSFORMER_ID);

TRANSFORMER_ID CONDITION_STATUS INSTALL_D SAMPLE_ID  QUANTITY CONDITION_STATUS_1 CONTAINER_NUMBER SAMPLE_TYPE
-------------- ---------------- --------- ---------- -------- ------------------ ---------------- -----------
TRF001         GOOD             12-JAN-20 SM001      10       NORMAL             C001             OIL
TRF003         GOOD             18-JUL-19 SM002      12       NORMAL             C002             OIL
TRF004         FAIR             11-NOV-18 SM003      15       CRITICAL           C003             OIL
TRF006         GOOD             09-AUG-22 SM004      11       NORMAL             C004             OIL

4 rows selected.

