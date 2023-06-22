-- Création du déclencheur pour l'insertion, la mise à jour et la suppression des livres
CREATE OR REPLACE TRIGGER book_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON Books
FOR EACH ROW
DECLARE
  v_action VARCHAR2(10);
BEGIN
  IF INSERTING THEN
    v_action := 'insert';
  ELSIF UPDATING THEN
    v_action := 'update';
  ELSIF DELETING THEN
    v_action := 'delete';
  END IF;

  INSERT INTO book_audit (audit_id, book_id, action, audit_date)
  VALUES (book_audit_seq.NEXTVAL, :NEW.book_id, v_action, SYSTIMESTAMP);
END;
/


-- Création du déclencheur pour prévenir les opérations sur la table "authors" pendant les jours de semaine
CREATE OR REPLACE TRIGGER prevent_authors_operations_trigger
BEFORE UPDATE OR DELETE ON Authors
FOR EACH ROW
DECLARE
  v_day_of_week VARCHAR2(20);
BEGIN
  v_day_of_week := TO_CHAR(SYSDATE, 'DAY');
  
  IF v_day_of_week IN ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY') THEN
    RAISE_APPLICATION_ERROR(-20001, 'Les opérations sur la table "authors" ne sont pas autorisées pendant les jours de semaine.');
  END IF;
END;
/


-- Création du déclencheur pour capturer l'adresse IP lors des opérations sur la table "users"
CREATE OR REPLACE TRIGGER capture_user_operations_trigger
AFTER UPDATE OR DELETE ON Users
FOR EACH ROW
DECLARE
  v_action VARCHAR2(10);
  v_ip_address VARCHAR2(50);
BEGIN
  IF UPDATING THEN
    v_action := 'update';
  ELSIF DELETING THEN
    v_action := 'delete';
  END IF;

  v_ip_address := SYS_CONTEXT('USERENV', 'IP_ADDRESS');

  INSERT INTO audit_log (log_id, action, ip_address, log_date)
  VALUES (log_audit_seq.NEXTVAL, v_action, v_ip_address, SYSTIMESTAMP);
END;
/

-- Création du déclencheur pour la contrainte de dates d'emprunt et de retour
CREATE OR REPLACE TRIGGER enforce_borrow_return_dates_trigger
BEFORE INSERT OR UPDATE ON Borrowings
FOR EACH ROW
BEGIN
  IF :NEW.borrow_date > :NEW.return_date THEN
    RAISE_APPLICATION_ERROR(-20002, 'La date d''emprunt ne peut pas être postérieure à la date de retour.');
  END IF;
END;
/