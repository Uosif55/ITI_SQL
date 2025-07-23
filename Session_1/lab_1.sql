DROP TABLE IF EXISTS Exam;
DROP TABLE IF EXISTS Student_Subject;
DROP TABLE IF EXISTS Student;
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
    first_name VARCHAR(50),
    last_name VARCHAR(50),
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
    exam_date DATE NOT NULL,
    score INT CHECK (score <= 100),
    student_id INT REFERENCES Student(id),
    subject_id INT REFERENCES Subject(id)
);

-- Tracks
INSERT INTO Track (name) VALUES ('Open Source');
INSERT INTO Track (name) VALUES ('Java');

-- Subjects
INSERT INTO Subject (name, description, max_score, track_id) VALUES 
('Python', 'Intro to Python programming', 100, 1),
('Linux', 'Linux Fundamentals', 100, 1),
('Java Basics', 'Introduction to Java', 100, 2),
('OOP with Java', 'Object-Oriented Programming in Java', 100, 2);

-- Contact Info
INSERT INTO ContactInfo (email, address) VALUES 
('uosif1@example.com', 'Cairo, Egypt'),
('uosif2@example.com', 'Giza, Egypt');

-- Students
INSERT INTO Student (first_name, last_name, gender, birth_date, contact_info_id, track_id) VALUES 
('Uosif', 'Negm', 'male', '2005-01-1', 1, 1),
('Uosif', 'Mohamed', 'male', '2002-08-21', 2, 2);

-- Student_Subjects 
INSERT INTO Student_Subject (student_id, subject_id) VALUES 
(1, 1),  
(1, 2),  
(2, 3),  
(2, 4);  

-- Exams
INSERT INTO Exam (exam_date, score, student_id, subject_id) VALUES 
('2025-07-10', 85, 1, 1),  
('2025-07-11', 90, 1, 2),  
('2025-07-12', 75, 2, 3),  
('2025-07-13', 88, 2, 4);  
