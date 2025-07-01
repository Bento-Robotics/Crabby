# Crabby system files
*This directory contains the configuration files and setup guide for Crabby's system setup.*  
Versioning these files helps keep track of changes, and turns worst-case scenarios (for instance a dead SD card) from disqualifying events into something that can be solved in a few minutes.

> This thing runs a *pi zero*!
> →Pi OS only, and make sure you use ther one with ***no desktop***

## Install software

> ℹ️ **internet required!**  
> you can test your connection using `ping google.com`

```shell
# Install software (everything after 'git' is optional)
sudo apt update
sudo apt install docker.io docker-compose dnsmasq-base git gh can-utils btop tree iperf3
sudo usermod -aG docker $USER
sudo reboot

# (Set up this Repo and) Build image and start container
#git clone https://github.com/Bento-Robotics/Crabby.git
cd Crabby/container
docker compose up -d  # if it can't find ros:jazzy, retry after doing `docker pull docker.io/library/ros:jazzy`
```


## Install configuration
Files are laid out in the same way that they would be in the system.
> e.g. `etc/NetworkManager/xyz` → `/etc/NetworkManager/xyz`

⚠️ **reboot to make changes take effect**, both for automatic and manual



### WiFi - NetworkManager
> /etc/NetworkManager/system-connections/*
```
sudo chmod 600 /etc/NetworkManager/system-connections/*
sudo chown root /etc/NetworkManager/system-connections/*
sudo chgrp root /etc/NetworkManager/system-connections/*
```

set country in `sudo raspi-config` (Localisation > Wlan Country)

### CAN & GPIO - systemd-networkd
> /boot/firmware/config.txt
```
...[all]
# enable can
dtoverlay=mcp2515-can0,oscillator=16000000,interrupt=25
dtoverlay=spi-bcm2835-overlay

# GPIO config for evotrainer platform
dtoverlay=gpio-shutdown,gpio_pin=17,active_low=1,gpio_pull=up
gpio=22=op,pn,dh
```

> /etc/systemd/network/80-can.network
```
sudo systemctl enable systemd-networkd
```
