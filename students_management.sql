create database students_management;
use students_management;

CREATE TABLE Classes(
Class_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Class_Name VARCHAR(60) NOT NULL,
Start_Date DATETIME NOT NULL,
Status BIT
);

CREATE TABLE Students(
Student_Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Student_Name VARCHAR(30) NOT NULL,
Address VARCHAR(50),	
Phone VARCHAR(20),
Status BIT,
Class_Id INT NOT NULL,
FOREIGN KEY (Class_Id) REFERENCES Classes (Class_Id)
);

CREATE TABLE Subject(
Sub_Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Sub_Name VARCHAR(30) NOT NULL,
Credit TINYINT NOT NULL DEFAULT 1 CHECK ( Credit >= 1 ),
Status BIT DEFAULT 1
);

CREATE TABLE Mark(
Mark_Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Sub_Id INT NOT NULL,
Student_Id INT NOT NULL,
Mark FLOAT DEFAULT 0 CHECK ( Mark BETWEEN 0 AND 100),
Exam_Times TINYINT DEFAULT 1,
UNIQUE (Sub_Id, Student_Id),
FOREIGN KEY (Sub_Id) REFERENCES Subject (Sub_Id),
FOREIGN KEY (Student_Id) REFERENCES Students (Student_Id)
 );

INSERT INTO Classes
VALUES (1, 'A1', '2008-12-20', 1);
INSERT INTO Classes
VALUES (2, 'A2', '2008-12-22', 1);
INSERT INTO Classes
VALUES (3, 'B3', current_date, 0);

INSERT INTO Students (Student_Name, Address, Phone, Status, Class_Id)
VALUES ('Hung', 'Ha Noi', '0912113113', 1, 1);
INSERT INTO Students (Student_Name, Address, Status, Class_Id)
VALUES ('Hoa', 'Hai phong', 1, 1);
INSERT INTO Students (Student_Name, Address, Phone, Status, Class_Id)
VALUES ('Manh', 'HCM', '0123123123', 0, 2);

INSERT INTO Subject
VALUES (1, 'CF', 5, 1),
 (2, 'C', 6, 1),
 (3, 'HDJ', 5, 1),
 (4, 'RDBMS', 10, 1);
 
INSERT INTO Mark (Sub_Id, Student_Id, Mark, Exam_Times)
VALUES (1, 1, 8, 1),
 (1, 2, 10, 2),
 (2, 1, 12, 1);
 
 SELECT *
FROM Students;

SELECT *
FROM Students
WHERE Status = true;

SELECT *
FROM Subject
WHERE Credit < 10;

SELECT S.Student_Id, S.Student_Name, C.Class_Name
FROM Students S join Classes C on S.Class_Id = C.Class_ID;

SELECT S.Student_Id, S.Student_Name, C.Class_Name
FROM Students S join Classes C on S.Class_Id = C.Class_ID
WHERE C.Class_Name = 'A1';

SELECT S.Student_Id, S.Student_Name, Sub.Sub_Name, M.Mark
FROM Students S join Mark M on S.Student_Id = M.Student_Id join Subject Sub on M.Sub_Id = Sub.Sub_Id;

SELECT S.Student_Id, S.Student_Name, Sub.Sub_Name, M.Mark
FROM Students S join Mark M on S.Student_Id = M.Student_Id join Subject Sub on M.Sub_Id = Sub.Sub_Id
WHERE Sub.Sub_Name = 'CF';

-- ss3 excercise
-- Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’
select s.student_id, s.Student_Name
from students s 
where Student_Name like 'h%';

-- Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
select c.class_id, c.class_name, c.start_date
from classes c 
where month(start_date) = 12; 

-- Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
select * from subject
where credit between 3 and 5;

-- Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
SET SQL_SAFE_UPDATES = 0;
update students
set class_id = 2
where student_name = 'Hung';
SET SQL_SAFE_UPDATES = 1;

-- Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
SELECT s.student_name, sub.sub_name, mark.mark
FROM students s 
JOIN subject sub on s.student_id = sub.sub_id
JOIN mark on s.student_id = mark.mark_id ORDER BY mark.mark, s.student_name;

-- ss4 thực hành
SELECT Address, COUNT(Student_Id) AS 'Số lượng học viên'
FROM Students
GROUP BY Address;

SELECT S.Student_Id,S.Student_Name, AVG(Mark)
FROM Students S join Mark M on S.Student_Id = M.Student_Id
GROUP BY S.Student_Id, S.Student_Name;

SELECT S.Student_Id,S.Student_Name, AVG(Mark)
FROM Students S join Mark M on S.Student_Id = M.Student_Id
GROUP BY S.Student_Id, S.Student_Name
HAVING AVG(Mark) > 15;

SELECT S.Student_Id, S.Student_Name, AVG(Mark)
FROM Students S join Mark M on S.Student_Id = M.Student_Id
GROUP BY S.Student_Id, S.Student_Name
HAVING AVG(Mark) >= ALL (SELECT AVG(Mark) FROM Mark GROUP BY Mark.Student_Id);

-- ss4 bài tập
SELECT * 
FROM subject
WHERE credit = (SELECT MAX(credit) from subject); 

SELECT sub.*, m.mark
FROM subject sub
JOIN mark m on sub.sub_id = m.mark_id
WHERE m.mark = (SELECT MAX(mark) from mark);

SELECT s.*, AVG(m.mark) as avg_mark
FROM students s
JOIN mark m ON s.Student_Id = m.Student_Id
GROUP BY s.Student_Id
ORDER BY avg_mark;


