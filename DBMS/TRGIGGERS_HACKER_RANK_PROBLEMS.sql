1.automatically prints a confirmation message showing the ID of each new transformer immediately after it is added to the table

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

SQL> INSERT INTO transformer VALUES ('T500', 'GOOD', SYSDATE);

New transformer inserted with ID: T500

1 row created.

2.

SQL> CREATE OR REPLACE TRIGGER trg_prevent_price_update_hours
  2  BEFORE UPDATE OF price ON equipment
  3  FOR EACH ROW
  4  DECLARE
  5      v_current_hour NUMBER;
  6  BEGIN
  7      v_current_hour := TO_NUMBER(TO_CHAR(SYSDATE,'HH24'));
  8
  9      IF v_current_hour BETWEEN 18 AND 23 OR v_current_hour BETWEEN 0 AND 6 THEN
 10          RAISE_APPLICATION_ERROR(-20001,
 11          'PRICE UPDATES NOT ALLOWED BETWEEN 6 PM AND 6 AM');
 12      END IF;
 13  END;
 14  /

Trigger created.

SQL> UPDATE equipment
  2  SET price = 5000
  3  WHERE equipment_id = 'E101';

ERROR at line 1:
ORA-20001: PRICE UPDATES NOT ALLOWED BETWEEN 6 PM AND 6 AM
ORA-06512: at "TRG_PREVENT_PRICE_UPDATE_HOURS", line 10
ORA-04088: error during execution of trigger

3.

SQL> CREATE OR REPLACE TRIGGER trg_prevent_client_delete
  2  BEFORE DELETE ON client
  3  FOR EACH ROW
  4  DECLARE
  5      v_count NUMBER;
  6  BEGIN
  7      SELECT COUNT(*) INTO v_count
  8      FROM test_request
  9      WHERE client_id = :OLD.client_id;
 10
 11      IF v_count > 0 THEN
 12          RAISE_APPLICATION_ERROR(-20002,
 13          'CANNOT DELETE CLIENT WITH EXISTING TEST REQUESTS');
 14      END IF;
 15  END;
 16  /

Trigger created.

SQL> DELETE FROM client
  2  WHERE client_id = 'C101';
ERROR at line 1:
ORA-20002: CANNOT DELETE CLIENT WITH EXISTING TEST REQUESTS
ORA-06512: at "TRG_PREVENT_CLIENT_DELETE", line 12
ORA-04088: error during execution of trigger

4.

SQL> CREATE OR REPLACE TRIGGER trg_check_duplicate_cert_num
  2  BEFORE INSERT OR UPDATE ON calibration
  3  FOR EACH ROW
  4  DECLARE
  5      v_count NUMBER;
  6  BEGIN
  7      SELECT COUNT(*) INTO v_count
  8      FROM calibration
  9      WHERE certification_num = :NEW.certification_num
 10      AND calibration_id != :NEW.calibration_id;
 11
 12      IF v_count > 0 THEN
 13          RAISE_APPLICATION_ERROR(-20003,
 14          'DUPLICATE CERTIFICATION NUMBER NOT ALLOWED');
 15      END IF;
 16  END;
 17  /

Trigger created.

SQL> INSERT INTO calibration VALUES ('CAL101', 'CERT100');
SQL> INSERT INTO calibration VALUES ('CAL102', 'CERT100');
ERROR at line 1:
ORA-20003: DUPLICATE CERTIFICATION NUMBER NOT ALLOWED
ORA-06512: at "TRG_CHECK_DUPLICATE_CERT_NUM", line 13
ORA-04088: error during execution of trigger

5.

SQL> CREATE OR REPLACE TRIGGER trg_validate_order_availability
  2  BEFORE INSERT ON orders
  3  FOR EACH ROW
  4  DECLARE
  5      v_stock NUMBER;
  6      v_reserved NUMBER;
  7      v_available NUMBER;
  8  BEGIN
  9      SELECT stock_quantity, reserved_quantity
 10      INTO v_stock, v_reserved
 11      FROM inventory
 12      WHERE item_id = :NEW.item_id;
 13
 14      v_available := v_stock - v_reserved;
 15
 16      IF :NEW.order_quantity > v_available THEN
 17          RAISE_APPLICATION_ERROR(-20004,
 18          'INSUFFICIENT STOCK. AVAILABLE: ' || v_available ||
 19          ' REQUESTED: ' || :NEW.order_quantity);
 20      END IF;
 21
 22      UPDATE inventory
 23      SET reserved_quantity = reserved_quantity + :NEW.order_quantity
 24      WHERE item_id = :NEW.item_id;
 25  END;
 26  /

