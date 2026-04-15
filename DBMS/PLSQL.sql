1.  Update condition status of a transformer with id TR001 using a PL/SQL block.

SQL> SELECT transformer_id, condition_status 
  2  FROM transformer 
  3  WHERE transformer_id='TR001';

TRANSFORMER_ID      CONDITION_STATUS
------------------  ----------------
TR001               GOOD


SQL> BEGIN
  2  UPDATE transformer
  3  SET condition_status='MAINTENANCE'
  4  WHERE transformer_id='TR001';
  5  DBMS_OUTPUT.PUT_LINE('Transformer TR001 condition updated to MAINTENANCE');
  6  COMMIT;
  7  END;
  8  /

Transformer TR001 condition updated to MAINTENANCE

PL/SQL procedure successfully completed.


SQL> SELECT transformer_id, condition_status
  2  FROM transformer
  3  WHERE transformer_id='TR001';

TRANSFORMER_ID      CONDITION_STATUS
------------------  ----------------
TR001               MAINTENANCE

2. Insert a new transformer record using a PL/SQL block.


SQL> SELECT * FROM transformer WHERE transformer_id='TR010';

no rows selected


SQL> DECLARE
  2  v_id transformer.transformer_id%TYPE;
  3  v_status transformer.condition_status%TYPE;
  4  BEGIN
  5  v_id := 'TR010';
  6  v_status := 'GOOD';
  7  INSERT INTO transformer(transformer_id, condition_status, install_date)
  8  VALUES(v_id, v_status, SYSDATE);
  9  DBMS_OUTPUT.PUT_LINE('Inserted successfully ' || v_id);
 10  END;
 11  /

Inserted successfully TR010

PL/SQL procedure successfully completed.


SQL> SELECT transformer_id, condition_status, install_date 
  2  FROM transformer 
  3  WHERE transformer_id='TR010';

TRANSFORMER_ID      CONDITION_STATUS      INSTALL_DATE
------------------  -------------------   ------------
TR010               GOOD                  17-MAR-26

3. Display the total testing cost of all test types.


SQL> DECLARE
  2  s_sum NUMBER;
  3  BEGIN
  4  SELECT SUM(testing_cost) INTO s_sum FROM test_type;
  5  DBMS_OUTPUT.PUT_LINE('The total testing cost is: ' || s_sum);
  6  END;
  7  /

The total testing cost is:4500

PL/SQL procedure successfully completed.

4. Display details of a transformer using %ROWTYPE.


SQL> DECLARE
  2  r_details transformer%ROWTYPE;
  3  BEGIN
  4  SELECT * INTO r_details
  5  FROM transformer
  6  WHERE transformer_id='TR001';
  7  DBMS_OUTPUT.PUT_LINE('TRANSFORMER_ID:'||r_details.transformer_id);
  8  DBMS_OUTPUT.PUT_LINE('STATUS:'||r_details.condition_status);
  9  DBMS_OUTPUT.PUT_LINE('INSTALL_DATE:'||r_details.install_date);
 10  END;
 11  /

TRANSFORMER_ID:TR001
STATUS:MAINTENANCE
INSTALL_DATE:10-JAN-22

PL/SQL procedure successfully completed.

5. Display transformer details using TYPE RECORD.


SQL> DECLARE
  2      TYPE v_record IS RECORD(
  3      v_id transformer.transformer_id%TYPE,
  4      v_status transformer.condition_status%TYPE,
  5      v_date transformer.install_date%TYPE
  6      );
  7      vv_record v_record;
  8  BEGIN
  9      SELECT transformer_id, condition_status, install_date
 10      INTO vv_record
 11      FROM transformer
 12      WHERE transformer_id='TR001';
 13      DBMS_OUTPUT.PUT_LINE('TRANSFORMER_ID:'||vv_record.v_id);
 14      DBMS_OUTPUT.PUT_LINE('STATUS:'||vv_record.v_status);
 15      DBMS_OUTPUT.PUT_LINE('INSTALL_DATE:'||vv_record.v_date);
 16  END;
 17  /

