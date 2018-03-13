FROM alpine:edge

LABEL maintainer="Pierre Gordon <pierregordon@protonmail.com>"

ENV SCRCPY_VER=v1.0

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk add --no-cache \
        ffmpeg \
        mesa-dri-swrast \
        android-tools && \
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
    curl -L -o scrcpy-server.jar https://github.com/Genymobile/scrcpy/releases/download/${SCRCPY_VER}/scrcpy-server-${SCRCPY_VER}.jar && \
    git clone https://github.com/Genymobile/scrcpy.git && \
    cd scrcpy && \
    meson x --buildtype release --strip -Db_lto=true -Dprebuilt_server=/scrcpy-server.jar && \
    cd x && \
    ninja && \
    ninja install && \
    cd / && \
    rm -rf scrcpy scrcpy-server.jar && \
    apk del .build-deps && \
    rm -r /var/cache/apk/APKINDEX.* && \
    echo -e "#!/bin/sh\nscrcpy \$@" > init.sh && \
    chmod +x init.sh

ENTRYPOINT [ "/init.sh" ]

