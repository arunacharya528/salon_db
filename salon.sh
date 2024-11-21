#! /bin/bash

source .env;

PSQL="psql --username=$POSTGRES_USERNAME --dbname=$POSTGRES_DATABASE --no-align --tuples-only -c"

echo ""
echo ~~~~~ MY SALON ~~~~~
echo ""
echo Welcome to My Salon, how can I help you?
echo ""

while true; do 

  all_services="$($PSQL"SELECT service_id,name from services;")";    

  service_ids=();
  service_names=();

  while IFS='|' read -r id service; do
    service_ids+=("$id")
    service_names+=("$service")

    echo "$id) $service";
  done <<< "$all_services"

  read SERVICE_ID_SELECTED 

  if ! printf "%s\n" "${service_ids[@]}" | grep -q -w "$SERVICE_ID_SELECTED"; then
    echo ""
    echo "I could not find that service. What would you like today?";
    continue;
  fi
  
  echo "";
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  customer_id="$($PSQL"SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")";   

  CUSTOMER_NAME=''
  if [ -z "$customer_id" ]; then
    echo ""
    echo "I don't have a record for that phone number, what's your name?";
    read CUSTOMER_NAME

    $PSQL"INSERT INTO customers (name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')" > /dev/null;
    
    customer_id="$($PSQL"SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")"; 
  else
    CUSTOMER_NAME="$($PSQL"SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")";   
  fi

  echo ""
  echo "What time would you like your cut, $CUSTOMER_NAME?";
  read SERVICE_TIME

  $PSQL"INSERT INTO appointments (customer_id,service_id, time) VALUES($customer_id,$SERVICE_ID_SELECTED,'$SERVICE_TIME')" > /dev/null;

  echo ""
  echo "I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
  echo ""

  break;
done
