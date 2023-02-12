#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# ask user to enter his name
echo Enter your username:
# read user input to USERNAME
read USERNAME

# check if it is a new user
RECORD=$($PSQL "SELECT * FROM records WHERE user_name='$USERNAME'")

if [[ -z $RECORD ]]
then
	echo Welcom $USERNAME
else
	echo User info: $RECORD
fi

