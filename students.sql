create database students;
use students;

create table teachers (
id int primary key auto_increment,
name varchar(50),
gender varchar(20),
phone_number varchar(10),
dob date
);

create table classes (
id int primary key auto_increment,
name varchar(50)
);

create table account_student(
username varchar(100) primary key,
password varchar(200)
);

create table students (
id int primary key auto_increment,
name varchar(50),
gender varchar(20),
phone_number varchar(10),
dob date,
id_class int,
username varchar(100) unique,
foreign key fk_account_students(username) references account_student(username),
foreign key fk_classes_students(id_class) references classes(id)
);

create table teachers_teach_classes (
id_teacher int,
id_class int,
primary key (id_teacher, id_class),
foreign key fk_classes_teachers(id_class) references classes(id),
foreign key fk_classes_teachers2(id_teacher) references teachers(id)
);

insert into classes(name) value ('c03');
insert into account_student(username, password) value ('AAA', '123456');
insert into account_student(username, password) value ('T123', '123456');
insert into account_student(username, password) value ('Toan', '123456');
insert into students(name, gender, phone_number, dob, id_class, username) value ('Nguyen Van A', 'male', '0123654987', '2000-02-01', 1, 'AAA');
insert into students(name, gender, phone_number, dob, id_class, username) value ('Le T', 'male', '0894514987', '2000-06-11', 1, 'T123');
insert into students(name, gender, phone_number, dob, id_class, username) value ('Nguyen Toan', 'male', '0894514111', '2000-09-10', 1, 'Toan');
insert into teachers(name, gender, phone_number, dob) value ('Dao H', 'male', '0981356485', '1986-05-20');
INSERT INTO teachers_teach_classes (id_teacher, id_class) VALUES (1, 1); 

-- 1. Lấy ra thông tin các học viên, và cho biết các học viên đang theo học lớp nào.
select s.*, c.name
from students s
join classes c
on s.id_class = c.id;

-- 2. Lấy ra thông tin các học viên, và cho biết các học viên đang theo học lớp nào, lớp đó giảng viên nào dạy
select s.*, c.name, t.name
from students s
join classes c on s.id_class = c.id
join teachers_teach_classes ttc on c.id = ttc.id_class
join teachers t on ttc.id_teacher = t.id;

-- 3. Lấy ra thông tin các học viên đang theo học tại các lớp kể cả các học viên không theo học lớp nào.
select s.*, c.name
from students s
left join classes c 
on s.id_class = c.id;

-- 4. Lấy thông tin của các học viên tên ‘Tien’ và ‘Toan’.
select * from students
where name like '%Tien%' or name like '%Toan%';

-- 5. Lấy ra số lượng học viên của từng lớp.
select c.name as class_name,
count(s.id) as student_count
from classes c 
left join students s on c.id = s.id_class
group by c.id, c.name;

-- 6. Lấy ra danh sách học viên và sắp xếp tên theo alphabet
select * from students
order by name asc;


