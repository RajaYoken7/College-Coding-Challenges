FUNCTIONS AND PROCEDURES

1.Get transformer condition status by ID.

SQL> CREATE OR REPLACE FUNCTION get_transformer_status
  2  (p_id VARCHAR2)
  3  RETURN VARCHAR2
  4  IS
  5      v_status VARCHAR2(20);
  6  BEGIN
  7      SELECT condition_status INTO v_status
  8      FROM transformer
  9      WHERE transformer_id = p_id;
 10
 11      RETURN v_status;
 12
 13  EXCEPTION
 14      WHEN NO_DATA_FOUND THEN
 15          RETURN 'NOT FOUND';
 16      WHEN OTHERS THEN
 17          RETURN NULL;
 18  END get_transformer_status;
 19  /

Function created.


SQL> SELECT get_transformer_status('T101') FROM dual;

GET_TRANSFORMER_STATUS('T101')
------------------------------
GOOD

2. Count total number of transformers.

SQL> CREATE OR REPLACE FUNCTION get_total_transformers
  2  RETURN NUMBER
  3  IS
  4      v_total NUMBER;
  5  BEGIN
  6      SELECT COUNT(*) INTO v_total
  7      FROM transformer;
  8
  9      RETURN v_total;
 10
 11  EXCEPTION
 12      WHEN OTHERS THEN
 13          RETURN 0;
 14  END get_total_transformers;
 15  /

Function created.

SQL> BEGIN
  2      DBMS_OUTPUT.PUT_LINE(get_total_transformers);
  3  END;
  4  /

8

PL/SQL procedure successfully completed.

3. Get transformer condition using ID.

SQL> CREATE OR REPLACE FUNCTION get_transformer_condition
  2  (p_id IN VARCHAR2)
  3  RETURN VARCHAR2
  4  IS
  5      v_status VARCHAR2(20);
  6  BEGIN
  7      SELECT condition_status INTO v_status
  8      FROM transformer
  9      WHERE transformer_id = p_id;
 10
 11      RETURN v_status;
 12
 13  EXCEPTION
 14      WHEN NO_DATA_FOUND THEN
 15          RETURN 'NOT FOUND';
 16      WHEN OTHERS THEN
 17          RETURN NULL;
 18  END get_transformer_condition;
 19  /

Function created.


SQL> SELECT get_transformer_condition('T101') FROM dual;

GET_TRANSFORMER_CONDITION('T101')
--------------------------------
GOOD

4.--get number of transformers with quantity greater than given value

SQL> CREATE OR REPLACE FUNCTION get_samples_by_quantity
  2  (p_type IN VARCHAR2,
  3   p_qty  IN NUMBER)
  4  RETURN NUMBER
  5  IS
  6      v_count NUMBER;
  7  BEGIN
  8      SELECT COUNT(*) INTO v_count
  9      FROM sample
 10      WHERE sample_type = p_type
 11      AND quantity > p_qty;
 12
 13      RETURN v_count;
 14  END get_samples_by_quantity;
 15  /

Function created.

SQL> SELECT * FROM sample;

SAMPLE_ID   QUANTITY   CONDITION_STATUS   CONTAINER_NUMBER   SAMPLE_TYPE   TRANSFORMER_ID
----------- ---------- ------------------ ------------------ ------------ ----------------
S101        10         GOOD               C1                 OIL          T101
S102        20         GOOD               C2                 OIL          T102
S103        5          GOOD               C3                 WATER        T103


SQL> SELECT get_samples_by_quantity('OIL',10) FROM dual;

GET_SAMPLES_BY_QUANTITY('OIL',10)
--------------------------------
1

5. get complete transformer record using transformer id

SQL> CREATE OR REPLACE FUNCTION get_transformer_record
  2  (p_id IN VARCHAR2)
  3  RETURN transformer%ROWTYPE
  4  IS
  5      v_trans transformer%ROWTYPE;
  6  BEGIN
  7      SELECT * INTO v_trans
  8      FROM transformer
  9      WHERE transformer_id = p_id;
 10
 11      RETURN v_trans;
 12
 13  EXCEPTION
 14      WHEN NO_DATA_FOUND THEN
 15          RETURN NULL;
 16      WHEN OTHERS THEN
 17          RETURN NULL;
 18  END get_transformer_record;
 19  /

Function created.


