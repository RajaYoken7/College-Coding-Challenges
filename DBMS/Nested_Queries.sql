1)Find the technician who has the highest experience in the technician table.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience = (
  4      SELECT MAX(experience)
  5      FROM technician
  6  );

TECHNICIAN_ID EXPERIENCE
---
105                  15

1 row selected.

2)Find transformers that have the same condition status as transformers installed before January 1, 2020.

SQL> SELECT transformer_id, condition_status
  2  FROM transformer
  3  WHERE condition_status IN (
  4      SELECT condition_status
  5      FROM transformer
  6      WHERE install_date < DATE '2020-01-01'
  7  );

TRANSFORMER_ID CONDITION_STATUS
---
201            GOOD
203            GOOD
204            NEEDS_SERVICE
207            NEEDS_SERVICE

4 rows selected.

3)Find technicians who have the same qualification as technician TECH001.

SQL> SELECT technician_id, qualification
  2  FROM technician
  3  WHERE qualification IN (
  4      SELECT qualification
  5      FROM technician
  6      WHERE technician_id = 'TECH001'
  7  );

TECHNICIAN_ID QUALIFICATION
---
TECH001       B.E
TECH004       B.E
TECH007       B.E

3 rows selected.

4)Find technicians whose experience is less than any technician who has more than 5 years of experience.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience < ANY (
  4      SELECT experience
  5      FROM technician
  6      WHERE experience > 5
  7  );

TECHNICIAN_ID EXPERIENCE
---
TECH002               3
TECH003               5
TECH005               4

3 rows selected.

5)Find technicians whose experience is less than every technician who has more than 5 years of experience.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience < ALL (
  4      SELECT experience
  5      FROM technician
  6      WHERE experience > 5
  7  );

TECHNICIAN_ID EXPERIENCE
---
TECH002               3
TECH003               5
TECH005               4

3 rows selected.

6)Find test types whose testing cost is greater than all test types that cost more than 1000.

SQL> SELECT testing_cost, test_type_id
  2  FROM test_type
  3  WHERE testing_cost > ALL (
  4      SELECT testing_cost
  5      FROM test_type
  6      WHERE testing_cost > 1000
  7  );

TESTING_COST TEST_TYPE_ID
---
        2500 TT05

1 row selected.

7)Find samples whose transformer ID and condition status match those of transformers that are in ACTIVE condition.

SQL> SELECT s.sample_id, s.transformer_id
  2  FROM sample s
  3  WHERE (s.transformer_id, s.condition_status) IN (
  4      SELECT t.transformer_id, t.condition_status
  5      FROM transformer t
  6      WHERE t.condition_status = 'ACTIVE'
  7  );

SAMPLE_ID TRANSFORMER_ID
---
S001      TR101
S003      TR103
S006      TR105
S008      TR107

4 rows selected.

8)Find technicians whose head (supervisor) has the same email domain association recorded as the technician, by matching the head ID and email through a multi-column subquery.


SQL> SELECT t1.technician_id, t1.head_id
  2  FROM technician t1
  3  WHERE (t1.head_id, t1.email) IN (
  4      SELECT t2.technician_id, t2.email
  5      FROM technician t2
  6      WHERE t1.head_id = t2.technician_id
  7  );

TECHNICIAN_ID HEAD_ID
---
TECH004       TECH001
TECH006       TECH003
TECH008       TECH003

3 rows selected.


9)Find technicians whose experience is less than the experience of their head (supervisor).

SQL> SELECT t1.technician_id, t1.experience
  2  FROM technician t1
  3  WHERE t1.experience < (
  4      SELECT t2.experience
  5      FROM technician t2
  6      WHERE t1.head_id = t2.technician_id
  7  );

TECHNICIAN_ID EXPERIENCE
---
TECH004               6
TECH006               4
TECH008               5

3 rows selected.

10)Update the experience of technician TECH005 to 15 years.

SQL> UPDATE technician
  2  SET experience = 15
  3  WHERE technician_id = 'TECH005';

1 row updated.

11) Find technicians whose experience is greater than the average experience 
    of technicians having the same qualification.

SQL> SELECT technician_id, qualification, experience
  2  FROM technician t1
  3  WHERE experience > (
  4      SELECT AVG(t2.experience)
  5      FROM technician t2
  6      WHERE t2.qualification = t1.qualification
  7  );

