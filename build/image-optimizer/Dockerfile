FROM node:latest

LABEL authors="Kriss Andrejevs info@scandiweb.com"
RUN apt-get update && apt-get install -y libgl1-mesa-glx

WORKDIR /var/www/media
COPY . .
RUN npm i

USER node
CMD ["node", "index.js"]