SQL> DECLARE
  2      v_trans_rec transformer%ROWTYPE;
  3  BEGIN
  4      v_trans_rec := get_transformer_record('T101');
  5
  6      IF v_trans_rec.transformer_id IS NOT NULL THEN
  7          DBMS_OUTPUT.PUT_LINE('Transformer ID: ' || v_trans_rec.transformer_id);
  8          DBMS_OUTPUT.PUT_LINE('Status: ' || v_trans_rec.condition_status);
  9          DBMS_OUTPUT.PUT_LINE('Install Date: ' || v_trans_rec.install_date);
 10      ELSE
 11          DBMS_OUTPUT.PUT_LINE('No record found.');
 12      END IF;
 13  END;
 14  /

Transformer ID: T101
Status: GOOD
Install Date: 18-MAR-26

PL/SQL procedure successfully completed.

6. return all transformer records using ref cursor

SQL> CREATE OR REPLACE FUNCTION get_transformer_ref_cursor
  2  RETURN SYS_REFCURSOR
  3  IS
  4      v_cursor SYS_REFCURSOR;
  5  BEGIN
  6      OPEN v_cursor FOR
  7          SELECT * FROM transformer;
  8
  9      RETURN v_cursor;
 10  END get_transformer_ref_cursor;
 11  /

Function created.

SQL> DECLARE
  2      v_cursor SYS_REFCURSOR;
  3      v_id     transformer.transformer_id%TYPE;
  4      v_status transformer.condition_status%TYPE;
  5      v_date   transformer.install_date%TYPE;
  6  BEGIN
  7      v_cursor := get_transformer_ref_cursor;
  8
  9      LOOP
 10          FETCH v_cursor INTO v_id, v_status, v_date;
 11          EXIT WHEN v_cursor%NOTFOUND;
 12
 13          DBMS_OUTPUT.PUT_LINE('Transformer ID: ' || v_id);
 14          DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
 15          DBMS_OUTPUT.PUT_LINE('Install Date: ' || v_date);
 16          DBMS_OUTPUT.PUT_LINE('----------------------');
 17      END LOOP;
 18
 19      CLOSE v_cursor;
 20  END;
 21  /

Transformer ID: T101
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T102
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T103
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T104
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T105
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T201
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T202
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T206
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T207
Status: GOOD
Install Date: 18-MAR-26
----------------------

PL/SQL procedure successfully completed.

7. Insert a fixed transformer record.

SQL> CREATE OR REPLACE PROCEDURE simple_proc_transformer
  2  IS
  3  BEGIN
  4      INSERT INTO transformer (transformer_id, condition_status, install_date)
  5      VALUES ('T400', 'GOOD', SYSDATE);
  6      COMMIT;
  7      DBMS_OUTPUT.PUT_LINE('New transformer inserted with ID: T400');
  8  END simple_proc_transformer;
  9  /

Procedure created.

SQL> EXEC simple_proc_transformer;

New transformer inserted with ID: T400

PL/SQL procedure successfully completed.

8. Insert transformer using input parameters

SQL> CREATE OR REPLACE PROCEDURE proc_with_in_param_transformer
  2  (p_id IN VARCHAR2,
  3   p_status IN VARCHAR2)
  4  IS
  5  BEGIN
  6      INSERT INTO transformer (transformer_id, condition_status, install_date)
  7      VALUES (p_id, p_status, SYSDATE);
  8      COMMIT;
  9      DBMS_OUTPUT.PUT_LINE('New transformer inserted with ID: ' || p_id);
 10  END proc_with_in_param_transformer;
 11  /

Procedure created.

SQL> EXEC proc_with_in_param_transformer('T500','GOOD');

New transformer inserted with ID: T500

PL/SQL procedure successfully completed.

9. get transformer status using out parameter

SQL> CREATE OR REPLACE PROCEDURE proc_with_out_param_transformer
  2  (p_id IN VARCHAR2,
  3   p_status OUT VARCHAR2)
  4  IS
  5  BEGIN
  6      SELECT condition_status INTO p_status
  7      FROM transformer
  8      WHERE transformer_id = p_id;
  9  END proc_with_out_param_transformer;
 10  /

Procedure created.

SQL> DECLARE
  2      v_status VARCHAR2(20);
  3  BEGIN
  4      proc_with_out_param_transformer('T101', v_status);
  5      DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
  6  END;
  7  /

Status: GOOD

PL/SQL procedure successfully completed.

10. update transformer status using in out parameter

