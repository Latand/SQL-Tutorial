SELECT DISTINCT(product_id)
FROM order_products
ORDER BY product_id;


SELECT product_id, title, description
FROM products
WHERE product_id NOT IN (
                         6,
                         7,
                         8,
                         9,
                         10,
                         11,
                         12,
                         13,
                         14,
                         15,
                         16,
                         17,
                         18,
                         19,
                         20,
                         21,
                         22,
                         23,
                         24,
                         25,
                         26,
                         27,
                         28,
                         29,
                         30,
                         31,
                         32,
                         33,
                         34);


SELECT product_id, title, description
FROM products
WHERE product_id NOT IN (SELECT DISTINCT(product_id)
                         FROM order_products
                         ORDER BY product_id);


SELECT telegram_id, full_name, username
FROM users
WHERE telegram_id NOT IN (SELECT DISTINCT(user_id)
                          FROM orders
                          ORDER BY user_id);


INSERT INTO orders (user_id)
VALUES (1);

SELECT RANK() OVER (ORDER BY count(order_id) DESC) AS rank, telegram_id, full_name, username, count(order_id)
FROM users
         LEFT JOIN orders ON users.telegram_id = orders.user_id
GROUP BY telegram_id, full_name, username;


SELECT DENSE_RANK() OVER (ORDER BY count(order_id) DESC) AS rank, telegram_id, full_name, username, count(order_id)
FROM users
         LEFT JOIN orders ON users.telegram_id = orders.user_id
GROUP BY telegram_id, full_name, username;


SELECT ROW_NUMBER() OVER (ORDER BY count(order_id) DESC) AS rank, telegram_id, full_name, username, count(order_id)
FROM users
         LEFT JOIN orders ON users.telegram_id = orders.user_id
GROUP BY telegram_id, full_name, username;


SELECT r.rank, full_name, username, telegram_id, r.count
FROM (SELECT RANK() OVER (ORDER BY count(order_id) DESC) AS rank,
             telegram_id,
             full_name,
             username,
             count(order_id)                             as count
      FROM users
               LEFT JOIN orders ON users.telegram_id = orders.user_id
      GROUP BY telegram_id, full_name, username) as r
WHERE telegram_id = 4;

