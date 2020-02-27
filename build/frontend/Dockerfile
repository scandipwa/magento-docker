ARG NODEJS_VERSION=10

FROM node:$NODEJS_VERSION
LABEL authors="Alfred Genkins, Ilja Lapkovskis info@scandiweb.com"

# Set working directory so any relative configuration or scripts wont fail

RUN ["npm", "i", "-g", "pm2", "forever"]
CMD ["npm", "ci"]
