#!/usr/bin/python
# -*- coding:utf-8 -*-

import epd2in13b
import time
import os
from PIL import Image,ImageDraw,ImageFont
import traceback

try:
    epd = epd2in13b.EPD()
    epd.init()
    print("Clear...")
    epd.Clear()
    
    print("Drawing")
    
    # Drawing on the Vertical image
    HBlackimage = Image.new('1', (epd2in13b.EPD_HEIGHT, epd2in13b.EPD_WIDTH), 255)  # 298*126
    HYellowimage = Image.new('1', (epd2in13b.EPD_HEIGHT, epd2in13b.EPD_WIDTH), 255)  # 298*126    
    
    drawblack = ImageDraw.Draw(HBlackimage)
    drawyellow = ImageDraw.Draw(HYellowimage)
    font1 = ImageFont.truetype('/usr/share/fonts/truetype/freefont/FreeSansBold.ttf', 18)
    font2 = ImageFont.truetype('/usr/share/fonts/truetype/freefont/FreeSerif.ttf', 18)
    font3 = ImageFont.truetype('/usr/share/fonts/truetype/freefont/FreeMonoBoldOblique.ttf', 25)

    # Left line
    drawyellow.rectangle((0, 0, 2, epd2in13b.EPD_WIDTH), fill = 0)
    # Top Line
    drawyellow.rectangle((0, 0, epd2in13b.EPD_HEIGHT, 2), fill = 0)
    
    host = os.popen('hostname').read()
    drawblack.text((2, 2), 'SBC:', font = font1, fill = 0)
    drawblack.text((80, 2), host, font = font2, fill = 0)
    
    drawyellow.rectangle((0, 20, epd2in13b.EPD_HEIGHT, 22), fill = 0)
    
    wifi = os.popen("nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2").read()
    drawblack.text((2, 22), 'Wifi:', font = font1, fill = 0)
    drawblack.text((80, 22), wifi, font = font2, fill = 0)
    
    drawyellow.rectangle((0, 40, epd2in13b.EPD_HEIGHT, 42), fill = 0)
    
    ipAddress = os.popen("hostname -I").read()
    drawblack.text((2, 42), 'IP:', font = font1, fill = 0)
    drawblack.text((80, 42), ipAddress, font = font2, fill = 0)
    
    drawyellow.rectangle((0, 60, epd2in13b.EPD_HEIGHT, epd2in13b.EPD_WIDTH), fill = 0)
    drawyellow.text((30, 68), 'Lancaster', font = font3, fill = 1)

    epd.display(epd.getbuffer(HBlackimage), epd.getbuffer(HYellowimage))
    time.sleep(2)
    
    
    epd.sleep()
        
except:
    print('traceback.format_exc():\n%s',traceback.format_exc())
    exit()
