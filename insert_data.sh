#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# clear database.
echo $($PSQL "TRUNCATE teams, games")
echo -e "Loading..."
LCT=0 #Loop Cycle Counter.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINGOAL OPPGOAL
do
  let LCT+=1
  # ignore first line.
  if [[ $YEAR != "year" ]]
  then
    # get Winner Team and Opponent Team ID.
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if winner is not found in database.
    if [[ -z $WIN_ID ]]
    then
      # insert the result (ITR)
      ITR=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # get new winner id.
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    # if opponent not found in database.
    if [[ -z $OPP_ID ]]
      then
      # insert the result (ITR)
      ITR=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      # get new opponent id.
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    # Insert data into games table.
    ITR=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINGOAL, $OPPGOAL)")
  fi
  echo -e $LCT
done
echo -e "COMPLETE"