FROM ubuntu:16.04
MAINTAINER Dennis Fleurbaaij <mail@dennisfleurbaaij.com>

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential \
                       cmake \
                       curl \
                       git \
                       libboost-dev \
                       libboost-system-dev \
                       libboost-thread-dev \
                       libcurl4-openssl-dev \
                       liblua5.2-dev \
                       libmosquittopp-dev \
                       libsqlite3-dev \
                       libssl-dev \
                       libudev-dev \
                       libusb-dev \
                       zlib1g-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# OpenZWave
# - The installer does not know about Ubuntu's new x86_64 library name 
#   and installs in the wrong dir, hence the ldconfig additions
RUN cd /tmp && \
    git clone --depth 1 https://github.com/OpenZWave/open-zwave.git && \
    cd open-zwave && \
    make -j `grep -c '^processor' /proc/cpuinfo` && \
    make install && \
    make clean && \
    echo "/usr/local/lib64" > /etc/ld.so.conf.d/usr_local_lib64.conf && \
    ldconfig

# Domoticz
# - Needs a full-depth clone because the version generation depends on it
#   (and then applies some magic)
RUN cd /tmp && \
    git clone https://github.com/domoticz/domoticz.git && \
    cd domoticz && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DUSE_STATIC_OPENZWAVE=No \
          -DUSE_STATIC_BOOST=No \
          -DUSE_PYTHON=No \
          -DUSE_BUILTIN_SQLITE=No \
          -DUSE_BUILTIN_MQTT=No \
          -DUSE_BUILTIN_LUA=No \
          .. && \
    make -j `grep -c '^processor' /proc/cpuinfo` && \
    make install && \
    make clean

VOLUME /config
EXPOSE 9000

ENTRYPOINT ["/opt/domoticz/domoticz", "-dbase", "/config/domoticz.db", "-log", "/config/domoticz.log", "-sslwww", "0", "-pidfile", "/config/domoticz.container.pid"]
CMD ["-www", "9000"]

