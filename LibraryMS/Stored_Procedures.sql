delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`check_reader` $$
CREATE PROCEDURE `DBProject`.`check_reader` (IN  readerId bigint unsigned,
                          OUT present_in_reader int)
BEGIN
  SELECT count(*) INTO present_in_reader FROM reader_details
    WHERE reader_id = readerId;
END 
$$

delimiter ;

-- -----------------------------------------------------------------------

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`check_admin` $$
CREATE PROCEDURE `DBProject`.`check_admin` (IN  adminId int(11) unsigned,
			      IN  adminPassword varchar(20),
                              OUT present_in_admin int)
BEGIN
  SELECT count(*) INTO present_in_admin FROM admin
    WHERE admin_id = adminId AND admin_password = adminPassword;
END
$$

delimiter ;

-- ------------------------------------------------------------------
delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`search_book_by_id` $$
CREATE PROCEDURE `DBProject`.`search_book_by_id` (IN  bookId int(11) unsigned,
                          OUT bId int(11) unsigned, 
			  OUT bISBN int(11) unsigned,
			  OUT btitle varchar(50),
			  OUT libraryName varchar(20),
			  OUT authorName varchar(20),
			  OUT publisherName varchar(20),
			  OUT present_in_book int,
			  OUT present_in_borrow int)
BEGIN
  SELECT count(*) INTO present_in_book FROM book
    WHERE book_id = bookId;

  SELECT b.book_id, b.ISBN, bd.title, branch.library_name, a.author_name, p.publisher_name 
	INTO bId, bISBN, bTitle,libraryName, authorName, publisherName 
  FROM book b, book_details bd, book_association basso, branches branch, authors a, publisher p
    WHERE b.book_id = bookId 
	AND b.ISBN = bd.ISBN 
	AND b.book_id = basso.book_id 
	AND basso.library_id = branch.library_id
	AND bd.author_id = a.author_id
	AND bd.publisher_id = p.publisher_id; 

  SELECT count(*) INTO present_in_borrow FROM borrow_a_book
    WHERE book_id = bookId AND status = "ACTIVE";
END
$$

delimiter ;

-- ---------------------------------------------------------------------------

-- ------------------------------------------------------------------------

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`search_book_by_title` $$
CREATE PROCEDURE `DBProject`.`search_book_by_title` (IN  bookTitle varchar(20))
BEGIN
DECLARE bISBN INT(11) UNSIGNED;
SELECT ISBN INTO bISBN FROM book_details WHERE title LIKE CONCAT('%',bookTitle,'%');

SELECT b.ISBN, bd.title, a.author_name, p.publisher_name 
  FROM book b, book_details bd, authors a, publishers p
    WHERE bd.title LIKE CONCAT('%',bookTitle,'%') 
	AND b.ISBN = bd.ISBN 
	AND bd.author_id = a.author_id
	AND bd.publisher_id = p.publisher_id
	GROUP BY bd.title;


-- SELECT book_id from book WHERE ISBN = bISBN;
SELECT b.book_id, branch.library_name 
FROM book b, branches branch, book_association basso  
WHERE b.ISBN = bISBN AND b.book_id = basso.book_id AND branch.library_id = basso.library_id; 

END
$$

delimiter ;




------------------------------------------------------------------------------

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`search_book_by_publisher_name` $$
CREATE PROCEDURE `DBProject`.`search_book_by_publisher_name` (IN  bookPublisherName varchar(20))
BEGIN
  SELECT bd.ISBN, bd.title, a.author_name
  FROM book_details bd, authors a, publishers p
    WHERE p.publisher_name LIKE CONCAT('%',bookPublisherName,'%') 
	AND bd.author_id = a.author_id
	AND bd.publisher_id = p.publisher_id
	GROUP BY bd.title;
END
$$

delimiter ;

-----------------------------------------------------------

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`check_reader_total_number_of_books` $$
CREATE PROCEDURE `check_reader_total_number_of_books`(IN readerId bigint unsigned,
						OUT total_number_of_books int)
BEGIN 
DECLARE number_of_borrowed_books INT;
DECLARE number_of_reserved_books INT;
SELECT COUNT(*) INTO number_of_borrowed_books FROM borrow_a_book WHERE reader_id = readerID AND status = "ACTIVE" AND return_datetime IS NULL GROUP BY reader_id;
SELECT COUNT(*) INTO number_of_reserved_books FROM reserve_a_book WHERE reader_id = readerID AND status = "ACTIVE" GROUP BY reader_id;

SET total_number_of_books = number_of_borrowed_books + number_of_reserved_books;

END
$$

delimiter ;


