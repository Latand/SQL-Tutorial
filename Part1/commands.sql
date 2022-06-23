CREATE TABLE users
(
    telegram_id BIGINT PRIMARY KEY,
    full_name   VARCHAR,
    created_at  TIMESTAMP DEFAULT NOW()
);

INSERT INTO users (telegram_id, full_name, created_at)
VALUES (123456789, 'John Doe', '2020-01-01 00:00:00');

SELECT telegram_id
FROM users;

SELECT *
FROM users
WHERE telegram_id = 123456789;

UPDATE users
SET full_name = 'John Moe'
WHERE telegram_id = 123456789;

DELETE
FROM users
WHERE telegram_id = 123456789;