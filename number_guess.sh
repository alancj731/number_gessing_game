#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# ask user to enter his name
echo Enter your username:
# read user input to USERNAME
read USERNAME

# check if it is a new user
RECORD=$($PSQL "SELECT * FROM records WHERE user_name='$USERNAME'")

if [[ ! -z $RECORD ]]
then
	# get user's information from database
	USERINFO=$($PSQL "SELECT games_played, best_game FROM records WHERE user_name='$USERNAME';")
	# relpace | with space in query result
	USERINFO=$(echo $USERINFO | sed 's/|/ /g')
	# read games_played, best_game data from query result
	read GAMES_PLAYED BEST_GAME <<< $USERINFO
	# print the welcome message
	echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses." 
else
	echo User info: $RECORD
fi

