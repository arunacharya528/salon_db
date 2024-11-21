#! /bin/bash

source .env;

PSQL="psql --username=$POSTGRES_USERNAME --dbname=$POSTGRES_DATABASE --no-align --tuples-only -c"

# -------------------------------------
# Truncate all old data
# -------------------------------------

echo "$($PSQL "TRUNCATE TABLE customers, services, appointments CASCADE;")";


# -------------------------------------
# Insert into teams customers
# -------------------------------------

index=0
while IFS=, read -r service customer_name customer_phone appointment_time
do

  if [ $index -ne 0 ]; then

    echo "$($PSQL"INSERT INTO customers (name, phone) VALUES ('$customer_name', '$customer_phone') ON CONFLICT DO NOTHING;")";    
  
  fi

  index=$((index+1));

done < data.csv

# -------------------------------------
# Insert into services table
# -------------------------------------

index=0
while IFS=, read -r service customer_name customer_phone appointment_time
do

  if [ $index -ne 0 ]; then

    echo "$($PSQL"INSERT INTO services (name) VALUES ('$service') ON CONFLICT DO NOTHING;")";    
  
  fi

  index=$((index+1));

done < data.csv


# -------------------------------------
# Insert into appointments table
# -------------------------------------

index=0
while IFS=, read -r service customer_name customer_phone appointment_time
do

  if [ $index -ne 0 ]; then

    customer_id="$($PSQL "SELECT customer_id from customers WHERE name = '$customer_name' AND phone = '$customer_phone';")";
    service_id="$($PSQL "SELECT service_id from services WHERE name = '$service';")";

    echo "$($PSQL"INSERT INTO appointments (customer_id, service_id, time) VALUES ('$customer_id','$service_id','$appointment_time') ON CONFLICT DO NOTHING;")";    
  
  fi

  index=$((index+1));

done < data.csv
