### builder
FROM alpine:edge AS builder

ARG SCRCPY_VER=1.24
ARG SERVER_HASH="ae74a81ea79c0dc7250e586627c278c0a9a8c5de46c9fb5c38c167fb1a36f056"

RUN apk add --no-cache \
    curl \
    ffmpeg-dev \
    gcc \
    git \
    libusb-dev \
    make \
    meson \
    musl-dev \
    openjdk11 \
    pkgconf \
    sdl2-dev

RUN PATH=$PATH:/usr/lib/jvm/java-11-openjdk/bin
RUN curl -L -o scrcpy-server https://github.com/Genymobile/scrcpy/releases/download/v${SCRCPY_VER}/scrcpy-server-v${SCRCPY_VER}
RUN echo "$SERVER_HASH  /scrcpy-server" | sha256sum -c -
RUN git clone https://github.com/Genymobile/scrcpy.git
RUN cd scrcpy && meson x --buildtype=release --strip -Db_lto=true -Dprebuilt_server=/scrcpy-server
RUN cd scrcpy/x && ninja
RUN cd scrcpy/x && ninja install

### runner
FROM alpine:edge AS runner

# needed for android-tools
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

LABEL maintainer="Pierre Gordon <pierregordon@protonmail.com>"

RUN apk add --no-cache \
    android-tools \
    ffmpeg \
    virtualgl

COPY --from=builder /usr/local/share/scrcpy/scrcpy-server /usr/local/share/scrcpy/
COPY --from=builder /usr/local/bin/scrcpy /usr/local/bin/
COPY --from=builder /usr/local/share/icons/hicolor/256x256/apps/scrcpy.png /usr/local/share/icons/hicolor/256x256/apps/

### runner (amd)
FROM runner AS amd

RUN apk add --no-cache mesa-dri-gallium

### runner (intel)
FROM runner AS intel

RUN apk add --no-cache mesa-dri-intel

### runner (nvidia)
FROM runner AS nvidia

RUN apk add --no-cache mesa-dri-nouveau
