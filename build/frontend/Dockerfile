ARG NODEJS_VERSION=10

FROM node:$NODEJS_VERSION
LABEL authors="Alfred Genkins, Ilja Lapkovskis info@scandiweb.com"

COPY start.sh /start.sh
COPY start-and-wait.sh /start-and-wait.sh

RUN chmod +x /start.sh
RUN chmod +x /start-and-wait.sh

RUN npm install pm2 forever -g
