\connect userdb;

CREATE DATABASE userdb;
CREATE USER demo WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE userdb TO demo;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(30) NOT NULL UNIQUE,
  password VARCHAR(30) NOT NULL
);

INSERT INTO users (username, password) VALUES ('Ivek', 'password');