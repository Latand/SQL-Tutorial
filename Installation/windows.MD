1. Go to
   the [link and follow the instructions](https://www.postgresqltutorial.com/postgresql-getting-started/install-postgresql/)
   to install PostgreSQL.

2. Run the SQL Shell and enter the default user.

3. Create a new role with password and superuser privileges. You may see in other tutorials that 'user' is created, but
   in more recent versions [it is better to user 'role' concept](https://stackoverflow.com/questions/27709456/what-is-the-difference-between-a-user-and-a-role)
   .

   `CREATE ROLE testuser WITH LOGIN ENCRYPTED PASSWORD 'testpassword' SUPERUSER;`

4. Create a new database.

   `CREATE DATABASE testuser OWNER testuser;`

5. Quit the shell and enter the new database with the new user.

