This file describes the setup process for the login screen

Install:
python3-psycopg2
postgresql

Create SQL database:
CREATE DATABASE userdb;
CREATE USER demo WITH SUPERUSER PASSWORD 'password';
\c userdb;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(30) NOT NULL UNIQUE,
  password VARCHAR(30) NOT NULL
);
INSERT INTO users (username, password) VALUES ('Ivek', 'password');

Run the login page:
python3 check_login.py