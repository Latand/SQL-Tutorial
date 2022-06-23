1. Go to the [link and follow the instructions](https://www.postgresqltutorial.com/postgresql-getting-started/install-postgresql/) to install PostgreSQL.

2. Run the SQL Shell and enter the default user.

3. Create a new user with password and superuser privileges. 
`CREATE ROLE testuser WITH LOGIN ENCRYPTED PASSWORD 'testpassword' SUPERUSER;`

4. Create a new database.
`CREATE DATABASE testuser OWNER testuser;`

5. Quit the shell and enter the new database with the new user.

