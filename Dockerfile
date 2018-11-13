FROM alpine:edge

LABEL maintainer="Pierre Gordon <pierregordon@protonmail.com>"

ARG SCRCPY_VER=1.5
ARG SERVER_HASH="d97aab6f60294e33e7ff79c2856ad3e01f912892395131f4f337e9ece03c24de"

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk add --no-cache \
        android-tools \        
        ffmpeg \
        virtualgl && \
    apk add --no-cache --virtual .build-deps \
        curl \
        ffmpeg-dev \
        gcc \
        git \
        make \
        meson \
        musl-dev \
        openjdk8 \
        pkgconf \
        sdl2-dev && \
    # TODO: remove 'fixversion' for next release
    curl -L -o scrcpy-server.jar https://github.com/Genymobile/scrcpy/releases/download/v${SCRCPY_VER}-fixversion/scrcpy-server-v${SCRCPY_VER}.jar && \
    echo "$SERVER_HASH  /scrcpy-server.jar" | sha256sum -c - && \
    git clone https://github.com/Genymobile/scrcpy.git && \
    cd scrcpy && \
    PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/bin && \
    meson x --buildtype release --strip -Db_lto=true -Dprebuilt_server=/scrcpy-server.jar && \
    cd x && \
    ninja && \
    ninja install && \
    cd / && \
    rm -rf scrcpy scrcpy-server.jar && \
    apk del .build-deps

