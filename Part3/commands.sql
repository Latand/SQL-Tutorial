DROP TABLE IF EXISTS users;


CREATE TABLE users
(
    telegram_id   BIGINT PRIMARY KEY,
    full_name     VARCHAR(255) NOT NULL,
    username      VARCHAR(255),
    language_code VARCHAR(255) NOT NULL,
    created_at    TIMESTAMP DEFAULT NOW(),
    referrer_id   BIGINT,
    FOREIGN KEY (referrer_id)
        REFERENCES users (telegram_id)
        ON DELETE SET NULL
);


INSERT INTO users
    (telegram_id, full_name, username, language_code, created_at)
VALUES (1, 'John Doe', 'johnny', 'en', '2020-01-01');


INSERT INTO users
(telegram_id, full_name, username, language_code, created_at, referrer_id)
VALUES (2, 'Jane Doe', 'jane', 'en', '2020-01-02', 1);


SELECT users.full_name AS "user", ref.full_name AS referrer
FROM users
         JOIN users AS ref ON ref.telegram_id = users.referrer_id;


CREATE TABLE orders
(
    order_id   SERIAL PRIMARY KEY,
    user_id    BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id)
        REFERENCES users (telegram_id)
        ON DELETE CASCADE
);


INSERT INTO orders (user_id)
VALUES (1)
RETURNING order_id;


SELECT orders.order_id, users.full_name
FROM orders
         JOIN users ON users.telegram_id = orders.user_id;


CREATE TABLE products
(
    product_id  SERIAL PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    created_at  TIMESTAMP DEFAULT NOW()
);


CREATE TABLE order_products
(
    order_id   INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity   INTEGER NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE RESTRICT
);


INSERT INTO products (title, description)
VALUES ('Product 1', 'Description 1'),
       ('Product 2', 'Description 2'),
       ('Product 3', 'Description 3');


INSERT INTO order_products (order_id, product_id, quantity)
VALUES (1, 1, 1),
       (1, 2, 2),
       (1, 3, 3);


SELECT orders.order_id, products.title as product_name, users.full_name
FROM order_products
         JOIN products ON products.product_id = order_products.product_id
         JOIN orders ON orders.order_id = order_products.order_id
         JOIN users ON users.telegram_id = orders.user_id;


DELETE
FROM products
WHERE product_id = 1;


DELETE
FROM users
WHERE telegram_id = 1;


select *
from order_products;