TRANSFORMER_ID:TR001
STATUS:MAINTENANCE
INSTALL_DATE:10-JAN-22

PL/SQL procedure successfully completed.

6. Display transformer id and status using an explicit cursor.


SQL> DECLARE
  2     v_record transformer%ROWTYPE;
  3
  4     CURSOR c_cursor IS
  5     SELECT transformer_id, condition_status
  6     FROM transformer
  7     WHERE transformer_id = 'TR001';
  8
  9  BEGIN
 10     OPEN c_cursor;
 11
 12     FETCH c_cursor INTO v_record;
 13
 14     DBMS_OUTPUT.PUT_LINE('TRANSFORMER_ID: ' || v_record.transformer_id);
 15     DBMS_OUTPUT.PUT_LINE('STATUS: ' || v_record.condition_status);
 16
 17     CLOSE c_cursor;
 18  END;
 19  /

TRANSFORMER_ID:TR001
STATUS:MAINTENANCE

PL/SQL procedure successfully completed.

7. Display transformer id and status using an implicit cursor.


SQL> DECLARE
  2     v_id VARCHAR2(20);
  3     v_status VARCHAR2(20);
  4  BEGIN
  5     SELECT transformer_id, condition_status
  6     INTO v_id, v_status
  7     FROM transformer
  8     WHERE transformer_id='TR001';
  9     DBMS_OUTPUT.PUT_LINE('TRANSFORMER_ID:'||v_id);
 10     DBMS_OUTPUT.PUT_LINE('STATUS:'||v_status);
 11  END;
 12  /

TRANSFORMER_ID:TR001
STATUS:MAINTENANCE

PL/SQL procedure successfully completed.

8. Demonstrate explicit cursor attributes using technician table.


SQL> DECLARE
  2     v_rec technician%ROWTYPE;
  3
  4     CURSOR c_cursor IS
  5     SELECT technician_id, email FROM technician;
  6
  7  BEGIN
  8     OPEN c_cursor;
  9
 10     LOOP
 11        FETCH c_cursor INTO v_rec;
 12        EXIT WHEN c_cursor%NOTFOUND;
 13
 14        DBMS_OUTPUT.PUT_LINE('Fetched: ' || v_rec.technician_id);
 15     END LOOP;
 16
 17     IF c_cursor%ISOPEN THEN
 18        DBMS_OUTPUT.PUT_LINE('Cursor open');
 19     ELSE
 20        DBMS_OUTPUT.PUT_LINE('Cursor not open');
 21     END IF;
 22
 23     DBMS_OUTPUT.PUT_LINE('The no of rows fetched: ' || c_cursor%ROWCOUNT);
 24
 25     CLOSE c_cursor;
 26
 27     IF c_cursor%ISOPEN THEN
 28        DBMS_OUTPUT.PUT_LINE('Cursor open');
 29     ELSE
 30        DBMS_OUTPUT.PUT_LINE('Cursor not open');
 31     END IF;
 32
 33  END;
 34  /

First row fetched TECH01
Second row fetched TECH02
Cursor open
The no of rows fetched:2
Cursor not open

PL/SQL procedure successfully completed.

11. Check technician experience and classify using IF, ELSIF, ELSE.

SQL> DECLARE
  2     CURSOR c_cursor IS
  3     SELECT technician_id, experience FROM technician;
  4  BEGIN
  5     FOR rec IN c_cursor LOOP
  6        IF rec.experience < 5 THEN
  7           DBMS_OUTPUT.PUT_LINE('TECHNICIAN:'||rec.technician_id||' ||EXP:'||rec.experience||'|| JUNIOR');
  8        ELSIF rec.experience > 5 AND rec.experience <= 10 THEN
  9           DBMS_OUTPUT.PUT_LINE('TECHNICIAN:'||rec.technician_id||' ||EXP:'||rec.experience||'|| MID LEVEL');
 10        ELSE
 11           DBMS_OUTPUT.PUT_LINE('TECHNICIAN:'||rec.technician_id||' ||EXP:'||rec.experience||'|| SENIOR');
 12        END IF;
 13     END LOOP;
 14  END;
 15  /

