FROM alpine:3.9 as builder

MAINTAINER Adi Linden <adi@adis.ca>

RUN apk add --no-cache curl ffmpeg

# Songs picked from YouTube Audio Library
# https://www.youtube.com/audiolibrary/music
WORKDIR /music/country
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=154c28a7be031c89  # Glen Canyon
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=a497d2adea951993  # Morning Mandolin
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=8e9a4a3f567dac70  # 5-O-July
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=dbba6c1747281ada  # Moultries Madness
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=8ac9a1cfef7c9e20  # Ghosts of California
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=f5a909be915457d4  # Sleepy Jake
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=6187c94ae427bba6  # Fargo
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=9f269fb6bf30668b  # Sugar Pines
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=fe874744439c3a71  # Valley Drive
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=6d69b8666f748d5d  # Cliffsides
RUN curl -JLO https://www.youtube.com/audiolibrary_download?vid=753d3c2f7d4be370  # Sally Goodin

WORKDIR /
RUN z=0; \
    for i in $(ls -1 /music/*/*.mp3); do \
        if [ $z -gt 0 ]; then \
            printf "|%s" "$i" >> /music/all.txt; \
        else \
            printf "%s" "$i" >> /music/all.txt; \
        fi; \
        z=1; \
    done
RUN LIST=$(head -1 /music/all.txt); ffmpeg -i "concat:$LIST" -acodec copy /music/all.mp3

###

FROM busybox

WORKDIR /music
COPY --from=builder /music/ /music

CMD ["/bin/ash"]
