#! /bin/bash

# Server deployment script.
# Meant to be run over SSH, to deploy on remote server
# Example: ssh <server-ip-address> "deploy.sh production"
#
# Requirements for remote deployment:
# - Remote must have this script in the home folder
# - Remote must have this repo cloned on folder 'ktg'
#
# By default deploys latest development branch.
# With the 'production' argument, deplos latest master branch.

if [[ ! -d ~/ktg ]]; then
  echo "ktg/ does not exist."
        exit 1
fi

ENV="development"
if [[ $1 = "production" ]]; then
    ENV=$1
fi

cd ~/ktg/server

if [[ $1 = "production" ]]; then
git checkout master
else
git checkout develop
fi

git pull -f

npm ci
pm2 start ecosystem.config.js --env $ENV

cd ~
