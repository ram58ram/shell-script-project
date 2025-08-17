#! /bin/bash

LOGS_FOLDER="/var/log/shell-script-project"
SCRIPT_NAME=$(echo $0 | cut -d "." -f 1)
TIME_STAMP=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 command is... $R FAILED $N" | tee -a &>> $LOG_FILE
        exit 1
    else
        echo -e "$2 Command is.... $G successful $N" | tee -a &>> $LOG_FILE
    fi
}

CHECK_ROOT_USER(){
    if [ $USERID -ne 0 ]; then
        echo -e "$R Pelease run this with root priveleges...$N" | tee -a &>> $LOG_FILE
        exit 1
    fi
}

USAGE(){
    echo -e "USAGE is :: $R sudo sh $SCRIPT_NAME.sh package1 package2 ... $N"
    exit 1
}

echo "Script started executing at $(date)" | tee -a &>> $LOG_FILE
CHECK_ROOT_USER

if [ $# -eq 0 ]; then
    USAGE
fi

# sh loops.sh git mysql postfix nginx
for package in $@ 
do
    dnf list installed $package &>> $LOG_FILE

    if [ $? -ne 0 ]; then
        echo "$package is not installed,going to install it..." | tee -a  &>> $LOG_FILE
        dnf install $package -y  &>> $LOG_FILE
        VALIDATE $? "Installing $package"
    else
        echo -e "$package is $Y already installed..nothing to do $N" | tee -a &>> $LOG_FILE
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

