#!/bin/bash

echo "Waiting for initial files to be synced"
while ! [ -f ./package.json -a -f ./package-lock.json ]
do
  sleep 2
done

echo "Installing node modules"
npm ci

pm2-runtime $PROCESS_FILE
