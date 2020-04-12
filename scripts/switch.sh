#!/usr/bin/env bash

# 현재 stop.sh가 속해 있는 경로를 찾음
ABSPATH=$(readlink -f "$0")
ABSDIR=$(dirname "$ABSPATH")
# shellcheck disable=SC1090
# 자바로 보면 일종의 import 구문
# 해당 코드로 인해 stop.sh에서도 profile.sh의 여러 function을 사용할 수 있음.
source "${ABSDIR}"/profile.sh

function switch_proxy() {
  IDLE_PORT=$(find_idle_port)

  echo "> 전환할 Port: $IDLE_PORT"
  echo "> Port 전환"
  # 하나의 문장(echo구문)을 파이프라인(|)으로 넘겨주기 위해 echo를 사용
  # tee: 터미널 출력을 파일로 저장
  echo "set \$service_url http://127.0.0.1:${IDLE_PORT};" | sudo tee /etc/nginx/conf.d/service-url.inc
  echo "> Nginx Reload"
  # Nginx 설정을 다시 불러옴
  # reload는 끊김 없이 다시 불러옴
  # 다만, 중요한 설정들은 반영되지 않으므로 restart를 사용해야함.
  # 여기선 외부의 설정 파일인 service-url을 다시 불러오는 거라 reload로 가능
  sudo service nginx reload
}
