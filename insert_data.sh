#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # GET WINNER TEAM NAME
  if [[ $WINNER != "winner" ]]
  then
    # Get team name
    WINNER_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    #If team name is not found
    if [[ -z $WINNER_TEAM ]]
    then
      #insert new team
      INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted team $WINNER
      fi
    fi
  fi

  # GET OPPONENT TEAM NAME
  if [[ $OPPONENT != "opponent" ]]
  then
    # Get team name
    OPPONENT_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    #If team name is not found
    if [[ -z $OPPONENT_TEAM ]]
    then
      #insert new team
      INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT__OPPONENT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted team $OPPONENT
      fi
    fi
  fi

  # INSERT GAMES TABLE DATA
  if [[ YEAR != "year" ]]
  then
    #GET WINNER_ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #GET OPPONENT_ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #INSERT NEW TEAM
    INSERT_TEAM=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

    if [[ $INSERT_TEAM == "INSERT 0 1" ]]
    then
      echo New game added
    fi
  fi
    
done
