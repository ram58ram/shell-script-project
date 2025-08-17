#! /bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"]

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2 command is... $R FAILED $N"
        exit 1
    else
        echo "$2 Command is.... $G successful $N"
    fi
}

CHECK_ROOT_USER(){
    if [ $USERID -ne 0 ]; then
        echo "Please run as root user"
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

