CREATE DATABASE IF NOT EXISTS school_db;
USE school_db;

CREATE TABLE University (
    university_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Instructor (
    instructor_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    university_id INT NOT NULL,
    FOREIGN KEY (university_id) REFERENCES University(university_id)
);

CREATE TABLE Classroom (
    classroom_id INT PRIMARY KEY,
    room_number VARCHAR(50) NOT NULL
);

CREATE TABLE Class (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(255) NOT NULL,
    university_id INT NOT NULL,
    instructor_id INT NOT NULL,
    classroom_id INT UNIQUE,
    FOREIGN KEY (university_id) REFERENCES University(university_id),
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id),
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);

CREATE TABLE Chair (
    chair_id INT PRIMARY KEY,
    classroom_id INT NOT NULL,
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    ssn VARCHAR(11) NOT NULL UNIQUE ,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    university_id INT NOT NULL,
    chair_id INT UNIQUE,
    FOREIGN KEY (university_id) REFERENCES University(university_id),
    FOREIGN KEY (chair_id) REFERENCES Chair(chair_id)
);

CREATE TABLE Attends (
    student_id INT,
    class_id INT,
    PRIMARY KEY (student_id, class_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES Class(class_id) ON DELETE CASCADE
);
