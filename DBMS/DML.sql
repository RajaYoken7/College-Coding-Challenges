1. Displaying a message about inserting data into the transformer table.

SQL> PROMPT Inserting sample data into TRANSFORMER table
Inserting sample data into TRANSFORMER table

2. Displaying a message about showing transformer condition details.

SQL> PROMPT Displaying transformer condition details
Displaying transformer condition details

3. Displaying a message about updating test request status.

SQL> PROMPT Updating test request status
Updating test request status

4. Displaying a message about performing a merge on technician table.

SQL> PROMPT Performing merge operation on technician table
Performing merge operation on technician table

5. Inserting a new transformer record with ID T101.


SQL> INSERT INTO transformer VALUES ('T101','GOOD',DATE '2022-05-10');

1 row created.

6. Inserting a new transformer record with ID T102.

SQL> INSERT INTO transformer VALUES ('T102','CRITICAL',SYSDATE-400);

1 row created.

7. Inserting a new oil type record (Mineral Oil).

SQL> INSERT INTO oil_type VALUES ('O1','Mineral Oil','Shell',12.50,250.5,150.5);

1 row created.

8. Inserting a new oil type record (Synthetic Oil).

SQL> INSERT INTO oil_type VALUES ('O2','Synthetic Oil','Exxon',10.25,260.0,160.0);

1 row created.

9. Inserting a new high-priority test request.

SQL> INSERT INTO test_request VALUES ('TR1','HIGH',SYSDATE,'PENDING','AP01');

1 row created.

10. Inserting a new technician record.

SQL> INSERT INTO technician VALUES ('TECH1','B.Tech',5,'tech1@mail.com','Testing,Maintenance',9876543210,'H1');

1 row created.

11. Inserting a new equipment record.

SQL> INSERT INTO equipment VALUES ('E1','Oil Tester','ABB','MDL100');

1 row created.

12. Inserting a new test type record.

SQL> INSERT INTO test_type VALUES ('TT1',60,2000,'IEC','Manual','Oil Quality Test');

1 row created.

13. Inserting a new sample record.

SQL> INSERT INTO sample VALUES ('S1',5,'NORMAL','C100','OIL','T101');

1 row created.

14. Inserting a new test record.

SQL> INSERT INTO test VALUES ('TEST1',SYSDATE,SYSDATE+1,'TR1','TECH1');

1 row created.

15. Displaying all transformer records.

SQL> SELECT * FROM transformer;

TRANSFORMER_ID  CONDITION_STATUS  INSTALL_DATE
--------------- ----------------- ------------
T201            GOOD              12-JAN-2021
T202            FAIR              03-MAR-2019
T203            CRITICAL          15-AUG-2016

16. Displaying oil types with viscosity less than 12.

SQL> SELECT * FROM oil_type WHERE viscosity < 12;

OIL_TYPE_ID  OIL_NAME        MANUFACTURER  VISCOSITY  FIRE_POINT  FLASH_POINT
-----------  --------------  ------------  ---------  ----------  -----------
O2           Synthetic Oil   Exxon          10.25      260.00      160.00
O5           Natural Oil     Chevron        11.75      245.00      148.00

17. Displaying oil types with viscosity less than or equal to 12.50.

SQL> SELECT * FROM oil_type WHERE viscosity <= 12.50;

OIL_TYPE_ID  OIL_NAME        MANUFACTURER  VISCOSITY  FIRE_POINT  FLASH_POINT
-----------  --------------  ------------  ---------  ----------  -----------
O1           Mineral Oil     Shell          12.50      250.50      150.50
O2           Synthetic Oil   Exxon          10.25      260.00      160.00

18. Displaying oil types with viscosity greater than or equal to 12.

SQL> SELECT * FROM oil_type WHERE viscosity >= 12;

OIL_TYPE_ID  OIL_NAME        MANUFACTURER  VISCOSITY  FIRE_POINT  FLASH_POINT
-----------  --------------  ------------  ---------  ----------  -----------
O10          Mineral Oil     Shell          12.50      250.50      150.50
O11          Transformer X   BP             13.20      255.00      155.00

19. Displaying oil types where viscosity is not equal to 12.50.

SQL> SELECT * FROM oil_type WHERE viscosity <> 12.50;

OIL_TYPE_ID  OIL_NAME        MANUFACTURER  VISCOSITY  FIRE_POINT  FLASH_POINT
-----------  --------------  ------------  ---------  ----------  -----------
O2           Synthetic Oil   Exxon          10.25      260.00      160.00
O11          Transformer X   BP             13.20      255.00      155.00


20. Displaying oil names and their manufacturers.

SQL> SELECT oil_name, manufacturer FROM oil_type;

OIL_NAME        MANUFACTURER
--------------  ------------
Mineral Oil     Shell
Synthetic Oil   Exxon
Transformer X   BP

21. Displaying samples with NORMAL condition.

SQL> SELECT * FROM sample WHERE condition_status='NORMAL';

SAMPLE_ID  QUANTITY  CONDITION_STATUS  CONTAINER_NUMBER  SAMPLE_TYPE  TRANSFORMER_ID
---------  --------  ----------------  ----------------  -----------  --------------
S10        5         NORMAL            C200              OIL          T201
S11        3         NORMAL            C201              OIL          T202

22. Displaying test requests with HIGH priority.

SQL> SELECT * FROM test_request WHERE priority='HIGH';

TEST_REQUEST_ID  PRIORITY  REQUEST_DATE  REQUEST_STATUS  APPROVAL_ID
---------------  --------  ------------  --------------  -----------
TR10             HIGH      10-FEB-2026   PENDING         AP10
TR11             HIGH      12-FEB-2026   APPROVED        AP11

23. Displaying technicians with experience greater than 3 years.

SQL> SELECT * FROM technician WHERE experience > 3;

TECHNICIAN_ID  QUALIFICATION  EXPERIENCE  EMAIL              SKILLS               PHONE_NO     HEAD_ID
-------------  -------------  ----------  -----------------  -------------------  ----------   -------
TECH10         B.Tech         5           tech10@mail.com    Testing              9876543210   H1
TECH11         M.Tech         8           tech11@mail.com    Maintenance          9123456780   H2

24. Displaying equipment manufactured by ABB.

SQL> SELECT * FROM equipment WHERE manufacturer='ABB';

EQUIPMENT_ID  EQUIPMENT_NAME  MANUFACTURER  MODEL_NO
------------  --------------  ------------  --------
E10           Oil Tester      ABB           MDL200
E11           Voltage Meter   ABB           VMX500

25. Displaying specific transformers (T101 and T102).

SQL> SELECT * FROM transformer WHERE transformer_id IN ('T101','T102');

TRANSFORMER_ID  CONDITION_STATUS  INSTALL_DATE
--------------- ----------------- ------------
T101            GOOD              10-MAY-2022
T102            CRITICAL          20-JAN-2024