--------------------------------------------------------------------------------------

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`book_checkout` $$
CREATE PROCEDURE `DBProject`.`book_checkout` (IN  bookId int(11) unsigned,
					IN libraryId int(11) unsigned,
					IN readerId bigint unsigned,
					OUT active_book int,
                    			OUT active_book_same_branch int,
					OUT book_is_borrowed int)
BEGIN 



SELECT COUNT(*) INTO active_book FROM borrow_a_book WHERE reader_id = readerID AND book_id = bookId  AND status = "ACTIVE" AND return_datetime IS NULL;

IF active_book = 1 THEN
	SELECT COUNT(*) INTO active_book_same_branch 
    FROM borrow_a_book 
    WHERE reader_id = readerID AND book_id= bookId  AND library_id = libraryId AND status = "ACTIVE" AND return_datetime IS NULL;
	IF active_book_same_branch = 1 THEN
		UPDATE borrow_a_book 
		SET borrow_datetime = NOW()
		WHERE reader_id = readerID AND book_id = bookId AND library_id = libraryId AND status = "ACTIVE" AND return_datetime IS NULL;
	ELSEIF active_book_same_branch = 0 then
		SET active_book_same_branch = 0;
	ELSE
		SET active_book_same_branch = -1;
    END IF;
ELSEIF active_book = 0 THEN
	SELECT COUNT(*) INTO book_is_borrowed FROM borrow_a_book WHERE reader_id != readerID AND book_id = bookId  AND status = "ACTIVE" AND return_datetime IS NULL;
    IF book_is_borrowed = 1 THEN
		SET book_is_borrowed = 1;
	ELSEIF book_is_borrowed = 0 THEN
		INSERT INTO borrow_a_book(borrow_id,book_id,reader_id,library_id,borrow_datetime,due_date,return_datetime,fine_paid_by_reader,status)
		VALUES (UUID_SHORT(), bookId,readerId,libraryId, NOW(), CURDATE() + INTERVAL 20 DAY,NULL,0.0,"ACTIVE");
	ELSE 
		SET book_is_borrowed = -1;
	END IF;
ELSE 
	SET active_book = -1;

END IF;
END
$$

delimiter ;

------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------
-- Book Return

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`book_return` $$
CREATE PROCEDURE `DBProject`.`book_return` (IN  bookId int(11) unsigned,
					IN libraryId int(11) unsigned,
					IN readerId bigint unsigned,
					OUT active_book int,
					OUT active_book_same_branch int)
BEGIN 
SELECT COUNT(*) INTO active_book FROM borrow_a_book WHERE reader_id = readerID AND book_id= bookId AND status = "ACTIVE" AND return_datetime IS NULL;
IF active_book = 1 THEN
	SELECT COUNT(*) INTO active_book_same_branch FROM borrow_a_book 
	WHERE reader_id = readerID AND book_id= bookId AND library_id = libraryId AND status = "ACTIVE" AND return_datetime IS NULL;
	IF active_book_same_branch = 1 THEN
		UPDATE borrow_a_book 
	 	SET return_datetime = NOW(), status = "INACTIVE"
	        WHERE reader_id = readerID AND book_id= bookId AND library_id = libraryId;
	ELSEIF active_book_same_branch = 0 THEN
		SET active_book_same_branch = 0;
	END IF;
ELSE
	SET active_book = 0;
END IF;
END
$$

delimiter ;
--------------------------------------------------------------------------------------------------------------------------------
-- reserve logic
delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`book_reserve` $$
CREATE PROCEDURE `DBProject`.`book_reserve` (IN  bookId int(11) unsigned,
										IN  readerId bigint unsigned,
					OUT active_book int)
BEGIN 
DECLARE reserve_status varchar(20);
SELECT COUNT(*) INTO active_book FROM borrow_a_book WHERE reader_id = readerID AND book_id= bookId AND status = "ACTIVE" AND return_datetime IS NULL;
IF active_book = 0 THEN
	set reserve_status = "ACTIVE";
ELSE
	SET reserve_status = "INACTIVE";
END IF;

INSERT INTO reserve_a_book(reserve_id,book_id,reader_id,reserve_datetime,status)
		VALUES (UUID_SHORT(), bookId,readerId,NOW(),reserve_status);
END
$$

delimiter ;
-- --------------------------------------------------------------------------------------------------------
-- Compute fine based on the current date

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`compute_fine` $$
CREATE PROCEDURE `DBProject`.`compute_fine` (IN  bookId int(11) unsigned,
					IN readerId bigint unsigned,
					OUT days int)
BEGIN 
DECLARE dueDate DATE;
DECLARE returnDateTime DATETIME;
DECLARE returnDate DATE;
SELECT due_date, return_datetime INTO dueDate, returnDateTime FROM borrow_a_book WHERE reader_id = readerID AND book_id= bookId AND status = "ACTIVE";

