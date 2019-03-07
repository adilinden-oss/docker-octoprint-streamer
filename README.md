# About

## What is this for?

I built this to stream the webcam attached to my [OctoPi](https://octoprint.org/) to online streaming services. This docker container is one of the building blocks of my [adilinden-oss/docker-octoprint-streamer](https://github.com/adilinden-oss/docker-octoprint-streamer) solution. This is **not** an OctoPrint plugin! Neither does it run on a [Raspberry Pi](https://www.raspberrypi.org/). It is meant to run on a generic x86 or x86_64 Docker host.

## Building

Currently two branches are present, `dev` and `master`. The `dev` branch is used for development and builds the containers the service depends on from the Dockerfiles in the `music`, `stream` and `text` directories. The `master` branch is meant for deployment and pulls the required images from Docker Hub.

To build or re-build the docker images from GitHub run

	git clone https://github.com/adilinden-oss/docker-octoprint-streamer.git
	cd docker-octoprint-streamer
	docker-compose build

## Usage

The `docker-compose.yml` file is kept as generic as possible and by default expects default rPi camera settings of 640x480 at 10 fps. If the camera is set using different values, then `docker-compose.yml` needs to be adjusted accordingly.

  - The frame rate is defined in the `FFMPEG_FPS` variable.
  - The resolution is relevant when video is resized from 4:3 to 16:9 format in the `FFMPEG_FILTER_VIDEO` variable. YouTune supported encoder settings and supported resolutions can be found on the [Live encoder settings, bitrates, and resolutions](https://support.google.com/youtube/answer/2853702?hl=en) page.

A environment file is required to set some required environment variable containing somewhat sensitive paramters. The default `docker-compose.yml` file uses `.stream-testing.env`. Note that `.gitignore` purposely ignores `*.env` files to prevent accidental checkin of secrets into the git repo. Contents for an example `.stream-testing.env` file:

	# My twitch credentials
	SOURCE_URL=http://octopi.example.com:8080/?action=stream
	STREAM_URL=rtmp://live.twitch.tv/app
	STREAM_KEY=live_123456789_ab1CDe2FghiJ3klmnopqRS4tUV5Wxy

	# My OctoPi API credentials
	OCTOPI_URL=http://octopi.example.com
	OCTPPI_API_KEY=12345678A98B123FBCD123EBD123EDD9

Bring up the service using

	docker-compose up -d

Take down the service using

	docker-compose down -v

Do note that this is meant to be run on some Docker host, not a [Raspberry Pi](https://www.raspberrypi.org/), nor the [Raspberry Pi](https://www.raspberrypi.org/) that hosts OctoPrint. Being executed on a remote (whether same LAN, or some remote VPS) requires that the `SOURCE_URL` and `OCTOPI_URL` are fully qualified URL using valid hostname and domain or IP address. If run on a remote VPS then proper port forwarding and firewalling needs to be deployed to ensure remote access yet security of the OctoPi or OctoPrint installation.

## Additional Thoughts

### Network Usage

I am running this successfuly with default rPi cam settings of 640x480 at 10 fps. This generates some 12+Mbps of network traffic on the wireless NIC of the [Raspberry Pi](https://www.raspberrypi.org/) running OctoPi. This was an initial surpise but realizing that `mjpeg-streamer` feeds a consecutive stream of JPEG images without any stream based optimization, it eventually made sense. In my case the individual JPEG images are about 160kB in size. Sending 10 per seconds results in 1.6MB or 12.8Mbits of data being transfered every second. I was unable to make higher resolutions work, not because of [Raspberry Pi](https://www.raspberrypi.org/) processing concerns, but lack of USB WiFi throughput. Remember that accessing the OctoPrint webUI will send an equal amount of data to the viewers browser, in essence doubling that network traffic.

### CPU Usage

At a resolution of 640x480 and 10 fps the `ffmpeg` transcoding process consumed about 100% of a single core of my Ubuntu Docker host which itself is hosted on a Hyer-V host with 2 quad core Xeon processors. Increasing resolution to 720p equivalent caused CPU to skyrocket. I could not determine an accurate CPU requirement as at 720p is was unable to sustain 10 fps as stream throughput exceeded USB WiFi adapter capabilities.