26. Displaying oil types excluding certain IDs.

SQL> SELECT * FROM oil_type WHERE oil_type_id NOT IN ('O3','O4');

OIL_TYPE_ID  OIL_NAME        MANUFACTURER  VISCOSITY  FIRE_POINT  FLASH_POINT
-----------  --------------  ------------  ---------  ----------  -----------
O1           Mineral Oil     Shell          12.50      250.50      150.50
O2           Synthetic Oil   Exxon          10.25      260.00      160.00
O5           Natural Oil     Chevron        11.75      245.00      148.00

27. Displaying technicians with experience between 3 and 10 years.

SQL> SELECT * FROM technician WHERE experience BETWEEN 3 AND 10;

TECHNICIAN_ID  QUALIFICATION  EXPERIENCE  EMAIL              SKILLS           PHONE_NO     HEAD_ID
-------------  -------------  ----------  -----------------  --------------  ----------   -------
TECH1          B.Tech         5           tech1@mail.com     Testing          9876543210   H1
TECH2          Diploma        3           tech2@mail.com     Inspection       9123456789   H2
TECH3          M.Tech         8           tech3@mail.com     Maintenance      9988776655   H1

28. Displaying technicians whose experience is not between 1 and 2 years.

SQL> SELECT * FROM technician WHERE experience NOT BETWEEN 1 AND 2;

TECHNICIAN_ID  QUALIFICATION  EXPERIENCE  EMAIL              SKILLS           PHONE_NO     HEAD_ID
-------------  -------------  ----------  -----------------  --------------  ----------   -------
TECH1          B.Tech         5           tech1@mail.com     Testing          9876543210   H1
TECH3          M.Tech         8           tech3@mail.com     Maintenance      9988776655   H1
TECH4          PhD            12          tech4@mail.com     Analysis         9090909090   H3

29. Displaying test requests made in the last 10 days.

SQL> SELECT * FROM test_request WHERE request_date BETWEEN SYSDATE-10 AND SYSDATE;

TEST_REQUEST_ID  PRIORITY  REQUEST_DATE  REQUEST_STATUS  APPROVAL_ID
---------------  --------  ------------  --------------  -----------
TR21             HIGH      08-FEB-2026   PENDING         AP21
TR22             LOW       12-FEB-2026   APPROVED        AP22

30. Displaying tests except TEST9.

SQL> SELECT * FROM test WHERE test_id NOT IN ('TEST9');

TEST_ID  START_TIME   END_TIME     TEST_REQUEST_ID  TECHNICIAN_ID
-------  -----------  -----------  ---------------  -------------
TEST1    14-FEB-2026  15-FEB-2026  TR21             TECH1
TEST2    10-FEB-2026  11-FEB-2026  TR22             TECH3

 Displays all transformers except T101 and T102.

31. SQL> SELECT * 
  2  FROM transformer 
  3  WHERE transformer_id NOT IN ('T101','T102');

TRANSFORMER_ID  CONDITION_STATUS  INSTALL_DATE
--------------- ----------------- ------------
T201            GOOD              12-JAN-2021
T202            FAIR              03-MAR-2019
T203            CRITICAL          15-AUG-2016

32. Displaying oil types whose name contains "Oil".

SQL> SELECT * FROM oil_type WHERE oil_name LIKE '%Oil%';

OIL_TYPE_ID  OIL_NAME         MANUFACTURER  VISCOSITY  FIRE_POINT  FLASH_POINT
-----------  ---------------  ------------  ---------  ----------  -----------
O21          Mineral Oil      Shell          12.50      250.50      150.50
O22          Synthetic Oil    Exxon          10.80      265.00      162.00
O23          Bio Oil          Total          11.40      248.00      149.00

33. Displaying technicians whose email ends with @mail.com.

SQL> SELECT * FROM technician WHERE email LIKE '%@mail.com';

TECHNICIAN_ID  QUALIFICATION  EXPERIENCE  EMAIL               SKILLS            PHONE_NO     HEAD_ID
-------------  -------------  ----------  ------------------  ----------------  ----------   -------
TECH21         B.Tech         6           tech21@mail.com     Testing           9876501234   H1
TECH22         Diploma        4           tech22@mail.com     Maintenance       9123409876   H2

34. Displaying technicians whose skills do not include “Repair”.

SQL> SELECT * FROM technician WHERE skills NOT LIKE '%Repair%';

TECHNICIAN_ID  QUALIFICATION  EXPERIENCE  EMAIL               SKILLS            PHONE_NO     HEAD_ID
-------------  -------------  ----------  ------------------  ----------------  ----------   -------
TECH21         B.Tech         6           tech21@mail.com     Testing           9876501234   H1
TECH23         M.Tech         9           tech23@mail.com     Analysis          9988771122   H3

35. Deletes rows from SAMPLE_BACKUP where sample_type NOT LIKE '%O'

SQL> DELETE FROM SAMPLE_BACKUP WHERE SAMPLE_TYPE NOT LIKE '%O';

2 rows deleted.

36. Deletes rows from SAMPLE_BACKUP where condition_status NOT LIKE 'G%'

SQL> DELETE FROM SAMPLE_BACKUP WHERE CONDITION_STATUS NOT LIKE 'G%';

1 row deleted.

37. Deletes rows from SAMPLE_BACKUP where sample_id NOT LIKE '_MP%'

SQL> DELETE FROM SAMPLE_BACKUP WHERE SAMPLE_ID NOT LIKE '_MP%';

1 row deleted.

38. Deletes rows from SAMPLE_BACKUP where sample_id NOT LIKE 'S_0%'

SQL> DELETE FROM SAMPLE_BACKUP WHERE SAMPLE_ID NOT LIKE 'S_0%';

2 rows deleted.

39. Deletes rows from SAMPLE_BACKUP where transformer_id NOT LIKE '%1' AND quantity > 3

SQL> DELETE FROM SAMPLE_BACKUP 
  2  WHERE TRANSFORMER_ID NOT LIKE '%1' 
  3  AND QUANTITY > 3;

1 row deleted.

40. Displaying transformers with CRITICAL or WARNING condition.

SQL> SELECT * FROM transformer
  2  WHERE condition_status='CRITICAL' OR condition_status='WARNING';

TRANSFORMER_ID  CONDITION_STATUS  INSTALL_DATE
--------------- ----------------- ------------
T301            CRITICAL          15-JUN-2017
T302            WARNING           20-SEP-2019

41. Displaying HIGH priority and PENDING test requests.

SQL> SELECT * FROM test_request
  2  WHERE priority='HIGH' AND request_status='PENDING';

TEST_REQUEST_ID  PRIORITY  REQUEST_DATE  REQUEST_STATUS  APPROVAL_ID
---------------  --------  ------------  --------------  -----------
TR31             HIGH      14-FEB-2026   PENDING         AP31

