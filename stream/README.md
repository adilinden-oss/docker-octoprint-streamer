# About

## What is this for?

I built this to stream the webcam attached to my [OctoPi](https://octoprint.org/) to online streaming services. This docker container is one of the building blocks of my [adilinden-oss/docker-octoprint-streamer](https://github.com/adilinden-oss/docker-octoprint-streamer) solution. This is **not** an OctoPrint plugin! Neither does it run on a [Raspberry Pi](https://www.raspberrypi.org/). It is meant to run on a generic x86 or x86_64 Docker host.

Using an `ENTRYPOINT` script it is possible to use and expand environment variables defined in a `docker-compose.yml` file. This makes constructing the long `ffmpeg` command line much easier. It also allows for secrets such as API keys and stream keys to be placed in an environment file.

## Building

See the [README.md](https://github.com/adilinden-oss/docker-octoprint-streamer/blob/master/README.md) in the main GitHub repo [adilinden-oss/docker-octoprint-streamer](https://github.com/adilinden-oss/docker-octoprint-streamer).

## Usage

To use simply execute `ffmpeg`.

    docker run -it --rm --privileged stream ffmpeg \
        -re -f mjpeg -framerate 5 -i http://<IP of OctoPi>:8080/?action=stream \
        -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -acodec aac -ab 128k \
        -strict experimental -vcodec h264 -pix_fmt yuv420p -g 10 -vb 700k -framerate 5 \
        -f flv rtmp://a.rtmp.youtube.com/live2/<YouTube Stream ID>
   
