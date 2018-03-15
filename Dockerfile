FROM alpine:3.7

RUN mkdir /app && mkdir /config

RUN apk add --no-cache python git bash && git clone https://github.com/ngovil21/Plex-Cleaner.git /app && apk del git

COPY run-periodically.sh /app/run-periodically.sh

# Default interval to 5min
ENV INTERVAL_IN_SECOND 300

# REQUIRED
# Store the configuration out of the container
VOLUME ["/config"]

# OPTIONNAL
# In case the script is configured to directly delete the files, we need to mount the plex data folder
VOLUME ["/plexdata"]

ENTRYPOINT ["/app/run-periodically.sh"]