TECHNICIAN:TECH01 ||EXP:3|| JUNIOR
TECHNICIAN:TECH02 ||EXP:7|| MID LEVEL
TECHNICIAN:TECH03 ||EXP:12|| SENIOR
TECHNICIAN:TECH04 ||EXP:4|| JUNIOR

PL/SQL procedure successfully completed.

12. Print numbers 1 to 5 using LOOP and EXIT WHEN.


SQL> DECLARE
  2  n NUMBER :=1;
  3  BEGIN
  4  LOOP
  5     DBMS_OUTPUT.PUT_LINE('Number '|| n);
  6     n := n + 1;
  7     EXIT WHEN n > 5;
  8  END LOOP;
  9  END;
 10  /

Number 1
Number 2
Number 3
Number 4
Number 5

PL/SQL procedure successfully completed.

13. Print n × n star pattern using FOR loop.


SQL> DECLARE
  2  n NUMBER;
  3  BEGIN
  4  n := &n;
  5  FOR i IN 1..n LOOP
  6     FOR j IN 1..n LOOP
  7        DBMS_OUTPUT.PUT('* ');
  8     END LOOP;
  9     DBMS_OUTPUT.NEW_LINE;
 10  END LOOP;
 11  END;
 12  /

Enter value for n: 3
old   4: n :=&n;
new   4: n :=3;
* * *
* * *
* * *

PL/SQL procedure successfully completed.

14. Display test ids in steps of 2 using FOR loop with BY keyword.


SQL> DECLARE
 2  n NUMBER;
 3  BEGIN
 4  n := &n;
 5  DBMS_OUTPUT.PUT('Test numbers between 0 and '||n||' are:');
 6  FOR i IN 0..n BY 2 LOOP
 7      DBMS_OUTPUT.PUT(i||' ');
 8  END LOOP;
 9  DBMS_OUTPUT.NEW_LINE;
10  END;
11  /

Enter value for n: 10
old   4: n :=&n;
new   4: n :=10;
Test numbers between 0 and 10 are:0 2 4 6 8 10

PL/SQL procedure successfully completed.

15. Print even numbers in a range without using BY keyword.


SQL> DECLARE
  2     n NUMBER;
  3  BEGIN
  4     n := &n;
  5     DBMS_OUTPUT.PUT('Even numbers between 0 and '||n||' are: ');
  6     FOR i IN 0..n LOOP
  7         IF MOD(i,2)=0 THEN
  8            DBMS_OUTPUT.PUT(i||' ');
  9         END IF;
 10     END LOOP;
 11     DBMS_OUTPUT.NEW_LINE;
 12  END;
 13  /

Enter value for n: 10
old   4: n :=&n;
new   4: n :=10;
Even numbers between 0 and 10 are: 0 2 4 6 8 10

PL/SQL procedure successfully completed.

16. Find factorial of a number using WHILE loop.


SQL> DECLARE
  2  v_num NUMBER;
  3  v NUMBER;
  4  ans NUMBER :=1;
  5  BEGIN
  6  v_num := &v_num;
  7  v := v_num;
  8  WHILE v_num > 0 LOOP
  9     ans := ans * v_num;
 10     v_num := v_num - 1;
 11  END LOOP;
 12  DBMS_OUTPUT.PUT_LINE('Factorial of '||v||' is '||ans);
 13  END;
 14  /

Enter value for v_num: 5
old   6: v_num :=&v_num;
new   6: v_num :=5;
Factorial of 5 is 120

PL/SQL procedure successfully completed.

Enter value for v_num: 6
old   6: v_num :=&v_num;
new   6: v_num :=6;
Factorial of 6 is 720

PL/SQL procedure successfully completed.

17. Display all technician ids and experience using explicit cursor in FOR loop.


