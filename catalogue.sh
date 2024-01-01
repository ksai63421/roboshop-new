#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# inside the above folder /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
  echo -e "$R ERROR:: Please run this script with root access $N"
  exit 1
fi
VALIDATE(){
  if [ $1 -ne 0 ];
  then 
     echo -e "$2....$R FAILURE $N"
     exit 1
     else 
      echo -e "$2...$G SUCCESS $N"
      fi
}

yum install https://rpm.nodesource.com/pub_18.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y \
    && yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1

# curl -0- https://rpm.nodesource.com/setup_18.x | bash &>> $LOGFILE

# VALIDATE $? "Setting up NPM source"

# dnf install nodejs -y 

# once user is created if you run this script for the 2nd time 
# this command will fail ?
# improvement: check the user alredy exit or not if not then create
useradd roboshop &>> $LOGFILE

# write a condifiton to check dir alredy exit or not

mkdir /app &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "downloading catalogue artifact"

cd /app &>> $LOGFILE

VALIDATE $? "moving into app dir"

unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "unzipping catalogue"

npm install &>> $LOGFILE

VALIDATE $? "installing dependencies"

cp /home/centos/roboshop-new/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "copying catalogue.service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "starting catalogue"

cp /home/centos/roboshop-new/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying monogo repo"

yum install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "installing mongo client"

mongo --host mongodb.joindevops.eu </app/schema/catalogue.js &>> $LOGFILE 

VALIDATE $? "loading catalogue data into mongodb"