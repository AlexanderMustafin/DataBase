USE [lab7.2];

--1. Добавить внешние ключи.

ALTER TABLE [student] 
ADD FOREIGN KEY (id_group) REFERENCES [group] (id_group);

ALTER TABLE [lesson] 
ADD FOREIGN KEY (id_group) REFERENCES [group] (id_group);

ALTER TABLE [lesson] 
ADD FOREIGN KEY (id_teacher) REFERENCES [teacher] (id_teacher);

ALTER TABLE [lesson] 
ADD FOREIGN KEY (id_subject) REFERENCES [subject] (id_subject);

ALTER TABLE [mark] 
ADD FOREIGN KEY (id_lesson) REFERENCES [lesson] (id_lesson);

ALTER TABLE [mark] 
ADD FOREIGN KEY (id_student) REFERENCES [student] (id_student);

GO
--2. Выдать оценки студентов по информатике если они обучаются данному предмету. Оформить выдачу данных с использованием view.


CREATE VIEW  info_mark
AS
	SELECT [mark].mark, [student].name 
	FROM [mark]
	INNER JOIN [student] ON [mark].id_student = [student].id_student
	INNER JOIN [lesson] ON [mark].id_lesson = [lesson].id_lesson
	INNER JOIN [subject] ON [lesson].id_subject = [subject].id_subject
	WHERE [subject].name = 'Информатика'
GO

SELECT * FROM info_mark;

DROP VIEW info_mark;
GO

--3. Дать информацию о должниках с указанием фамилии студента и названия предмета. Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе. 
--   Оформить в виде процедуры, на входе идентификатор группы.
GO

CREATE PROCEDURE get_student_debtors  @id_group AS INT 
AS
  SELECT student.name as student, [subject].name as subject FROM  student
    LEFT JOIN [group] ON [student].id_group = [group].id_group
    LEFT JOIN [lesson] ON [lesson].id_group = [group].id_group
	LEFT JOIN [subject] ON [lesson].id_subject = [subject].id_subject
	LEFT JOIN [mark] ON [mark].id_lesson = [lesson].id_lesson
	WHERE [mark].mark IS NULL AND [group].id_group = @id_group
GO

EXECUTE get_student_debtors @id_group = 1;

EXECUTE get_student_debtors @id_group = 2;

EXECUTE get_student_debtors @id_group = 3;

EXECUTE get_student_debtors @id_group = 4;

DROP PROCEDURE get_student_debtors;

--4. Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым занимается не менее 35 студентов.

GO

CREATE TABLE #student_grade_subject(id_subject int, subject_name nvarchar(50), student_quantity int, subject_avg_mark smallint);
INSERT INTO #student_grade_subject
  SELECT subject.id_subject, subject.name, COUNT(student.id_student), AVG(mark.mark) FROM subject
  LEFT JOIN [lesson] ON [subject].id_subject = [lesson].id_subject
  LEFT JOIN [group] ON lesson.id_group = [group].id_group
  LEFT JOIN [student] ON [group].id_group = [student].id_group
  LEFT JOIN [mark] ON [lesson].id_lesson = [mark].id_lesson
  WHERE [student].id_student IS NOT NULL
  GROUP BY [subject].id_subject, [subject].name;
SELECT subject_name, subject_avg_mark FROM #student_grade_subject WHERE student_quantity >= 35;

select * from [lesson]
right JOIN [subject] ON [lesson].id_subject = [subject].id_subject

GO
--5 Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить значениями NULL поля оценки.

CREATE VIEW VM_student_marks AS 
	SELECT [student].name AS student_name, [group].name AS group_name, [mark].mark, [subject].name AS subject_name, [lesson].date 
	FROM [student]
	LEFT JOIN [group] ON [student].id_group = [group].id_group
	LEFT JOIN [lesson] ON [group].id_group = [lesson].id_group
	LEFT JOIN [mark] ON ([student].id_student = [mark].id_student AND [lesson].id_lesson = mark.id_lesson)
	LEFT JOIN [subject] ON [lesson].id_subject = [subject].id_subject
	WHERE [group].name = 'ВМ'
GO

SELECT * FROM VM_student_marks;

DROP VIEW VM_student_marks;

--6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05, повысить эти оценки на 1 балл.

UPDATE [mark]
SET [mark].mark += 1
FROM [mark]
LEFT JOIN [student] ON [mark].id_student = [student].id_student
LEFT JOIN [group] ON [student].id_group = [group].id_group
LEFT JOIN [lesson] ON [mark].id_lesson = [lesson].id_lesson
LEFT JOIN [subject] ON [lesson].id_subject = [subject].id_subject
WHERE [subject].name = 'БД' AND [group].name = 'ПС' AND [lesson].date < '2019-05-12' AND [mark].mark < 5

SELECT * FROM [mark];

--7. Добавить необходимые индексы.

CREATE NONCLUSTERED INDEX [IX_lesson_id_group] ON [dbo].[lesson]
(
	[id_group] ASC
)

CREATE NONCLUSTERED INDEX [IX_lesson_id_subject] ON [dbo].[lesson]
(
	[id_subject] ASC
)


CREATE NONCLUSTERED INDEX [IX_student_id_group] ON [dbo].[student]
(
	[id_group] ASC
)

CREATE NONCLUSTERED INDEX [IX_lesson_id_teacher] ON [dbo].[lesson]
(
	[id_teacher] ASC
)

CREATE NONCLUSTERED INDEX [IX_student_name] ON [dbo].[student]
(
	[name] ASC
)


CREATE NONCLUSTERED INDEX [IX_group_name] ON [dbo].[group]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_subject_name] ON [dbo].[subject]
(
	[name] ASC
)

CREATE UNIQUE NONCLUSTERED INDEX [IU_student_phone] ON [dbo].[student]
(
	[phone] ASC
)

CREATE NONCLUSTERED INDEX [IX_teacher_name] ON [dbo].[teacher]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_mark_id_lesson] ON [dbo].[mark]
(
	[id_lesson] ASC
)

CREATE NONCLUSTERED INDEX [IX_mark_mark] ON [dbo].[mark]
(
	[mark] ASC
)

CREATE NONCLUSTERED INDEX [IX_mark_id_student] ON [dbo].[mark]
(
	[id_student] ASC
)

