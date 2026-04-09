FROM nginx:alpine

RUN apk add --no-cache gettext

COPY nginx/default.conf.template /opt/templates/default.conf.template
COPY site/index.template.html /opt/templates/index.template.html
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
