domoticz-docker
=====

This container has the latest Domoticz and OpenZWave built from git tags. It's based on Ubuntu 16.04 and uses Ubuntu's shared libraries in favor of building everything from the built-in library copies where possible. There is also support for Python scripts. Finally the builds are cleaned for space but a simple make command offers an easy way to play with the code.

**Run the pre-built container**

```
docker pull defl/domoticz
docker run -it --rm -v /etc/domoticz/:/config --device /dev/ttyACM0 defl/domoticz
```

The container has an entrypoint to the correct path. So you only need to run it by it's name. It is expected that you mount the database/log location to /config. The whole thing is approx 750mb.

**Build and run the container from source**

```
git clone https://github.com/defl/domoticz-docker
docker build -t domoticz .
docker run -it --rm -v /etc/domoticz/:/config --device /dev/ttyACM0 domoticz
```

**OS support**

In the os subdirectory you can find helper scripts for firewall and systemd. Just copy to the relevant directories, reload the services (or reboot) and enable them.

**Access Domoticz web gui**

```
http://<host ip>:9000
```

The port is 9000 by default, this deviates from the standard. You can use the -p argument to put it on a different port. The ssl http server is turned off.

