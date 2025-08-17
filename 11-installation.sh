#! /bin/bash

USERID=$(id -u)
if [ $USERID -ne 0 ]; then
    echo "Please run as root user"
    exit 1
fi
dnf list installed git

if [ $? -ne 0 ]; then
    echo "Installing git..."
    dnf install git -y
    if [ $? -ne 0 ]; then
        echo "Failed to install git. Please check your network connection or repository settings."
        exit 1
    else
        echo "Git installed successfully." 
    fi
else
    echo "Git is already installed."
fi

dnf list installed mysql
if [ $? -ne 0 ]; then
    echo "Installing MySQL..."
    dnf install mysql-server -y
    if [ $? -ne 0 ]; then
        echo "Failed to install MySQL. Please check your network connection or repository settings."
        exit 1
    else
        echo "MySQL installed successfully."
    fi
else
    echo "MySQL is already installed."
fi