SQL> DECLARE
  2  v_id VARCHAR2(20);
  3  v_exp NUMBER;
  4  CURSOR c_cursor IS SELECT * FROM technician;
  5  BEGIN
  6  FOR i IN c_cursor LOOP
  7      DBMS_OUTPUT.PUT_LINE('TECHNICIAN_ID:'||i.technician_id||'  EXPERIENCE:'||i.experience);
  8  END LOOP;
  9  END;
 10  /

TECHNICIAN_ID:TECH01  EXPERIENCE:3
TECHNICIAN_ID:TECH02  EXPERIENCE:7
TECHNICIAN_ID:TECH03  EXPERIENCE:12
TECHNICIAN_ID:TECH04  EXPERIENCE:5
TECHNICIAN_ID:TECH05  EXPERIENCE:2

PL/SQL procedure successfully completed.

18. Display all technician ids and experience using implicit cursor in FOR loop.


SQL> BEGIN
  2     FOR i IN (SELECT * FROM technician) LOOP
  3         DBMS_OUTPUT.PUT_LINE('TECHNICIAN_ID:'||i.technician_id||'  EXPERIENCE:'||i.experience);
  4     END LOOP;
  5  END;
  6  /

TECHNICIAN_ID:TECH01  EXPERIENCE:3
TECHNICIAN_ID:TECH02  EXPERIENCE:7
TECHNICIAN_ID:TECH03  EXPERIENCE:12
TECHNICIAN_ID:TECH04  EXPERIENCE:5
TECHNICIAN_ID:TECH05  EXPERIENCE:2

PL/SQL procedure successfully completed.



20. Handle NO_DATA_FOUND exception when transformer id does not exist.


SQL> DECLARE
  2      v_status VARCHAR2(20);
  3      v_id VARCHAR2(20);
  4  BEGIN
  5      v_id := '&v_id';
  6      SELECT condition_status
  7      INTO v_status
  8      FROM transformer
  9      WHERE transformer_id = v_id;
 10      DBMS_OUTPUT.PUT_LINE('Status: '||v_status);
 11  EXCEPTION
 12      WHEN NO_DATA_FOUND THEN
 13         DBMS_OUTPUT.PUT_LINE('Error: No data found');
 14  END;
 15  /

Enter value for v_id: TR999
old   5: v_id := '&v_id';
new   5: v_id := 'TR999';
Error: No data found

Enter value for v_id: TR001
old   5: v_id := '&v_id';
new   5: v_id := 'TR001';
Status: MAINTENANCE

21. Handle TOO_MANY_ROWS exception when query returns many transformers.


SQL> DECLARE
  2  v_status VARCHAR2(20);
  3  BEGIN
  4  SELECT condition_status INTO v_status FROM transformer;
  5  DBMS_OUTPUT.PUT_LINE('STATUS:'||v_status);
  6  EXCEPTION
  7  WHEN TOO_MANY_ROWS THEN
  8     DBMS_OUTPUT.PUT_LINE('error: too many rows');
  9  END;
 10  /

error: too many rows

PL/SQL procedure successfully completed.

22. Handle ZERO_DIVIDE exception.


SQL> DECLARE
  2  n NUMBER :=0;
  3  BEGIN
  4  n := n/n;
  5  DBMS_OUTPUT.PUT_LINE(n);
  6  EXCEPTION
  7  WHEN ZERO_DIVIDE THEN
  8     DBMS_OUTPUT.PUT_LINE('error: cant divide with 0');
  9  END;
 10  /

error: cant divide with 0

PL/SQL procedure successfully completed.

23. Handle VALUE_ERROR when wrong datatype is assigned.


SQL> DECLARE
 2  v_cost NUMBER;
 3  BEGIN
 4  SELECT method INTO v_cost FROM test_type WHERE test_type_id='TT01';
 5  DBMS_OUTPUT.PUT_LINE(v_cost);
 6  EXCEPTION
 7  WHEN VALUE_ERROR THEN
 8     DBMS_OUTPUT.PUT_LINE('error: value error');
 9  END;
