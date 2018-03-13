# scrcpy

Docker image to run [scrcpy](https://github.com/Genymobile/scrcpy).

## Usage

Before running the image, Docker must be allowed to connect to the X server:

```shell
$ xhost + local:docker
```

Then, run the image:

```shell
$ docker run --rm -i -t --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    scrcpy [options]
```

## Issues

See the [FAQ](FAQ.md).

