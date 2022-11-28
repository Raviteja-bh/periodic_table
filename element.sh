#!/bin/bash
ITEM=false
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]*$ ]]
  then
    CHECK_NUM=true
  else 
    CHECK_NUM=false
  fi
  if [[ $CHECK_NUM = true ]]
  then
      ATOMIC_NUM=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) WHERE atomic_number=$1")
      if [[ $ATOMIC_NUM ]]
      then
        ITEM=true
        echo -e "$ATOMIC_NUM" > elements.csv
        cat elements.csv | while IFS="|" read ATOMIC SYMBOL NAME TYPE MASS MELTING BOILING TYPE_ID
        do
          echo -e "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi
  fi
  if [[ $ITEM=false ]]
  then
      SYM=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) WHERE symbol='$1'")
      if [[ $SYM ]]
      then
      ITEM=true
      echo -e "$SYM" > elements.csv
      cat elements.csv | while IFS="|" read ATOMIC SYMBOL NAME TYPE MASS MELTING BOILING TYPE_ID
      do
        echo -e "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
      fi
  fi
  if [[ $ITEM = false ]]
  then
    NAM=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) WHERE name='$1'")
    if [[ $NAM ]]
    then
      ITEM=true
      echo $NAM > elements.csv
      cat elements.csv | while IFS="|" read ATOMIC SYMBOL NAME TYPE MASS MELTING BOILING TYPE_ID
      do
        echo -e "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi  
  fi
  if [[ $ITEM = false ]]
  then
    echo -e "I could not find that element in the database."
  fi
fi