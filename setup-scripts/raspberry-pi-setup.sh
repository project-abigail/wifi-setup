#!/bin/bash
source_dir=$( cd "$(dirname "$0")"/.. ; pwd )

sudo apt-get install -y hostapd
sudo apt-get install -y dnsmasq
sudo systemctl disable hostapd
sudo systemctl disable dnsmasq

# Add:
# DAEMON_CONF="/etc/hostapd/hostapd.conf"
# to /etc/default/hostapd
perl -e 'while(<>) {if (/#DAEMON_CONF/) {print("DAEMON_CONF=\"\/etc\/hostapd\/hostapd.conf\"\n")} else {print($_)}} ' < /etc/default/hostapd > hostapd.new
sudo mv /etc/default/hostapd /etc/default/hostapd.sav
sudo cp hostapd.new /etc/default/hostapd
rm hostapd.new

sudo cp $source_dir/config/hostapd.conf /etc/hostapd/hostapd.conf

sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.sav
sudo cp $source_dir/config/dnsmasq.conf /etc/dnsmasq.conf

# Run wifi-setup on system start
# Note: the ugly bash expansion below replaces all `/` with `\/` so that sed is
# happy.
sudo sed "s/<SOURCEDIR>/${source_dir////\\/}/g" $source_dir/config/wifi-setup.service.in > /lib/systemd/system/wifi-setup.service
sudo systemctl enable wifi-setup
