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
('mohammeed', 'Ahmed', 'male','1999-01-10', 1, 2);

UPDATE Student
Set first_Name = 'Mohammed'
WHERE first_Name = 'mohammeed';
select * from Student;

----------------------------------------------

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

--------------------------------------------------------------

--8. Display all students’ information.
SELECT *
FROM Student;

--------------------------------------------------------------

--9. Display male students only.
SELECT * 
FROM Student 
WHERE gender = 'male';

---------------------------------------------------------

--10. Display the number of female students.
SELECT COUNT(*) 
FROM Student 
WHERE gender = 'female';

----------------------------------------------------------  

--11. Display the students who are born before 1992-10-01.
SELECT * 
FROM Student
WHERE birth_date < '1992-10-01';

 ----------------------------------------------------------

--12. Display male students who are born before 1991-10-01.
SELECT * 
FROM Student
WHERE gender = 'male' AND birth_date < '1991-10-01';

 -------------------------------------------------------------

--13. Display subjects and their max score sorted by max score.
SELECT name, max_score
FROM Subject
ORDER BY max_score DESC;

------------------------------------------------------------

--14. Display the subject with highest max score
SELECT name, max_score
FROM Subject
WHERE max_score = (SELECT MAX(max_score) FROM Subject);

-----------------------------------------------------------
  
--15. Display students’ names that begin with A.
SELECT first_Name, Last_Name
FROM Student
WHERE first_Name LIKE 'A%';

----------------------------------------------------------

--16. Display the number of students’ their name is “Mohammed”
SELECT COUNT(*) 
FROM Student 
WHERE first_Name LIKE 'Mohammed';

-----------------------------------------------------------------

--17. Display the number of males and females.
SELECT COUNT(gender) 
FROM Student ;

  -------------------------------------------------------------------

--18. Display the repeated first names and their counts if higher than 2.
SELECT first_Name, COUNT(*) AS name_count
FROM Student
GROUP BY first_Name
HAVING COUNT(*) > 2;
---------------------------------------------------------

-- 19. Display the all Students and track name that belong to it
SELECT 
    first_Name, 
    Last_Name, 
    (SELECT name 
     FROM Track 
     WHERE Track.id = Student.track_id) AS track_name
FROM 
    Student;
	----------------------------------------------------------------

--20. (Bouns) Display students’ names, their score and subject name.
SELECT
  (SELECT first_name + ' ' + Last_Name --(Concatinate)
   FROM Student 
   WHERE Student.id = Exam.student_id) AS student_name,
   score,

  (SELECT name 
   FROM Subject 
   WHERE Subject.id = Exam.subject_id) AS subject_name

FROM Exam;
----20. (Bouns) Display students’ names, their score and subject name. (By Join)
SELECT 
    S.first_Name + ' ' + S.last_Name AS student_name,
    E.score,
    Sub.name
FROM 
    Student S
JOIN 
    Exam E ON S.id = E.student_id
JOIN 
    Subject Sub ON E.subject_id = Sub.id;

	--------------------------Lab_3--------------------------------------------------

--1. Insert new student and his score in exam in different subjects as transaction and save it.
BEGIN TRANSACTION;

INSERT INTO Student (first_Name, last_Name, gender, birth_date, contact_info_id, track_id)
VALUES ('Youssef', 'Hassan', 'male', '2003-02-02', 1, 2);

DECLARE @StudentID INT = SCOPE_IDENTITY();

INSERT INTO Exam (student_id, subject_id, score)
VALUES 
(@StudentID, 1, 85),
(@StudentID, 2, 92),
(@StudentID, 3, 78);

COMMIT;
SELECT * FROM Student;

--1. Insert new student and his score in exam in different subjects as transaction and Undo it.

BEGIN TRANSACTION;

INSERT INTO Student (first_Name, last_Name, gender, birth_date, contact_info_id, track_id)
VALUES ('Omar', 'Ali', 'male', '2001-01-01', 2, 1);

DECLARE @StudentID INT = SCOPE_IDENTITY();

INSERT INTO Exam (student_id, subject_id, score)
VALUES 
(@StudentID, 1, 88),
(@StudentID, 2, 77);

ROLLBACK;