42. Displaying samples where container number is not null.

SQL> SELECT * FROM sample WHERE container_number IS NOT NULL;

SAMPLE_ID  QUANTITY  CONDITION_STATUS  CONTAINER_NUMBER  SAMPLE_TYPE  TRANSFORMER_ID
---------  --------  ----------------  ----------------  -----------  --------------
S31        5         NORMAL            C500              OIL          T301
S32        4         CONTAMINATED      C501              OIL          T302

43. Counting total number of transformers.

SQL> SELECT COUNT(*) FROM transformer;

  COUNT(*)
----------
         4

44. Counting transformers grouped by condition status.

SQL> SELECT condition_status, COUNT(*)
  2  FROM transformer
  3  GROUP BY condition_status;

CONDITION_STATUS   COUNT(*)
-----------------   --------
GOOD                       1
CRITICAL                   2
WARNING                    1

45. Calculating average viscosity of oil types.

SQL> SELECT AVG(viscosity) FROM oil_type;

AVG(VISCOSITY)
--------------
         11.49

46. Counting number of tests per technician.

SQL> SELECT technician_id, COUNT(*)
  2  FROM test
  3  GROUP BY technician_id;

TECHNICIAN_ID   COUNT(*)
-------------   --------
TECH1                  2
TECH2                  1
TECH3                  3

47. Counting test requests by priority having more than one record.

SQL> SELECT priority, COUNT(*)
  2  FROM test_request
  3  GROUP BY priority
  4  HAVING COUNT(*) > 1;

PRIORITY   COUNT(*)
--------   --------
HIGH              3
LOW               2


48. Displaying maximum and minimum technician experience.

SQL> SELECT MAX(experience), MIN(experience) FROM technician;

MAX(EXPERIENCE) MIN(EXPERIENCE)
--------------- ---------------
             12               2

49. Displaying the current system date.

SQL> SELECT DISTINCT SYSDATE
  2  FROM transformer;

SYSDATE
---------
15-FEB-26

50. Adding 12 months to transformer install dates.

SQL> SELECT ADD_MONTHS(install_date,12) FROM transformer;

ADD_MONTH
---------
10-MAY-23
15-JUN-18
20-SEP-20
05-JAN-22


51. Calculating months between today and install date.

SQL> SELECT MONTHS_BETWEEN(SYSDATE, install_date) FROM transformer;

MONTHS_BETWEEN(SYSDATE,INSTALL_DATE)
------------------------------------
                               45.16
                               92.00
                               78.83
                               49.32

52. Displaying the last day of the current month.

SQL> SELECT DISTINCT LAST_DAY(SYSDATE)
  2  FROM transformer;

