# Basics

Now it's time to write some Python code!

## Introduction and Installation

To use SQL efficiently in your bots you need 2 things:

- some library that will run SQL queries (psycopg2, asyncpg, sqlite3, etc.)
- SQLAlchemy library that will help you to build python-like queries. Since you may be used to Python
  syntax you would like to build models and requests to your database with some Python code as well.

> **Note:**
>
> We will be using syntax for SQLAlchemy v2.0 for this tutorial. 

_This is not a full tutorial, so you might like to check out
the [SQLAlchemy tutorial](https://docs.sqlalchemy.org/en/20/tutorial/index.html) later._

First off, let's build a virtual environment and install all the dependencies.

We will be using the latest stable version, Python 3.10.

### Ubuntu installation:

```bash
# Install virtualenv
python3 -m pip install virtualenv 

# Create a virtual environment folder
python3 -m virtualenv venv

# Activate the virtual environment
source venv/bin/activate

# No we can install all the dependencies into the virtual environment
# Let's install psycopg2==binary-2.9.3 (synchronous driver), asyncpg==0.25.0 (asynchronous driver), also SQLAlchemy~=2.0
pip3 install psycopg2-binary==2.9.3 asyncpg==0.25.0 SQLAlchemy~=2.0
```

Our dependencies are ready to use!

## Connecting to a database

In order to connect to our database we need to
use [SQLAlchemy Engine](https://docs.sqlalchemy.org/en/20/tutorial/engine.html).
It is created by using the `create_engine` function.

```python
from sqlalchemy import create_engine

engine = create_engine('URL', echo=True, future=True)
```

> Echo is a boolean parameter that will print all the queries that are being executed.
> Future is a boolean parameter that will enable the usage of the SQLAlchemy 2.0 syntax.

Here we are using the string `URL` to connect to our database. It is
called [SQLAlchemy connection string](https://docs.sqlalchemy.org/en/20/core/engines.html#database-urls) and looks
something like this: `driver+postgresql://user:password@host:port/dbname`.

However, you can build it using a URL-builder:

```python
from sqlalchemy.engine.url import URL

URL = URL.create(
    drivername="postgresql+psycopg2",  # driver name = postgresql + the library we are using
    username='testuser',
    password='testpassword',
    host='localhost',
    database='testuser',
    port=5432
)
```

Now you can pass this URL to the `create_engine` function.

```
engine = create_engine(URL, echo=True, future=True)
```

Be aware that we are not yet connected to the database, it will be done when we use the `engine` variable.

## Transactions

As you may have learnt, SQL has Transaction Control Language (TCL) to manage transactions.

Transaction - is a set of commands that are executed in a single unit of work.

- A transaction is started by calling the `begin()` method.
- A transaction is committed by calling the `commit()` method.
- A transaction is rolled back by calling the `rollback()` method.

You can insert some rows and then rollback the transaction, so the rows will not be inserted, otherwise you may commit
the transaction and all changed will be saved.

In the transactions you can also alter tables structure and rollback that as well.

### Syntax for transactions:

```SQL
BEGIN; -- start a transaction
INSERT INTO table1
VALUES (1, 'test'); -- insert some dummy data
INSERT INTO table2
VALUES (2, 'test'); -- insert some more dummy data
ALTER TABLE table1
    RENAME TO table3; -- rename table1 to table3
ROLLBACK; -- cancel the changes

BEGIN;
INSERT INTO table1
VALUES (1, 'test'); -- insert some dummy data
COMMIT; -- commit (save) the changes
```

## Sessions

Sessions are used to manage the connection to the database.

Session is used to actually connect to the database using engine.

We can use a session builder method to quickly create sessions:

```python
from sqlalchemy.orm import sessionmaker

session_pool = sessionmaker(bind=engine)
```

Now every time we need to create a session we can use the `session_pool` variable.

```python
session = session_pool()  # create a session
session.execute(...)  # execute some SQL query
session.commit()  # or session.rollback() to commit/rollback the changes
session.close()  # close the session (IMPORTANT: you must close the session after you are done with it)

# OR

with session_pool() as session:
    # do something with session
    session.execute(...)
    session.commit()  # or session.rollback()
```

## Textual SQL

You can use the `text()` function to create a SQLAlchemy `Text` object and run raw SQL queries.
This is not how we will use SQLAlchemy in our bots, but I'll show it for smoother transition from SQL lessons.

We will use tables from the previous tutorials:

```python
from sqlalchemy import text  # import the `text()` function

query = text("SELECT * FROM users LIMIT 2")  # create a SQLAlchemy `Text` object. 
with session_pool() as session:  # create a session
    result = session.execute(query)  # execute the query
    for row in result:  # result is sqlalchemy.engine.cursor.CursorResult object. You can iterate over it.
        print(row)  # Every element of the result is a tuple.
```

#### Response:

```
INFO sqlalchemy.engine.Engine BEGIN (implicit)
INFO sqlalchemy.engine.Engine SELECT * FROM users LIMIT 2
INFO sqlalchemy.engine.Engine [generated in 0.00006s] {}
(1, 'Test User', 'test_user', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None)
(2, 'Test User 2', 'test_user_2', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None)
INFO sqlalchemy.engine.Engine ROLLBACK
```

##### Explanation:

You can see that firstly the transaction is started, then the query is executed,
then we print the result and finally the transaction is rollbacked automatically.
This is because we didn't commit any changes.

## Extracting data from rows

You can also print every row of the result as a dictionary, or get columns as attributes:

#### Example 1

```python
for row in result:
    print(dict(row))  # print every row as a dictionary
    print()  # print a new line
    print(f'ID: {row.telegram_id}, Full name: {row.full_name}, Username: {row.username}')  # print as attributes
    print()  # print a new line
```

##### Response:

```
{'telegram_id': 1, 'full_name': 'Test User', 'username': 'test_user', 'language_code': 'en', 'created_at': datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), 'referrer_id': None}

ID: 1, Full name: Test User, Username: test_user

{'telegram_id': 2, 'full_name': 'Test User 2', 'username': 'test_user_2', 'language_code': 'en', 'created_at': datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), 'referrer_id': None}

ID: 2, Full name: Test User 2, Username: test_user_2
```

See, now you know that row-objects may be transformed to different types of objects.

## Working with Result

There are different ways you can retrieve the result of a query. Not all results you need are in a form of a table.

Sometimes you want to retrieve a single row, or a single column at once.

You can do this by calling different methods of the `Result` object:

- `all()` - returns all rows of the result as a list of tuples.
- `first()` - returns the first row of the result.
- `scalar()` - returns the first column of the first row of the result.

> **Note:**
> You can apply these methods only ONCE. The result will be consumed after the first call, and you'll get
> an error: `sqlalchemy.exc.ResourceClosedError: This result object is closed.`

#### Example 2

Let's get all rows of the result as a list of tuples:

```python
query = text("SELECT * FROM users")
with session_pool() as session:
    result = session.execute(query)
    all_rows = result.all()
    print(f'{all_rows=}')
```

##### Response:

```
all_rows=[
  (1, 'Test User', 'test_user', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None), 
  (2, 'Test User 2', 'test_user_2', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None), 
  (3, 'Test User 3', 'test_user_3', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None), 
  (4, 'Test User 4', 'test_user_4', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None), 
  (5, 'Test User 5', 'test_user_5', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None), 
  (6, 'Test User 6', 'test_user_6', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None), 
  (7, 'Test User 7', 'test_user_7', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None), 
  (8, 'Test User 8', 'test_user_8', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None)
]
```

#### Example 3

Let's get the first row of the result:

```python
query = text("SELECT * FROM users")
with session_pool() as session:
    result = session.execute(query)
    first_row = result.first()
    print(f'{first_row=}')
```

##### Response:

```
first_row=(1, 'Test User', 'test_user', 'en', datetime.datetime(2022, 7, 2, 9, 2, 40, 711703), None)
```

#### Example 4

Let's get the first column of the first row of the result:
> **Note:**
> 
> If you want to pass the parameters to the query, you can name it as a keyword argument (`:id`) and pass it as a
> keyword argument to the `params` method.
>
> **Never insert a parameter into a string by formating methods, your query will be vulnerable to SQL injection.**


```python
query = text("SELECT full_name FROM users WHERE telegram_id = :id").params(id=1)
with session_pool() as session:
    result = session.execute(query)
    full_name = result.scalar()
    print(f'{full_name=}')
```

##### Response:

```
full_name='Test User'
```

Great! Now you know how to retrieve data from a result.