IF returnDateTime IS NULL THEN
	SET returnDate = CURDATE();
else
	SET returnDate = DATE(returnDateTime);
END IF;
    
SELECT DATEDIFF(returnDate, dueDate) INTO days;
END
$$

delimiter ;
--------------------------------------------------------------------------------------
-- Print the list of books reserved by a reader and their status

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`list_of reserved_book_status` $$
CREATE PROCEDURE `DBProject`.`list_of reserved_book_status` (IN readerId bigint unsigned)
BEGIN 

SELECT book_id, status from reserve_a_book where reader_id = readerId;
END
$$

delimiter ;

---------------------------------------------------------------------------------
-- Print the book id and titles of books published by a publisher

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`print_bookIds_title_by_publisher_name` $$
CREATE PROCEDURE `DBProject`.`print_bookIds_title_by_publisher_name` (IN  bookPublisherName varchar(20))
BEGIN

SELECT bk.book_id, bkd.title 
FROM book bk, book_details bkd
WHERE bkd.ISBN IN (SELECT bd.ISBN 
  FROM book_details bd, publishers p
    WHERE p.publisher_name LIKE CONCAT('%',bookPublisherName,'%') 
	AND bd.publisher_id = p.publisher_id)
    AND bk.ISBN = bkd.ISBN;
END
$$


delimiter ;

------------------------------------------------------------------------------
-- Add a book copy


delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`add_a_new_author` $$
CREATE PROCEDURE `DBProject`.`add_a_new_author` (IN  authorName varchar(20),
					OUT authorId int(11) unsigned)
BEGIN 
INSERT INTO authors(author_name)
	VALUES (authorName); 

SELECT author_id INTO authorId FROM authors 
WHERE author_name LIKE authorName; 
END
$$

delimiter ;



delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`add_a_new_publisher` $$
CREATE PROCEDURE `DBProject`.`add_a_new_publisher` (IN  publisherName varchar(20),
						IN  publisherAddress varchar(20),
						OUT publisherId int(11) unsigned)
BEGIN 
INSERT INTO publishers(publisher_name,publisher_address)
	VALUES (publisherName,publisherAddress); 

SELECT publisher_id INTO publisherId FROM publishers 
WHERE publisher_name LIKE publisherName AND publisher_address LIKE publisherAddress;
END
$$

delimiter ;


delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`add_a_new_branch` $$
CREATE PROCEDURE `DBProject`.`add_a_new_branch` (IN  libraryName varchar(20),
						IN  libraryLocation varchar(20),
						OUT libraryId int(11) unsigned)
BEGIN 
INSERT INTO branches(library_name,library_location)
	VALUES (libraryName,libraryLocation); 

SELECT library_id INTO libraryId FROM branches WHERE library_name LIKE libraryName AND library_location LIKE libraryLocation;
END
$$

delimiter ;


delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`add_a_new_book` $$
CREATE PROCEDURE `DBProject`.`add_a_new_book` ( IN  bookISBN int(11) unsigned,
						IN  bookTitle varchar(20),
						IN  authorId int(11) unsigned,
						IN publisherId int(11) unsigned,
						IN publishedDate date,
						IN libraryId int(11) unsigned, OUT bookId INT(11) UNSIGNED)
BEGIN 
-- DECLARE bookId INT(11) UNSIGNED;
INSERT INTO book_details(ISBN,title,author_id,publisher_id,published_date)
	VALUES (bookISBN,bookTitle,authorId,publisherId,publishedDate);

INSERT INTO book(ISBN)
	VALUES (bookISBN);

SELECT book_id INTO bookId FROM book WHERE ISBN = bookISBN; 

INSERT INTO book_association(book_id,library_id)
	VALUES(bookId,libraryId);

INSERT INTO total_number_of_copies(ISBN,library_id,no_of_copies)
	VALUES(bookISBN,libraryId,1);
-- SELECT bookId;

END
$$
delimiter ;
----------------------------------------------------------------------
delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`add_an_existing_book` $$
CREATE PROCEDURE `DBProject`.`add_an_existing_book` ( IN  bookISBN int(11) unsigned,
						IN libraryId int(11) unsigned,
						OUT bookId int(11) unsigned)
BEGIN 
-- DECLARE bookId INT(11) UNSIGNED;
INSERT INTO book(ISBN)
	VALUES (bookISBN);

SELECT book_id INTO bookId FROM book WHERE ISBN = bookISBN ORDER BY book_id DESC LIMIT 1;

INSERT INTO book_association(book_id,library_id)
	VALUES(bookId,libraryId);

UPDATE total_number_of_copies
	 SET no_of_copies = (no_of_copies + 1)
	WHERE ISBN=bookISBN AND library_id = libraryId;
END
$$

