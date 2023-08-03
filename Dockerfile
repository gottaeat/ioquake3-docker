# build image
FROM alpine:3.18.2 AS build
WORKDIR /build
ADD ./ioq3 /build

ENV \
    BUILD_STANDALONE=0 \
    BUILD_CLIENT=0 \
    BUILD_SERVER=1 \
    BUILD_GAME_SO=0 \
    BUILD_GAME_QVM=0 \
    BUILD_BASEGAME=1 \
    BUILD_MISSIONPACK=0 \
    BUILD_AUTOUPDATER=0 \
    USE_CURL=1 \
    USE_CURL_DLOPEN=0 \
    USE_INTERNAL_LIBS=0 \
    DEFAULT_BASEDIR=/opt/quake3 \
    COPYDIR=/build/tempinstall/quake3

RUN \
    apk --no-cache add curl g++ gcc make zlib-dev && \
    mkdir tempinstall/quake3/ -pv && \
    make && \
    make copyfiles 

# game image w/o build artifacts
FROM alpine:3.18.2 AS ioquake3

RUN \
 adduser quake -D -h /home/quake && \
 mkdir -pv /home/quake/.q3a/baseq3/ /opt/quake3/baseq3 && \
 chown quake:quake -R /home/quake/.q3a/

COPY --from=build /build/tempinstall/quake3 /opt/quake3
COPY bin/ /opt/quake3/
COPY --chown=quake etc/ /home/quake/.q3a/baseq3/

USER quake
EXPOSE 27960/udp
CMD /opt/quake3/quake-wrapper.sh
