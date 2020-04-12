#!/usr/bin/env bash

# 현재 stop.sh가 속해 있는 경로를 찾음
ABSPATH=$(readlink -f "$0")
ABSDIR=$(dirname "$ABSPATH")
# shellcheck disable=SC1090
# 자바로 보면 일종의 import 구문
# 해당 코드로 인해 stop.sh에서도 profile.sh의 여러 function을 사용할 수 있음.
source "${ABSDIR}"/profile.sh
# shellcheck disable=SC1090
source "${ABSDIR}"/switch.sh

IDLE_PORT=$(find_idle_port)

echo "> Health Check Start!"
echo "> IDLE_PORT: $IDLE_PORT"
echo "> curl - http://localhost:$IDLE_PORT/profile "
sleep 10

for RETRY_COUNT in {1..10}
do
  RESPONSE=$(curl -s http:/localhost:"${IDLE_PORT}"/profile)
  # shellcheck disable=SC2126
  UP_COUNT=$(echo "${RESPONSE}" | grep 'real' | wc -l)

  if [ "${UP_COUNT}" -ge 1 ]
  then # $up_count >= 1 ("real" 문자열이 있는지 검증)
    echo "> Health check 성공"
    switch_proxy
    break
  else
    echo "> Health check의 응답을 알 수 없거나 혹은 실행 상태가 아닙니다."
    echo "> Health check: ${RESPONSE}"
  fi

  if [ "${RETRY_COUNT}" -eq 10 ]
  then
    echo "> Health check 실패"
    echo "> Nginx에 연결하지 않고 배포를 종료"
    exit 1
  fi

  echo "> Health check 연결 실패 재시도..."
  sleep 10
done
