#!/bin/bash
echo """
                                                                        __
   ____ ___  ____ _____  ____ _____ ____  _____        __  ______ ___  / /
  / __ \`__ \/ __ \`/ __ \/ __ \`/ __ \`/ _ \/ ___/       / / / / __ \`__ \/ / 
 / / / / / / /_/ / / / / /_/ / /_/ /  __/ /     _    / /_/ / / / / / / /  
/_/ /_/ /_/\__,_/_/ /_/\__,_/\__, /\___/_/     (_)   \__, /_/ /_/ /_/_/   
                            /____/                  /____/                
""" 


echo


ACME_EMAIL=
PORTAINER_DOMAIN=
TRAEFIK_DASHBOARD_DOMAIN=
TRAEFIK_API_DOMAIN=
TRAEFIK_USER=
TRAEFIK_PASSWORD=
read -p "Email (for Let's Encrypt): " ACME_EMAIL
read -p "Portainer domain: " PORTAINER_DOMAIN
read -p "Treafik dashboard domain: " TRAEFIK_DASHBOARD_DOMAIN
read -p "Treafik API domain: " TRAEFIK_API_DOMAIN
read -p "Treafik user: " TRAEFIK_USER
read -s -p "Treafik password: " TRAEFIK_PASSWORD
echo
TRAEFIK_LOGIN=$(htpasswd -nbB -C 8 $TRAEFIK_USER $TRAEFIK_PASSWORD | sed -e s/\\$/\\$\\$/g)
echo "Traefik login: $TRAEFIK_LOGIN"


echo


read -p "Create specific manager.yml? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi
rm -f manager.yml
cp template_manager.yml manager.yml
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i "" "s#{{ACME_EMAIL}}#$ACME_EMAIL#g" manager.yml
    sed -i "" "s@{{PORTAINER_DOMAIN}}@$PORTAINER_DOMAIN@g" manager.yml
    sed -i "" "s@{{TRAEFIK_DASHBOARD_DOMAIN}}@$TRAEFIK_DASHBOARD_DOMAIN@g" manager.yml
    sed -i "" "s@{{TRAEFIK_API_DOMAIN}}@$TRAEFIK_API_DOMAIN@g" manager.yml
    sed -i "" "s@{{TRAEFIK_USER}}@$TRAEFIK_USER@g" manager.yml
    sed -i "" "s@{{TRAEFIK_PASSWORD}}@$TRAEFIK_PASSWORD@g" manager.yml
    sed -i "" "s@{{TRAEFIK_LOGIN}}@$TRAEFIK_LOGIN@g" manager.yml
else
    sed -i "s#{{ACME_EMAIL}}#$ACME_EMAIL#g" manager.yml
    sed -i "s@{{PORTAINER_DOMAIN}}@$PORTAINER_DOMAIN@g" manager.yml
    sed -i "s@{{TRAEFIK_DASHBOARD_DOMAIN}}@$TRAEFIK_DASHBOARD_DOMAIN@g" manager.yml
    sed -i "s@{{TRAEFIK_API_DOMAIN}}@$TRAEFIK_API_DOMAIN@g" manager.yml
    sed -i "s@{{TRAEFIK_USER}}@$TRAEFIK_USER@g" manager.yml
    sed -i "s@{{TRAEFIK_PASSWORD}}@$TRAEFIK_PASSWORD@g" manager.yml
    sed -i "s@{{TRAEFIK_LOGIN}}@$TRAEFIK_LOGIN@g" manager.yml
fi
echo "manager.yml created..."


echo


read -p "Start the manager? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi
docker network create proxy
docker compose -f manager.yml -p manager up -d  || exit 1
echo "Manager started..."
