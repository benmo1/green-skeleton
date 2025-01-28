#!/usr/bin/env bash

. $( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )/header.sh

# General
alias bvim='vim ~/.bashrc && . ~/.bashrc'
alias hvim='sudo vim /etc/hosts'
alias svim='vim ~/.ssh/config'

# Make an alias to cd to the current directory
function mkcdalias () {
    dirname=`pwd | egrep -oh '[^\/\0]+$'`
    aliasname="cd$dirname"
    occurances=`grep -c "alias $aliasname" ~/.bashrc`
    if [[ $occurances -gt "0" ]] ; then
        echo -e "Alias $aliasname already exists"'!'
    else
        echo -e "Alias $aliasname created"'!'
        echo "alias $aliasname='cd $PWD'" >> ~/.bashrc
        . ~/.bashrc
    fi

    return
}

# Decrypt the contents of your clip board with gpg
function gpg_d_clip() {
    pbpaste > temp.gpg
    gpg -d temp.gpg
    rm -P temp.gpg
}

function gpg_i_clip() {
   pbpaste > temp.key
   gpg --import temp.key
   rm -P temp.key
}

function gen_ssc() {
  openssl genrsa -out tls.key 2048
  openssl req -new -key tls.key -out server.csr -noenc
  openssl x509 -req -sha256 -days 3650 -in server.csr -signkey tls.key -out tls.crt
}

function pem2pfx() {
  in_key=${1-'tls.key'}
  in_crt=${2-'tls.crt'}
  out_crt=${3-'crt.pfx'}
  openssl pkcs12 -export -inkey "$in_key" -in "$in_crt" -out "$out_crt"
}

function pfx2pem() {
  if [[ -z "$1" ]] ; then
    echo "Must specify a file to split! Exiting."
    return 1;
  fi
  infile="$1"
  openssl pkcs12 -in "$infile" -nocerts -out key.pem -nodes
  openssl pkcs12 -in "$infile" -nokeys -out cert.pem
}

function mactrust() {
  to_trust=${1-'tls.crt'}
  sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$to_trust"
}

alias myip="curl checkip.amazonaws.com | tee -a ~/ips.txt"
alias cmyip="curl checkip.amazonaws.com | tee -a ~/ips.txt && tail -1 ~/ips.txt | pbcopy"
alias rider="open -na "Rider.app" --args"

alias dr="dotnet run"
alias yr="yarn run start"
alias dma="dotnet ef migrations add"
alias abswag="abp generate-proxy -t ng"

function ctar()
{
  if [[ -z "$1" ]]
  then
    echo "Please provide a folder to zip, e.g.:"
    echo "ctar path/to/my_folder/." 
  fi
  
  folder_name_without_slash=$(echo "$1" | sed 's/\/$//g')
  tar -czvf "$folder_name_without_slash".tgz "$1"
}


function rtar()
{
  if [[ -z "$1" ]]
  then
    echo "Please provide a tar zip to extract, e.g.:"
    echo "rtar path/to/my_zip.tgz" 
  fi
 
  file_name_without_extension=$(echo "$1" | sed 's/\.tgz$//g')
  tar -xvf "$1" "$file_name_without_extension"
}

function find_files_containing()
{
  find . -name '*sql' -exec grep -nl "$1" {} \;
}

# don't open cursor in the wrong place
cursor ()
{
    for arg in "$@";
    do
        if [ -d "$arg" ] || [[ "$arg" = "." || "$arg" = ".." || "$arg" = "~" ]]; then
            full_path=$(realpath $arg)/;
            allowed_paths=(realpath ~/general-dev/);
            allowed=false;
            for allowed_path in "${allowed_paths[@]}";
            do
                [[ "$full_path" == "$allowed_path"* ]] && allowed=true;
            done;
            if [ "$allowed" = false ]; then
                echo "directory not allowed" && return 1;
            fi;
        fi;
    done;
    command cursor "$@"
}

# check for secrets in a git repo
function check_secrets() {
    # Function body goes here
    echo "Checking git status..."
    git status
    echo "Checking git ignore..."
    git check-ignore -v **/**/*
    echo "Checking tfstate..."
    find . -name 'terraform.tfstate' -exec cat {} \;
    echo "Checking Python settings..."
    find . -name 'settin*py' -exec cat {} \;
    echo "Checking Appsettings..."
    find . -name 'appset*' -exec cat {} \;
}

