#!/bin/bash
npm ci
npm install pm2 forever -g
pm2-runtime process.yml
