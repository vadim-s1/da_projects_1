Задача 1.
Посчитайте, сколько компаний закрылось.
------------------
Запрос:
SELECT COUNT(*)
FROM company
WHERE status = 'closed';


Задача 2.
Отобразите количество привлечённых средств для новостных компаний США. Используйте данные из таблицы company. Отсортируйте таблицу по убыванию значений в поле funding_total.
------------------
Запрос:
SELECT funding_total
FROM company
WHERE country_code = 'USA'
AND category_code = 'news'
ORDER BY funding_total DESC;


Задача 3.
Найдите общую сумму сделок по покупке одних компаний другими в долларах. Отберите сделки, которые осуществлялись только за наличные с 2011 по 2013 год включительно.
------------------
Запрос:
SELECT SUM(price_amount)
FROM acquisition
WHERE EXTRACT(YEAR FROM acquired_at) BETWEEN 2011
AND 2013
AND term_code = 'cash';


Задача 4.
Отобразите имя, фамилию и названия аккаунтов людей в твиттере, у которых названия аккаунтов начинаются на 'Silver'.
------------------
Запрос:
SELECT first_name,
       last_name,
       twitter_username
FROM people
WHERE twitter_username LIKE 'Silver%';


Задача 5.
Выведите на экран всю информацию о людях, у которых названия аккаунтов в твиттере содержат подстроку 'money', а фамилия начинается на 'K'.
------------------
Запрос:
SELECT *
FROM people
WHERE twitter_username LIKE '%money%'
AND last_name LIKE 'K%';


Задача 6.
Для каждой страны отобразите общую сумму привлечённых инвестиций, которые получили компании, зарегистрированные в этой стране. Страну, в которой зарегистрирована компания, можно определить по коду страны. Отсортируйте данные по убыванию суммы.
------------------
Запрос:
SELECT country_code,
       SUM(funding_total) AS total
FROM company
GROUP BY country_code
ORDER BY total DESC;


Задача 7.
Составьте таблицу, в которую войдёт дата проведения раунда, а также минимальное и максимальное значения суммы инвестиций, привлечённых в эту дату.
Оставьте в итоговой таблице только те записи, в которых минимальное значение суммы инвестиций не равно нулю и не равно максимальному значению.
------------------
Запрос:
SELECT funded_at,
       MIN(raised_amount) AS min_amount,
       MAX(raised_amount) AS max_amount
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) <> 0
AND MIN(raised_amount) <> MAX(raised_amount);


Задача 8.
Создайте поле с категориями:
- Для фондов, которые инвестируют в 100 и более компаний, назначьте категорию high_activity.
- Для фондов, которые инвестируют в 20 и более компаний до 100, назначьте категорию middle_activity.
- Если количество инвестируемых компаний фонда не достигает 20, назначьте категорию low_activity.
Отобразите все поля таблицы fund и новое поле с категориями.
------------------
Запрос:
SELECT *,
       CASE
           WHEN invested_companies >= 100 THEN 'high_activity'
           WHEN invested_companies >= 20 AND invested_companies < 100 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS category
FROM fund;


Задача 9.
Для каждой из категорий, назначенных в предыдущем задании, посчитайте округлённое до ближайшего целого числа среднее количество инвестиционных раундов, в которых фонд принимал участие. Выведите на экран категории и среднее число инвестиционных раундов. Отсортируйте таблицу по возрастанию среднего.
------------------
Запрос:
SELECT CASE
           WHEN invested_companies >= 100 THEN 'high_activity'
           WHEN invested_companies >= 20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity,
       ROUND(AVG(investment_rounds)) AS avg_rounds
FROM fund
GROUP BY activity
ORDER BY avg_rounds;


Задача 10.
Проанализируйте, в каких странах находятся фонды, которые чаще всего инвестируют в стартапы. Для каждой страны посчитайте минимальное, максимальное и среднее число компаний, в которые инвестировали фонды этой страны, основанные с 2010 по 2012 год включительно. Исключите страны с фондами, у которых минимальное число компаний, получивших инвестиции, равно нулю. 
Выгрузите десять самых активных стран-инвесторов: отсортируйте таблицу по среднему количеству компаний от большего к меньшему. Затем добавьте сортировку по коду страны в лексикографическом порядке.
------------------
Запрос:
SELECT country_code,
       MIN(invested_companies) AS min_invested_companies,
       MAX(invested_companies) AS max_invested_companies,
       AVG(invested_companies) AS avg_invested_companies
FROM (SELECT *
      FROM fund
      WHERE EXTRACT(YEAR FROM founded_at) BETWEEN 2010
      AND 2012) AS i
GROUP BY country_code
HAVING MIN(invested_companies) <> 0
ORDER BY avg_invested_companies DESC, country_code
LIMIT 10;


