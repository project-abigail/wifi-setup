sudo apt-get install -y hostapd
sudo apt-get install -y udhcpd
sudo systemctl disable hostapd
sudo systemctl disable udhcpd

# Add:
# DAEMON_CONF="/etc/hostapd/hostapd.conf"
# to /etc/default/hostapd
perl -e 'while(<>) {if (/#DAEMON_CONF/) {print("DAEMON_CONF=\"\/etc\/hostapd\/hostapd.conf\"\n")} else {print($_)}} ' < /etc/default/hostapd > hostapd.new
sudo mv /etc/default/hostapd /etc/default/hostapd.sav
sudo cp hostapd.new /etc/default/hostapd
rm hostapd.new

sudo cp config/hostapd.conf /etc/hostapd/hostapd.conf

# Edit the file /etc/default/udhcpd and comment out the line:
# DHCPD_ENABLED="no"
perl -e 'while(<>) {if (/DHCPD_ENABLED=/) {print("#DHCPD_ENABLED=\"no\"\n")} else {print($_)}} ' < /etc/default/udhcpd > udhcpd.new
sudo mv /etc/default/udhcpd /etc/default/udhcpd.sav
sudo cp udhcpd.new /etc/default/udhcpd
rm udhcpd.new

sudo mv /etc/udhcpd.conf /etc/udhcpd.conf.sav
sudo cp config/udhcpd.conf /etc/udhcpd.conf

# Run wifi-setup on system start
sudo cp config/wifi-setup.service /lib/systemd/system
sudo systemctl enable wifi-setup
