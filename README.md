# wk-8-assignment
# Library Management System

A comprehensive MySQL database for managing all aspects of a modern library's operations.

## Project Description

The Library Management System is a complete relational database solution designed to efficiently track and manage a library's resources and operations. It provides a robust foundation for libraries of any size to manage their collections, patrons, and daily activities.

### Key Features

- **Member Management**: Track member information, membership status, and account history
- **Book Cataloging**: Maintain detailed information about books, including metadata and physical copies
- **Staff Management**: Manage library personnel with different access levels and responsibilities
- **Loan Processing**: Handle book checkouts, returns, and renewals with automated due date calculations
- **Fine Management**: Calculate and track overdue fines and payments
- **Reservation System**: Allow members to reserve books that are currently unavailable
- **Event Management**: Organize and track library events and attendees
- **Library Hours**: Maintain regular and special operating hours
- **Automated Workflows**: Through triggers and stored procedures for common operations

### Database Design

The system uses a well-structured relational model with:

- **13 Primary Tables**: Members, Staff, Books, Publishers, Authors, Genres, BookItems, Loans, Fines, Reservations, Events, EventAttendees, and LibraryHours
- **Multiple Relationship Types**: One-to-one, one-to-many, and many-to-many relationships
- **Proper Constraints**: Primary keys, foreign keys, unique constraints, and not-null constraints
- **Performance Optimization**: Strategic indexing on frequently queried columns
- **Data Integrity**: Enforced through constraints, triggers, and stored procedures

## How to Setup/Import

### Prerequisites

- MySQL Server 5.7+ or MariaDB 10.2+
- MySQL client (command line, MySQL Workbench, phpMyAdmin, etc.)
