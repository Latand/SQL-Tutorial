# Part-4. Subqueries and Ranks

Here we are going to quickly learn about subqueries.

Sometimes you need to send more than one request to get the results you need.

This is because you may need to use the result of the first request to get the results of the second request.
Instead of sending two requests and processing them by your programming language, you can use a subquery, which will be
faster.

> **Note:**
>
>Also, if you do not know how to build a complicated query, you can too divide it into smaller parts and run as a
> query + subquery.
>
> This may be useful if you want to avoid `JOIN`'s.

For example:

1. Get some average result from a table (average ordered items) and filter values that are greater than that average.
2. Get rank of a specific user over all users by some column. (e.g. to show 'You are the #1 by number of orders!').
3. Get some ids from one table and filter another query by them (to exclude/include only them).

This may be sound very complicated, but we will show this with an example.

## Preparations

Let's clean our database first, and recreate tables from scratch. We will also create some dummy data.
You can just copy and paste the code below into your terminal.

```sql
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
VALUES (1, '2022-02-01 00:00:00'),
       (2, '2022-03-01 00:00:00'),
       (3, '2022-04-01 00:00:00'),
       (4, '2022-05-01 00:00:00'),
       (6, '2022-02-15 00:00:00'),
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
```

## Examples

### Find products that haven't been sold yet.

So you have a number interconnected of tables, and you want to determine which products are not so popular.
Let's divide the task into 2 parts:

1. Find all id's of products that have been sold.
2. Select all products that are not in this list (i.e. exclude them from the result).

```sql
SELECT DISTINCT(product_id)
FROM order_products
ORDER BY product_id;
```

#### Response

``` 
 product_id
------------
          6
          7
          8
          9
         10
         11
         12
         13
         14
         15
         16
         17
         18
         19
         20
         21
         22
         23
         24
         25
         26
         27
         28
         29
         30
         31
         32
         33
         34
(29 rows)
```

```sql
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
```

```
 product_id |   title    |  description
------------+------------+----------------
          1 | Product 4  | Description 4
          2 | Product 5  | Description 5
          3 | Product 6  | Description 6
          4 | Product 7  | Description 7
          5 | Product 8  | Description 8
         35 | Product 38 | Description 38
         36 | Product 39 | Description 39
         37 | Product 40 | Description 40
         38 | Product 41 | Description 41
         39 | Product 42 | Description 42
         40 | Product 43 | Description 43
         41 | Product 44 | Description 44
         42 | Product 45 | Description 45
         43 | Product 46 | Description 46
         44 | Product 47 | Description 47
         45 | Product 48 | Description 48
         46 | Product 49 | Description 49
         47 | Product 50 | Description 50
         48 | Product 51 | Description 51
         49 | Product 52 | Description 52
         50 | Product 53 | Description 53
(21 rows)
```

Not very convenient, isn't it? Let's make a more efficient query.

```sql
SELECT product_id, title, description
FROM products
WHERE product_id NOT IN (SELECT DISTINCT(product_id)
                         FROM order_products
                         ORDER BY product_id);
```

#### Explanation

So we've just put the first query into the brackets, and put after `NOT IN` statement of the second query.

### Find users that haven't placed an order yet

Let's now see who hasn't placed any orders yet. Maybe you'll want to send a message to these users.

```sql
SELECT telegram_id, full_name, username
FROM users
WHERE telegram_id NOT IN (SELECT DISTINCT(user_id)
                          FROM orders
                          ORDER BY user_id);
```

#### Response

```
 telegram_id |  full_name  |  username
-------------+-------------+-------------
           5 | Test User 5 | test_user_5
           7 | Test User 7 | test_user_7
(2 рядки)
```

### Top users' leaderboard by their order count

Suppose you want to say something like "You are rank #1 in our community by placing orders".

To do something like that you need to use `RANK() OVER (...)` function.

Syntax: `RANK() OVER ([PARTITION BY partition_exp, .... ] ORDER BY sort_exp [ASC | DESC], ....)`

> **Note:**
>
> `RANK()` can return repeated values for repeating input values. For example, if you have two rows with the same value
> for `sort_exp`, then `RANK()` will return `1` for both rows.
> If you want to avoid this, you can use `ROW_NUMBER()` instead.

Let's first place a new order by the user with id `1`.

```sql
INSERT INTO orders (user_id)
VALUES (1);
```

Now let's find the rank **of all users**. Don't forget the `GROUP BY` clause when using aggregating functions.

We will also show users that have not placed orders. To do this we will need to inclulde `NULL` values from the users
table. In that case we need to use `LEFT (OUTER) JOIN` instead of simple `(INNER) JOIN`.