TECHNICIAN_ID QUALIFICATION        EXPERIENCE
-------------------- -------------------- ----------
TECH005       DIPLOMA                     15
TECH007       B.E                         15

2 rows selected.

12)List the total number of transformers in each condition status.

SQL> SELECT condition_status, COUNT(*) AS total_transformers
  2  FROM (
  3      SELECT condition_status
  4      FROM transformer
  5  ) t
  6  GROUP BY condition_status;

CONDITION_STATUS TOTAL_TRANSFORMERS
---
ACTIVE                            4
GOOD                              3
NEEDS_SERVICE                     2
INACTIVE                          1

4 rows selected.

13)For each technician, display their experience and the average experience of technicians with the same qualification.

SQL> SELECT t1.technician_id,
  2         t1.qualification,
  3         t1.experience,
  4         (SELECT AVG(t2.experience)
  5          FROM technician t2
  6          WHERE t2.qualification = t1.qualification) AS avg_qualification_experience
  7  FROM technician t1;

TECHNICIAN_ID QUALIFICATION        EXPERIENCE AVG_QUALIFICATION_EXPERIENCE
---
TECH001       B.E                          12                           11
TECH002       DIPLOMA                       3                            4
TECH003       M.TECH                       14                           13
TECH004       B.E                           6                           11
TECH005       DIPLOMA                      15                            4
TECH006       M.TECH                        4                           13
TECH007       B.E                          15                           11
TECH008       M.TECH                        5                           13

8 rows selected.

14)Find qualifications where the average experience of technicians is greater than the overall average experience of all technicians.

SQL> SELECT qualification, AVG(experience) AS avg_experience
  2  FROM technician
  3  GROUP BY qualification
  4  HAVING AVG(experience) > (
  5      SELECT AVG(experience)
  6      FROM technician
  7  );

QUALIFICATION        AVG_EXPERIENCE
---
B.E                              11
M.TECH                           13

2 rows selected.

15)Find technicians who have a head (supervisor), meaning their head ID exists as a technician ID in the technician table.

SQL> SELECT t1.technician_id, t1.head_id
  2  FROM technician t1
  3  WHERE EXISTS (
  4      SELECT 1
  5      FROM technician t2
  6      WHERE t1.head_id = t2.technician_id
  7  );

TECHNICIAN_ID HEAD_ID
---
TECH004       TECH001
TECH005       TECH001
TECH006       TECH003
TECH007       TECH001
TECH008       TECH003

5 rows selected.

16)Find technicians who share the same qualification with at least one other technician.

SQL> SELECT t1.technician_id, t1.qualification
  2  FROM technician t1
  3  WHERE EXISTS (
  4      SELECT 1
  5      FROM technician t2
  6      WHERE t1.qualification = t2.qualification
  7        AND t1.technician_id <> t2.technician_id
  8  );

TECHNICIAN_ID QUALIFICATION
---
TECH001       B.E
TECH002       DIPLOMA
TECH003       M.TECH
TECH004       B.E
TECH005       DIPLOMA
TECH006       M.TECH
TECH007       B.E
TECH008       M.TECH

8 rows selected.

17)Find technicians who do not have a head (supervisor), meaning their head ID does not exist in the technician table.

SQL> SELECT t1.technician_id, t1.head_id
  2  FROM technician t1
  3  WHERE NOT EXISTS (
  4      SELECT 1
  5      FROM technician t2
  6      WHERE t1.head_id = t2.technician_id
  7  );

TECHNICIAN_ID HEAD_ID
---
TECH001
TECH002
TECH003

3 rows selected.

18)First calculate the average experience of technicians, then find technicians whose experience is greater than the average experience.

SQL> WITH AvgExperience AS (
  2      SELECT AVG(experience) AS avg_exp
  3      FROM technician
  4  )
  5  SELECT technician_id, experience
  6  FROM technician
  7  WHERE experience > (
  8      SELECT avg_exp
  9      FROM AvgExperience
 10  );

