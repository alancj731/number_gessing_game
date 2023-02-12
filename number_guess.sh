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
	# add GAMES_PLAYED by 1
	# GAMES_PLAYED=$[ $GAMES_PLAYED + 1 ]
	# print the welcome message
	echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses." 
else
	echo -e "Welcome, $USERNAME! It looks like this is your first time here."
        set GAMES_PLAYED to 0
	GAMES_PLAYED=0	
	# set BEST_GAME to 1001
	# BEST_GAME=1001
	# insert data into database
	# INSERT_RESULT=$($PSQL "INSERT INTO records(user_name, games_played, best_game) VALUES('$USERNAME', $GAMES_PLAYED, $BEST_GAME);")
fi
SECRET=$[ $RANDOM % 1000 + 1 ]
TRIES=0
FOUND="false"

echo Guess the secret number between 1 and 1000:

while [[ $FOUND == "false" ]]
do
	read GUESS
	TRIES=$[ $TRIES + 1 ]
	# check if input is an integer
	if [[ ! $GUESS =~ ^[0-9]+$ ]]
	then
		echo "That is not an integer, guess again:"
		continue
	fi	
	# increase guessed tries by 1
	if [[ $GUESS = $SECRET ]]
	then	
		echo "You guessed it in $TRIES tries. The secret number was $SECRET. Nice job!"
		FOUND="true"
	else
		if [[ $GUESS < $SECRET ]]
		then
			echo "It's higher than that, guess again:"
		else
			echo "It's lower than that, guess again:"
		fi
	fi
done
# update GAMES_PLAYED
GAMES_PLAYED=$[ $GAMES_PLAYED + 1 ]

# check if the user has the best tries number
if [[ $GAMES_PLAYED == 1 ]] || [[ $TRIES < $BEST_GAME ]]
then
	BEST_GAME=$TRIES
fi

# update the database
if [[ $GAMES_PLAYED == 1 ]]
then
	# insert the record
	INSERT_RESULT=$($PSQL "INSERT INTO records(user_name, games_played, best_game) VALUES('$USERNAME', $GAMES_PLAYED, $BEST_GAME);")
else
	# update the record
	UPDATERESULT=$($PSQL "UPDATE records SET games_played=$GAMES_PLAYED, best_game=$BEST_GAME WHERE user_name='$USERNAME';") 
fi