Trigger created.

SQL> INSERT INTO inventory VALUES ('I101','TRANSFORMER OIL',10,2);

1 row created.

SQL> INSERT INTO orders VALUES ('O101','I101',9,SYSDATE,'NEW');
ERROR at line 1:
ORA-20004: INSUFFICIENT STOCK. AVAILABLE: 8 REQUESTED: 9
ORA-06512: at "TRG_VALIDATE_ORDER_AVAILABILITY", line 17
ORA-04088: error during execution of trigger

6.

SQL> CREATE OR REPLACE TRIGGER trg_email_on_critical_error
  2  BEFORE INSERT ON equipment
  3  FOR EACH ROW
  4  DECLARE
  5      v_error_msg VARCHAR2(500);
  6  BEGIN
  7      IF :NEW.price IS NULL OR :NEW.price <= 0 THEN
  8          v_error_msg := 'INVALID PRICE FOR EQUIPMENT: ' || :NEW.equipment_id;
  9
 10          INSERT INTO error_log(error_message, error_operation, user_name, email_sent)
 11          VALUES(v_error_msg, 'EQUIPMENT INSERT VALIDATION', USER, 'YES');
 12
 13         
 14          DBMS_OUTPUT.PUT_LINE('EMAIL SENT TO: admin@transformertest.com');
 15          DBMS_OUTPUT.PUT_LINE('SUBJECT: CRITICAL ERROR - EQUIPMENT VALIDATION');
 16          DBMS_OUTPUT.PUT_LINE('MESSAGE: ' || v_error_msg);
 17
 18
 19          RAISE_APPLICATION_ERROR(-20005, v_error_msg);
 20      END IF;
 21  END;
 22  /

Trigger created.

SQL> INSERT INTO equipment(equipment_id, equipment_name, manufacturer, model_no, price)
  2  VALUES ('E500','TEST KIT','ABC','M1',0);

EMAIL SENT TO: admin@transformertest.com
SUBJECT: CRITICAL ERROR - EQUIPMENT VALIDATION
MESSAGE: INVALID PRICE FOR EQUIPMENT: E500

ERROR at line 1:
ORA-20005: INVALID PRICE FOR EQUIPMENT: E500
ORA-06512: at "TRG_EMAIL_ON_CRITICAL_ERROR", line 19
ORA-04088: error during execution of trigger

7.

SQL> CREATE OR REPLACE TRIGGER trg_audit_admin_dept_change
  2  AFTER UPDATE OF department ON admin
  3  FOR EACH ROW
  4  BEGIN
  5      INSERT INTO admin_audit(admin_id, old_department, new_department, changed_by)
  6      VALUES(:OLD.admin_id, :OLD.department, :NEW.department, USER);
  7  END;
  8  /

Trigger created.

SQL> UPDATE admin
  2  SET department = 'QUALITY'
  3  WHERE admin_id = 'A101';

1 row updated.

SQL> SELECT * FROM admin_audit;

AUDIT_ID  ADMIN_ID  OLD_DEPARTMENT  NEW_DEPARTMENT  CHANGED_BY  CHANGE_DATE
--------  --------  --------------  --------------  ----------  -------------------
1         A101      HR              QUALITY         SYSTEM      25-MAR-26

7.

