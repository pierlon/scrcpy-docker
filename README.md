[![Docker Build Status](https://img.shields.io/docker/build/pierlo1/scrcpy.svg)](https://hub.docker.com/r/pierlo1/scrcpy/)
[![Docker Pulls](https://img.shields.io/docker/pulls/pierlo1/scrcpy.svg)](https://hub.docker.com/r/pierlo1/scrcpy/)
[![AMD Size](https://img.shields.io/microbadger/image-size/pierlo1%2Fscrcpy/amd.svg?label=amd%20size)](https://hub.docker.com/r/pierlo1/scrcpy/)
[![Intel Size](https://img.shields.io/microbadger/image-size/pierlo1%2Fscrcpy/intel.svg?label=intel%20size)](https://hub.docker.com/r/pierlo1/scrcpy/)
[![Nvidia Size](https://img.shields.io/microbadger/image-size/pierlo1%2Fscrcpy/nvidia.svg?label=nvidia%20size)](https://hub.docker.com/r/pierlo1/scrcpy/)

# scrcpy

Docker image to run [scrcpy](https://github.com/Genymobile/scrcpy).

## Usage

Before running the image, Docker must be allowed to connect to the X server:

```shell
xhost + local:docker
```

A separate image has been built for AMD, Intel, & Nvidia graphics hardwares.
To get the image for your hardware, simply append `:<graphics type>` to the image name (`pierlo1/scrcpy`) where graphics type can be:

- amd
- intel
- nvidia

For example: `pierlo1/scrcpy:amd`.

### Running with Docker

To run the image with Docker run:

```shell
docker run --rm -i -t --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    pierlo1/scrcpy:<graphics type>
```

### Running with Docker Compose

To run with Docker Compose, set the `SCRCPY_GRAPHICS_TYPE` environment variable to one of the graphics types mentioned earlier.
For persistence, make a copy of `.env.example`, name it `.env`, and configure it.

Once done, run the command:

```shell
docker-compose run --rm scrcpy
```

The `scrcpy_adb_keys` volume is used to preserve the `adb` authorization keys.  

### Running scrcpy

Inside the container, verify you can see your Android device with:

```shell
adb devices
```
Note: make sure the adb daemon is not running on the host (`adb kill-server`) to view devices in the container.

And finally, run `scrcpy`:

```shell
scrcpy [options]
```
