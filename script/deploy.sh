#!/bin/bash

REPOSITORY=/home/ec2-user/app/step1
PROJECT_NAME=junsu-springboot2-webservice-demo

cd $REPOSITORY/$PROJECT_NAME/

echo "> Git Pull"

git pull

echo "> Start Project Build"

./gradlew build

echo "> Move REPOSITORY"

cd $REPOSITORY

pwd

echo "> Copy Build File"

cp $REPOSITORY/$PROJECT_NAME/build/libs/*.jar $REPOSITORY/

echo "> Check Current Running Application PID"

CURRENT_PID=$(pgrep -f ${PROJECT_NAME}*.jar)
# pgrep -> process id만 추출하는 명령어
# -f 프로세스 이름으로 찾음

echo "Current Running Application PID: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
        echo "> Not exit because don't exist current running application"
else
        echo "> kill -15 $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 5
fi

echo "> Deploy New Application"

JAR_NAME=$(ls -tr $REPOSITORY/ | grep *.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

nohup java -jar $REPOSITORY/$JAR_NAME 2>&1 &
