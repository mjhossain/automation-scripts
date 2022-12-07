#! /bin/bash
#
# Mohammed J Hossain
# Nov 28, 2021
# 
# This script takes a csv file as an input and creates/removes users
#


echo "########################################"
echo "Linux User Creation/Deletion Script"
echo "########################################"

# Usage function below
function usage() {
	echo ""
	echo "This linux script takes an option c or d with an argument of a csv file path"
	echo "Option -c will create user accounts from the file provided"
	echo "Option -d will delete user accounts from the file provided"
	echo "Example:    ./As8_MHossain.sh -c userlist.csv"
	echo ""
	echo "If no argumets are provided then the list of all users will be printed on the screen"
	exit 1
}


# userOperation function to create/delete users

function userOperation() {
	
	# variables for the filename and operation selected
	filename=$1
	selected_option=$2

	# checking to see if file provided exists and is of right type
	if [[ ! -f $filename || "${filename: -4}" != ".csv" ]]; then
		echo "Userlist file does not exist or is not a .csv type file!"
		usage
	fi


	# AWK to create a temp file with username format 
	awk -F',' '{ print tolower(substr($1,1,1)) tolower($2) substr($3,5,length($3)) }' $filename >> ./userlist.txt
	
	# temp file location with formatted usernames
	local inputfile="./userlist.txt"
	
	# loop to perform user create/delete operation based on user selection
	while read -r line; do

		# the code below removes the carriage return character '^M' from each username
		# without which linux renders the usernames as 'badname'
		# Logic: the len variable holds the length of each like i.e username along with ^M char
		# the username variable slices each line starting at index 0 until the second-last char of the word
		# which removes ^M from each username
		len=${#line}
		username=${line:0:$len-1}

		echo ""

		# the if..else below checks the selected_option to determine whether to create or delete users

		if [[ $selected_option -eq 1 ]]; then
			
			# the next line creates a user and then add the password '12345678' to the useraccount
			# the -m option creates a home directory for the user

			useradd -m $username; echo "12345678" | passwd "$username" --stdin >> garbage.txt
			
			# user creation verification check below. 
			# Check #1 command execution code 
			# Cehck #2 home directory check
			if [[ "$?" -eq 0 && -d "/home/$username" ]]; then
				echo "User $username created with default password 12345678"
			else
				echo "User creation failed!"
			fi

		elif [[ $selected_option -eq 2 ]]; then

			# Deleting user
			userdel -r $username
			if [[ "$?" -eq 0 ]]; then
				echo "User $username deleted"
			else
				echo "User deletion failed!"
			fi

		fi

	done < "$inputfile"


	# the lines below removes the temp files created
	if [[ -f "garbage.txt" ]];then	
		rm -f ./garbage.txt
	fi
	rm -f ./userlist.txt 

	echo ""
	exit 0
}



# The code below checks if no argumets are passed then all the users are printed on the screen
if [[ $# -eq 0 ]]; then
	echo "List of all User Accounts"
	echo ""
	awk -F':' '{ print $1 }' /etc/passwd
	echo ""
	usage
fi


getopts ":c:d:" opt_var
case $opt_var in
  c) userOperation $2 1;;
  d) userOperation $2 2;;
  ?) echo "Invalid Option: -&OPTARG" >&2; usage ;;
  :) echo "Option -$OPTARG requires an argument." >&2; usage;;
esac


