#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
mkdir -p "$LOGS_FOLDER"
LOGS_FILE="$LOGS_FOLDER/$(basename $0).log"

if [ "$USERID" -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N" | tee -a "$LOGS_FILE"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a "$LOGS_FILE"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a "$LOGS_FILE"
    fi
}

SCRIPT_DIR=$(dirname "$(realpath "$0")")

cp "$SCRIPT_DIR/mongo.repo" /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo Repo"

dnf install mongodb-org -y &>>"$LOGS_FILE"
VALIDATE $? "Installing MongoDB server"

systemctl enable mongod &>>"$LOGS_FILE"
VALIDATE $? "Enable MongoDB"

systemctl start mongod &>>"$LOGS_FILE"
VALIDATE $? "Start MongoDB"

sed -i '/bindIp:/c\  bindIp: 0.0.0.0' /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

systemctl restart mongod &>>"$LOGS_FILE"
VALIDATE $? "Restarted MongoDB"