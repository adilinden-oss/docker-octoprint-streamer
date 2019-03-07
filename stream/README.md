# About

## What is this for?

I built this to stream the webcam attached to my [OctoPi](https://octoprint.org/) to online streaming services. This docker container is one of the building blocks of my [adilinden-oss/docker-octoprint-streamer](https://github.com/adilinden-oss/docker-octoprint-streamer) solution. This is **not** an OctoPrint plugin! Neither does it run on a [Raspberry Pi](https://www.raspberrypi.org/). It is meant to run on a generic x86 or x86_64 Docker host.

This particular container is a wrapper around my `ffmpeg` container that can be found at Docker Hub as [adilinden/ffmpeg](https://cloud.docker.com/repository/docker/adilinden/ffmpeg) or on GitHub as [adilinden-oss/docker-ffmpeg](https://github.com/adilinden-oss/docker-ffmpeg).

Using an `ENTRYPOINT` script it is possible to use and expand environment variables defined in a `docker-compose.yml` file. This makes constructing the long `ffmpeg` command line much easier. It also allows for secrets such as API keys and stream keys to be placed in an environment file.


## Building & Usage

See the [README.d](https://github.com/adilinden-oss/docker-octoprint-streamer/blob/master/README.md) in the main GitHub repo [adilinden-oss/docker-octoprint-streamer](https://github.com/adilinden-oss/docker-octoprint-streamer).