10  /

error: value error

PL/SQL procedure successfully completed.

24. Handle unexpected errors using OTHERS exception.


SQL> DECLARE
  2  v_exp NUMBER;
  3  v_email VARCHAR2(30);
  4  BEGIN
  5  SELECT experience INTO v_exp FROM technician WHERE technician_id='TECH01';
  6  DBMS_OUTPUT.PUT_LINE(v_exp);
  7  SELECT email INTO v_email FROM technician;
  8  DBMS_OUTPUT.PUT_LINE(v_email);
  9  EXCEPTION
 10  WHEN VALUE_ERROR THEN
 11     DBMS_OUTPUT.PUT_LINE('error: value error');
 12  WHEN OTHERS THEN
 13     DBMS_OUTPUT.PUT_LINE('error: unexpected error');
 14  END;
 15  /

3
error: unexpected error

PL/SQL procedure successfully completed.

25. User defined exception for negative experience of technician.


SQL> DECLARE
  2  v_exp NUMBER;
  3  negative_error EXCEPTION;
  4  BEGIN
  5  v_exp := &v_exp;
  6  IF v_exp < 0 THEN
  7     RAISE negative_error;
  8  ELSE
  9     DBMS_OUTPUT.PUT_LINE('Correct experience value: '||v_exp);
 10  END IF;
 11  EXCEPTION
 12  WHEN negative_error THEN
 13     DBMS_OUTPUT.PUT_LINE('Experience cannot be negative');
 14  END;
 15  /

Enter value for v_exp: 5
old   5: v_exp :=&v_exp;
new   5: v_exp :=5;
Correct experience value: 5

Enter value for v_exp: -3
old   5: v_exp :=&v_exp;
new   5: v_exp :=-3;
Experience cannot be negative


26. Check number type and Armstrong number.


SQL> DECLARE
  2  v_num NUMBER;
  3  l_len NUMBER :=0;
  4  n NUMBER :=0;
  5  rem NUMBER :=0;
  6  ans NUMBER :=0;
  7  BEGIN
  8  v_num := &v_num;
  9  IF v_num = 0 THEN
 10     DBMS_OUTPUT.PUT_LINE('NUMBER IS ZERO');
 11  ELSIF v_num > 0 THEN
 12     DBMS_OUTPUT.PUT_LINE('NUMBER IS POSITIVE');
 13     IF MOD(v_num,2)=0 THEN
 14        DBMS_OUTPUT.PUT_LINE('EVEN');
 15     ELSE
 16        DBMS_OUTPUT.PUT_LINE('ODD');
 17     END IF;
 18
 19     l_len := LENGTH(TO_CHAR(v_num));
 20     n := v_num;
 21
 22     WHILE n != 0 LOOP
 23        rem := MOD(n,10);
 24        ans := ans + POWER(rem,l_len);
 25        n := TRUNC(n/10);
 26     END LOOP;
 27
 28     IF ans = v_num THEN
 29        DBMS_OUTPUT.PUT_LINE('NUMBER IS ARMSTRONG');
 30     ELSE
 31        DBMS_OUTPUT.PUT_LINE('NUMBER IS NOT ARMSTRONG');
 32     END IF;
 33
 34  ELSE
 35     DBMS_OUTPUT.PUT_LINE('NUMBER IS NEGATIVE');
 36  END IF;
 37  END;
 38  /

Enter value for v_num: 1634
old   8: v_num :=&v_num;
new   8: v_num :=1634;
NUMBER IS POSITIVE
EVEN
NUMBER IS ARMSTRONG

Enter value for v_num: 57
old   8: v_num :=&v_num;
new   8: v_num :=57;
NUMBER IS POSITIVE
ODD
NUMBER IS NOT ARMSTRONG

Enter value for v_num: -344
old   8: v_num :=&v_num;
new   8: v_num :=-344;
NUMBER IS NEGATIVE