SQL> CREATE OR REPLACE TRIGGER trg_invoice_amount_validation
  2  FOR UPDATE OF total_amt ON invoice
  3  COMPOUND TRIGGER
  4
  5  TYPE t_invoice_rec IS RECORD(
  6      invoice_id VARCHAR2(20),
  7      old_amt NUMBER,
  8      new_amt NUMBER
  9  );
 10
 11  TYPE t_invoice_tab IS TABLE OF t_invoice_rec INDEX BY PLS_INTEGER;
 12
 13  g_invoices t_invoice_tab;
 14  g_index PLS_INTEGER := 0;
 15
 16  BEFORE EACH ROW IS
 17  BEGIN
 18      IF :NEW.total_amt < :OLD.total_amt * 0.5 THEN
 19          RAISE_APPLICATION_ERROR(-20006,
 20          'AMOUNT REDUCTION EXCEEDS 50% LIMIT');
 21      END IF;
 22
 23      g_index := g_index + 1;
 24      g_invoices(g_index).invoice_id := :NEW.invoice_id;
 25      g_invoices(g_index).old_amt := :OLD.total_amt;
 26      g_invoices(g_index).new_amt := :NEW.total_amt;
 27  END BEFORE EACH ROW;
 28
 29  AFTER STATEMENT IS
 30  BEGIN
 31      FOR i IN 1..g_index LOOP
 32          DBMS_OUTPUT.PUT_LINE('INVOICE ' || g_invoices(i).invoice_id ||
 33          ' UPDATED FROM ' || g_invoices(i).old_amt ||
 34          ' TO ' || g_invoices(i).new_amt);
 35      END LOOP;
 36
 37      g_invoices.DELETE;
 38      g_index := 0;
 39  END AFTER STATEMENT;
 40
 41  END;
 42  /

Trigger created.

SQL> UPDATE invoice
  2  SET total_amt = 800
  3  WHERE invoice_id = 'INV101';

1 row updated.

INVOICE INV101 UPDATED FROM 1000 TO 800

SQL> UPDATE invoice
  2  SET total_amt = 400
  3  WHERE invoice_id = 'INV101';

ERROR at line 1:
ORA-20006: AMOUNT REDUCTION EXCEEDS 50% LIMIT
ORA-04088: error during execution of trigger

8.

SQL> CREATE OR REPLACE TRIGGER trg_instead_client_invoice_update
  2  INSTEAD OF UPDATE ON vw_client_invoices
  3  FOR EACH ROW
  4  BEGIN
  5      UPDATE invoice
  6      SET payment_status = :NEW.payment_status
  7      WHERE invoice_id = :OLD.invoice_id;
  8  END;
  9  /

Trigger created.

SQL> UPDATE vw_client_invoices
  2  SET payment_status = 'PAID'
  3  WHERE invoice_id = 'INV101';

1 row updated.

SQL> SELECT invoice_id, payment_status
  2  FROM invoice
  3  WHERE invoice_id = 'INV101';

INVOICE_ID  PAYMENT_STATUS
----------  --------------
INV101      PAID

9.

SQL> SET SERVEROUTPUT ON;

SQL> SELECT trigger_name, trigger_type, triggering_event, table_name, status
  2  FROM user_triggers
  3  WHERE table_name IN ('EQUIPMENT','CLIENT','CALIBRATION','ORDERS','ADMIN','INVOICE')
  4  ORDER BY table_name, trigger_name;

TRIGGER_NAME                     TRIGGER_TYPE     TRIGGERING_EVENT  TABLE_NAME   STATUS
------------------------------- ---------------- ----------------- ------------ --------
TRG_EMAIL_ON_CRITICAL_ERROR     BEFORE EACH ROW  INSERT            EQUIPMENT    ENABLED
TRG_PREVENT_PRICE_UPDATE_HOURS  BEFORE EACH ROW  UPDATE            EQUIPMENT    ENABLED
TRG_INVOICE_AMOUNT_VALIDATION   COMPOUND         UPDATE            INVOICE      ENABLED
TRG_AUDIT_ADMIN_DEPT_CHANGE     AFTER EACH ROW   UPDATE            ADMIN        ENABLED

SQL> ALTER TRIGGER trg_prevent_price_update_hours DISABLE;

Trigger altered.

SQL> SELECT trigger_name, status
  2  FROM user_triggers
  3  WHERE trigger_name = 'TRG_PREVENT_PRICE_UPDATE_HOURS';

TRIGGER_NAME                     STATUS
------------------------------- --------
TRG_PREVENT_PRICE_UPDATE_HOURS  DISABLED

