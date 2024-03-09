
### Introduction

This is a simple tool to setup a docker environment with Traefik and Portainer.

### Requirements

- Docker
- Docker Compose
- unzip
- apache2-utils
- wget

### Usage

```bash
# Clone the repository 
wget "https://github.com/maxmielchen/manager.yml/archive/refs/tags/1.0.0.zip"

# Unzip the repository
unzip 1.0.0.zip
cp manager.yml-1.0.0/* .
rm -rf manager.yml-1.0.0 1.0.0.zip

# Start wizard
sh init.sh
```

### Add new Web Application

First of all its important that your container is in the same network as Traefik.
The network is called `proxy` and is created by the `init.sh` file.

```yaml
networks:
  proxy:
    external: true
```

To add a new web application you have to add a new label to your container.

```yaml
labels:
 # Service
 - traefik.http.services.APPNAME_service.loadbalancer.server.port=PORT
 
 # HTTP -> HTTPS
 - traefik.http.routers.APPNAME_http.entrypoints=web
 - traefik.http.routers.APPNAME_http.rule=Host(`DOMAIN`)
 - traefik.http.routers.APPNAME_http.middlewares=APPNAME_redirect
 - traefik.http.middlewares.APPNAME_redirect.redirectscheme.scheme=https

 # HTTPS -> Service
 - traefik.http.routers.APPNAME_https.entrypoints=websecure
 - traefik.http.routers.APPNAME_https.rule=Host(`DOMAIN`)
 - traefik.http.routers.APPNAME_https.tls.certresolver=default 
 - traefik.http.routers.APPNAME_https.service=APPNAME_service
```



