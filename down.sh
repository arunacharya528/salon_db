#! /bin/bash
source .env;

PSQL="psql --username=$POSTGRES_USERNAME --dbname=$POSTGRES_DATABASE --no-align --tuples-only -c"

echo "$($PSQL "DROP TABLE IF EXISTS appointments;")";

echo "$($PSQL "DROP TABLE IF EXISTS customers;")";

echo "$($PSQL "DROP TABLE IF EXISTS services;")";
