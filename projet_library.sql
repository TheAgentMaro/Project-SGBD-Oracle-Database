-- Create Authors table
CREATE TABLE Authors (
  author_id INT PRIMARY KEY,
  author_name VARCHAR(100)
);

-- Create Books table
CREATE TABLE Books (
  book_id INT PRIMARY KEY,
  title VARCHAR(100),
  author_id INT,
  availability_status VARCHAR(20),
  FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Create Users table
CREATE TABLE Users (
  user_id INT PRIMARY KEY,
  user_name VARCHAR(100)
);

-- Create Borrowings table
CREATE TABLE Borrowings (
  borrowing_id INT PRIMARY KEY,
  book_id INT,
  user_id INT,
  borrow_date DATE,
  return_date DATE,
  FOREIGN KEY (book_id) REFERENCES Books(book_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create BookAudit table
CREATE TABLE book_audit (
  audit_id INT PRIMARY KEY,
  book_id INT,
  action VARCHAR2(10),
  audit_date TIMESTAMP
);

-- Création de la séquence pour book_audit_id
CREATE SEQUENCE book_audit_seq;

-- Create Table Audit Logs
CREATE TABLE audit_log (
  log_id INT PRIMARY KEY,
  action VARCHAR2(10),
  ip_address VARCHAR2(50),
  log_date TIMESTAMP
);

-- Création de la séquence pour log_audit_id
CREATE SEQUENCE log_audit_seq;




-- Add check constraint to Borrowings table to ensure borrow_date is before return_date
ALTER TABLE Borrowings ADD CONSTRAINT CHK_Borrowings_Dates CHECK (borrow_date < return_date);


--Insertion
INSERT INTO Authors (author_id, author_name)
VALUES (1, 'John Smith');
INSERT INTO Authors (author_id, author_name)
VALUES (2, 'Mike Smith');
INSERT INTO Authors (author_id, author_name)
VALUES (3, 'Marwen Smith');


INSERT INTO Books (book_id, title, author_id, availability_status)
VALUES (1, 'Harry Poter', 1, 'Available');
INSERT INTO Books (book_id, title, author_id, availability_status)
VALUES (2, 'Dragon', 2, 'Available');
INSERT INTO Books (book_id, title, author_id, availability_status)
VALUES (3, 'Technology', 3, 'Available');

INSERT INTO Users (user_id, user_name)
VALUES (1, 'Marwen');
INSERT INTO Users (user_id, user_name)
VALUES (2, 'Mike');
INSERT INTO Users (user_id, user_name)
VALUES (3, 'Alice');


INSERT INTO Borrowings (borrowing_id, book_id, user_id, borrow_date)
VALUES (1, 1, 1, SYSDATE);

INSERT INTO Borrowings (borrowing_id, book_id, user_id, borrow_date)
VALUES (2, 2, 2, SYSDATE);

INSERT INTO Borrowings (borrowing_id, book_id, user_id, borrow_date)
VALUES (3, 3, 3, SYSDATE);