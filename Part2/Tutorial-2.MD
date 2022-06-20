### For full info check this tutorial: [Tutorial](https://www.postgresqltutorial.com/)

This is not a full tutorial, it's just a brief introduction to PostgreSQL and a script for video-tutorial.

# Part 2. Advanced data selection.

## Ordering Data

You can sort data in PostgreSQL using the `ORDER BY` clause with `SELECT` statement.

> Syntax: `SELECT column_name, ... FROM table_name ORDER BY column_name;`

> **Note:**
>
> - You can sort by multiple columns by separating them with commas. It will sort by the first column first, then the
    second column (if the first one has duplicates), and so on.
> - You can also sort in descending or ascending order by adding `DESC` or `ASC` after the column name.

#### Example

Let's select all records from the `users` table and sort them by their `telegram_id` column in descending order.

```postgresql
SELECT *
FROM users
ORDER BY telegram_id DESC;
```

##### Response

```
 telegram_id | full_name  |         created_at         
-------------+------------+----------------------------
           4 | Jane Smith | 2022-06-19 04:24:16.775551
           3 | John Smith | 2022-06-19 04:24:16.775551
           2 | Jane Doe   | 2022-06-19 04:24:16.775551
           1 | John Doe   | 2022-06-19 04:24:16.775551
```

## Aggregating Data

You can use different mathematical functions to aggregate data in PostgreSQL:

- `COUNT`: Counts the number of rows in a table.
- `SUM`: Sums the values of a column.
- `AVG`: Calculates the average value of a column.
- `MIN`: Finds the minimum value of a column.
- `MAX`: Finds the maximum value of a column.
- ...

> Syntax: `SELECT function(column_name) FROM table_name;`

## Grouping Data

You can apply aggregation functions to columns and divide the result into groups by using the `GROUP BY` clause
with `SELECT` statement.

> Syntax: `SELECT column_to_divide_by, aggregate_func(column_to_aggreage) FROM table_name GROUP BY column_to_divide_by;`

> **Note:**
>
> It is not necessary to use aggregation functions with `GROUP BY`, it will group and remove the
> duplicates from the result. But you will need to list all columns in the `GROUP BY` clause.

For this example we will add another column to the table `users` called `role`
and set it to `admin` for the first user, with the default value `user` for the rest:

```postgresql
ALTER TABLE users
    ADD COLUMN role varchar(20) default 'user';

UPDATE users
SET role = 'admin'
WHERE telegram_id == 1;
```

#### Example 1

Let's count the users by their role:

```postgresql
SELECT role, COUNT(telegram_id)
FROM users
GROUP BY role;
```

##### Response

``` 
 role  | count 
-------+-------
 admin |     1
 user  |     3
```

#### Example 2

You can also sort by aggregated columns:

```postgresql
SELECT role, COUNT(telegram_id)
FROM users
GROUP BY role
ORDER BY COUNT(telegram_id) DESC;
```

##### Response

```
 role  | count 
-------+-------
 user  |     3
 admin |     1
 ```

## Advanced filtering

- You can filter data by multiple boolean conditions if you need to.
  Just join them with `AND` or `OR` operators.
- You can also use `NOT` operator to negate a condition.
- You can use `IN` operator to filter by a list of values.
- You can use `LIKE`/`ILIKE` operator to filter by a pattern (`LIKE` is case-sensitive). Use `%` to match any
  characters, `_` to match a single character.
- You can use `BETWEEN` operator to filter by a range of values.
- You can use `IS NULL` and `IS NOT NULL` operators to filter by null values.

> Syntax: `SELECT * FROM table_name WHERE (condition1 AND condition2) OR (condition3 AND condition4);`

#### Example 1.

Filtering by a list of values

```postgresql
SELECT telegram_id, full_name
FROM users
WHERE telegram_id IN (1, 3);
```

##### Response

```
 telegram_id | full_name  
-------------+------------
           1 | John Doe
           3 | John Smith
```

#### Example 2.

Filtering by a pattern. Let's filter by the name `John` but any case:

```postgresql
SELECT telegram_id, full_name
FROM users
WHERE full_name ILIKE 'john%';
```

##### Response

```
 telegram_id | full_name  
-------------+------------
           3 | John Smith
           1 | John Doe
(2 rows)
```

#### Example 3.

Let's use previous example but add all 'Jane' users;

```postgresql
SELECT telegram_id, full_name
FROM users
WHERE full_name ILIKE 'john%'
   OR full_name ILIKE 'jane%';
```

##### Response

```
 telegram_id | full_name  
-------------+------------
           3 | John Smith
           4 | Jane Smith
           1 | John Doe
           2 | Jane Doe
(4 rows)
```

#### Example 4.

Let's use previous example but remove all users that have 'doe' in their name.
To do this, we need to put both `AND` **conditions** in parentheses:

```postgresql
SELECT telegram_id, full_name
FROM users
WHERE (full_name ILIKE 'john%'
    OR
       full_name ILIKE 'jane%')
  AND NOT full_name ILIKE '%doe%';
```

##### Response

```
 telegram_id | full_name  
-------------+------------
           3 | John Smith
           4 | Jane Smith
(2 rows)
```

#### Example 5.

IF you don't put parentheses around the `AND` conditions, PostgreSQL will interpret them as a single condition with the
previous condition.

```postgresql
SELECT telegram_id, full_name
FROM users
WHERE full_name ILIKE 'john%'
   OR full_name ILIKE 'jane%'
    AND NOT full_name ILIKE '%doe%';
```

##### Response

Now 'doe' is excluded only with condition `ILIKE 'jane%'` condition.

```
telegram_id | full_name  
-------------+------------
           3 | John Smith
           4 | Jane Smith
           1 | John Doe
(3 rows)
```

## Distinct values

You can use the `DISTINCT` clause select different values from a column.

> Syntax: `SELECT DISTINCT column_name FROM table_name;`

#### Example 1

Let's first see what roles we have:

```postgresql
SELECT role
FROM users;
```

##### Response

You can see that there are duplicate values in the `role` column.

```
role  
-------
 user
 user
 admin
 user
(4 rows)
```

#### Example 2

Let's remove the duplicates:

```postgresql
SELECT DISTINCT role
FROM users;
```

##### Response

``` 
role  
-------
 admin
 user
(2 rows)
```



## Aliasing outputs

You can use the `AS` clause to set a specific name for selected data. 
This is useful if you want to get an output with a different name than the column name or give a name to an aggregated value.

> Syntax: `SELECT some_func(column_name1) AS alias_name, column_name2 FROM table_name;`

#### Example 1
Let's get the number of users by their role:
```postgresql
SELECT role, COUNT(telegram_id) AS number_of_users
FROM users
GROUP BY role;
```

##### Response
```
 role  | number_of_users 
-------+-----------------
 admin |               1
 user  |               3

```