27. Print Fibonacci series up to n numbers.


SQL> DECLARE
  2     A NUMBER := -1;
  3     B NUMBER := 1;
  4     TEMP NUMBER := 0;
  5     NUM NUMBER;
  6  BEGIN
  7     NUM := &NUM;
  8     FOR I IN 1..NUM LOOP
  9        TEMP := A + B;
 10        DBMS_OUTPUT.PUT_LINE(TEMP||' ');
 11        A := B;
 12        B := TEMP;
 13     END LOOP;
 14  END;
 15  /

Enter value for num: 5
old   7: NUM :=&NUM;
new   7: NUM :=5;
0
1
1
2
3

PL/SQL procedure successfully completed.

28. Declare cursor to retrieve technicians whose id starts with 'TECH0' and display cursor attributes.


SQL> DECLARE
  2     v_id VARCHAR2(20);
  3     v_exp NUMBER;
  4     CURSOR c_cursor IS
  5     SELECT technician_id,experience FROM technician WHERE technician_id LIKE 'TECH0%';
  6  BEGIN
  7     OPEN c_cursor;
  8     FETCH c_cursor INTO v_id,v_exp;
  9     IF c_cursor%FOUND THEN
 10        DBMS_OUTPUT.PUT_LINE('first row fetched '|| v_id);
 11     ELSE
 12        DBMS_OUTPUT.PUT_LINE('no row fetched');
 13     END IF;
 14
 15     FETCH c_cursor INTO v_id,v_exp;
 16     IF c_cursor%FOUND THEN
 17        DBMS_OUTPUT.PUT_LINE('second row fetched '|| v_id);
 18     ELSE
 19        DBMS_OUTPUT.PUT_LINE('no row fetched');
 20     END IF;
 21
 22     IF c_cursor%ISOPEN THEN
 23        DBMS_OUTPUT.PUT_LINE('cursor open');
 24     ELSE
 25        DBMS_OUTPUT.PUT_LINE('cursor not open');
 26     END IF;
 27
 28     DBMS_OUTPUT.PUT_LINE('the no of rows fetched:'||c_cursor%ROWCOUNT);
 29
 30     CLOSE c_cursor;
 31
 32     IF c_cursor%ISOPEN THEN
 33        DBMS_OUTPUT.PUT_LINE('cursor open');
 34     ELSE
 35        DBMS_OUTPUT.PUT_LINE('cursor not open');
 36     END IF;
 37  END;
 38  /

first row fetched TECH01
second row fetched TECH02
cursor open
the no of rows fetched:2
cursor not open

PL/SQL procedure successfully completed.

29. Count technicians with experience greater than average experience.


SQL> SELECT COUNT(*) FROM technician
  2  WHERE experience > (SELECT AVG(experience) FROM technician);

  COUNT(*)
----------
         2


SQL> DECLARE
  2  c_count NUMBER;
  3  cursor_open EXCEPTION;
  4  CURSOR c_cursor IS
  5  SELECT COUNT(*) FROM technician
  6  WHERE experience > (SELECT AVG(experience) FROM technician);
  7  BEGIN
  8  OPEN c_cursor;
  9  FETCH c_cursor INTO c_count;
 10
 11  IF c_cursor%ISOPEN THEN
 12     DBMS_OUTPUT.PUT_LINE('Technicians with experience greater than average: '||c_count);
 13  ELSE
 14     RAISE cursor_open;
 15  END IF;
 16
 17  CLOSE c_cursor;
 18
 19  IF c_cursor%ISOPEN THEN
 20     DBMS_OUTPUT.PUT_LINE('Technicians with experience greater than average: '||c_count);
 21  ELSE
 22     RAISE cursor_open;
 23  END IF;
 24
 25  EXCEPTION
 26  WHEN cursor_open THEN
 27     DBMS_OUTPUT.PUT_LINE('error: cursor closed');
 28  END;
 29  /

Technicians with experience greater than average: 2
error: cursor closed

PL/SQL procedure successfully completed.