18B) Using MIN – Find technicians whose experience is greater than the minimum experience.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience > (
  4      SELECT MIN(experience)
  5      FROM technician
  6  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH001                     12
TECH002                      3
TECH003                     14
TECH004                      6
TECH005                     15
TECH006                      4
TECH007                     15
TECH008                      5

8 rows selected.

18C) Using MAX – Find technicians whose experience is equal to the maximum experience.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience = (
  4      SELECT MAX(experience)
  5      FROM technician
  6  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH005                     15
TECH007                     15

2 rows selected.

18D) Using SUM – Find technicians whose experience is greater than 
      the total experience divided by total number of technicians.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience > (
  4      SELECT SUM(experience)/COUNT(*)
  5      FROM technician
  6  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH001                     12
TECH003                     14
TECH005                     15
TECH007                     15

4 rows selected.

18E) Using COUNT – Find technicians whose experience is greater than 
      the total number of technicians.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience > (
  4      SELECT COUNT(*)
  5      FROM technician
  6  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH001                     12
TECH003                     14
TECH005                     15
TECH007                     15

4 rows selected.



TECHNICIAN_ID EXPERIENCE
---
TECH001              12
TECH003              14
TECH005              15
TECH007              15

4 rows selected.

19)Display technicians whose experience is above the average experience and who belong to a qualification group that has more than two technicians.

SQL> WITH AvgExp AS (
  2      SELECT AVG(experience) AS avg_experience
  3      FROM technician
  4  ),
  5  QualifiedGroup AS (
  6      SELECT qualification
  7      FROM technician
  8      GROUP BY qualification
  9      HAVING COUNT(*) > 2
 10  )
 11  SELECT technician_id, experience, qualification
 12  FROM technician
 13  WHERE experience > (SELECT avg_experience FROM AvgExp)
 14  AND qualification IN (SELECT qualification FROM QualifiedGroup);

TECHNICIAN_ID EXPERIENCE QUALIFICATION
---
TECH001              12 B.E
TECH003              14 M.TECH
TECH007              15 B.E

3 rows selected.

20)Display technicians whose experience is above the average experience and whose qualification group contains more than two technicians.

SQL> WITH AvgExp AS (
  2      SELECT AVG(experience) AS avg_experience
  3      FROM technician
  4  ),
  5  QualCount AS (
  6      SELECT qualification, COUNT(*) AS qual_count
  7      FROM technician
  8      GROUP BY qualification
  9  )
 10  SELECT t1.technician_id,
 11         t1.experience,
 12         q.qualification,
 13         q.qual_count
 14  FROM technician t1
 15  JOIN QualCount q
 16    ON t1.qualification = q.qualification
 17  WHERE t1.experience > (SELECT avg_experience FROM AvgExp)
 18    AND q.qual_count > 2;

TECHNICIAN_ID EXPERIENCE QUALIFICATION        QUAL_COUNT
---
TECH001              12 B.E                           3
TECH003              14 M.TECH                        3
TECH007              15 B.E                           3

3 rows selected.

21)Display technician IDs of those with the qualification 'ELECTRICAL', along with the head ID of technician TECH003 using a scalar subquery.

SQL> SELECT technician_id,
  2         (SELECT head_id
  3          FROM technician
  4          WHERE technician_id = 'TECH003') AS head_of_tech003
  5  FROM technician
  6  WHERE qualification = 'B.E';

TECHNICIAN_ID HEAD_OF_TECH003
---
TECH001
TECH004
TECH007

3 rows selected.

22)Display technician IDs of those with the qualification 'MECHANICAL', along with the head ID of technician TECH001 using a scalar subquery.

SQL> SELECT technician_id,
  2         (SELECT head_id
  3          FROM technician
  4          WHERE technician_id = 'TECH001') AS supervisor_of_tech001
  5  FROM technician
  6  WHERE qualification = 'M.TECH';

TECHNICIAN_ID SUPERVISOR_OF_TECH001
---
TECH003
TECH006
TECH008

3 rows selected.

23)Find technicians whose experience is greater than the average experience of all technicians using a scalar subquery in the WHERE clause.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience > (
  4      SELECT AVG(experience)
  5      FROM technician
  6  );

TECHNICIAN_ID EXPERIENCE
---
TECH001              12
TECH003              14
TECH005              15
TECH007              15

4 rows selected.

