-- --------------------------------------------------------
-- Library Management System Database
-- Created: May 21, 2025

-- Drop database if it exists to start fresh
DROP DATABASE IF EXISTS library_management_system;

-- Create database
CREATE DATABASE library_management_system;

-- Use the database
USE library_management_system;

-- --------------------------------------------------------
-- Table structure for 'members'
-- --------------------------------------------------------
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    date_of_birth DATE,
    membership_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    membership_status ENUM('Active', 'Expired', 'Suspended') NOT NULL DEFAULT 'Active',
    membership_expiry DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_membership_status (membership_status),
    INDEX idx_member_name (last_name, first_name)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'staff'
-- --------------------------------------------------------
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    is_admin BOOLEAN DEFAULT FALSE,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_staff_position (position),
    INDEX idx_staff_name (last_name, first_name)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'publishers'
-- --------------------------------------------------------
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    address VARCHAR(255),
    website VARCHAR(100),
    established_year YEAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_publisher_name (name)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'authors'
-- --------------------------------------------------------
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    biography TEXT,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_author_name (last_name, first_name)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'genres'
-- --------------------------------------------------------
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_genre_name (name)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'books'
-- --------------------------------------------------------
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    publication_year YEAR,
    isbn VARCHAR(20) UNIQUE,
    language VARCHAR(50) DEFAULT 'English',
    page_count INT,
    summary TEXT,
    cover_image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL,
    INDEX idx_book_title (title),
    INDEX idx_book_isbn (isbn),
    INDEX idx_book_publication_year (publication_year)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'book_authors' (M:M relationship)
