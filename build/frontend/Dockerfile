ARG NODEJS_VERSION=10

FROM node:$NODEJS_VERSION

LABEL maintainer="Alfreds Genkins alfreds@scandipwa.com"
LABEL author="Ilja Lapkovskis info@scandiweb.com"

RUN npm install pm2 forever -g

COPY start.sh /start.sh
RUN chmod +x /start.sh
