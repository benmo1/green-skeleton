#!/usr/bin/env bash

alias dkc='docker kill $(docker ps -q)'
alias drc='docker rm $(docker ps -a -q)'
alias dfresh='dkc && drc'
alias dri='docker rmi $(docker images -q)'
alias dp='docker ps'

alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dce='docker-compose exec'
