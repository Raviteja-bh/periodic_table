#!/bin/bash
ITEM=false
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

ADD_COL=$($PSQL "ALTER TABLE properties ADD COLUMN type VARCHAR(30)")
INSERT_ROW=$($PSQL "UPDATE properties SET type='nonmetal' WHERE type_id=1")
INSERT_ROW1=$($PSQL "UPDATE properties SET type='metal' WHERE type_id=2")
INSERT_ROW2=$($PSQL "UPDATE properties SET type='metalloid' WHERE type_id=3")

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
        cat elements.csv | while IFS="|" read ATOMIC SYMBOL NAME MASS MELTING BOILING TYPE_ID TYPE
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
      cat elements.csv | while IFS="|" read ATOMIC SYMBOL NAME MASS MELTING BOILING TYPE_ID TYPE
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
      cat elements.csv | while IFS="|" read ATOMIC SYMBOL NAME MASS MELTING BOILING TYPE_ID TYPE
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

SEARCH=$($PSQL "SELECT * FROM properties WHERE atomic_number=1000")
if [[ -z $SEARCH ]]
then
    #echo "Add element"
    ADD_ELEMENT=$($PSQL "INSERT INTO properties(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(1000, 'metalloid', 1, 10, 100, 3)")
fi

REMOVE_ELEMENT=$($PSQL "DELETE FROM properties WHERE atomic_number=1000")
#echo "elements removed are $REMOVE_ELEMENT"

REMOVE_COLUMN=$($PSQL "ALTER TABLE properties DROP COLUMN type")
#echo "column removed are $REMOVE_COLUMN"