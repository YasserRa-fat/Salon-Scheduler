#! /bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  if [[ -z $1 ]]
  then
    MENU_TITLE= echo -e "Welcome to My Salon, how can I help you?\n"
  else
    MENU_TITLE= echo -e "\n$1"
  fi
SERVICES=$($PSQL "SELECT * FROM services ")
echo "$SERVICES" | while read ID BAR NAME
do
echo "$ID) $NAME"
done
read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
  1) CUT_MENU;;
  2) COLOR_MENU;;
  3) PERM_MENU;;
  4) STYLE_MENU;;
  5) TRIM_MENU;;
  *) MAIN_MENU "I could not find that service. What would you like today?";;
  esac
}

ASK_TIME(){
echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g').?"
}
INSERT_INFO(){
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
}
INSERT_APPOINTMENT(){
APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,time,service_id) VALUES($CUSTOMER_ID,'$SERVICE_TIME',$SERVICE_ID_SELECTED)")

}

EXIT(){
echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}

ALL(){
SERVICE_NAME="$($PSQL"SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")"

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
PHONE_CHECK=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $PHONE_CHECK ]]
then 
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
INSERT_INFO
ASK_TIME
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

INSERT_APPOINTMENT
EXIT
else
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
ASK_TIME
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
INSERT_APPOINTMENT
EXIT

fi

}
CUT_MENU(){
  ALL
}
COLOR_MENU(){
  ALL
}
PERM_MENU(){
  ALL
}
STYLE_MENU(){
  ALL
}
TRIM_MENU(){
  ALL
}




MAIN_MENU

