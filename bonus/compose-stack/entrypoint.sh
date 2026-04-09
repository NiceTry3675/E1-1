#!/bin/sh
set -eu

: "${APP_MODE:=compose}"
: "${APP_TITLE:=Codyssey Compose Bonus}"
: "${API_BASE_URL:=/api/}"

envsubst '${APP_MODE} ${APP_TITLE} ${API_BASE_URL}' \
  < /opt/templates/index.template.html \
  > /usr/share/nginx/html/index.html

envsubst '${APP_MODE}' \
  < /opt/templates/default.conf.template \
  > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
