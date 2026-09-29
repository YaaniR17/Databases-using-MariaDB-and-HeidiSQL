-- Local Library Borrowing System

CREATE DATABASE IF NOT EXISTS `local_library`;
USE `local_library`;

-- 1. Authors Table
CREATE TABLE `authors` (
    `author_id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `birth_year` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Books Table
CREATE TABLE `books` (
    `book_id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `isbn` VARCHAR(13) UNIQUE NOT NULL,
    `author_id` INT,
    `published_year` INT,
    `total_copies` INT NOT NULL DEFAULT 1,
    `available_copies` INT NOT NULL DEFAULT 1,
    FOREIGN KEY (`author_id`) REFERENCES `authors`(`author_id`) ON DELETE SET NULL,
    CONSTRAINT chk_total_copies CHECK (`total_copies` >= 0),
    CONSTRAINT chk_avail_copies CHECK (`available_copies` <= `total_copies`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Members Table
CREATE TABLE `members` (
    `member_id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) UNIQUE NOT NULL,
    `join_date` DATE NOT NULL,
    `outstanding_fines` DECIMAL(6, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT chk_fines CHECK (`outstanding_fines` >= 0.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Loans Table (Tracks borrowing history)
CREATE TABLE `loans` (
    `loan_id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT,
    `member_id` INT,
    `loan_date` DATE NOT NULL,
    `due_date` DATE NOT NULL,
    `return_date` DATE DEFAULT NULL,
    FOREIGN KEY (`book_id`) REFERENCES `books`(`book_id`) ON DELETE RESTRICT,
    FOREIGN KEY (`member_id`) REFERENCES `members`(`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Indexes for fast book lookups and due-date tracking
CREATE INDEX `idx_books_title` ON `books`(`title`);
CREATE INDEX `idx_loans_due_date` ON `loans`(`due_date`);
