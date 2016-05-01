FROM ubuntu:16.04
MAINTAINER Dennis Fleurbaaij <mail@dennisfleurbaaij.com>

# install dependencies
RUN apt-get update && \
    apt-get install -y build-essential \
                       cmake \
                       curl \
                       git \
                       libboost-dev \
                       libboost-python-dev \
                       libboost-system-dev \
                       libboost-thread-dev \
                       libcurl4-openssl-dev \
                       liblua5.2-dev \
                       libmosquittopp-dev \
                       libsqlite3-dev \
                       libssl-dev \
                       libudev-dev \
                       libusb-dev \
                       python-dev \
                       wget \
                       zlib1g-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# build OpenZWave static library
RUN cd /tmp && \
    git clone --depth 1 https://github.com/OpenZWave/open-zwave.git && \
    cd open-zwave && \
    make -j7 &&	\
    make install

# build domoticz
RUN cd /tmp && \
    git clone --depth 1 https://github.com/domoticz/domoticz.git && \
    cd domoticz && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DUSE_STATIC_OPENZWAVE=No \
          -DUSE_STATIC_BOOST=No \
          -DUSE_PYTHON=Yes \
          -DUSE_BUILTIN_SQLITE=No \
          -DUSE_BUILTIN_MQTT=No \
          -DUSE_BUILTIN_LUA=No \
          .. && \
    make -j7 && \
    make install

