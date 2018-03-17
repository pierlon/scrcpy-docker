FROM alpine:edge

LABEL maintainer="Pierre Gordon <pierregordon@protonmail.com>"

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
    curl -L -o scrcpy-server.jar \
      $(curl https://api.github.com/repos/Genymobile/scrcpy/releases/latest | \
         grep "browser_download_url" | \
         grep "scrcpy-server" | \
         cut -d ":" -f 2,3 | \
         tr -d "\" ,") \
      && \
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

