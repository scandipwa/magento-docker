#!/bin/bash

mutagen="0"
core="0"

helpFunction()
{
   echo ""
   echo "Usage: $0 [-M] [-C]"
   echo -e "\t-M Wait for Mutagen to sync files before start"
   echo -e "\t-C Start core watching script"
   exit 1 # Exit script after printing help
}

while getopts "MC" opt
do
   case "$opt" in
      M ) mutagen="1" ;;
      C ) core="1" ;;
      ? ) helpFunction ;;
   esac
done

PATH_TO_THEME="/var/www/public"

# default value
SCANDIPWA_THEME=${SCANDIPWA_THEME:-"Scandiweb/pwa"}

if [ "$core" = "1" ]
then
  PATH_TO_THEME="$PATH_TO_THEME/localmodules/base-theme/"
else
  PATH_TO_THEME="$PATH_TO_THEME/app/design/frontend/$SCANDIPWA_THEME/"
fi

retry_count=0

echo "Waiting for the theme folder"
while ! [ -d $PATH_TO_THEME ]
do
  ((retry_count++))

  if [ $retry_count -gt 60 ]
  then
      echo "ERROR: Timeout, $((2 * retry_count))s elapsed. Theme folder \"$PATH_TO_THEME\" is empty!"
      exit 1
  fi

  sleep 2
done

cd $PATH_TO_THEME;

if [ "$mutagen" = "1" ] # wait for theme files
then
    echo "Waiting for Mutagen to sync files"
    while ! [ -f ./package.json -a -f ./package-lock.json ]
    do
      sleep 2
    done
fi

echo "Installing node modules"
npm ci

if [ "$core" = "1" ]
then
  pm2-runtime process-core.yml
else
  pm2-runtime process.yml
fi
