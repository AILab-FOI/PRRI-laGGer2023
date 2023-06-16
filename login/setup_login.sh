#!/bin/bash

# Install dependencies
sudo apt-get install -y python3-psycopg2 postgresql
sudo ufw allow 5000
sudo ufw allow 5432
sudo ufw allow 6379

# Move init.sql to home directory
cp init.sql ~/init.sql

# Set permissions for init.sql
sudo chmod 777 ~/init.sql

# Execute init.sql in PostgreSQL
sudo -u postgres psql -c "\ir ~/init.sql"

# Create SQL database and user
sudo -u postgres psql -c "CREATE DATABASE userdb;"
sudo -u postgres psql -c "\connect userdb;"
sudo -u postgres psql -c "CREATE USER demo WITH SUPERUSER PASSWORD 'password';"
sudo -u postgres psql -c "CREATE TABLE users (id SERIAL PRIMARY KEY, username VARCHAR(30) NOT NULL UNIQUE, password VARCHAR(30) NOT NULL);"
sudo -u postgres psql -c "INSERT INTO users (username, password) VALUES ('Ivek', 'password');"

# Run the login page
python3 check_login.py
