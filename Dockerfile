FROM nginx:alpine

LABEL org.opencontainers.image.title="codyssey-week1-workstation"
LABEL org.opencontainers.image.description="Week 1 workstation assignment static site"

COPY site/ /usr/share/nginx/html/
