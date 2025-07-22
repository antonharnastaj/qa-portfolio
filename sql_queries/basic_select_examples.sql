-- 1. Найти пользователя по email
SELECT * FROM users WHERE email = 'user@example.com';

-- 2. Проверить активен ли пользователь
SELECT is_active FROM users WHERE email = 'user@example.com';

-- 3. Найти сессии пользователя
SELECT * FROM user_sessions WHERE user_id = 123 ORDER BY created_at DESC;

-- 4. Проверить активный токен
SELECT * FROM auth_tokens WHERE user_id = 123 AND is_active = true;

-- 5. Существует ли пользователь
SELECT COUNT(*) FROM users WHERE username = 'test_user';

-- 6. Вставка тестового пользователя
INSERT INTO users (username, email, password, is_active)
VALUES ('test_user', 'test@example.com', 'hashed_password', true);

-- 7. Удаление тестового пользователя
DELETE FROM users WHERE email = 'test@example.com';

-- 8. Попытка найти несуществующего пользователя
SELECT * FROM users WHERE email = 'nope@example.com';

-- 9. Поиск дубликатов email
SELECT email, COUNT(*) FROM users GROUP BY email HAVING COUNT(*) > 1;

-- 10. Проверка на SQL-инъекцию
SELECT * FROM users WHERE username = '' OR 1=1 --';

-- 11. Проверка последнего входа пользователя
SELECT last_login_at FROM users WHERE email = 'user@example.com';

-- 12. Проверка последних действий пользователя
SELECT * FROM audit_logs WHERE user_id = 123 ORDER BY created_at DESC;



-- **МОИ РАБОЧИЕ ПРИМЕРЫ**
-- *Запросы, групповые операции*
/*Посчитать стоимость всех экземпляров каждого автора без учета книг «Идиот» и «Белая гвардия». 
В результат включить только тех авторов, у которых суммарная стоимость книг (без учета книг «Идиот» и «Белая гвардия») 
более 5000 руб. Вычисляемый столбец назвать Стоимость. Результат отсортировать по убыванию стоимости.*/
SELECT author,
    SUM(price*amount) AS Стоимость
FROM book
WHERE title <> 'Идиот' AND title <> 'Белая гвардия'
GROUP BY author
HAVING SUM(price*amount) > 5000
ORDER BY Стоимость DESC;

-- *Вложенные запросы*
/*Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, чтобы на складе стало одинаковое количество экземпляров 
каждой книги, равное значению самого большего количества экземпляров одной книги на складе. 
Вывести название книги, ее автора, текущее количество экземпляров на складе и количество заказываемых экземпляров книг. 
Последнему столбцу присвоить имя Заказ. В результат не включать книги, которые заказывать не нужно.*/
SELECT title, author, amount, 
      ABS(amount - (SELECT MAX(amount) FROM book)) AS Заказ 
FROM book
WHERE ABS(amount - (SELECT MAX(amount) FROM book)) > 0;

-- *Запросы корректировки данных*
/*Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше 4.
Для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.*/
CREATE TABLE ordering AS
SELECT author, title, 
   (
    SELECT ROUND(AVG(amount)) 
    FROM book
   ) AS amount
FROM book
WHERE amount < (SELECT ROUND(AVG(amount)) FROM book);

-- *Запросы на выборку*
/*Вывести название месяца и количество командировок для каждого месяца. Считаем, что командировка относится к некоторому месяцу, 
если она началась в этом месяце. Информацию вывести сначала в отсортированном по убыванию количества, а потом в алфавитном порядке
по названию месяца виде. Название столбцов – Месяц и Количество.*/
SELECT MONTHNAME (date_first) AS 'Месяц', COUNT(MONTHNAME(date_first)) AS 'Количество'
FROM trip
GROUP BY Месяц
ORDER BY Количество DESC, Месяц ASC;

-- *Запрос на выборку, соединение таблиц*
/*Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям 
книг виде*/
SELECT name_genre, title, name_author
FROM
    author 
    INNER JOIN  book ON author.author_id = book.author_id
    INNER JOIN genre ON genre.genre_id = book.genre_id
WHERE name_genre = 'Роман'
ORDER BY title;

