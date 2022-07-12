from sqlalchemy import create_engine
from sqlalchemy import text
from sqlalchemy.engine.url import URL
from sqlalchemy.orm import sessionmaker

URL = URL.create(
    drivername="postgresql+psycopg2",  # driver name = postgresql + the library we are using
    username='testuser',
    password='testpassword',
    host='localhost',
    database='testuser',
    port=5439
)
engine = create_engine(URL, echo=True, future=True)

session_pool = sessionmaker(bind=engine)


def example_1():
    query = text("SELECT * FROM users LIMIT 2")
    with session_pool() as session:
        result = session.execute(query)

        for row in result:
            print(dict(row))  # print every row as a dictionary
            print()  # print a new line
            print(f'ID: {row.telegram_id}, Full name: {row.full_name}, Username: {row.username}')  # print as attributes
            print()  # print a new line


def example_2():
    query = text("SELECT * FROM users")
    with session_pool() as session:
        result = session.execute(query)
        all_rows = result.all()
        print(f'{all_rows=}')


def example_3():
    query = text("SELECT * FROM users")
    with session_pool() as session:
        result = session.execute(query)
        first_row = result.first()
        print(f'{first_row=}')


def example_4():
    query = text("SELECT full_name FROM users WHERE telegram_id = :id").params(id=1)
    with session_pool() as session:
        result = session.execute(query)
        full_name = result.scalar()
        print(f'{full_name=}')


example_3()
