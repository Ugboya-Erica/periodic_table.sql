#!/bin/bash 

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#the if then statement
if [[ $1 ]]
  then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
  DATA=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.name LIKE '$1%' ORDER BY atomic_number LIMIT 1")
  else
  DATA=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.atomic_number=$1")
  fi
    if [[ -z $DATA ]]
    then
      echo "I could not find that element in the database."
    else
      echo $DATA | while IFS=\| read ATOMIC_NUMBER ATOMIC_MASS MELTING BOILING SYMBOL NAME TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done

    fi

  else
  echo "Please provide an element as an argument."
fi
