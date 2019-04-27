FROM python:alpine

# Set version label
LABEL maintainer="tmp-hallenser"

# Install base dependencies and clone the repo 
RUN \
    apk update && \
    apk add \
    git \
    gcc \
    musl-dev \
    libjpeg-turbo-dev \
    zlib-dev && \
    cd /home && \
    git clone --recurse-submodules -b lychee-laravel --single-branch https://github.com/tmp-hallenser/lycheesync.git

# Install python modules
RUN pip install -r /home/lycheesync/requirements.txt

VOLUME /uploads /import

WORKDIR /home

COPY entrypoint.sh wait-for-it/wait-for-it.sh /

RUN chmod +x /entrypoint.sh && chmod +x /wait-for-it.sh

ENTRYPOINT [ "/wait-for-it.sh", "webserver:80", "-t", "0", "--", "/entrypoint.sh" ]

