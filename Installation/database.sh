# Update the system
sudo apt update

# Install the postgresql
sudo apt install postgresql

# Start the postgresql
sudo systemctl start postgresql.service

# Log into the postgresql database
sudo -i -u postgres

# First create a role
createuser --interactive # testuser

# Then create a database
createdb -U testuser testuser

# Then enter the database
psql -U testuser --db testuser


