# build ioquake3
FROM alpine:3.23.0 AS ioquake3-build

WORKDIR /ioq3

COPY ./ioq3 /ioq3

# apk-tools has a bug that breaks on emulated armv7
RUN \
    apk update && \
    apk upgrade --scripts=no apk-tools && \
    apk upgrade && \
    apk --no-cache add cmake gcc g++ make zlib-dev && \
\
    rm -rfv .git || true && \
    cmake -S . -B build -Wno-dev \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/quake \
        -DBUILD_CLIENT=OFF \
        -DBUILD_GAME_LIBRARIES=OFF \
        -DBUILD_GAME_QVMS=OFF \
        -DBUILD_RENDERER_GL1=OFF \
        -DBUILD_RENDERER_GL2=OFF \
        -DBUILD_SERVER=ON \
        -DBUILD_STANDALONE=OFF \
        -DUSE_CODEC_OPUS=OFF \
        -DUSE_CODEC_VORBIS=OFF \
        -DUSE_FREETYPE=OFF \
        -DUSE_HTTP=OFF \
        -DUSE_INTERNAL_JPEG=OFF \
        -DUSE_INTERNAL_LIBS=OFF \
        -DUSE_INTERNAL_OGG=OFF \
        -DUSE_INTERNAL_OPUS=OFF \
        -DUSE_INTERNAL_SDL=OFF \
        -DUSE_INTERNAL_VORBIS=OFF \
        -DUSE_INTERNAL_ZLIB=OFF \
        -DUSE_MUMBLE=OFF \
        -DUSE_OPENAL=OFF \
        -DUSE_OPENAL_DLOPEN=OFF \
        -DUSE_RENDERER_DLOPEN=OFF \
        -DUSE_VOIP=OFF && \
    cmake --build build

# move the bins to the actual image
FROM alpine:3.23.0 AS ioquake3

RUN \
    addgroup -g 1337 quake && \
    adduser -D -h /home/quake -G quake -u 1337 quake && \
    mkdir -pv /home/quake/.q3a/baseq3 && \
    ln -sfv /config/dockerquake.cfg /home/quake/.q3a/baseq3/

COPY --from=ioquake3-build /ioq3/build/Release/ioq3ded /quake/
COPY ./static /static

EXPOSE 27960/udp
CMD ["/static/shell/entrypoint.sh"]
