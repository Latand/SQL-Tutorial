1. Update the system
`sudo apt update`


2. Install the postgresql
`sudo apt install postgresql`


3. Start the postgresql
`sudo systemctl start postgresql.service`


4. Log into the postgres user
`su - postgres`


5. First create a role with password and superuser privileges
`createuser --interactive --pwprompt --createdb --superuser testuser`


6. Then enter the database
`psql -U testuser --db testuser`


