# astroPaperDisplay
Updates an EPaper Display with information about the AstroPhotography on an SBC

Did you ever have your Astro Imaging Device in an observing field and wonder if it has connected to a network
and if so, what its hostname or IP address happens to be?  

This set of scripts is based upon a WaveShare EPaper/EInk Module/Hat for a raspberry pi and is meant to get it to display
its name, network IP address, currently connected Network, and hostname.  That way you know that you can connect and how.

The EInk Module(s) it is based upon:  
https://www.waveshare.com/wiki/2.13inch_e-Paper_HAT_(B)
https://www.waveshare.com/wiki/2.13inch_e-Paper_HAT_(C)

User Manual:
https://www.waveshare.com/w/upload/4/4a/2.13inch-e-paper-hat-b-user-manual-en.pdf

To get this set up, you would need to:
1. Buy a Module
2. Connect it as described in the manual, either as a HAT or with wires in a module configuration
3. Turn on your Raspberry pi, open Terminal, and clone this repo in your home directory
	git clone http://www.github.com/rlancaste/astroPaperDisplay
4. Run the installAstroPaper.sh script to install it all.'
	cd ~/astroPaperDisplay
	sudo ./installAstroPaper.sh

