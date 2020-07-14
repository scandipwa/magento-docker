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
  PATH_TO_THEME="$PATH_TO_THEME/app/design/frontend/$SCANDIPWA_THEME/"
fi

echo "Waiting for theme folder. If the app container is ready to handle connections and this message is still shown - something went wrong."
while ! [ -d $PATH_TO_THEME ]
do
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