```sql
SELECT RANK() OVER (ORDER BY count(order_id) DESC) AS rank, telegram_id, full_name, username, count(order_id)
FROM users
         LEFT JOIN orders ON users.telegram_id = orders.user_id
GROUP BY telegram_id, full_name, username;
```

##### Response

```
 rank | telegram_id |  full_name  |  username   | count
------+-------------+-------------+-------------+-------
    1 |           1 | Test User   | test_user   |     2
    2 |           6 | Test User 6 | test_user_6 |     1
    2 |           3 | Test User 3 | test_user_3 |     1
    2 |           8 | Test User 8 | test_user_8 |     1
    2 |           2 | Test User 2 | test_user_2 |     1
    2 |           4 | Test User 4 | test_user_4 |     1
    7 |           7 | Test User 7 | test_user_7 |     0
    7 |           5 | Test User 5 | test_user_5 |     0

(8 rows)
```

##### Explanation

You can see that we have repeated ranks for users with the same order count.

Also, the last 2 users ranks have `7` because there are 7 users before them and they both have equal order count.

This is not a goodlooking leaderboard, we need to show ranks that increment by 1. Let's replace `RANK()`
with `DENSE_RANK()`.

```sql
SELECT DENSE_RANK() OVER (ORDER BY count(order_id) DESC) AS rank, telegram_id, full_name, username, count(order_id)
FROM users
         LEFT JOIN orders ON users.telegram_id = orders.user_id
GROUP BY telegram_id, full_name, username;
```

##### Response

```
 rank | telegram_id |  full_name  |  username   | count
------+-------------+-------------+-------------+-------
    1 |           1 | Test User   | test_user   |     2
    2 |           6 | Test User 6 | test_user_6 |     1
    2 |           3 | Test User 3 | test_user_3 |     1
    2 |           8 | Test User 8 | test_user_8 |     1
    2 |           2 | Test User 2 | test_user_2 |     1
    2 |           4 | Test User 4 | test_user_4 |     1
    3 |           7 | Test User 7 | test_user_7 |     0
    3 |           5 | Test User 5 | test_user_5 |     0

(8 рядків)
```

Still not perfect, we still have repeated ranks, however, now they increment by 1. Let's use `ROW_NUMBER()` function to
show the real leaderboard.

```postgresql
SELECT ROW_NUMBER() OVER (ORDER BY count(order_id) DESC) AS rank, telegram_id, full_name, username, count(order_id)
FROM users
         LEFT JOIN orders ON users.telegram_id = orders.user_id
GROUP BY telegram_id, full_name, username;
```

##### Response

```
 rank | telegram_id |  full_name  |  username   | count
------+-------------+-------------+-------------+-------
    1 |           1 | Test User   | test_user   |     2
    2 |           6 | Test User 6 | test_user_6 |     1
    3 |           3 | Test User 3 | test_user_3 |     1
    4 |           8 | Test User 8 | test_user_8 |     1
    5 |           2 | Test User 2 | test_user_2 |     1
    6 |           4 | Test User 4 | test_user_4 |     1
    7 |           7 | Test User 7 | test_user_7 |     0
    8 |           5 | Test User 5 | test_user_5 |     0

(8 rows)
```

### User's real rank by their order count

Suppose, you do not show a leaderboard for all users, but you only want to show the real rank of the user.
It might not very fair to put `Test User 6` above `Test User 4` since they have the same order count.

Thus, we will omit showing full leaderboard and show only the real rank. Now we put the query from the 1st
example as a subquery and filter by user_id.

```sql
SELECT r.rank, full_name, username, telegram_id, r.count 
FROM (SELECT RANK() OVER (ORDER BY count(order_id) DESC) AS rank, telegram_id, full_name, username, count(order_id) as count 
      FROM users 
               LEFT JOIN orders ON users.telegram_id = orders.user_id 
      GROUP BY telegram_id, full_name, username) as r 
WHERE telegram_id = 4; 
```

#### Response

```
 rank |  full_name  |  username   | telegram_id | count
------+-------------+-------------+-------------+-------
    2 | Test User 4 | test_user_4 |           4 |     1

(1 row)
```

##### Explanation

Now we put the subquery into a `FROM` statement, and we also gave a name (alias) for the resulting table `r`.

Since we did that, we could get the attributes of the table `r` by using the alias (as Python attribute `r.attribute`),
or just by column name.

> **Note:** To get results from the aggregated functions from the subquery you must use the alias. 

Well done! You have learned how to use Subqueries and a little about `RANK()` functions.