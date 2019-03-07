# About

## What is this for?

I built this to stream the webcam attached to my [OctoPi](https://octoprint.org/) to online streaming services. This docker container is one of the building blocks of my [adilinden-oss/docker-octoprint-streamer](https://github.com/adilinden-oss/docker-octoprint-streamer) solution. This is **not** an OctoPrint plugin! Neither does it run on a [Raspberry Pi](https://www.raspberrypi.org/). It is meant to run on a generic x86 or x86_64 Docker host.

This particular container fetches a number of MP3 audio files from the [YouTube Audio Library](https://www.youtube.com/audiolibrary/music). The audio files selected are royalty free and deemed suitable for use in YouTube videos and live streams. The songs choosen do not require that credit be given in the videos description. The audio files are merged into one or more larger files and available to use as audio input for `ffmpeg`.


## Building & Usage

See the [README.md](https://github.com/adilinden-oss/docker-octoprint-streamer/blob/master/README.md) in the main GitHub repo [adilinden-oss/docker-octoprint-streamer](https://github.com/adilinden-oss/docker-octoprint-streamer).