24.Displays technicians having more experience than TECH003.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience > (
  4      SELECT experience
  5      FROM technician
  6      WHERE technician_id = 'TECH003'
  7  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH005                     15
TECH007                     12

2 rows selected.

25. Displays technicians whose experience is greater than or equal to the average experience.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience >= (
  4      SELECT AVG(experience)
  5      FROM technician
  6  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH002                     10
TECH005                     15
TECH007                     12

3 rows selected.

26. Displays technicians having less experience than TECH001.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience < (
  4      SELECT experience
  5      FROM technician
  6      WHERE technician_id = 'TECH001'
  7  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH003                      5
TECH004                      7

2 rows selected.

-- 
27. Displays all technicians since every experience is less than or equal to the maximum experience.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience <= (
  4      SELECT MAX(experience)
  5      FROM technician
  6  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH001                      8
TECH002                     10
TECH003                      5
TECH004                      7
TECH005                     15
TECH006                      9
TECH007                     12

7 rows selected.

28. Displays technicians whose qualification is not equal to TECH001.

SQL> SELECT technician_id, qualification
  2  FROM technician
  3  WHERE qualification <> (
  4      SELECT qualification
  5      FROM technician
  6      WHERE technician_id = 'TECH001'
  7  );

TECHNICIAN_ID       QUALIFICATION
-------------------- ------------------------------
TECH002              B.Tech
TECH003              Diploma
TECH004              Diploma
TECH006              B.Sc
TECH007              B.Tech

5 rows selected.

29. Displays technicians whose qualification matches those with experience greater than 10 years.

SQL> SELECT technician_id, qualification
  2  FROM technician
  3  WHERE qualification IN (
  4      SELECT qualification
  5      FROM technician
  6      WHERE experience > 10
  7  );

TECHNICIAN_ID       QUALIFICATION
-------------------- ------------------------------
TECH002              B.Tech
TECH005              M.Tech
TECH007              B.Tech

3 rows selected.

30.Displays technicians having experience greater than at least one B.E qualified technician.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience > ANY (
  4      SELECT experience
  5      FROM technician
  6      WHERE qualification = 'B.E'
  7  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH002                     10
TECH004                      7
TECH005                     15
TECH006                      9
TECH007                     12

5 rows selected.

31.Displays technicians whose experience is greater than or equal to all DIPLOMA qualified technicians.

 SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience >= ALL (
  4      SELECT experience
  5      FROM technician
  6      WHERE qualification = 'DIPLOMA'
  7  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH002                     10
TECH005                     15
TECH007                     12

3 rows selected.

32.Displays samples whose transformer_id and condition_status match records in transformer table.

SQL> SELECT sample_id, transformer_id
  2  FROM sample
  3  WHERE (transformer_id, condition_status) IN (
  4      SELECT transformer_id, condition_status
  5      FROM transformer
  6  );

SAMPLE_ID            TRANSFORMER_ID
-------------------- --------------------
S001                 T201
S003                 T203
S005                 T202

3 rows selected.

33. Displays technicians having maximum experience within each qualification.

SQL> SELECT technician_id
  2  FROM technician
  3  WHERE (qualification, experience) IN (
  4      SELECT qualification, MAX(experience)
  5      FROM technician
  6      GROUP BY qualification
  7  );

TECHNICIAN_ID
--------------------
TECH001
TECH002
TECH004
TECH005
TECH006

5 rows selected.

34. Displays technicians whose qualification and experience differ from TECH001.

SQL> SELECT technician_id
  2  FROM technician t1
  3  WHERE (t1.qualification, t1.experience) <> (
  4      SELECT qualification, experience
  5      FROM technician
  6      WHERE technician_id = 'TECH001'
  7  );

TECHNICIAN_ID
--------------------
TECH002
TECH003
TECH004
TECH005
TECH006
TECH007

6 rows selected.

35.Displays technicians whose qualification and experience are above the average experience.

 SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE (qualification, experience) IN (
  4      SELECT qualification, experience
  5      FROM technician
  6      WHERE experience > (
  7          SELECT AVG(experience)
  8          FROM technician
  9      )
 10  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH005                     15
TECH007                     12

2 rows selected.

36.Displays technicians who share the same qualification with at least one other technician.

 SQL> SELECT t1.technician_id
  2  FROM technician t1
  3  WHERE EXISTS (
  4      SELECT 1
  5      FROM technician t2
  6      WHERE t1.qualification = t2.qualification
  7      AND t1.technician_id <> t2.technician_id
  8  );

TECHNICIAN_ID
--------------------
TECH001
TECH002
TECH003
TECH004
TECH007

5 rows selected.

37. Displays transformers installed before 01-JAN-2020 with matching condition status and install date.

SQL> SELECT transformer_id, condition_status
  2  FROM transformer
  3  WHERE (condition_status, install_date) IN (
  4      SELECT condition_status, install_date
  5      FROM transformer
  6      WHERE install_date < DATE '2020-01-01'
  7  );

TRANSFORMER_ID      CONDITION_STATUS
-------------------- --------------------
T202                 FAIR
T203                 CRITICAL

2 rows selected.

38. Displays technicians whose (experience, qualification) is greater than or equal to TECH003.

SQL> SELECT technician_id
  2  FROM technician
  3  WHERE (experience, qualification) >= (
  4      SELECT experience, qualification
  5      FROM technician
  6      WHERE technician_id = 'TECH003'
  7  );

TECHNICIAN_ID
--------------------
TECH001
TECH002
TECH003
TECH004
TECH005
TECH006
TECH007

7 rows selected.

39) Find technicians whose qualification is not the same as TECH001 using NOT IN.

SQL> SELECT technician_id, qualification
  2  FROM technician
  3  WHERE qualification NOT IN (
  4      SELECT qualification
  5      FROM technician
  6      WHERE technician_id = 'TECH001'
  7  );

TECHNICIAN_ID       QUALIFICATION
-------------------- --------------------
TECH002              DIPLOMA
TECH003              M.TECH
TECH005              DIPLOMA
TECH006              M.TECH
TECH008              M.TECH

5 rows selected.

DELETE with subquery

40) Delete technicians whose experience is less than the average experience.

SQL> DELETE FROM technician
  2  WHERE experience < (
  3      SELECT AVG(experience)
  4      FROM technician
  5  );

3 rows deleted.

INSERT with subquery

41) Insert into senior_technician table the technicians whose experience is greater than 10 years using a subquery.

SQL> INSERT INTO senior_technician (technician_id, experience)
  2  SELECT technician_id, experience
  3  FROM technician
  4  WHERE experience > (
  5      SELECT 10 FROM dual
  6  );

2 rows created.

HAVING with nested aggregate condition
42) Find qualifications whose average experience is greater than 
    the minimum experience of technicians in qualification 'B.E'.

SQL> SELECT qualification, AVG(experience)
  2  FROM technician
  3  GROUP BY qualification
  4  HAVING AVG(experience) > (
  5      SELECT MIN(experience)
  6      FROM technician
  7      WHERE qualification = 'B.E'
  8  );

QUALIFICATION        AVG(EXPERIENCE)
-------------------- ---------------
B.E                              11
M.TECH                           13

2 rows selected.

Multi-column NOT IN with GROUP BY
43) Display technicians whose (qualification, experience) 
    do NOT match maximum experience within each qualification.

SQL> SELECT technician_id
  2  FROM technician
  3  WHERE (qualification, experience) NOT IN (
  4      SELECT qualification, MAX(experience)
  5      FROM technician
  6      GROUP BY qualification
  7  );

TECHNICIAN_ID
--------------------
TECH004
TECH006
TECH008

3 rows selected.

Aggregate with conditional filter inside subquery

44) Find technicians whose experience is greater than 
    the average experience of technicians who have a head.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience > (
  4      SELECT AVG(experience)
  5      FROM technician
  6      WHERE head_id IS NOT NULL
  7  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH003                     14
TECH005                     15
TECH007                     15

3 rows selected.

MAX inside filtered subquery
45) Find technicians whose experience is greater than 
    the maximum experience among technicians having 
    qualification 'DIPLOMA'.

SQL> SELECT technician_id, experience
  2  FROM technician
  3  WHERE experience > (
  4      SELECT MAX(experience)
  5      FROM technician
  6      WHERE qualification = 'DIPLOMA'
  7  );

TECHNICIAN_ID       EXPERIENCE
-------------------- ----------
TECH005                     15

1 row selected.