SQL> CREATE OR REPLACE PROCEDURE proc_with_in_out_param_transformer
  2  (p_id IN OUT VARCHAR2,
  3   p_status IN OUT VARCHAR2)
  4  IS
  5  BEGIN
  6      UPDATE transformer
  7      SET condition_status = p_status
  8      WHERE transformer_id = p_id;
  9
 10      SELECT condition_status INTO p_status
 11      FROM transformer
 12      WHERE transformer_id = p_id;
 13
 14      DBMS_OUTPUT.PUT_LINE('Transformer ' || p_id || ' updated.');
 15  END proc_with_in_out_param_transformer;
 16  /

Procedure created.

SQL> DECLARE
  2      v_id VARCHAR2(20) := 'T101';
  3      v_status VARCHAR2(20) := 'BAD';
  4  BEGIN
  5      proc_with_in_out_param_transformer(v_id, v_status);
  6      DBMS_OUTPUT.PUT_LINE('Updated Status: ' || v_status);
  7  END;
  8  /

Transformer T101 updated.
Updated Status: BAD

PL/SQL procedure successfully completed.

11. return all transformer records using ref cursor procedure

SQL> CREATE OR REPLACE PROCEDURE proc_with_ref_cursor_transformer
  2  (p_cursor OUT SYS_REFCURSOR)
  3  IS
  4  BEGIN
  5      OPEN p_cursor FOR
  6          SELECT * FROM transformer;
  7  END proc_with_ref_cursor_transformer;
  8  /

Procedure created.

SQL> DECLARE
  2      v_cursor SYS_REFCURSOR;
  3      v_id     transformer.transformer_id%TYPE;
  4      v_status transformer.condition_status%TYPE;
  5      v_date   transformer.install_date%TYPE;
  6  BEGIN
  7      proc_with_ref_cursor_transformer(v_cursor);
  8
  9      LOOP
 10          FETCH v_cursor INTO v_id, v_status, v_date;
 11          EXIT WHEN v_cursor%NOTFOUND;
 12
 13          DBMS_OUTPUT.PUT_LINE('Transformer ID: ' || v_id);
 14          DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
 15          DBMS_OUTPUT.PUT_LINE('Install Date: ' || v_date);
 16          DBMS_OUTPUT.PUT_LINE('----------------------');
 17      END LOOP;
 18
 19      CLOSE v_cursor;
 20  END;
 21  /

Transformer ID: T101
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T102
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T103
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T104
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T105
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T201
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T202
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T206
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T207
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T300
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T400
Status: GOOD
Install Date: 18-MAR-26
----------------------
Transformer ID: T500
Status: GOOD
Install Date: 18-MAR-26
----------------------

PL/SQL procedure successfully completed.

12. insert transformer with exception handling

SQL> CREATE OR REPLACE PROCEDURE proc_with_exception_transformer
  2  (p_id IN VARCHAR2,
  3   p_status IN VARCHAR2)
  4  IS
  5  BEGIN
  6      INSERT INTO transformer (transformer_id, condition_status, install_date)
  7      VALUES (p_id, p_status, SYSDATE);
  8      COMMIT;
  9
 10  EXCEPTION
 11      WHEN DUP_VAL_ON_INDEX THEN
 12          DBMS_OUTPUT.PUT_LINE('Error: Duplicate transformer id.');
 13      WHEN OTHERS THEN
 14          DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
 15  END proc_with_exception_transformer;
 16  /

Procedure created.

SQL> EXEC proc_with_exception_transformer('T101','GOOD');

Error: Duplicate transformer id.

PL/SQL procedure successfully completed.

13. Get oil name using oil ID.

SQL> CREATE OR REPLACE FUNCTION get_oil_name
  2  (p_id VARCHAR2)
  3  RETURN VARCHAR2
  4  IS
  5      v_name VARCHAR2(30);
  6  BEGIN
  7      SELECT oil_name INTO v_name
  8      FROM oil_type
  9      WHERE oil_type_id = p_id;
 10
 11      RETURN v_name;
 12
 13  EXCEPTION
 14      WHEN NO_DATA_FOUND THEN
 15          RETURN 'NOT FOUND';
 16  END;
 17  /

Function created.

SQL> SELECT get_oil_name('O101') FROM dual;

GET_OIL_NAME('O101')
--------------------
TRANSFORMER OIL

14. Count total number of technicians.

