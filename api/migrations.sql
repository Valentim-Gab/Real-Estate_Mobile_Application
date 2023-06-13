CREATE DATABASE real_state;

CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) not null,
	email VARCHAR(250) not null unique,
	password VARCHAR(200) not null,
	role varchar(10)[]
);

CREATE TABLE property (
	id SERIAL PRIMARY KEY,
	identifier_name VARCHAR(50),
	value MONEY,
	owner_name VARCHAR(100),
	number_property INTEGER,
	road VARCHAR(50),
	neighborhood VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(50),
	country VARCHAR(50),
	zip_code VARCHAR(10),
	description TEXT,
	type_use VARCHAR(15),
	type_marketing VARCHAR(15),
	id_real_estate_agent INTEGER,
	FOREIGN KEY (id_real_estate_agent) REFERENCES users (id) ON DELETE CASCADE
);

INSERT INTO users VALUES 
(default, 'Admin', 'admin@email.vale', '123', ARRAY['admin']);