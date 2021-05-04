import smtplib
import time
from datetime import datetime
from email.mime.text import MIMEText

time_current = datetime.now().time()
msg['Subject'] = 'Motion has been detected at home at  %s' % time_current
msg['From'] = 'pi@dabbmedia.com'
msg['To'] = 'brentself@gmail.com'
s = smtplib.SMTP('localhost')
s.send_message(msg)
s.quit()




import smtplib
from email.mime.multipart import MIMEMultipart
msg = MIMEMultipart()
msg['Subject'] = 'Motion has been detected at home'
msg['From'] = 'pi@dabbmedia.com'
msg['To'] = 'brentself@gmail.com'
s = smtplib.SMTP('localhost')
s.send_message(msg)
s.quit()


Format Video Capture:
	Width/Height  : 320/240
	Pixel Format  : 'YUYV'
	Field         : None
	Bytes per Line: 640
	Size Image    : 153600
	Colorspace    : SRGB
	Flags         : 
Streaming Parameters Video Capture:
	Capabilities     : timeperframe
	Frames per second: 30.000 (30/1)
	Read buffers     : 2

User Controls

                     brightness (int)    : min=0 max=255 step=1 default=0 value=0 flags=slider
                       contrast (int)    : min=0 max=255 step=1 default=32 value=32 flags=slider
                     saturation (int)    : min=0 max=255 step=1 default=64 value=64 flags=slider
                            hue (int)    : min=-90 max=90 step=1 default=0 value=0 flags=slider
        white_balance_automatic (bool)   : default=1 value=1
                       exposure (int)    : min=0 max=255 step=1 default=120 value=137 flags=inactive, volatile
                 gain_automatic (bool)   : default=1 value=1 flags=update
                           gain (int)    : min=0 max=63 step=1 default=20 value=7 flags=inactive, volatile
                horizontal_flip (bool)   : default=0 value=0
                  vertical_flip (bool)   : default=0 value=0
           power_line_frequency (menu)   : min=0 max=1 default=0 value=0
                      sharpness (int)    : min=0 max=63 step=1 default=0 value=0 flags=slider

                      