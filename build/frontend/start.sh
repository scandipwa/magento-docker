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

if [ "$core" = "1" ]
then
  PATH_TO_THEME="$PATH_TO_THEME/localmodules/base-theme/"
else
  PATH_TO_THEME="$PATH_TO_THEME/app/design/frontend/Scandiweb/pwa/"
fi

if [ -d $PATH_TO_THEME ]
then
  cd $PATH_TO_THEME;
else
  echo "ERROR: $PATH_TO_THEME is empty!"
  exit 1
fi

if [ "$mutagen" = "1" ]
then
    echo "Waiting for Mutagen to sync initial files"
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
