# About

## What is this for?

I built this to stream the webcam attached to my [OctoPi](https://octoprint.org/) to online streaming services. This docker container is one of the building blocks of my [adilinden-oss/docker-octoprint-streamer](https://github.com/adilinden-oss/docker-octoprint-streamer) solution. This is **not** an OctoPrint plugin! Neither does it run on a [Raspberry Pi](https://www.raspberrypi.org/). It is meant to run on a generic x86 or x86_64 Docker host.

This particular container will obtain printer and job status information from the OctoPrint API and make it available to be used in the `ffmpeg` stream as text overlay.


## Building & Usage

See the [README.md](https://github.com/adilinden-oss/docker-octoprint-streamer/blob/master/README.md) in the main GitHub repo [adilinden-oss/docker-octoprint-streamer](https://github.com/adilinden-oss/docker-octoprint-streamer).
