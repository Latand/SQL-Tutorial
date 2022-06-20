### For full info check this tutorial: [Tutorial](https://www.postgresqltutorial.com/)

This is not a full tutorial, it's just a brief introduction to PostgreSQL and a script for video-tutorial.

# Part 2
## Ordering Data

You can sort data in PostgreSQL using the `ORDER BY` clause with `SELECT` statement.

> Syntax: `SELECT column_name, ... FROM table_name ORDER BY column_name;`

> **Note:**
>
> - You can sort by multiple columns by separating them with commas. It will sort by the first column first, then the
    second column (if the first one has duplicates), and so on.
> - You can also sort in descending or ascending order by adding `DESC` or `ASC` after the column name.

#### Example

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

You can apply aggregation functions to colunmns and divide the result into groups by using the `GROUP BY` clause
with `SELECT` statement. 

> Syntax: `SELECT column_to_divide_by, aggregate_func(column_to_aggreage) FROM table_name GROUP BY column_to_divide_by;`

> **Note:**
> 
> It is not necessary to use aggregation functions with `GROUP BY`, it will group and remove the
duplicates from the result. But you will need to list all columns in the `GROUP BY` clause.

For this example we will add another column to the table `users` called `role` 
and set it to `admin` for the first two users, with the default value `user` for the rest:

```postgresql
ALTER TABLE users
    ADD COLUMN role varchar(20) default 'user';

UPDATE users
SET role = 'admin'
WHERE telegram_id in (1, 2);
```

#### Example

```postgresql
SELECT role, COUNT(telegram_id)
FROM users
GROUP BY role;
```

##### Response

``` 
 role  | count 
-------+-------
 admin |     2
 user  |     2
```

