Предметная область База данных по студентам имеет следующие таблицы:
Группы:
идентификатор группы, краткое название специальности (ПС, ВМ, ИВТ, БИ).

Студенты:
идентификатор студента, фамилия, номер телефона, идентификатор группы.

Предметы:
идентификатор предмета, название.

Преподаватели:
идентификатор преподавателя, фамилия, номер телефона.

Занятия:
идентификатор занятия, идентификатор преподавателя, идентификатор предмета, идентификатор группы, дата.

Оценки:идентификатор оценки, идентификатор студента, идентификатор занятия, оценка.

Требуется
1. Добавить внешние ключи.
2. 
3.Выдать оценки студентов по информатике если они обучаются данному предмету. Оформить выдачу данных с использованием view.

4.Дать информацию о должниках с указанием фамилии студента и названия предмета.Должниками считаются студенты, не имеющие оценки по предмету,
который ведется в группе. Оформить в виде процедуры, на входе идентификатор группы.

4.Дать среднюю оценку студентов по каждому предмету для тех предметов, по
которым занимается не менее 35 студентов.

5.Дать оценки студентов специальности ВМ по всем проводимым предметам суказанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить
значениями NULL поля оценки.

6.Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05, повысить эти оценки на 1 балл.

7.Добавить необходимые индексы.
