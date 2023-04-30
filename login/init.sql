\connect userdb;

CREATE DATABASE userdb;
CREATE USER demo WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE userdb TO demo;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(30) NOT NULL UNIQUE,
  password VARCHAR(30) NOT NULL
);

CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(32) UNIQUE NOT NULL,
    username VARCHAR(32) NOT NULL,
    expiry_time TIMESTAMP NOT NULL
);


INSERT INTO users (username, password) VALUES ('Ivek', 'password');