SQL> CREATE OR REPLACE FUNCTION get_total_technicians
  2  RETURN NUMBER
  3  IS
  4      v_total NUMBER;
  5  BEGIN
  6      SELECT COUNT(*) INTO v_total
  7      FROM technician;
  8
  9      RETURN v_total;
 10  END;
 11  /

Function created.

SQL> BEGIN
  2      DBMS_OUTPUT.PUT_LINE(get_total_technicians);
  3  END;
  4  /

5

PL/SQL procedure successfully completed.

15. Get test request status by ID.

SQL> CREATE OR REPLACE FUNCTION get_test_request_status
  2  (p_id VARCHAR2)
  3  RETURN VARCHAR2
  4  IS
  5      v_status VARCHAR2(20);
  6  BEGIN
  7      SELECT request_status INTO v_status
  8      FROM test_request
  9      WHERE test_request_id = p_id;
 10
 11      RETURN v_status;
 12
 13  EXCEPTION
 14      WHEN NO_DATA_FOUND THEN
 15          RETURN 'NOT FOUND';
 16  END;
 17  /

Function created.

SQL> SELECT get_test_request_status('TR101') FROM dual;

GET_TEST_REQUEST_STATUS('TR101')
-------------------------------
PENDING

16. Count samples based on condition.

SQL> CREATE OR REPLACE FUNCTION get_samples_by_condition
  2  (p_cond VARCHAR2)
  3  RETURN NUMBER
  4  IS
  5      v_count NUMBER;
  6  BEGIN
  7      SELECT COUNT(*) INTO v_count
  8      FROM sample
  9      WHERE condition_status = p_cond;
 10
 11      RETURN v_count;
 12  END;
 13  /

Function created.

SQL> SELECT get_samples_by_condition('GOOD') FROM dual;

GET_SAMPLES_BY_CONDITION('GOOD')
--------------------------------
3

17. Get full technician record by ID.

SQL> CREATE OR REPLACE FUNCTION get_technician_record
  2  (p_id VARCHAR2)
  3  RETURN technician%ROWTYPE
  4  IS
  5      v_rec technician%ROWTYPE;
  6  BEGIN
  7      SELECT * INTO v_rec
  8      FROM technician
  9      WHERE technician_id = p_id;
 10
 11      RETURN v_rec;
 12
 13  EXCEPTION
 14      WHEN NO_DATA_FOUND THEN
 15          RETURN NULL;
 16  END;
 17  /

Function created.

SQL> DECLARE
  2      v_rec technician%ROWTYPE;
  3  BEGIN
  4      v_rec := get_technician_record('TECH101');
  5      DBMS_OUTPUT.PUT_LINE('Technician ID: ' || v_rec.technician_id);
  6  END;
  7  /

Technician ID: TECH101

PL/SQL procedure successfully completed.

18. Return all equipment records using cursor.

SQL> CREATE OR REPLACE FUNCTION get_equipment_cursor
  2  RETURN SYS_REFCURSOR
  3  IS
  4      v_cursor SYS_REFCURSOR;
  5  BEGIN
  6      OPEN v_cursor FOR
  7          SELECT * FROM equipment;
  8
  9      RETURN v_cursor;
 10  END;
 11  /

Function created.

SQL> CREATE OR REPLACE PROCEDURE simple_proc_test_type
  2  IS
  3  BEGIN
  4      INSERT INTO test_type
  5      VALUES ('TT500', 60, 5000, 'ISO', 'AUTO', 'Routine test');
  6      COMMIT;
  7  END;
  8  /

Procedure created.

SQL> EXEC simple_proc_test_type;

PL/SQL procedure successfully completed.

19. Insert oil type using input values.

SQL> CREATE OR REPLACE PROCEDURE proc_with_in_param_oil
  2  (p_id VARCHAR2, p_name VARCHAR2)
  3  IS
  4  BEGIN
  5      INSERT INTO oil_type(oil_type_id, oil_name)
  6      VALUES (p_id, p_name);
  7      COMMIT;
  8  END;
  9  /

Procedure created.

SQL> EXEC proc_with_in_param_oil('O200','SYNTHETIC OIL');

PL/SQL procedure successfully completed.

20. Get sample quantity using OUT parameter.

SQL> CREATE OR REPLACE PROCEDURE proc_with_out_sample
  2  (p_id VARCHAR2, p_qty OUT NUMBER)
  3  IS
  4  BEGIN
  5      SELECT quantity INTO p_qty
  6      FROM sample
  7      WHERE sample_id = p_id;
  8  END;
  9  /

