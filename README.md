domoticz-docker
=====

This container has the latest Domoticz and OpenZWave built from git tags. It's based on Ubuntu 16.04 and uses Ubuntu's shared libraries in favor of building everything from the built-in library copies where possible. There is also support for Python scripts. Finally the builds are cleaned for space but a simple make command offers an easy way to play with the code.

**Run the container**

```
docker pull defl/domoticz (if you don't want to build yourself)
docker run -it --rm -v /etc/domoticz/:/config --device /dev/ttyACM0 domoticz
```

The container has an entrypoint to the correct path. So you only need to run it by it's name. In this case it was tagged as domoticz (docker tag -f <hash> domoticz).

**OS support**

In the os subdirectory you can find helper scripts for firewall and systemd.

**Access Domoticz web gui**

```
http://<host ip>:9000
```

The port is 9000 by default, this deviates from the standard. You can use the -p argument to put it on a different port. The ssl http server is turned off.

