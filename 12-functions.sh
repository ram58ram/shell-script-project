#! /bin/bash

USERID=$(id -u)

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2 command is failed."
        exit 1
    else
        echo "$2 Command is successful."
    fi
}

if [ $USERID -ne 0 ]; then
    echo "Please run as root user"
    exit 1
fi
dnf list installed git

VALIDATE $? "Listing GIT"

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