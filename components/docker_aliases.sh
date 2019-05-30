#!/usr/bin/env bash

alias dkc='docker kill $(docker ps -q)'
alias drc='docker rm $(docker ps -a -q)'
alias dfresh='dkc && drc'
alias dri='docker rmi $(docker images -q)'

alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