Задача 11.
Отобразите имя и фамилию всех сотрудников стартапов. Добавьте поле с названием учебного заведения, которое окончил сотрудник, если эта информация известна.
------------------
Запрос:
SELECT first_name,
       last_name,
       instituition
FROM people AS p
LEFT JOIN education AS e ON p.id = e.person_id;


Задача 12.
Для каждой компании найдите количество учебных заведений, которые окончили её сотрудники. Выведите название компании и число уникальных названий учебных заведений. Составьте топ-5 компаний по количеству университетов.
------------------
Запрос:
SELECT name,
       COUNT(DISTINCT instituition) AS count_instituition
FROM company AS c
JOIN people AS p ON c.id = p.company_id
JOIN education AS e ON p.id = e.person_id
GROUP BY name
ORDER BY count_instituition DESC
LIMIT 5;


Задача 13.
Составьте список с уникальными названиями закрытых компаний, для которых первый раунд финансирования оказался последним.
------------------
Запрос:
SELECT DISTINCT c.name
FROM company AS c
JOIN funding_round AS fr ON c.id = fr.company_id
WHERE status = 'closed'
AND is_first_round = 1
AND is_last_round = 1;


Задача 14.
Составьте список уникальных номеров сотрудников, которые работают в компаниях, отобранных в предыдущем задании.
------------------
Запрос:
SELECT DISTINCT p.id
FROM people AS p
WHERE p.company_id IN (SELECT c.id
                       FROM company AS c
                       JOIN funding_round AS fr ON c.id = fr.company_id
                       WHERE status = 'closed'
                       AND is_first_round = 1
                       AND is_last_round = 1);


Задача 15.
Составьте таблицу, куда войдут уникальные пары с номерами сотрудников из предыдущей задачи и учебным заведением, которое окончил сотрудник.
------------------
Запрос:
SELECT DISTINCT p.id,
       e.instituition
FROM people AS p
JOIN education AS e ON p.id = e.person_id
WHERE p.company_id IN (SELECT c.id
                       FROM company AS c
                       JOIN funding_round AS fr ON c.id = fr.company_id
                       WHERE status = 'closed'
                       AND is_first_round = 1
                       AND is_last_round = 1);


Задача 16.
Посчитайте количество учебных заведений для каждого сотрудника из предыдущего задания. При подсчёте учитывайте, что некоторые сотрудники могли окончить одно и то же заведение дважды.
------------------
Запрос:
SELECT DISTINCT p.id,
       COUNT(e.instituition) AS count_instituition
FROM people AS p
JOIN education AS e ON p.id = e.person_id
WHERE p.company_id IN (SELECT c.id
                       FROM company AS c
                       JOIN funding_round AS fr ON c.id = fr.company_id
                       WHERE status = 'closed'
                       AND is_first_round = 1
                       AND is_last_round = 1)
GROUP BY p.id;


Задача 17.
Дополните предыдущий запрос и выведите среднее число учебных заведений (всех, не только уникальных), которые окончили сотрудники разных компаний. Нужно вывести только одну запись, группировка здесь не понадобится.
------------------
Запрос:
SELECT AVG(a.count_instituition) AS avg_count_instituition
FROM (SELECT DISTINCT p.id,
             COUNT(e.instituition) AS count_instituition
      FROM people AS p
      JOIN education AS e ON p.id = e.person_id
      WHERE p.company_id IN (SELECT c.id
                             FROM company AS c
                             JOIN funding_round AS fr ON c.id = fr.company_id
                             WHERE status = 'closed'
                             AND is_first_round = 1
                             AND is_last_round = 1)
      GROUP BY p.id) AS a;


Задача 18.
Напишите похожий запрос: выведите среднее число учебных заведений (всех, не только уникальных), которые окончили сотрудники Facebook.
------------------
Запрос:
SELECT AVG(a.count_instituition) AS avg_count_instituition
FROM (SELECT p.id AS id_people,
             COUNT(instituition) AS count_instituition
      FROM company AS c
      JOIN people AS p ON c.id = p.company_id
      JOIN education AS e ON p.id = e.person_id
      WHERE name = 'Facebook'
      GROUP BY id_people) AS a;


Задача 19.
Составьте таблицу из полей:
- name_of_fund — название фонда;
- name_of_company — название компании;
- amount — сумма инвестиций, которую привлекла компания в раунде.
В таблицу войдут данные о компаниях, в истории которых было больше шести важных этапов, а раунды финансирования проходили с 2012 по 2013 год включительно.
------------------
Запрос:
SELECT f.name AS name_of_fund,
       c.name AS name_of_company,
       fr.raised_amount AS amount
FROM company AS c
JOIN investment AS i ON c.id = i.company_id
JOIN funding_round AS fr ON i.funding_round_id = fr.id
JOIN fund AS f ON i.fund_id = f.id
WHERE c.milestones > 6
AND EXTRACT(YEAR FROM funded_at) BETWEEN 2012
AND 2013;


