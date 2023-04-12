#!/usr/bin/env bash

alias dkc='docker kill $(docker ps -q)'
alias drc='docker rm $(docker ps -a -q)'
alias dfresh='dkc && drc'
alias dri='docker rmi $(docker images -q)'
alias dp='docker ps'

alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dce='docker-compose exec'

alias dpwsh='docker run -it --rm mcr.microsoft.com/powershell'
function dpwshf() {
    docker run -v "$PWD/$1":"/tmp/$1" mcr.microsoft.com/powershell pwsh "/tmp/$1"
}

function ksn() {
    kubectl config set-context --current --namespace=$1;
}

alias mh='docker run -p 1025:1025 -p 8025:8025 mailhog/mailhog'
