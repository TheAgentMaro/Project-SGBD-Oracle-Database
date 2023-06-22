-- Create an event trigger for book borrowing
CREATE OR REPLACE TRIGGER after_borrow_trigger
AFTER INSERT ON Borrowings
FOR EACH ROW
BEGIN
  -- Mettre à jour le statut à 'Unavailable'
  UPDATE Books
  SET availability_status = 'Unavailable'
  WHERE book_id = :NEW.book_id;
END;
/


-- Create an event trigger for book returning
CREATE OR REPLACE TRIGGER after_return_trigger
AFTER UPDATE ON Borrowings
FOR EACH ROW
BEGIN
  -- Vérifier si le livre a été retourné (return_date n'est pas null)
  IF :NEW.return_date IS NOT NULL THEN
    -- Mettre à jour le statut à  'Available'
    UPDATE Books
    SET availability_status = 'Available'
    WHERE book_id = :NEW.book_id;
  END IF;
END;
