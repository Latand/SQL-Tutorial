# Part-4. Subqueries

Here we are going to quickly learn about subqueries.

Sometimes you need to send more than one request to get the results you need.

This is because you may need to use the result of the first request to get the results of the second request.
Instead of sending two requests and processing them by your programming language, you can use a subquery, which will be
faster.

For example:

1. Get some average result from a table (average ordered items) and filter values that are greater than that average.
2. Get the top 10 users by sum of some column.
3. Get rank of a specific user over all users by some column. (e.g. for 'You are the #1 by number of orders!').
4. Get some ids from one table and filter another query by them (to exclude/include only them).

This may be sound very complicated, but we will show this with an example.

## Preparations
Let's clean our database first, and recreate tables from scratch. We will also create some dummy data.

```sql


1. Find products that haven't been sold yet.

2. Find users that haven't placed an order yet.