#!/bin/bash

echo "Installing node modules"
npm ci

pm2-runtime $PROCESS_FILE
