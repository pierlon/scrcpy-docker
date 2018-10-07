FROM alpine:edge

LABEL maintainer="Pierre Gordon <pierregordon@protonmail.com>"

ARG SCRCPY_VER=1.4

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk add --no-cache \
        ffmpeg \
        android-tools \
        virtualgl && \
    apk add --no-cache --virtual .build-deps \
        curl \
        ffmpeg-dev \
        gcc \
        git \
        make \
        meson \
        musl-dev \
        pkgconf \
        sdl2-dev && \
    curl -L -o scrcpy-server.jar https://github.com/Genymobile/scrcpy/releases/download/v${SCRCPY_VER}/scrcpy-server-v${SCRCPY_VER}.jar && \
    git clone https://github.com/Genymobile/scrcpy.git && \
    cd scrcpy && \
    meson x --buildtype release --strip -Db_lto=true -Dprebuilt_server=/scrcpy-server.jar && \
    cd x && \
    ninja && \
    ninja install && \
    cd / && \
    rm -rf scrcpy scrcpy-server.jar && \
    apk del .build-deps