delimiter ;
----------------------------------------------------------------
-- Search a book copy and check its status

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`check_book_copy_status` $$
CREATE PROCEDURE `DBProject`.`check_book_copy_status` (IN  bookId int(11) unsigned,
                          OUT bId int(11) unsigned, 
			  OUT bISBN int(11) unsigned,
			  OUT btitle varchar(50),
			  OUT libraryName varchar(20),
			  OUT authorName varchar(20),
			  OUT publisherName varchar(20),
			  OUT present_in_book int,
			  OUT present_in_borrow int,
			  OUT present_in_reserve int)
BEGIN
  SELECT count(*) INTO present_in_book FROM book
    WHERE book_id = bookId;

  SELECT b.book_id, b.ISBN, bd.title, branch.library_name, a.author_name, p.publisher_name 
	INTO bId, bISBN, bTitle,libraryName, authorName, publisherName 
  FROM book b, book_details bd, book_association basso, branches branch, authors a, publishers p
    WHERE b.book_id = bookId 
	AND b.ISBN = bd.ISBN 
	AND b.book_id = basso.book_id 
	AND basso.library_id = branch.library_id
	AND bd.author_id = a.author_id
	AND bd.publisher_id = p.publisher_id; 

  SELECT count(*) INTO present_in_borrow FROM borrow_a_book
    WHERE book_id = bookId AND status = "ACTIVE" AND return_datetime IS NULL;

SELECT count(*) INTO present_in_reserve FROM reserve_a_book
    WHERE book_id = bookId AND status = "ACTIVE";
END
$$

delimiter ;


---------------------------------------------------------------------

-----------------------------------------------------------------------
-- Add a new reader

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`add_a_new_reader` $$
CREATE PROCEDURE `DBProject`.`add_a_new_reader` (IN  readerName varchar(20),
					IN readerAddress varchar(50),
					IN phoneNumber int(10))
BEGIN 
 DECLARE readerId bigint unsigned;
INSERT INTO reader_details(reader_name,reader_address,phone_number)
	VALUES (readerName,readerAddress,phoneNumber); 
select reader_id INTO readerId FROM reader_details where reader_name LIKE readerName AND reader_address LIKE readerAddress AND phone_number = phoneNumber;
END
$$

delimiter ;

-------------------------------------------------------------


delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`print_specific_branch_information` $$
CREATE PROCEDURE `DBProject`.`print_specific_branch_information`(IN libraryId int(11) unsigned
								OUT libraryName varchar(20)
								OUT libraryLocation varchar(20))
BEGIN 
SELECT library_name,library_location INTO libraryName, libraryLocation FROM branches; 
END
$$

delimiter ;


------------------------------------------------------------------
-- Print branch information(name and location) - Done

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`print_branch_information` $$
CREATE PROCEDURE `DBProject`.`print_branch_information`()
BEGIN 
SELECT * FROM branches; 
END
$$

delimiter ;


------------------------------------------------------------------------
-- Print 10 most frequent borrowers in the branch and the number of books each has borrowed

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`print_10_frequent_borrowers` $$
CREATE PROCEDURE `DBProject`.`print_10_frequent_borrowers`(IN libraryId int(11) unsigned)
BEGIN 

SELECT bab.reader_id, rd.reader_name, count(*) AS Number_of_times_Borrowed FROM borrow_a_book bab, reader_details rd 
WHERE bab.library_id = libraryId AND bab.reader_id = rd.reader_id 
GROUP BY bab.reader_id ORDER BY Number_of_times_Borrowed DESC LIMIT 10;
 
END
$$

delimiter ;

--------------------------------------------------------------------
-- Print top most borrowed books in a branch

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`print_10_borrowed_books` $$
CREATE PROCEDURE `DBProject`.`print_10_borrowed_books`(IN libraryId int(11) unsigned)
BEGIN 

SELECT bd.ISBN, bd.title, count(*) AS Number_of_times_Borrowed FROM borrow_a_book bab, book b, book_details bd 
WHERE bab.library_id = libraryId AND bab.book_id = b.book_id AND b.ISBN = bd.ISBN 
GROUP BY bd.ISBN ORDER BY Number_of_times_Borrowed DESC LIMIT 10;
 
END
$$

delimiter ;


-------------------------------------------------------------------------
-- Find the average fine paid by reader

delimiter $$
DROP PROCEDURE IF EXISTS `DBProject`.`average_fine_paid_by_reader` $$
CREATE PROCEDURE `DBProject`.`average_fine_paid_by_reader`(IN readerId int(11) unsigned)
BEGIN 

SELECT avg(fine_paid_by_reader) from borrow_a_book WHERE reader_id = readerId GROUP BY reader_id;
 
END
$$

delimiter ;


