FROM scandipwa/base

# Start script for setup with mutagen
COPY ./start.sh /start-with-mutagen.sh
RUN chmod +x /start-with-mutagen.sh

# Start script for setup with mutagen and frontend container serving
COPY ./start-when-frontend-serving.sh /start-with-mutagen-when-frontend-serving.sh
RUN chmod +x /start-with-mutagen-when-frontend-serving.sh

