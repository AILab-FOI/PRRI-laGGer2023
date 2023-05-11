This file describes the setup process for the login screen

Install:
sudo apt-get install python3-psycopg2 postgresql
sudo ufw allow 5000

Execute init.sql in PostgreSQL:
1. Move init.sql to home(~) directory
2. sudo chmod 777 init.sql
3. sudo -u postgres psql
4. \ir /home/lagger/init.sql
5. \q

Create SQL database:
CREATE DATABASE userdb;
\connect userdb;
CREATE USER demo WITH SUPERUSER PASSWORD 'password';

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(30) NOT NULL UNIQUE,
  password VARCHAR(30) NOT NULL
);
INSERT INTO users (username, password) VALUES ('Ivek', 'password');

Run the login page:
python3 check_login.py