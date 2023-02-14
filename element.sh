#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_RESULT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius
    FROM properties inner join elements using(atomic_number) inner join types using(type_id) WHERE atomic_number = $1")
  else
    ELEMENT_RESULT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius
    FROM properties inner join elements using(atomic_number) inner join types using(type_id) WHERE name = '$1' OR symbol = '$1'")
  fi

  if [[ -z $ELEMENT_RESULT ]]
  then
    echo -e "I could not find that element in the database."
  else
    echo "$ELEMENT_RESULT" | sed 's/|/ /g' | while read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
    
  fi
  
  
fi
