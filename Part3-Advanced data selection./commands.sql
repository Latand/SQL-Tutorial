INSERT INTO users (telegram_id, full_name, created_at)
VALUES (1, 'John Doe', '2022-06-19 04:24:16.775551'),
       (2, 'Jane Doe', '2022-06-19 04:24:16.775551'),
       (3, 'John Smith', '2022-06-19 04:24:16.775551'),
       (4, 'Jane Smith', '2022-06-19 04:24:16.775551');

SELECT *
FROM users
ORDER BY telegram_id DESC;

ALTER TABLE users
    ADD COLUMN role varchar(20) default 'user';

UPDATE users
SET role = 'admin'
WHERE telegram_id = 1;

SELECT role, COUNT(telegram_id)
FROM users
GROUP BY role;

SELECT role, COUNT(telegram_id)
FROM users
GROUP BY role
ORDER BY COUNT(telegram_id) DESC;

SELECT telegram_id, full_name
FROM users
WHERE telegram_id IN (1, 3);

SELECT telegram_id, full_name
FROM users
WHERE full_name ILIKE 'john%';


SELECT telegram_id, full_name
FROM users
WHERE full_name ILIKE 'john%'
   OR full_name ILIKE 'jane%';


SELECT telegram_id, full_name
FROM users
WHERE (full_name ILIKE 'john%'
    OR
       full_name ILIKE 'jane%')
  AND NOT full_name ILIKE '%doe%';

SELECT telegram_id, full_name
FROM users
WHERE full_name ILIKE 'john%'
   OR full_name ILIKE 'jane%'
    AND NOT full_name ILIKE '%doe%';

SELECT role
FROM users;

SELECT DISTINCT role
FROM users;

SELECT role, COUNT(telegram_id) AS number_of_users
FROM users
GROUP BY role;
