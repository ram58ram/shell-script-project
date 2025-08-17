#! /bin/bash

LOGS_FOLDER="/var/log/shell-script-project"
SCRIPT_NAME=$(echo $0 | cut -d "." -f 1)
TIME_STAMP=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"]

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 command is... $R FAILED $N" &>> $LOG_FILE
        exit 1
    else
        echo -e "$2 Command is.... $G successful $N" &>> $LOG_FILE
    fi
}

CHECK_ROOT_USER(){
    if [ $USERID -ne 0 ]; then
        echo -e "$R Pelease run this with root priveleges...$N" &>> $LOG_FILE
        exit 1
    fi
}

CHECK_ROOT_USER

# sh loops.sh git mysql postfix nginx
for package in $@ 
do
    dnf list installed $package

    if [ $? -ne 0 ]; then
        echo "Installing $package..."
        dnf install $package -y
        VALIDATE $? "Installing $package"
    else
        echo "$package is already installed."
    fi
done

: <<'END_COMMENT'
dnf list installed git

if [ $? -ne 0 ]; then
    echo "Installing git..."
    dnf install git -y
    VALIDATE $? "Installing GIT"
else
    echo "Git is already installed."
fi

dnf list installed mysql
if [ $? -ne 0 ]; then
    echo "Installing MySQL..."
    dnf install mysql-server -y
    VALIDATE $? "Installing MySql"
else
    echo "MySQL is already installed."
fi
END_COMMENT

