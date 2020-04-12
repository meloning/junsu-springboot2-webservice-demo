#!/usr/bin/env bash

# 현재 stop.sh가 속해 있는 경로를 찾음
ABSPATH=$(readlink -f "$0")
ABSDIR=$(dirname "$ABSPATH")
# shellcheck disable=SC1090
# 자바로 보면 일종의 import 구문
# 해당 코드로 인해 stop.sh에서도 profile.sh의 여러 function을 사용할 수 있음.
source "${ABSDIR}"/profile.sh

REPOSITORY=/home/ec2-user/app/step3
# shellcheck disable=SC2034
PROJECT_NAME=junsu-springboot2-webservice-demo

echo "> Build 파일 복사"
echo "> cp $REPOSITORY/zip/*.jar $REPOSITORY/"

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> 새 애플리케이션 배포"
# shellcheck disable=SC2012
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x "$JAR_NAME"

echo "> $JAR_NAME 실행"

IDLE_PROFILE=$(find_idle_profile)

echo "> $JAR_NAME 를 profile=$IDLE_PROFILE 로 실행"
nohub java -jar \
  -Dspring.config.location=classpath:/application.yml,classpath:/application-"$IDLE_PROFILE".yml,/home/ec2-user/app/application-oauth.yml,/home/ec2-user/app/application-real-db.yml \
  -Dspring.profiles.active="$IDLE_PROFILE" \
  "$JAR_NAME" > $REPOSITORY/nohub.out 2>&1 &
