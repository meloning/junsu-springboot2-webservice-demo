#!/bin/bash

#REPOSITORY=/home/ec2-user/app/step1
REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=junsu-springboot2-webservice-demo

#cd $REPOSITORY/$PROJECT_NAME/
#
#echo "> Git Pull"
#
#git pull
#
#echo "> Start Project Build"
#
#./gradlew build
#
#echo "> Move REPOSITORY"
#
#cd $REPOSITORY
#
#pwd

echo "> Copy Build File"

#cp $REPOSITORY/$PROJECT_NAME/build/libs/*.jar $REPOSITORY/
cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> Check Current Running Application PID"

#CURRENT_PID=$(pgrep -f ${PROJECT_NAME}*.jar)
# pgrep -> process id만 추출하는 명령어
# -f 프로세스 이름으로 찾음

CURRENT_PID=$(pgrep -fl ${PROJECT_NAME} | grep jar | awk '{print $1}')
# awk '{print $1}' pid 출력

echo "Current Running Application PID: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
        echo "> Not exit because don't exist current running application"
else
        echo "> kill -15 $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 5
fi

echo "> Deploy New Application"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> Add run grant to $JAR_NAME"

chmod +x $JAR_NAME

echo "> Run $JAR_NAME"

# nohup java -jar $REPOSITORY/$JAR_NAME 2>&1 &

#nohup java -jar \
#-Dspring.config.location=classpath:/application.yml,classpath:/application-real.yml,/home/ec2-user/app/application-real-db.yml,/home/ec2-user/app/application-oauth.yml \
#-Dspring.profiles.active=real \
#$REPOSITORY/$JAR_NAME 2>&1 &

nohup java -jar \
-Dspring.config.location=classpath:/application.yml,classpath:/application-real.yml,/home/ec2-user/app/application-real-db.yml,/home/ec2-user/app/application-oauth.yml \
-Dspring.profiles.active=real \
$JAR_NAME > $REPOSITORY/nohup.out 2>$1 $
# nohup 실행 시 CodeDeploy는 무한 대기
# 이 이슈를 해결하기 위해 nohup.out 파일을 표준 입출력용으로 별로로 사용
# 이렇게 하지 않으면 nohup.out 파일이 생기지 않고, CodeDeploy 로그에 표준 입출력이 출력
# nohup이 끝나기 전까지 CodeDeploy도 끝나지 않으니 꼭 이렇게 해야만 함.
