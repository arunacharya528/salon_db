#! /bin/bash
source .env;

PSQL="psql --username=$POSTGRES_USERNAME --dbname=$POSTGRES_DATABASE --no-align --tuples-only -c"

echo "$($PSQL "
CREATE TABLE customers(
  customer_id SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(255) UNIQUE
);
")"

echo "$($PSQL "
CREATE TABLE services(
  service_id SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(255) UNIQUE NOT NULL
);
")"

echo "$($PSQL "
CREATE TABLE appointments(
  appointment_id SERIAL PRIMARY KEY NOT NULL,
  customer_id INTEGER REFERENCES customers(customer_id),
  service_id INTEGER REFERENCES services(service_id),
  time VARCHAR(255)
);
")"
