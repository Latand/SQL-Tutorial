DROP TABLE IF EXISTS users, order_products, orders, products CASCADE;

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

CREATE TABLE orders
(
    order_id   SERIAL PRIMARY KEY,
    user_id    BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id)
        REFERENCES users (telegram_id)
        ON DELETE CASCADE
);

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
INSERT INTO users
    (telegram_id, full_name, username, language_code, created_at)
VALUES (1, 'Test User', 'test_user', 'en', NOW()),
       (2, 'Test User 2', 'test_user_2', 'en', NOW()),
       (3, 'Test User 3', 'test_user_3', 'en', NOW()),
       (4, 'Test User 4', 'test_user_4', 'en', NOW()),
       (5, 'Test User 5', 'test_user_5', 'en', NOW()),
       (6, 'Test User 6', 'test_user_6', 'en', NOW()),
       (7, 'Test User 7', 'test_user_7', 'en', NOW()),
       (8, 'Test User 8', 'test_user_8', 'en', NOW());


INSERT INTO orders (user_id, created_at)
VALUES
       (1, '2022-02-01 00:00:00'),
       (2, '2022-03-01 00:00:00'),
       (3, '2022-04-01 00:00:00'),
       (4, '2022-05-01 00:00:00'),
       (6,'2022-02-15 00:00:00'),
       (8, '2022-04-16 00:00:00');



INSERT INTO products (title, description)
VALUES ('Product 4', 'Description 4'),
       ('Product 5', 'Description 5'),
       ('Product 6', 'Description 6'),
       ('Product 7', 'Description 7'),
       ('Product 8', 'Description 8'),
       ('Product 9', 'Description 9'),
       ('Product 10', 'Description 10'),
       ('Product 11', 'Description 11'),
       ('Product 12', 'Description 12'),
       ('Product 13', 'Description 13'),
       ('Product 14', 'Description 14'),
       ('Product 15', 'Description 15'),
       ('Product 16', 'Description 16'),
       ('Product 17', 'Description 17'),
       ('Product 18', 'Description 18'),
       ('Product 19', 'Description 19'),
       ('Product 20', 'Description 20'),
       ('Product 21', 'Description 21'),
       ('Product 22', 'Description 22'),
       ('Product 23', 'Description 23'),
       ('Product 24', 'Description 24'),
       ('Product 25', 'Description 25'),
       ('Product 26', 'Description 26'),
       ('Product 27', 'Description 27'),
       ('Product 28', 'Description 28'),
       ('Product 29', 'Description 29'),
       ('Product 30', 'Description 30'),
       ('Product 31', 'Description 31'),
       ('Product 32', 'Description 32'),
       ('Product 33', 'Description 33'),
       ('Product 34', 'Description 34'),
       ('Product 35', 'Description 35'),
       ('Product 36', 'Description 36'),
       ('Product 37', 'Description 37'),
       ('Product 38', 'Description 38'),
       ('Product 39', 'Description 39'),
       ('Product 40', 'Description 40'),
       ('Product 41', 'Description 41'),
       ('Product 42', 'Description 42'),
       ('Product 43', 'Description 43'),
       ('Product 44', 'Description 44'),
       ('Product 45', 'Description 45'),
       ('Product 46', 'Description 46'),
       ('Product 47', 'Description 47'),
       ('Product 48', 'Description 48'),
       ('Product 49', 'Description 49'),
       ('Product 50', 'Description 50'),
       ('Product 51', 'Description 51'),
       ('Product 52', 'Description 52'),
       ('Product 53', 'Description 53');



INSERT INTO order_products (order_id, product_id, quantity)
VALUES (1, 6, 2),
       (1, 8, 1),
       (1, 7, 1),
       (2, 8, 6),
       (2, 8, 1),
       (2, 9, 1),
       (3, 10, 1),
       (3, 11, 1),
       (3, 12, 1),
       (3, 13, 1),
       (3, 14, 1),
       (3, 15, 1),
       (3, 16, 1),
       (3, 17, 1),
       (4, 18, 1),
       (5, 19, 1),
       (6, 20, 1),
       (6, 21, 1),
       (6, 22, 1),
       (6, 23, 1),
       (6, 24, 1),
       (6, 25, 1),
       (6, 26, 1),
       (6, 27, 1),
       (6, 28, 1),
       (6, 29, 1),
       (6, 30, 1),
       (6, 31, 1),
       (6, 32, 1),
       (6, 33, 1),
       (6, 34, 1);