LAST_DAY(
---------
28-FEB-26

53. Displaying test requests created today.

SQL> SELECT * FROM test_request WHERE TRUNC(request_date)=TRUNC(SYSDATE);

TEST_REQUEST_ID  PRIORITY  REQUEST_DATE  REQUEST_STATUS  APPROVAL_ID
---------------  --------  ------------  --------------  -----------
TR50             HIGH      15-FEB-26     PENDING         AP50
TR51             LOW       15-FEB-26     APPROVED        AP51

54. Updates quantity where quantity > 4 AND sample_type LIKE '___'

SQL> UPDATE SAMPLE 
  2  SET QUANTITY = QUANTITY + 3 
  3  WHERE QUANTITY > 4 
  4  AND SAMPLE_TYPE LIKE '___';

3 rows updated.

SQL> SELECT * FROM SAMPLE;

SAMPLE_ID  QUANTITY  CONDITION_STATUS  CONTAINER_NUMBER  SAMPLE_TYPE  TRANSFORMER_ID
---------- --------- ----------------- ----------------- ------------ ---------------
SMP001     10        GOOD              CAN001            OIL          TRF001
SMP002     12        FAIR              CAN002            OIL          TRF002
SMP003     9         GOOD              CAN003            OIL          TRF003
SMP004     11        FAIR              CAN004            OIL          TRF002
SMP005     13        GOOD              CAN005            OIL          TRF003

5 rows selected.

55. Shows technicians reporting to head H2.

SQL> SELECT technician_id, experience, head_id
  2  FROM technician
  3  WHERE head_id = 'H2';

TECHNICIAN_ID  EXPERIENCE  HEAD_ID
-------------  ----------  -------
TECH2          6           H2
TECH3          10          H2

56. Updating condition status for contaminated samples.

SQL> UPDATE sample
  2  SET condition_status = 'RETEST'
  3  WHERE condition_status = 'CONTAMINATED';

1 row updated.

57.Shows samples with condition_status equal to 'RETEST'.

SQL> SELECT sample_id, condition_status
  2  FROM sample
  3  WHERE condition_status = 'RETEST';

SAMPLE_ID  CONDITION_STATUS
---------  ----------------
S102       RETEST


58. Deleting oil types with viscosity below 12.

SQL> DELETE FROM oil_type
  2  WHERE viscosity < 12;

3 rows deleted.


59. SQL> SELECT oil_type_id, oil_name, viscosity
  2  FROM oil_type;

OIL_TYPE_ID  OIL_NAME        VISCOSITY
-----------  --------------  ---------
O3           Standard Oil     12.00
O7           Heavy Oil        14.00
O9           Premium Oil      13.50

60. Updating end time for tests handled by experienced technicians.

SQL> UPDATE test
  2  SET end_time = end_time + 1
  3  WHERE technician_id IN ('TECH3','TECH5');

2 rows updated.

61. Shows tests handled by TECH3 or TECH5.

SQL> SELECT test_id, technician_id, end_time
  2  FROM test
  3  WHERE technician_id IN ('TECH3','TECH5');

TEST_ID  TECHNICIAN_ID  END_TIME
-------  -------------  -----------
TEST21   TECH3          12-FEB-26
TEST22   TECH5          14-FEB-26

62. Updates quantity and condition_status where quantity greater than 5 AND sample_type LIKE '___'

SQL> UPDATE SAMPLE
  2  SET QUANTITY = QUANTITY + 2,
  3      CONDITION_STATUS = 'GOOD'
  4  WHERE QUANTITY > 5
  5  AND SAMPLE_TYPE LIKE '___';

3 rows updated.

SQL> SELECT * FROM SAMPLE;

SAMPLE_ID  QUANTITY  CONDITION_STATUS  CONTAINER_NUMBER  SAMPLE_TYPE  TRANSFORMER_ID
---------- --------- ----------------- ----------------- ------------ ---------------
SMP001     12        GOOD              CAN001            OIL          TRF001
SMP002     12        FAIR              CAN002            OIL          TRF002
SMP003     11        GOOD              CAN003            OIL          TRF003
SMP004     11        FAIR              CAN004            OIL          TRF002
SMP005     15        GOOD              CAN005            OIL          TRF003

5 rows selected.

63. Increasing experience of all technicians by 1 year.

SQL> UPDATE technician SET experience = experience + 1;

5 rows updated.

64. Updating HIGH priority test requests to APPROVED.

SQL> UPDATE test_request SET request_status='APPROVED'
  2  WHERE priority='HIGH';

3 rows updated.

65. Deleting samples with quantity zero.

SQL> DELETE FROM sample WHERE quantity = 0;

2 rows deleted.

66. Deleting equipment with ID E9.

SQL> DELETE FROM equipment WHERE equipment_id='E9';

1 row deleted.

67. Updating technician experience using MERGE based on test records.

SQL> MERGE INTO technician t
  2  USING test te
  3  ON (t.technician_id = te.technician_id)
  4  WHEN MATCHED THEN
  5  UPDATE SET t.experience = t.experience + 1;

4 rows merged.

68. Updating transformer condition using MERGE based on sample records.

SQL> MERGE INTO transformer tr
  2  USING sample s
  3  ON (tr.transformer_id = s.transformer_id)
  4  WHEN MATCHED THEN
  5  UPDATE SET tr.condition_status = s.condition_status;

3 rows merged.

69. Updating test request status to COMPLETED using MERGE.

SQL> MERGE INTO test_request tr
  2  USING test_request src
  3  ON (tr.test_request_id = 'TR1' AND src.test_request_id = 'TR1')
  4  WHEN MATCHED THEN
  5  UPDATE SET tr.request_status = 'COMPLETED';

1 row merged.

70. Creating a savepoint named sp_test.

SQL> SAVEPOINT sp_test;

Savepoint created.

71. Updates quantity by adding 1 where quantity greater than 4 and displays sample table

SQL> UPDATE SAMPLE SET QUANTITY = QUANTITY + 1 WHERE QUANTITY > 4;

2 rows updated.

SQL> SELECT * FROM SAMPLE;

SAMPLE_ID  QUANTITY  CONDITION_STATUS  CONTAINER_NUMBER  SAMPLE_TYPE  TRANSFORMER_ID
---------- --------- ----------------- ----------------- ------------ ---------------
SMP001     7         GOOD              CAN001            OIL          TRF001
SMP002     4         FAIR              CAN002            OIL          TRF002
SMP003     8         GOOD              CAN003            OIL          TRF003
SMP004     3         FAIR              CAN004            OIL          TRF002
SMP005     2         GOOD              CAN005            OIL          TRF003

5 rows selected.


72. Rolling back changes to savepoint sp_test.

SQL> ROLLBACK TO sp_test;

Rollback complete.

73. Displaying next Monday’s date.

SQL> SELECT DISTINCT NEXT_DAY(SYSDATE, 'MONDAY')
  2  FROM transformer;

NEXT_DAY(
---------
16-FEB-26

74. Displaying last day of current month using technician table.

SQL> SELECT DISTINCT LAST_DAY(SYSDATE)
  2  FROM technician;

LAST_DAY(
---------
28-FEB-26

75. Displaying tests started today.

SQL> SELECT *
  2  FROM test
  3  WHERE TRUNC(start_time) = TRUNC(SYSDATE);

TEST_ID  START_TIME   END_TIME     TEST_REQUEST_ID  TECHNICIAN_ID
-------  -----------  -----------  ---------------  -------------
TEST30   15-FEB-26    16-FEB-26    TR90             TECH2
TEST31   15-FEB-26    15-FEB-26    TR91             TECH4

76. Rounding request date to first day of month.

SQL> SELECT ROUND(request_date, 'MONTH')
  2  FROM test_request;

ROUND(REQ
---------
01-FEB-26
01-MAR-26
01-FEB-26

77. Calculating duration of each test in days.

SQL> SELECT test_id,
  2         end_time - start_time AS duration_days
  3  FROM test;

TEST_ID  DURATION_DAYS
-------  -------------
TEST30              1
TEST31              0
TEST32              2

78.Calculating warranty expiry date (24 months added).

SQL> SELECT transform_id,
  2         ADD_MONTHS(install_date, 24) AS warranty_expiry
  3  FROM transform;

TRANSFORM_ID  WARRANTY_EXPIRY
------------  ---------------
TR01          10-MAY-24
TR02          15-JUL-23
TR03          20-SEP-25

79.Calculating total months used since installation.

SQL> SELECT transformer_id,
  2         ROUND(MONTHS_BETWEEN(SYSDATE, install_date)) AS months_used
  3  FROM transform;

TRANSFORMER_ID  MONTHS_USED
--------------  -----------
TR01                     45
TR02                     62
TR03                     30

80. Displaying current date and time using CURRENT_TIMESTAMP.

SQL> SELECT DISTINCT CURRENT_TIMESTAMP
  2  FROM transformer;

CURRENT_TIMESTAMP
---------------------------------------------------------------------------
24-FEB-26 10.15.32.123000 AM +05:30

81. Displaying current session date using CURRENT_DATE.

SQL> SELECT DISTINCT CURRENT_DATE
  2  FROM transformer;

CURRENT_DATE
------------
24-FEB-26

82. Extracting year from install date.

SQL> SELECT transformer_id,
  2         EXTRACT(YEAR FROM install_date) AS install_year
  3  FROM transformer;

TRANSFORMER_ID  INSTALL_YEAR
--------------  ------------
TR01                    2022
TR02                    2018
TR03                    2020

83. Extracting month from request date.

SQL> SELECT test_request_id,
  2         EXTRACT(MONTH FROM request_date) AS request_month
  3  FROM test_request;

TEST_REQUEST_ID  REQUEST_MONTH
---------------  -------------
TR50                        2
TR51                        2
TR52                        3

84. Extracting day from start time.

SQL> SELECT test_id,
  2         EXTRACT(DAY FROM start_time) AS start_day
  3  FROM test;

TEST_ID  START_DAY
-------  ---------
TEST30         15
TEST31         15
TEST32         18

85. Truncating install date to month.

SQL> SELECT transformer_id,
  2         TRUNC(install_date, 'MM') AS install_month
  3  FROM transformer;

TRANSFORMER_ID  INSTALL_MONTH
--------------  -------------
TR01            01-MAY-22
TR02            01-JUL-18
TR03            01-SEP-20

86. Rounding install date to nearest year.

SQL> SELECT transformer_id,
  2         ROUND(install_date, 'YYYY') AS rounded_year
  3  FROM transformer;

TRANSFORMER_ID  ROUNDED_YEAR
--------------  ------------
TR01            01-JAN-22
TR02            01-JAN-18
TR03            01-JAN-21

87. Displaying install date in formatted string (YYYY-MM-DD).

SQL> SELECT transformer_id,
  2         TO_CHAR(install_date, 'YYYY-MM-DD') AS formatted_date
  3  FROM transformer;

TRANSFORMER_ID  FORMATTED_DATE
--------------  --------------
TR01            2022-05-10
TR02            2018-07-15
TR03            2020-09-20



80. Summing sample quantity grouped by type and condition.

SQL> SELECT sample_type, condition_status, SUM(quantity) AS total_quantity
  2  FROM sample
  3  GROUP BY sample_type, condition_status;

SAMPLE_TYPE  CONDITION_STATUS  TOTAL_QUANTITY
-----------  ----------------  --------------
OIL          NORMAL                       15
OIL          CONTAMINATED                  6
GAS          NORMAL                        4


81. Counting test requests grouped by year and priority.

SQL> SELECT EXTRACT(YEAR FROM request_date) AS request_year,
  2         priority,
  3         COUNT(*) AS total
  4  FROM test_request
  5  GROUP BY EXTRACT(YEAR FROM request_date), priority;

REQUEST_YEAR  PRIORITY  TOTAL
------------  --------  -----
        2025  HIGH          3
        2025  LOW           2
        2026  HIGH          1
        2026  MEDIUM        2

82. Counting test requests grouped by month and status.

SQL> SELECT TO_CHAR(request_date, 'MONTH') AS month_name,
  2         request_status,
  3         COUNT(*)
  4  FROM test_request
  5  GROUP BY TO_CHAR(request_date, 'MONTH'), request_status;

MONTH_NAME  REQUEST_STATUS  COUNT(*)
----------  --------------  --------tr

JANUARY     APPROVED               2
JANUARY     PENDING                1
FEBRUARY    COMPLETED              2
FEBRUARY    PENDING                1

83. Counting test requests grouped by priority and status.

SQL> SELECT priority, request_status, COUNT(*) AS total_requests
  2  FROM test_request
  3  GROUP BY priority, request_status
  4  ORDER BY priority;

PRIORITY  REQUEST_STATUS  TOTAL_REQUESTS
--------  --------------  --------------
HIGH      APPROVED                     2
HIGH      PENDING                      1
LOW       COMPLETED                    2
MEDIUM    PENDING                      1


85. Displaying ASCII value of character 'A'.

SQL> SELECT DISTINCT ASCII(SUBSTR(technician_id,1,1)) AS ASCII_VALUE
  2  FROM technician;

ASCII_VALUE
-----------
84

1 row selected.

89. Displaying ASCII value of oil_name.

SQL> SELECT oil_name,
  2         ASCII(oil_name) AS ASCII_VALUE
  3  FROM oil_type;

OIL_NAME             ASCII_VALUE
-------------------- -----------
Mineral Oil                   77
Transformer X                 84
Super Insul                   83
Power Oil                     80
Ultra Cool                    85

5 rows selected.

87. Displaying ASCII value of first letter of qualification.

SQL> SELECT DISTINCT ASCII(SUBSTR(qualification,1,1)) AS ASCII_VALUE
  2  FROM technician;

ASCII_VALUE
-----------
66
68
77

3 rows selected.

88. Rounding viscosity values.

SQL> SELECT ROUND(viscosity) FROM oil_type;

ROUND(VISCOSITY)
----------------
              13
              11
              10

89. Rounding viscosity to zero decimal places.

SQL> SELECT ROUND(viscosity, 1) FROM oil_type;

ROUND(VISCOSITY,1)
------------------
               13.1
               11.3
               10.5

90. Rounding fire point to 2 decimal places.

SQL> SELECT ROUND(fire_point, 2) FROM oil_type;

ROUND(FIRE_POINT,2)
-------------------
            250.56
            260.44
            245.78

91. Rounding flash point to nearest 10.

SQL> SELECT ROUND(flash_point, -1) FROM oil_type;

ROUND(FLASH_POINT,-1)
---------------------
                  150
                  160
                  150

92. Rounding flash point to nearest 100.

SQL> SELECT ROUND(flash_point, -2) FROM oil_type;

ROUND(FLASH_POINT,-2)
---------------------
                  200
                  200
                  100


93. Rounding fire point to nearest 1000.

SQL> SELECT ROUND(fire_point, -3) FROM oil_type;

ROUND(FIRE_POINT,-3)
--------------------
                   0
                   0
                   0

94. Truncating fire point values.

SQL> SELECT TRUNC(fire_point) FROM oil_type;

TRUNC(FIRE_POINT)
-----------------
              250
              260
              245

95. Truncating fire point to zero decimal places.

SQL> SELECT TRUNC(fire_point, 0) FROM oil_type;

TRUNC(FIRE_POINT,0)
-------------------
                250
                260
                245

96. Truncating fire point to one decimal place.

SQL> SELECT TRUNC(fire_point, 1) FROM oil_type;

TRUNC(FIRE_POINT,1)
-------------------
              250.5
              260.4
              245.7

97. Truncating fire point to two decimal places.

SQL> SELECT TRUNC(fire_point, 2) FROM oil_type;

TRUNC(FIRE_POINT,2)
-------------------
             250.56
             260.44
             245.78


98. Truncating flash point to three decimal places.

SQL> SELECT TRUNC(flash_point, 3) FROM oil_type;

TRUNC(FLASH_POINT,3)
--------------------
            150.567
            160.432
            148.999

99. Displaying distinct fire and flash point combinations.


SQL> SELECT fire_point, flash_point
  2  FROM oil_type
  3  GROUP BY fire_point, flash_point;

FIRE_POINT  FLASH_POINT
----------  -----------
     250.5        150.5
     260.0        160.0
     245.8        148.9

100. Displaying oil types with multiple numeric conditions.


SQL> SELECT *
  2  FROM oil_type
  3  WHERE viscosity > 10
  4  AND fire_point > 5
  5  AND flash_point > 3;

OIL_TYPE_ID  OIL_NAME       MANUFACTURER  VISCOSITY  FIRE_POINT  FLASH_POINT
-----------  -------------  ------------  ---------  ----------  -----------
O1           Mineral Oil    Shell           12.50      250.50      150.50
O3           Bio Oil        Total           11.20      245.80      148.90

101. Attempting to select columns using HAVING incorrectly (causes error).


SQL> SELECT technician_name, salary
  2  FROM technician
  3  HAVING MAX(salary);

SELECT technician_name, salary
*
ERROR at line 1:
ORA-00979: not a GROUP BY expression

102. Counting test requests grouped by priority and status.


SQL> SELECT priority, request_status, COUNT(*)
  2  FROM test_request
  3  GROUP BY priority, request_status;

PRIORITY  REQUEST_STATUS  COUNT(*)
--------  --------------  --------
HIGH      APPROVED               2
HIGH      PENDING                1
LOW       COMPLETED              2
MEDIUM    PENDING                1

103. Left-padding technician names to 20 characters.


SQL> SELECT LPAD(technician_name, 20, ' ') AS padded_name
  2  FROM technician;

PADDED_NAME
--------------------
               RAJA
              SURESH
               ANITA


104. Right-padding technician names with asterisks.

SQL> SELECT RPAD(technician_name, 20, '*') AS rpad_name
  2  FROM technician;

RPAD_NAME
--------------------
RAJA****************
SURESH**************
ANITA***************

105. Trimming spaces from both sides of oil_name column.

SQL> SELECT DISTINCT TRIM(oil_name)
  2  FROM oil_type;

TRIM(OIL_NAME)
--------------------
Mineral Oil
Transformer X
Super Insul
Power Oil
Ultra Cool

5 rows selected.

106. Removing leading spaces from a string.

106. Removing leading spaces from qualification column.

SQL> SELECT DISTINCT LTRIM(qualification)
  2  FROM technician;

LTRIM(QUALIFICATION)
--------------------
B.E
DIPLOMA
M.TECH

3 rows selected.

107. Removing trailing spaces from qualification column.

SQL> SELECT DISTINCT RTRIM(qualification)
  2  FROM technician;

RTRIM(QUALIFICATION)
--------------------
B.E
DIPLOMA
M.TECH

3 rows selected.

108. Replacing letter 'A' with 'B' in technician names.

SQL> SELECT REPLACE(technician_name, 'A', 'B')
  2  FROM technician;

REPLACE(TECHNICIAN_NAME,'A','B')
--------------------------------
RBJB
SURESH
BNITB

109. Replacing 'Raja' with 'Saila' in technician names.

SQL> SELECT REPLACE(technician_name, 'Raja', 'Saila')
  2  FROM technician;

REPLACE(TECHNICIAN_NAME,'RAJA','SAILA')
---------------------------------------
Saila
SURESH
ANITA

110. Attempting to get ASCII value from non-existing table (error).

SQL> SELECT ASCII(technician_name)
  2  FROM customer;

SELECT ASCII(technician_name)
*
ERROR at line 1:
ORA-00942: table or view does not exist

111. Deleting samples with quantity zero.

SQL> DELETE FROM sample
  2  WHERE quantity = 0;

2 rows deleted.

112. Deleting equipment with ID E9.

SQL> DELETE FROM equipment
  2  WHERE equipment_id = 'E9';

1 row deleted.

113. Updating technician experience using MERGE.

SQL> MERGE INTO technician t
  2  USING test tr
  3  ON (t.technician_id = tr.technician_id)
  4  WHEN MATCHED THEN
  5  UPDATE SET t.experience = t.experience + 1;

3 rows merged.

114. Updating transformer condition using MERGE.

SQL> MERGE INTO transformer tr
  2  USING sample s
  3  ON (tr.transformer_id = s.transformer_id)
  4  WHEN MATCHED THEN
  5  UPDATE SET tr.condition_status = s.condition_status;

2 rows merged.

115. Updating test request status using MERGE.

SQL> MERGE INTO test_request tr
  2  USING test_request src
  3  ON (tr.request_id = 'TR1' AND src.request_id = 'TR1')
  4  WHEN MATCHED THEN
  5  UPDATE SET tr.request_status = 'COMPLETED';

1 row merged.

116. Creating savepoint sp_test.

SQL> SAVEPOINT sp_test;

Savepoint created.

117. Increasing viscosity of all oil types.

SQL> UPDATE oil_type
  2  SET viscosity = viscosity + 1;

4 rows updated.

118. Rolling back to savepoint.

SQL> ROLLBACK TO sp_test;

Rollback complete.


119. Updating viscosity by 100 where conditions match (no rows affected).

SQL> UPDATE oil_type
  2  SET viscosity = viscosity + 100
  3  WHERE fire_point > 300
  4  AND oil_name LIKE '___';

0 rows updated.

120. Updating test request priority based on approval ID and status.


SQL> UPDATE test_request
  2  SET priority = 'HIGH'
  3  WHERE approval_id = 'TR3'
  4  AND request_status = 'PENDING';

1 row updated.

121. Updating transformer T102 condition to WARNING.

SQL> UPDATE transformer
  2  SET condition_status = 'WARNING'
  3  WHERE transformer_id = 'T102';

1 row updated.

122. Increasing experience of all technicians by 1 year.

SQL> UPDATE technician
  2  SET experience = experience + 1;

6 rows updated.

123. Updating HIGH priority test requests to APPROVED.

SQL> UPDATE test_request
  2  SET request_status = 'APPROVED'
  3  WHERE priority = 'HIGH';

3 rows updated.

124. Inserts multiple oil types into OIL_TYPE table

SQL> INSERT ALL
  2  INTO OIL_TYPE VALUES('OIL001','Mineral Oil','IOC',12.50,210.00,180.00)
  3  INTO OIL_TYPE VALUES('OIL002','Silicone Oil','HPCL',10.20,220.00,190.00)
  4  INTO OIL_TYPE VALUES('OIL003','Natural Ester','BPCL',9.80,230.00,200.00)
  5  SELECT * FROM DUAL;

3 rows created.

125. Attempts to insert duplicate primary key value into TRANSFORMER table

SQL> INSERT INTO TRANSFORMER VALUES('TRF001','GOOD',TO_DATE('15-FEB-2024','DD-MON-YYYY'));
INSERT INTO TRANSFORMER VALUES('TRF001','GOOD',TO_DATE('15-FEB-2024','DD-MON-YYYY'))
*
ERROR at line 1:
ORA-00001: unique constraint (C##RAJA.SYS_C001245) violated


126. Attempts to insert invalid condition_status violating CHECK constraint in TRANSFORMER table

SQL> INSERT INTO TRANSFORMER VALUES('TRF006','EXCELLENT',TO_DATE('10-FEB-2025','DD-MON-YYYY'));
INSERT INTO TRANSFORMER VALUES('TRF006','EXCELLENT',TO_DATE('10-FEB-2025','DD-MON-YYYY'))
*
ERROR at line 1:
ORA-02290: check constraint (C##RAJA.SYS_C001310) violated
SINCE CHECK CONSTRAINT SET TO ALLOW ONLY 'GOOD','FAIR','POOR'.

127. Attempts to add foreign key on SAMPLE referencing non-existing TRANSFORMER values

SQL> ALTER TABLE SAMPLE
  2  ADD CONSTRAINT FK_SAMPLE_TRANS
  3  FOREIGN KEY (TRANSFORMER_ID)
  4  REFERENCES TRANSFORMER(TRANSFORMER_ID);
ALTER TABLE SAMPLE
*
ERROR at line 1:
ORA-02298: cannot validate (C##RAJA.FK_SAMPLE_TRANS) - parent keys not found

128.Adds APPROVAL_DATE column to TEST_REQUEST table and displays structure

SQL> ALTER TABLE TEST_REQUEST ADD APPROVAL_DATE DATE;

Table altered.

SQL> DESC TEST_REQUEST;
 Name               Null?    Type
 ------------------ -------- ------------------
 TEST_REQUEST_ID    NOT NULL VARCHAR2(20)
 PRIORITY                    VARCHAR2(15)
 REQUEST_DATE                DATE
 REQUEST_STATUS              VARCHAR2(20)
 APPROVAL_ID                 VARCHAR2(20)
 APPROVAL_DATE               DATE

129. Adds RATING column to TECHNICIAN table and displays structure

SQL> ALTER TABLE TECHNICIAN ADD RATING NUMBER;

Table altered.

SQL> DESC TECHNICIAN;
 Name               Null?    Type
 ------------------ -------- ------------------
 TECHNICIAN_ID      NOT NULL VARCHAR2(20)
 QUALIFICATION               VARCHAR2(30)
 EXPERIENCE                  NUMBER
 EMAIL                       VARCHAR2(30)
 SKILLS                      VARCHAR2(50)
 PHONE_NO                    NUMBER
 HEAD_ID                     VARCHAR2(20)
 RATING                      NUMBER

130. Deletes records where transformer_id ends with '1' or quantity is greater than 4.

SQL> DELETE FROM SAMPLE_BACKUP 
  2  WHERE TRANSFORMER_ID LIKE '%1' 
  3  OR QUANTITY > 4;

3 rows deleted.

131. Deletes records where sample_type does not end with 'O'.

SQL> SELECT sample_id, sample_type
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    SAMPLE_TYPE
------------ ------------
S001         OIL
S002         GAS
S003         SILICO
S004         WATER
S005         DIELECTRICO

5 rows selected.


SQL> DELETE FROM SAMPLE_BACKUP
  2  WHERE SAMPLE_TYPE NOT LIKE '%O';

2 rows deleted.


SQL> SELECT sample_id, sample_type
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    SAMPLE_TYPE
------------ ------------
S003         SILICO
S005         DIELECTRICO
S001         OIL

3 rows selected.

132. Deletes records where condition_status does not start with 'G'.

SQL> SELECT sample_id, condition_status
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    CONDITION_STATUS
------------ -----------------
S001         GOOD
S002         FAIR
S003         GOOD
S004         CRITICAL

4 rows selected.


SQL> DELETE FROM SAMPLE_BACKUP
  2  WHERE CONDITION_STATUS NOT LIKE 'G%';

2 rows deleted.


SQL> SELECT sample_id, condition_status
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    CONDITION_STATUS
------------ -----------------
S001         GOOD
S003         GOOD

2 rows selected.

133. Deletes records where sample_id does not match pattern '_MP%'.

SQL> SELECT sample_id, sample_type
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    SAMPLE_TYPE
------------ ------------
AMP101       OIL
BMP202       GAS
CMP303       OIL
TMP404       WATER

4 rows selected.


SQL> DELETE FROM SAMPLE_BACKUP
  2  WHERE SAMPLE_ID NOT LIKE '_MP%';

1 row deleted.


SQL> SELECT sample_id, sample_type
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    SAMPLE_TYPE
------------ ------------
AMP101       OIL
BMP202       GAS
CMP303       OIL

3 rows selected.

134. Deletes rows from SAMPLE_BACKUP where sample_id NOT LIKE 'S_0%'.

SQL> SELECT sample_id, sample_type
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    SAMPLE_TYPE
------------ ------------
S_001        OIL
S_002        GAS
S_010        WATER
S_105        SILICO
A_001        OIL

5 rows selected.


SQL> DELETE FROM SAMPLE_BACKUP
  2  WHERE SAMPLE_ID NOT LIKE 'S_0%';

2 rows deleted.


SQL> SELECT sample_id, sample_type
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    SAMPLE_TYPE
------------ ------------
S_001        OIL
S_002        GAS
S_010        WATER

3 rows selected.

135. Deletes records where transformer_id does not end with '1' and quantity is greater than 3.

SQL> SELECT sample_id, transformer_id, quantity
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    TRANSFORMER_ID    QUANTITY
------------ ------------------ ----------
S001         TR101                      2
S002         TR102                      5
S003         TR103                      4
S004         TR111                      6

4 rows selected.


SQL> DELETE FROM SAMPLE_BACKUP
  2  WHERE TRANSFORMER_ID NOT LIKE '%1'
  3  AND QUANTITY > 3;

1 row deleted.


SQL> SELECT sample_id, transformer_id, quantity
  2  FROM SAMPLE_BACKUP;

SAMPLE_ID    TRANSFORMER_ID    QUANTITY
------------ ------------------ ----------
S001         TR101                      2
S003         TR103                      4
S004         TR111                      6

3 rows selected.

136. Categorizing transformer condition using DECODE.

SQL> SELECT transformer_id,
  2         condition_status,
  3         DECODE(condition_status,
  4                'GOOD', 'WORKING',
  5                'DAMAGED', 'REPAIR REQUIRED',
  6                'REPLACED', 'NEW UNIT',
  7                'UNKNOWN') AS STATUS_REMARK
  8  FROM transformer;

TRANSFORMER_ID  CONDITION_STATUS  STATUS_REMARK
--------------  -----------------  ----------------
TR01            GOOD               WORKING
TR02            DAMAGED            REPAIR REQUIRED
TR03            REPLACED           NEW UNIT
TR04            OLD                UNKNOWN

4 rows selected.

137. Categorizing test request priority using DECODE.

SQL> SELECT test_request_id,
  2         priority,
  3         DECODE(priority,
  4                'HIGH', 'URGENT',
  5                'MEDIUM', 'NORMAL',
  6                'LOW', 'NOT URGENT',
  7                'UNSPECIFIED') AS PRIORITY_LEVEL
  8  FROM test_request;

TEST_REQUEST_ID  PRIORITY  PRIORITY_LEVEL
---------------  --------  --------------
TR50             HIGH      URGENT
TR51             LOW       NOT URGENT
TR52             MEDIUM    NORMAL

4 rows selected.

138. Categorizing technician experience using DECODE.

SQL> SELECT technician_id,
  2         experience,
  3         DECODE(experience,
  4                0, 'FRESHER',
  5                1, 'JUNIOR',
  6                5, 'SENIOR',
  7                'EXPERIENCED') AS EXPERIENCE_LEVEL
  8  FROM technician;

TECHNICIAN_ID  EXPERIENCE  EXPERIENCE_LEVEL
-------------  ----------  ----------------
TECH1                   0  FRESHER
TECH2                   1  JUNIOR
TECH3                   5  SENIOR
TECH4                   3  EXPERIENCED

4 rows selected.

139. Calculating median testing cost.

SQL> SELECT MEDIAN(testing_cost)
  2  FROM test_type;

MEDIAN(TESTING_COST)
--------------------
               5000


140. Calculating variance of testing cost.

SQL> SELECT VARIANCE(testing_cost)
  2  FROM test_type;

VARIANCE(TESTING_COST)
----------------------
           1250000


141. Calculating standard deviation of testing cost.

SQL> SELECT STDDEV(testing_cost)
  2  FROM test_type;

STDDEV(TESTING_COST)
--------------------
               1118


142. Displaying transformers ordered by transformer ID.

SQL> SELECT *
  2  FROM transformer
  3  ORDER BY transformer_id;

TRANSFORMER_ID  CONDITION_STATUS  INSTALL_DATE
--------------  -----------------  ------------
TR01            GOOD               10-MAY-22
TR02            DAMAGED            15-JUL-18
TR03            REPLACED           20-SEP-20
TR04            GOOD               05-JAN-22

4 rows selected.

143. Displaying test requests ordered by request date in ascending order.

SQL> SELECT *
  2  FROM test_request
  3  ORDER BY request_date ASC;

TEST_REQUEST_ID  PRIORITY  REQUEST_DATE  REQUEST_STATUS  APPROVAL_ID
---------------  --------  ------------  --------------  -----------
TR50             HIGH      15-FEB-26     PENDING         AP50
TR52             MEDIUM    20-FEB-26     APPROVED        AP52
TR51             LOW       01-MAR-26     APPROVED        AP51

3 rows selected.

144. Displaying technicians ordered by technician ID in descending order.

SQL> SELECT *
  2  FROM technician
  3  ORDER BY technician_id DESC;

TECHNICIAN_ID  QUALIFICATION  EXPERIENCE  EMAIL            SKILLS        PHONE_NO   HEAD_ID
-------------  -------------  ----------  ---------------  ------------  ---------  --------
TECH4          DIPLOMA                 3  tech4@mail.com  TESTING       987654324  TECH2
TECH3          M.E                     5  tech3@mail.com  ANALYSIS      987654323  TECH1
TECH2          B.E                     1  tech2@mail.com  MAINTENANCE   987654322  TECH1
TECH1          B.E                     0  tech1@mail.com  INSPECTION    987654321

4 rows selected.

145. Displaying test types ordered by standard and testing cost in descending order.

SQL> SELECT *
  2  FROM test_type
  3  ORDER BY standard, testing_cost DESC;

TEST_TYPE_ID  DURATION  TESTING_COST  STANDARD   METHOD        DESCRIPTION
------------  --------  ------------  ---------  ------------  -----------------------
TT01                 2          7000  IEC        CHEMICAL      Oil Quality Test
TT03                 3          5000  IEC        ELECTRICAL    Breakdown Voltage Test
TT02                 1          3000  IS         PHYSICAL      Moisture Test
TT04                 4          2000  IS         THERMAL       Heat Stability Test

4 rows selected.

146. Displaying test types ordered by standard and testing cost in ascending order.

SQL> SELECT *
  2  FROM test_type
  3  ORDER BY standard, testing_cost ASC;

TEST_TYPE_ID  DURATION  TESTING_COST  STANDARD   METHOD        DESCRIPTION
------------  --------  ------------  ---------  ------------  -----------------------
TT03                 3          5000  IEC        ELECTRICAL    Breakdown Voltage Test
TT01                 2          7000  IEC        CHEMICAL      Oil Quality Test
TT04                 4          2000  IS         THERMAL       Heat Stability Test
TT02                 1          3000  IS         PHYSICAL      Moisture Test

4 rows selected.

147. Counting total transformers.

SQL> SELECT COUNT(*)
  2  FROM transformer;

  COUNT(*)
----------
         4



148. Counting transformers with condition status.

SQL> SELECT COUNT(condition_status)
  2  FROM transformer;

COUNT(CONDITION_STATUS)
-----------------------
                      4


149. Counting transformers with condition status.

SQL> SELECT COUNT(condition_status)
  2  FROM transformer;

COUNT(CONDITION_STATUS)
-----------------------
                      4


155. Converts DATE to string using TO_CHAR on install_date column.

SQL> SELECT transformer_id,
  2         TO_CHAR(install_date,'DD-MON-YYYY') AS FORMATTED_DATE
  3  FROM transformer;

TRANSFORMER_ID      FORMATTED_DATE
-------------------- ----------------
TR101               12-JAN-2021
TR102               15-MAR-2018
TR103               20-JUN-2019
TR104               05-FEB-2022

4 rows selected.

TO DATE

154. Converts string to DATE using TO_DATE on install_date comparison.

SQL> SELECT transformer_id, install_date
  2  FROM transformer
  3  WHERE install_date = TO_DATE('15-03-2018','DD-MM-YYYY');

TRANSFORMER_ID      INSTALL_DATE
-------------------- ------------
TR102               15-MAR-18

1 row selected.

COLUMN RENAME WITH AS

156. Renames columns using SELECT with AS keyword.

SQL> SELECT technician_id AS TECH_ID,
  2         qualification AS QUAL,
  3         experience AS YEARS_OF_EXP
  4  FROM technician;

TECH_ID     QUAL        YEARS_OF_EXP
----------  ----------  ------------
TECH001     B.E                 12
TECH002     DIPLOMA              3
TECH003     M.TECH              14
TECH004     B.E                  6
TECH005     DIPLOMA             15
TECH006     M.TECH               4
TECH007     B.E                 15
TECH008     M.TECH               5

8 rows selected.


COLUMN RNAME WITH AS
157. Renames computed column using AS keyword.

SQL> SELECT oil_name,
  2         viscosity * 10 AS VISCOSITY_SCALE
  3  FROM oil_type;

OIL_NAME             VISCOSITY_SCALE
-------------------- ----------------
Mineral Oil                  125
Transformer X                132
Super Insul                   98
Power Oil                    214
Ultra Cool                   187

5 rows selected.

CONCAD WITH CONCAT FUNCTION

158. Concatenates technician_id and qualification using CONCAT function.

SQL> SELECT CONCAT(technician_id, qualification) AS TECH_INFO
  2  FROM technician;

TECH_INFO
------------------------
TECH001B.E
TECH002DIPLOMA
TECH003M.TECH
TECH004B.E
TECH005DIPLOMA
TECH006M.TECH
TECH007B.E
TECH008M.TECH

8 rows selected.

159. Concatenates oil_name and manufacturer using nested CONCAT function.

SQL> SELECT CONCAT(CONCAT(oil_name,' - '), manufacturer) AS OIL_DETAILS
  2  FROM oil_type;

OIL_DETAILS
--------------------------------
Mineral Oil - Shell
Transformer X - BP
Super Insul - HP
Power Oil - IOCL
Ultra Cool - Castrol

5 rows selected.
