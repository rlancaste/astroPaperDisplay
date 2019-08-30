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
    
    epd.sleep()
        
except:
    print('traceback.format_exc():\n%s',traceback.format_exc())
    exit()
