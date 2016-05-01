FROM ubuntu:16.04
MAINTAINER Dennis Fleurbaaij <mail@dennisfleurbaaij.com>

# Install dependencies
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

# OpenZWave
RUN cd /tmp && \
    git clone --depth 1 https://github.com/OpenZWave/open-zwave.git && \
    cd open-zwave && \
    make -j `grep -c '^processor' /proc/cpuinfo` && \
    make install && \
    make clean && \
    echo "/usr/local/lib64" > /etc/ld.so.conf.d/usr_local_lib64.conf && \
    ldconfig

# Domoticz
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
    make -j `grep -c '^processor' /proc/cpuinfo` && \
    make install && \
    make clean

VOLUME /config
EXPOSE 9000

ENTRYPOINT ["/opt/domoticz/domoticz", "-dbase", "/config/domoticz.db", "-log", "/config/domoticz.log"]
CMD ["-www", "9000"]

