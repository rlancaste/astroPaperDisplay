#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function display
{
    echo ""
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "~ $*"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    
    # This will display the message in the title bar (Note that the PS1 variable needs to be changed too--see below)
    echo -en "\033]0;astroPaperDisplay-$*\a"
}

display "Welcome to the AstroPaperDisplay Installation Script."

display "This will update, install the scripts and software requirements to support the WaveShare EInk 2.13 inch e paper display for astrophotography. Be sure to read the script first to see what it does and to customize it."

if [ "$(whoami)" != "root" ]; then
	display "Please run this script with sudo due to the fact that it must do a number of sudo tasks.  Exiting now."
	exit 1
fi

read -p "Are you ready to proceed (y/n)? " proceed

if [ "$proceed" != "y" ]
then
	exit
fi

# This changes the UserPrompt for the Setup Script (Necessary to make the messages display in the title bar)
PS1='astroPaperDisplay~$ '

#Installs the requirements for the ePaper Display
display "Installing Software Requirements"
sudo apt -y install python3-pip
pip3 install spidev
pip3 install RPi.GPIO
pip3 install Pillow


# Enables SPI
display "Enabling SPI for Raspberry Configuration"
if [ -f /boot/config.txt ]
then
	sed -i "s/dtparam=spi=off/dtparam=spi=on/g" /boot/config.txt
fi

display "Creating and installing display update script."
# This script will run anytime a network comes up to update the display
##################
sudo cat > /etc/NetworkManager/dispatcher.d/updateDisplay.sh <<- EOF
#!/bin/bash

interface=\$1
status=\$2

if [ "$status" == "up" ]
then
	if [ "\$interface" == "eth0" ]
	then
		/usr/bin/python3 $DIR/displayEthStatus.py
	fi

	if [ "\$interface" == "wlan0" ]
	then
		/usr/bin/python3 $DIR/displayWifiStatus.py
	fi
fi
EOF
##################
sudo chmod a+x /etc/NetworkManager/dispatcher.d/updateDisplay.sh

display "Creating and starting system shutdown monitor service for shutdown script"
# This service monitors shutdown and when it detects it, clears the display.
##################
sudo cat > /etc/systemd/system/ShutdownDisplay.service <<- EOF
[Unit]
Description=Shutdown the EInk Display

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/bin/true
ExecStop=/usr/bin/python3 $DIR/shutdownDisplay.py

[Install]
WantedBy=multi-user.target
EOF
##################

# Start the Shutdown Display Service
sudo systemctl enable ShutdownDisplay.service
sudo systemctl daemon-reload
sudo systemctl start ShutdownDisplay.service



