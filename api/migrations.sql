CREATE DATABASE real_state;

CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) not null,
	email VARCHAR(250) not null unique,
	password VARCHAR(200) not null,
	role varchar(10)[]
);

INSERT INTO users VALUES 
(default, 'Admin', 'admin@email.vale', '123', ARRAY['admin']);