CREATE DATABASE userdb;
\connect userdb
CREATE USER demo WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE userdb TO demo;
GRANT postgrest TO demo;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(30) NOT NULL UNIQUE,
  password VARCHAR(30) NOT NULL
);

INSERT INTO users (username, password) VALUES ('Ivek', 'password');