Задача 20.
Выгрузите таблицу, в которой будут такие поля:
- название компании-покупателя;
- сумма сделки;
- название компании, которую купили;
- сумма инвестиций, вложенных в купленную компанию;
- доля, которая отображает, во сколько раз сумма покупки превысила сумму вложенных в компанию инвестиций, округлённая до ближайшего целого числа.
Не учитывайте те сделки, в которых сумма покупки равна нулю. Если сумма инвестиций в компанию равна нулю, исключите такую компанию из таблицы. 
Отсортируйте таблицу по сумме сделки от большей к меньшей, а затем по названию купленной компании в лексикографическом порядке. Ограничьте таблицу первыми десятью записями.
------------------
Запрос:
SELECT c.name AS acquiring_name,
       a.price_amount AS purchase_amount,
       co.name AS acquired_name,
       co.funding_total AS attracted_investments,
       ROUND(a.price_amount / co.funding_total) AS share
FROM acquisition AS a
JOIN company AS c ON a.acquiring_company_id = c.id
JOIN company AS co ON a.acquired_company_id = co.id
WHERE a.price_amount <> 0
AND co.funding_total != 0
ORDER BY a.price_amount DESC, co.name
LIMIT 10;


Задача 21.
Выгрузите таблицу, в которую войдут названия компаний из категории social, получившие финансирование с 2010 по 2013 год включительно. Проверьте, что сумма инвестиций не равна нулю. Выведите также номер месяца, в котором проходил раунд финансирования.
------------------
Запрос:
SELECT name AS company_name,
       EXTRACT(MONTH FROM funded_at) AS month_number
FROM company AS c
JOIN funding_round AS fr ON c.id = fr.company_id
WHERE category_code = 'social'
AND EXTRACT(YEAR FROM funded_at) BETWEEN 2010
AND 2013
AND fr.raised_amount <> 0;


Задача 22.
Отберите данные по месяцам с 2010 по 2013 год, когда проходили инвестиционные раунды. Сгруппируйте данные по номеру месяца и получите таблицу, в которой будут поля:
- номер месяца, в котором проходили раунды;
- количество уникальных названий фондов из США, которые инвестировали в этом месяце;
- количество компаний, купленных за этот месяц;
- общая сумма сделок по покупкам в этом месяце.
------------------
Запрос:
WITH
pivot_table AS (SELECT EXTRACT(MONTH FROM fr.funded_at) AS month_round,
                       COUNT(DISTINCT f.name) AS count_invest_fund
                FROM investment AS i
                JOIN fund AS f ON i.fund_id = f.id 
                JOIN funding_round AS fr ON i.funding_round_id = fr.id
                WHERE f.country_code = 'USA'
                AND EXTRACT(YEAR FROM fr.funded_at) BETWEEN 2010
                AND 2013
                GROUP BY month_round),
acquired_table AS (SELECT EXTRACT(MONTH FROM a.acquired_at) AS month_round,
                          COUNT(acquired_company_id) AS count_acquired_company,
                          SUM(a.price_amount) AS total_sum
                   FROM acquisition AS a
                   WHERE EXTRACT(YEAR FROM a.acquired_at) BETWEEN 2010
                   AND 2013
                   GROUP BY month_round)
SELECT DISTINCT pt.month_round,
       pt.count_invest_fund,
       at.count_acquired_company,
       at.total_sum
FROM pivot_table AS pt
LEFT JOIN acquired_table AS at ON pt.month_round = at.month_round
ORDER BY pt.month_round;


Задача 23.
Составьте сводную таблицу и выведите среднюю сумму инвестиций для стран, в которых есть стартапы, зарегистрированные в 2011, 2012 и 2013 годах. Данные за каждый год должны быть в отдельном поле. Отсортируйте таблицу по среднему значению инвестиций за 2011 год от большего к меньшему.
------------------
Запрос:
WITH
year_2011 AS (SELECT country_code AS country,
                     AVG(funding_total) AS avg_investment_2011
              FROM company AS c
              WHERE EXTRACT(YEAR FROM founded_at) = 2011
              GROUP BY country_code),
year_2012 AS (SELECT country_code AS country,
                     AVG(funding_total) AS avg_investment_2012
              FROM company AS c
              WHERE EXTRACT(YEAR FROM founded_at) = 2012
              GROUP BY country_code),
year_2013 AS (SELECT country_code AS country,
                     AVG(funding_total) AS avg_investment_2013
              FROM company AS c
              WHERE EXTRACT(YEAR FROM founded_at) = 2013
              GROUP BY country_code)
SELECT f.country,
       f.avg_investment_2011,
       s.avg_investment_2012,
       t.avg_investment_2013
FROM year_2011 AS f
JOIN year_2012 AS s ON f.country = s.country
JOIN year_2013 AS t ON s.country = t.country
ORDER BY avg_investment_2011 DESC;


