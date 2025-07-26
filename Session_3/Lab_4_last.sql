DROP TABLE IF EXISTS Exam;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Phone;
DROP TABLE IF EXISTS Subject;
DROP TABLE IF EXISTS Track;
DROP TABLE IF EXISTS ContactInfo;



CREATE TABLE Track (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);


CREATE TABLE Subject (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    max_score INT CHECK (max_score <= 100),
    track_id INT REFERENCES Track(id)
);

--  Contact Info
CREATE TABLE ContactInfo (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE Student (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50),
    gender VARCHAR(10) CHECK (gender IN ('male', 'female')),
    birth_date DATE,
    contact_info_id INT REFERENCES ContactInfo(id),
    track_id INT REFERENCES Track(id)
);


CREATE TABLE Phone (
    id INT IDENTITY(1,1) PRIMARY KEY,
    phone_number VARCHAR(20),
    student_id INT REFERENCES Student(id)
);


CREATE TABLE Student_Subject (
    student_id INT REFERENCES Student(id),
    subject_id INT REFERENCES Subject(id),
    PRIMARY KEY (student_id, subject_id)
);

CREATE TABLE Exam (
    id INT IDENTITY(1,1) PRIMARY KEY,
    exam_date DATE ,
    score INT CHECK (score <= 100),
    student_id INT REFERENCES Student(id),
    subject_id INT REFERENCES Subject(id)
);

--3. Delete the name column and replace it with two columns first name and last name.
ALTER TABLE Student
DROP COLUMN name;

ALTER TABLE Student 
ADD 
first_Name VARCHAR(30),
Last_Name VARCHAR (30);
select * FROM Student;

-------------------------------------------------------

--4. Delete the address and email column and replace it with contact info (Address, email) as object/Composite Data type.
-- CONTACT INFO (UP) ☝
-------------------------------------------------------

--5. Change any Serial Datatype at your tables to smallInt

--ALTER TABLE your_table_name
--ALTER COLUMN your_column_name TYPE SMALLINT; (i'm using server)

---------------------------------------------------------

-- 7. Insert new data in all Tables :

-- Tracks
INSERT INTO Track (name) VALUES ('Open Source');
INSERT INTO Track (name) VALUES ('Java');

-------------------------------------------------------

-- Subjects
INSERT INTO Subject (name, description, max_score, track_id) VALUES 
('Python', 'Intro to Python programming', 100, 1),
('Linux', 'Linux Fundamentals', 100, 1),
('Java Basics', 'Introduction to Java', 100, 2),
('OOP with Java', 'Object-Oriented Programming in Java', 100, 2);

 ---------------------------------------------------------------

-- Contact Info
INSERT INTO ContactInfo (email, address) VALUES 
('uosif1@example.com', 'Cairo, Egypt'),
('uosif2@example.com', 'Giza, Egypt');

 ---------------------------------------------------------------

-- Students
INSERT INTO Student (first_Name, Last_Name, gender, birth_date, contact_info_id, track_id) VALUES 
('Uosif', 'Negm', 'male', '2005-01-1', 1, 1),
('Akram', 'Mohamed', 'male', '2007-07-21', 2, 2),
('Mariam', 'Ahmed', 'female','1990-12-20', 2, 1),
('Malak', 'Hamada', 'female','1991-12-20', 1, 1),
('Ahmed', 'Oamr', 'male','1985-10-10', 2, 2),
('Mohammed', 'Ahmed', 'male','1999-01-10', 1, 2);

-- Phone 
INSERT INTO Phone (phone_number, student_id) VALUES 
('01095635393', 22),
('01275919103', 23),
('01195635393', 24),
('01295635393', 25),
('01075919103', 26),
('01595635393', 27);

--------------------------------------------------

-- Student_Subjects 
INSERT INTO Student_Subject (student_id, subject_id) VALUES 
(22, 1),  
(24, 2),  
(26, 3),  
(27, 4);

----------------------------------

-- Exams
INSERT INTO Exam (exam_date, score, student_id, subject_id) VALUES 
('2025-07-10', 85, 22, 1),  
('2025-07-11', 90, 26, 2),  
('2025-07-12', 75, 24, 3),  
('2025-07-13', 88, 27, 4);


--1. Insert new student and his score in exam in different subjects as transaction and save it.
BEGIN TRANSACTION;

INSERT INTO Student (first_Name, last_Name, gender, birth_date, contact_info_id, track_id)
VALUES ('Youssef', 'Hassan', 'male', '2003-02-02', 1, 2);


-- 1. Trigger to prevent inserting Course with name > 20 characters
CREATE TRIGGER trg_SubjectNameLength
ON Subject
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(name) > 20)
    BEGIN
        RAISERROR ('Subject name must be 20 characters or less.', 16, 1);
        RETURN;
    END

    INSERT INTO Subject(name, max_score)
    SELECT name, max_score FROM inserted;
END;

-- 2. Trigger to prevent insert/update of Exam with invalid score
CREATE TRIGGER trg_ExamScoreLimit
ON Exam
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE score > 100 OR score < 0)
    BEGIN
        RAISERROR ('Score must be between 0 and 100.', 16, 1);
        RETURN;
    END

   IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        UPDATE e
        SET 
            e.subject_id = i.subject_id,
            e.student_id = i.student_id,
            e.score = i.score
        FROM Exam e
        JOIN inserted i ON e.id = i.id;
    END
    ELSE
    BEGIN
        INSERT INTO Exam (id, subject_id, student_id, score)
        SELECT id, subject_id, student_id, score FROM inserted;
    END
END;

CREATE DATABASE ITI;
GO

USE ITI;
GO

CREATE SCHEMA HR;
GO

CREATE TABLE HR.Employees (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100),
    position VARCHAR(50)
);

CREATE TABLE HR.Departments (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100)
);

BACKUP DATABASE ITI
TO DISK = 'C:\Users\media tech\Desktop\ITI_FullBackup.bak';

WITH FORMAT, MEDIANAME = 'ITIBackup', NAME = 'Full Backup of ITI';
