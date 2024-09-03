#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -tc"

echo -e "\n~~~~~ MY SALON ~~~~~"

MAIN_MENU () {
  echo -e $1
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  # test continues to execute code after jumping to function
  echo "$SERVICES" | while IFS=" | " read ID NAME
  do
    echo "$ID) $NAME"
  done
  #echo -e "1) trim\n2) cut\n3) color\n4) style"
  read SERVICE_ID_SELECTED
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_ID ]]
  then
    MAIN_MENU "\nI could not find that service. What would you like today?"
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      echo $($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") > /dev/null
    fi
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
    read SERVICE_TIME
    echo $($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')") > /dev/null
    echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
}

MAIN_MENU "\nWelcome to My Salon, how can I help you?"