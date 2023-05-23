#!/bin/bash

#ENV

#ip
export SERVER1="<IP>"
# export SERVER2="<IP>"
# export SERVER3="<IP>"

#port
export PORT="<PORT>"

#NGINX version(dockertag)
export NGINX_VERSION="1.23"
#NGINX LISTEN PORT
export NGINX_LISTEN_PORT={nginx listen port number}

#create config

# Dockerfile
cat > Dockerfile <<EOF
FROM nginx:${NGINX_VERSION}

COPY nginx.conf /etc/nginx/nginx.conf
COPY deny.conf /etc/nginx/deny.conf
EOF

# docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3'
services:
  nginx:
    build: .
    ports:
      - "{PORT}:{NGINX_LISTE_PORT}/udp"
    volumes:
      - ./deny.conf:/etc/nginx/deny.conf
      - ./nginx.conf:/etc/nginx/nginx.conf
EOF

# nginx.conf
cat > nginx.conf <<EOF
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

stream {
    include deny.conf; # BLOCK LIST(IP)

    upstream udp_servers {
        server ${SERVER1}:${PORT};
        # server ${SERVER2}:${PORT};
        # server ${SERVER3}:${PORT};
    }

    server {
        listen ${NGINX_LISTEN_PORT} udp;
        proxy_pass udp_servers;
    }
}
EOF