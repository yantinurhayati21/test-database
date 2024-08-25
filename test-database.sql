
#MEMBUAT DATABASE
CREATE DATABASE school_management;

#MEMBUAT DAN MENGISI TABEL teachers
CREATE TABLE teachers (
    id INT AUTO_INCREMENT,
    NAME VARCHAR(100),
    SUBJECT VARCHAR(50),
    PRIMARY KEY(id)
);

INSERT INTO teachers (NAME, SUBJECT) VALUES ('Pak Anton', 'Matematika');
INSERT INTO teachers (NAME, SUBJECT) VALUES ('Bu Dina', 'Bahasa Indonesia');
INSERT INTO teachers (NAME, SUBJECT) VALUES ('Pak Eko', 'Biologi');

#MEMBUAT DAN MENGISI TABEL classes
CREATE TABLE classes (
    id INT AUTO_INCREMENT,
    NAME VARCHAR(50),
    teacher_id INT,
    PRIMARY KEY(id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

INSERT INTO classes (NAME, teacher_id) VALUES ('Kelas 10A', 1);
INSERT INTO classes (NAME, teacher_id) VALUES ('Kelas 11B', 2);
INSERT INTO classes (NAME, teacher_id) VALUES ('Kelas 12C', 3);


#MEMBUAT DAN MENGISI TABEL students
CREATE TABLE students (
    id INT AUTO_INCREMENT,
    NAME VARCHAR(100),
    age INT,
    class_id INT,
    PRIMARY KEY(id),
    FOREIGN KEY (class_id) REFERENCES classes(id)
);

INSERT INTO students (NAME, age, class_id) VALUES ('Budi', 16, 1);
INSERT INTO students (NAME, age, class_id) VALUES ('Ani', 17, 2);
INSERT INTO students (NAME, age, class_id) VALUES ('Candra', 18, 3);

#SOAL TES

#1. Tampilkan daftar siswa beserta kelas dan guru yang mengajar kelas tersebut.
SELECT s.name AS student_name, c.name AS class_name, t.name AS teacher_name
FROM students s
JOIN classes c ON s.class_id = c.id
JOIN teachers t ON c.teacher_id = t.id;

#2. Tampilkan daftar kelas yang diajar oleh guru yang sama.
SELECT t.name AS teacher_name, GROUP_CONCAT(c.name) AS classes
FROM classes c
JOIN teachers t ON c.teacher_id = t.id
GROUP BY t.id
HAVING COUNT(c.id) > 1; 

#3. buat query view untuk siswa, kelas, dan guru yang mengajar
CREATE VIEW student_class_teacher_view AS
SELECT s.name AS student_name, c.name AS class_name, t.name AS teacher_name
FROM students s
JOIN classes c ON s.class_id = c.id
JOIN teachers t ON c.teacher_id = t.id;
#mengakses data view
SELECT * FROM student_class_teacher_view;

#4. buat query yang sama tapi menggunakan store_procedure
DELIMITER $$
CREATE PROCEDURE GetStudentClassTeacher()
BEGIN
    SELECT s.name AS student_name, c.name AS class_name, t.name AS teacher_name
    FROM students s
    JOIN classes c ON s.class_id = c.id
    JOIN teachers t ON c.teacher_id = t.id;
END $$
DELIMITER ;
#pemanggilan procedure
CALL GetStudentClassTeacher();

#5. buat query input, yang akan memberikan warning error jika ada data yang sama pernah masuk
DELIMITER $$
CREATE TRIGGER before_student_insert
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);

    IF EXISTS (SELECT 1 FROM students WHERE NAME = NEW.name) THEN
        SET msg = CONCAT('Error: Siswa dengan nama "', NEW.name, '" sudah ada.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END $$
DELIMITER ;

#insert data yang sudah ada
INSERT INTO students (NAME, age, class_id) VALUES ('Budi', 16, 1);