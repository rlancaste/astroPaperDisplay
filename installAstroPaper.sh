#!/bin/bash

#Installs the requirements for the ePaper Display

sudo apt -y install python3-pip python-PIL
pip3 install spidev
pip3 install RPi.GPIO
pip3 install Pillow


# Enables SPI
if [ -f /boot/config.txt ]
then
	sed -i "s/dtparam=spi=off/dtparam=spi=on/g" /boot/config.txt
fi

# This script will run anytime a network comes up to update the display
##################
sudo cat > /etc/NetworkManager/dispatcher.d/updateDisplay.sh <<- EOF
#!/bin/bash

interface=$1
status=$2

if [ "$status" == "up" ]
then
	if [ "$interface" == "eth0" ]
	then
		/usr/bin/python3 /home/pi/astroPaperDisplay/displayEthStatus.py
	fi

	if [ "$interface" == "wlan0" ]
	then
		/usr/bin/python3 /home/pi/astroPaperDisplay/displayWifiStatus.py
	fi
fi
EOF
##################
sudo chmod a+x /etc/NetworkManager/dispatcher.d/updateDisplay.sh

# This service monitors shutdown and when it detects it, clears the display.
##################
sudo cat > /etc/systemd/system/ShutdownDisplay.service <<- EOF
[Unit]
Description=Shutdown the EInk Display

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/bin/true
ExecStop=/usr/bin/python3 /home/pi/astroPaperDisplay/shutdownDisplay.py

[Install]
WantedBy=multi-user.target
EOF
##################

# Start the Shutdown Display Service
sudo systemctl enable ShutdownDisplay.service
sudo systemctl daemon-reload
sudo systemctl start ShutdownDisplay.service



