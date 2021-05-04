#!/usr/bin/python

#import logging
import os
#import smtplib
import subprocess
import time
from datetime import datetime
from email.mime.text import MIMEText

class MotionPlayAudio:
    time_current = datetime.now().time()

    def setup_audio(self):
        proc_volume=subprocess.Popen("amixer sset '%s' 90\%" % ('PCM'), shell=True)
        proc_volume.wait()

    def get_audio_string(self):
        audio_text = 'Alarm. Alarm. Arming warheads in. Ten. 9. 8. 7. 6. 5. 4. 3. 2. 1.'
        time_breakfast = self.time_current.replace(hour=5, minute=30)
        time_leave = self.time_current.replace(hour=8, minute=30)
        time_return = self.time_current.replace(hour=16, minute=30)
        if self.time_current > time_breakfast and self.time_current < time_leave:
                audio_text = 'Good morning, Leann!'
        if self.time_current > time_leave and self.time_current < time_leave.replace(hour=10, minute=30):
                audio_text = 'Have a great day at work!'
        if self.time_current > time_return and self.time_current < time_return.replace(hour=18, minute=15):
                audio_text = 'Good evening, Leann.'
        return audio_text

    def play_audio(self):
        audio_file = '/tmp/hello_' + self.time_current.strftime('%Y_%m_%d_%H_%M_%S') + '.wav'
        audio_text=self.get_audio_string()
        if audio_text:
            print("audio file: " + audio_file)
            print("audio text: " + audio_text)
            # proc=subprocess.Popen('echo %s | text2wave -o %s' % (audio_text, audio_file), shell=True, stdout=subprocess.PIPE)
            # proc.wait()
            # proc2=subprocess.Popen('aplay -D sysdefault %s' % (audio_file), shell=True)
            # proc2.wait()
            # #delete the file
            # #subprocess.call('rm -f %s' % audio_file)
            # if os.path.isfile(audio_file):
            #     os.remove(audio_file)

    def send_alert(self):
        url = 'https://services.dabbmedia.com'

if __name__ == "__main__":
    mpa = MotionPlayAudio()
    # mpa.setup_audio()
    mpa.play_audio()