Procedure created.

SQL> DECLARE
  2      v_qty NUMBER;
  3  BEGIN
  4      proc_with_out_sample('S101', v_qty);
  5      DBMS_OUTPUT.PUT_LINE('Quantity: ' || v_qty);
  6  END;
  7  /

Quantity: 10

PL/SQL procedure successfully completed.

 
21. Update test end time using IN OUT parameter.

SQL> CREATE OR REPLACE PROCEDURE proc_with_inout_test
  2  (p_id IN VARCHAR2, p_end_time IN OUT DATE)
  3  IS
  4  BEGIN
  5      UPDATE test
  6      SET end_time = p_end_time
  7      WHERE test_id = p_id;
  8
  9      SELECT end_time INTO p_end_time
 10      FROM test
 11      WHERE test_id = p_id;
 12  END;
 13  /

Procedure created.

SQL> CREATE OR REPLACE PROCEDURE proc_with_cursor_test_request
  2  (p_cursor OUT SYS_REFCURSOR)
  3  IS
  4  BEGIN
  5      OPEN p_cursor FOR
  6          SELECT * FROM test_request;
  7  END;
  8  /

Procedure created.

 
22. Insert technician with exception handling.

SQL> CREATE OR REPLACE PROCEDURE proc_exception_technician
  2  (p_id VARCHAR2, p_email VARCHAR2)
  3  IS
  4  BEGIN
  5      INSERT INTO technician(technician_id, email)
  6      VALUES (p_id, p_email);
  7
  8      COMMIT;
  9
 10  EXCEPTION
 11      WHEN DUP_VAL_ON_INDEX THEN
 12          DBMS_OUTPUT.PUT_LINE('Duplicate Technician ID');
 13      WHEN OTHERS THEN
 14          DBMS_OUTPUT.PUT_LINE(SQLERRM);
 15  END;
 16  /

Procedure created.

SQL> EXEC proc_exception_technician('TECH101','test@mail.com');

Duplicate Technician ID

PL/SQL procedure successfully completed.

23. Delete transformer safely with message.

SQL> CREATE OR REPLACE PROCEDURE delete_transformer_safe
  2  (p_id VARCHAR2)
  3  IS
  4  BEGIN
  5      DELETE FROM transformer
  6      WHERE transformer_id = p_id;
  7
  8      IF SQL%ROWCOUNT = 0 THEN
  9          DBMS_OUTPUT.PUT_LINE('No transformer found.');
 10      ELSE
 11          DBMS_OUTPUT.PUT_LINE('Transformer deleted successfully.');
 12      END IF;
 13
 14      COMMIT;
 15
 16  EXCEPTION
 17      WHEN OTHERS THEN
 18          DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
 19  END;
 20  /

Procedure created.

SQL> EXEC delete_transformer_safe('T300');

Transformer deleted successfully.

PL/SQL procedure successfully completed.

24. Count samples linked to a transformer.

SQL> CREATE OR REPLACE FUNCTION get_sample_count_by_transformer
  2  (p_id VARCHAR2)
  3  RETURN NUMBER
  4  IS
  5      v_count NUMBER;
  6  BEGIN
  7      SELECT COUNT(*)
  8      INTO v_count
  9      FROM transformer t
 10      JOIN sample s
 11      ON t.transformer_id = s.transformer_id
 12      WHERE t.transformer_id = p_id;
 13
 14      RETURN v_count;
 15
 16  EXCEPTION
 17      WHEN NO_DATA_FOUND THEN
 18          RETURN 0;
 19  END;
 20  /

Function created.

SQL> SELECT get_sample_count_by_transformer('T101') FROM dual;

GET_SAMPLE_COUNT_BY_TRANSFORMER('T101')
--------------------------------------
2

25. Check if transformer exists in table.

SQL> CREATE OR REPLACE FUNCTION check_transformer_exists
  2  (p_id VARCHAR2)
  3  RETURN NUMBER
  4  IS
  5      v_count NUMBER;
  6  BEGIN`7= v?>   -*
  7      SELECT COUNT(*) INTO v_count
  8      FROM transformer
  9      WHERE transformer_id = p_id;
 10
 11      RETURN v_count;

 12  END;
 13  /

Function created.

SQL> SELECT check_transformer_exists('T101') FROM dual;

CHECK_TRANSFORMER_EXISTS('T101')
-------------------------------
1
	
