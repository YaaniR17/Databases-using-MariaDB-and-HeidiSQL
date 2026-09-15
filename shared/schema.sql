CREATE TABLE Student (
    student_id INTEGER PRIMARY KEY,
    ssn TEXT UNIQUE,
    name TEXT NOT NULL,
    university_id INTEGER NOT NULL,
    FOREIGN KEY (university_id) REFERENCES University(university_id)
);