-- --------------------------------------------------------
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'book_genres' (M:M relationship)
-- --------------------------------------------------------
CREATE TABLE book_genres (
    book_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (book_id, genre_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'book_items' (physical copies)
-- --------------------------------------------------------
CREATE TABLE book_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    barcode VARCHAR(50) UNIQUE NOT NULL,
    location VARCHAR(50) NOT NULL,
    status ENUM('Available', 'Borrowed', 'Reserved', 'Maintenance', 'Lost') NOT NULL DEFAULT 'Available',
    acquisition_date DATE NOT NULL,
    price DECIMAL(10, 2),
    condition ENUM('New', 'Good', 'Fair', 'Poor') NOT NULL DEFAULT 'New',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    INDEX idx_book_item_status (status),
    INDEX idx_book_item_barcode (barcode),
    INDEX idx_book_item_location (location)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'loans'
-- --------------------------------------------------------
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    member_id INT NOT NULL,
    staff_id INT,
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    renewal_count INT DEFAULT 0,
    status ENUM('Active', 'Returned', 'Overdue', 'Lost') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES book_items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL,
    INDEX idx_loan_status (status),
    INDEX idx_loan_due_date (due_date),
    INDEX idx_loan_member (member_id)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'fines'
-- --------------------------------------------------------
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    member_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    reason ENUM('Late Return', 'Damaged Item', 'Lost Item') NOT NULL,
    issue_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    payment_date DATE,
    status ENUM('Pending', 'Paid', 'Waived') NOT NULL DEFAULT 'Pending',
    staff_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL,
    INDEX idx_fine_status (status),
    INDEX idx_fine_member (member_id)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'reservations'
-- --------------------------------------------------------
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    expiry_date DATE NOT NULL,
    status ENUM('Pending', 'Fulfilled', 'Cancelled', 'Expired') NOT NULL DEFAULT 'Pending',
    notification_sent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    INDEX idx_reservation_status (status),
    INDEX idx_reservation_member (member_id)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'events'
-- --------------------------------------------------------
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    location VARCHAR(100),
    max_attendees INT,
    organizer_staff_id INT,
    event_type ENUM('Book Club', 'Author Visit', 'Workshop', 'Children''s Event', 'Other') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organizer_staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL,
    INDEX idx_event_date (event_date),
    INDEX idx_event_type (event_type)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for 'event_attendees' (M:M relationship)
-- --------------------------------------------------------
CREATE TABLE event_attendees (
    event_id INT NOT NULL,
    member_id INT NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    attendance_status ENUM('Registered', 'Attended', 'No-show', 'Cancelled') DEFAULT 'Registered',
    PRIMARY KEY (event_id, member_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table structure for library_hours
-- --------------------------------------------------------
CREATE TABLE library_hours (
    id INT AUTO_INCREMENT PRIMARY KEY,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL,
    is_closed BOOLEAN DEFAULT FALSE,
    special_date DATE,
    note VARCHAR(255),
    UNIQUE KEY idx_day_special (day_of_week, special_date)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Views for common queries
-- --------------------------------------------------------

-- View for available books
CREATE VIEW available_books AS
SELECT 
    b.book_id,
    b.title,
    b.isbn,
    COUNT(bi.item_id) AS available_copies
FROM 
    books b
JOIN 
    book_items bi ON b.book_id = bi.book_id
WHERE 
    bi.status = 'Available'
GROUP BY 
    b.book_id, b.title, b.isbn;

-- View for overdue loans
CREATE VIEW overdue_loans AS
SELECT 
    l.loan_id,
    b.title AS book_title,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email AS member_email,
    l.loan_date,
    l.due_date,
    DATEDIFF(CURRENT_DATE, l.due_date) AS days_overdue
FROM 
    loans l
JOIN 
    book_items bi ON l.item_id = bi.item_id
JOIN 
    books b ON bi.book_id = b.book_id
JOIN 
    members m ON l.member_id = m.member_id
WHERE 
    l.status = 'Overdue'
    OR (l.status = 'Active' AND l.due_date < CURRENT_DATE);

-- View for member loan history
CREATE VIEW member_loan_history AS
SELECT 
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title AS book_title,
    l.loan_date,
    l.due_date,
    l.return_date,
    l.status
FROM 
    loans l
JOIN 
    members m ON l.member_id = m.member_id
JOIN 
    book_items bi ON l.item_id = bi.item_id
JOIN 
    books b ON bi.book_id = b.book_id;

-- View for popular books
CREATE VIEW popular_books AS
SELECT 
    b.book_id,
    b.title,
    COUNT(l.loan_id) AS times_borrowed
FROM 
    books b
JOIN 
    book_items bi ON b.book_id = bi.book_id
JOIN 
    loans l ON bi.item_id = l.item_id
WHERE 
    l.loan_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
GROUP BY 
    b.book_id, b.title
ORDER BY 
    times_borrowed DESC;

-- --------------------------------------------------------
-- Triggers for automation
-- --------------------------------------------------------

-- Trigger to update book item status when borrowed
DELIMITER //
CREATE TRIGGER after_loan_insert
AFTER INSERT ON loans
FOR EACH ROW
BEGIN
    UPDATE book_items
    SET status = 'Borrowed'
    WHERE item_id = NEW.item_id;
END//
DELIMITER ;

-- Trigger to update book item status when returned
DELIMITER //
CREATE TRIGGER after_loan_return
AFTER UPDATE ON loans
FOR EACH ROW
BEGIN
    IF NEW.status = 'Returned' AND OLD.status != 'Returned' THEN
        UPDATE book_items
        SET status = 'Available'
        WHERE item_id = NEW.item_id;
    END IF;
END//
DELIMITER ;

-- Trigger to check membership status before allowing loans
DELIMITER //
CREATE TRIGGER before_loan_check_member
BEFORE INSERT ON loans
FOR EACH ROW
BEGIN
    DECLARE member_status VARCHAR(20);
    
    SELECT membership_status INTO member_status
    FROM members
    WHERE member_id = NEW.member_id;
    
    IF member_status != 'Active' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cannot issue loan to member with non-active status';
    END IF;
END//
DELIMITER ;

-- Trigger to automatically set fine for overdue books
DELIMITER //
CREATE TRIGGER after_loan_update_check_overdue
AFTER UPDATE ON loans
FOR EACH ROW
BEGIN
    DECLARE days_late INT;
    DECLARE fine_amount DECIMAL(10,2);
    
    IF NEW.status = 'Returned' AND NEW.return_date > NEW.due_date THEN
        SET days_late = DATEDIFF(NEW.return_date, NEW.due_date);
        SET fine_amount = days_late * 0.50; -- $0.50 per day late
        
        INSERT INTO fines (loan_id, member_id, amount, reason, issue_date)
        VALUES (NEW.loan_id, NEW.member_id, fine_amount, 'Late Return', CURRENT_DATE);
    END IF;
END//
DELIMITER ;

-- --------------------------------------------------------
-- STORED PROCEDURES for common operations
-- --------------------------------------------------------

-- Procedure to renew a book
DELIMITER //
CREATE PROCEDURE renew_book(IN p_loan_id INT, IN p_new_due_date DATE)
BEGIN
    DECLARE current_status VARCHAR(20);
    
    -- Check if the loan exists and is active
    SELECT status INTO current_status
    FROM loans
    WHERE loan_id = p_loan_id;
    
    IF current_status = 'Active' THEN
        UPDATE loans
        SET due_date = p_new_due_date,
            renewal_count = renewal_count + 1
        WHERE loan_id = p_loan_id;
        
        SELECT 'Book renewed successfully.' AS message;
    ELSE
        SELECT 'Cannot renew. Loan is not active.' AS message;
    END IF;
END//
DELIMITER ;

-- Procedure to check out a book
DELIMITER //
CREATE PROCEDURE check_out_book(
    IN p_member_id INT,
    IN p_item_id INT,
    IN p_staff_id INT,
    IN p_loan_days INT
)
BEGIN
    DECLARE item_status VARCHAR(20);
    DECLARE member_status VARCHAR(20);
    DECLARE due_date_calc DATE;
    
    -- Check if the book item is available
    SELECT status INTO item_status
    FROM book_items
    WHERE item_id = p_item_id;
    
    -- Check if the member is active
    SELECT membership_status INTO member_status
    FROM members
    WHERE member_id = p_member_id;
    
    -- Calculate due date
    SET due_date_calc = DATE_ADD(CURRENT_DATE, INTERVAL p_loan_days DAY);
    
    IF item_status = 'Available' AND member_status = 'Active' THEN
        -- Insert the loan record
        INSERT INTO loans (item_id, member_id, staff_id, loan_date, due_date, status)
        VALUES (p_item_id, p_member_id, p_staff_id, CURRENT_DATE, due_date_calc, 'Active');
        
        SELECT 'Book checked out successfully.' AS message;
    ELSE
        IF item_status != 'Available' THEN
            SELECT 'Book is not available for checkout.' AS message;
        ELSE
            SELECT 'Member account is not active.' AS message;
        END IF;
    END IF;
END//
DELIMITER ;

-- Procedure to return a book
DELIMITER //
CREATE PROCEDURE return_book(IN p_loan_id INT)
BEGIN
    DECLARE loan_exists INT;
    
    -- Check if the loan exists
    SELECT COUNT(*) INTO loan_exists
    FROM loans
    WHERE loan_id = p_loan_id AND status != 'Returned';
    
    IF loan_exists > 0 THEN
        -- Update the loan record
        UPDATE loans
        SET status = 'Returned',
            return_date = CURRENT_DATE
        WHERE loan_id = p_loan_id;
        
        SELECT 'Book returned successfully.' AS message;
    ELSE
        SELECT 'Invalid loan ID or book already returned.' AS message;
    END IF;
END//
DELIMITER ;

-- Procedure to generate a report of outstanding fines
DELIMITER //
CREATE PROCEDURE get_outstanding_fines()
BEGIN
    SELECT 
        f.fine_id,
        CONCAT(m.first_name, ' ', m.last_name) AS member_name,
        m.email,
        b.title AS book_title,
        f.amount,
        f.reason,
        f.issue_date,
        DATEDIFF(CURRENT_DATE, f.issue_date) AS days_outstanding
    FROM 
        fines f
    JOIN 
        members m ON f.member_id = m.member_id
    JOIN 
        loans l ON f.loan_id = l.loan_id
    JOIN 
        book_items bi ON l.item_id = bi.item_id
    JOIN 
        books b ON bi.book_id = b.book_id
    WHERE 
        f.status = 'Pending'
    ORDER BY 
        days_outstanding DESC;
END//
DELIMITER ;

