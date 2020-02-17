#!/bin/bash

echo "Waiting for Mutagen to sync initial files"
while ! [ -f ./package.json -a -f ./package-lock.json ]
do
  sleep 2
done

npm ci
npm install pm2 forever -g
pm2-runtime process-core.yml
