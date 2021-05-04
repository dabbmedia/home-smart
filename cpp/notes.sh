----------------------------------------
#!/bin/bash
# ffmpeg -f video4linux2 -r 12 -i /dev/video0 -preset ultrafast -codec copy -f mpegts udp://10.0.0.104:1234
# cvlc v4l2:///dev/video0 --v4l2-chroma h264 --sout '#rtp{sdp=rtsp://:8554/}'
# raspivid -t 0 -o - | nc -k -l 1234
# ffmpeg -f video4linux2 -r 12 -i /dev/video0 -preset ultrafast -codec copy - | nc -l -p 1234
# cat /dev/video0 | nc -l -p 1234
# cvlc --no-audio v4l2:///dev/video0 --v4l2-width 640 --v4l2-height 480 --v4l2-chroma MJPG --v4l2-hflip 1 --v4l2-vflip 1 --sout '#standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=:8554/}' -I dummy
raspivid -t 999999 -w 640 -h 480 -fps 25 -hf -b 2000000 -o - | \
gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay config-interval=1 pt=96 \
! gdppay ! tcpserversink host=10.0.0.102 port=5000

gst-launch-1.0 -v v4l2src device=/dev/video0  \
! "image/jpeg,width=640, height=280,framerate=15/1" \
! rtpjpegpay \
! udpsink host=10.0.0.102 port=5000
----------------------------------------

# Stream USB camera over network RTP stream
ffmpeg -re -thread_queue_size 4 -i /dev/video0 -codec copy -f rtp rtp://10.0.0.104:8080
# https://sonnati.wordpress.com/2012/07/02/ffmpeg-the-swiss-army-knife-of-internet-streaming-part-v/
# Record a stream endlessly rotating target file
sudo ffmpeg -f video4linux2 -r 12 -i /dev/video0 -codec copy -f segment -segment_list out.list -segment_time 3600 -segment_wrap 24 -r 12 -vcodec libx264 -pix_fmt yuv420p /var/www/home_smart/home_smart/tmp/motion_maybe_%03d.mp4

# stream
ffmpeg -f video4linux2 -r 12 -i /dev/video0 -preset ultrafast -vcodec libx264 -tune zerolatency -b 900k -f mpegts udp://10.0.0.104:1234


sudo apt-get install -y vlc vlc-plugin-video-output

# vlc stream mjpeg
cvlc -vvv --no-audio v4l2:///dev/video0 --v4l2-width 640 --v4l2-height 480 --v4l2-chroma MJPG --v4l2-hflip 1 --v4l2-vflip 1 --sout '#standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=:8554/}' -I dummy

cvlc -vvv --no-audio v4l2:///dev/video0 --v4l2-width 640 --v4l2-height 480 --v4l2-chroma YV12 --v4l2-hflip 1 --v4l2-vflip 1 --sout '#transcode{vcodec=mp4v,vb=800}:
standard{access=http,mux=ogg,dst=:8080}'

cvlc -vvv --no-audio v4l2:///dev/video0 --v4l2-width 640 --v4l2-height 480 --v4l2-chroma YUY2 --v4l2-hflip 1 --v4l2-vflip 1 --sout '#transcode{vcodec=MJPG,acodec=none}:standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=:8554/}' -I dummy

cvlc -vvv --no-audio v4l2:///dev/video0 --v4l2-width 640 --v4l2-height 480 --v4l2-chroma MJPG --v4l2-hflip 1 --v4l2-vflip 1 --sout '#standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=:80/video-feed}' -I dummy

# stream mjpeg and record video file
cvlc -vvv --no-audio v4l2:///dev/video0 --v4l2-width 640 --v4l2-height 480 --v4l2-chroma MJPG --v4l2-hflip 1 --v4l2-vflip 1 --sout '#duplicate{dst=std{access=file,mux=mp4,dst='/var/www/home_smart/home_smart/tmp/video_0.mp4'},dst=standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=:8554/}}' -I dummy

# stream ogg format (plays in vlc)
vlc -vvv --no-audio v4l2:///dev/video0 --v4l2-width 1280 --v4l2-height 720 --v4l2-chroma MJPG --v4l2-hflip 1 --v4l2-vflip 1 --sout '#standard{access=http,mux=ogg,dst=:8080}'

# stream mp4
vlc -vvv --no-audio v4l2:///dev/video0 --v4l2-width 1280 --v4l2-height 720 --v4l2-chroma MJPG --v4l2-hflip 1 --v4l2-vflip 1 --sout '#transcode{vcodec=mp4v,acodec=mpga,vb=800,ab=128}:standard{access=http,mux=ogg,dst=:8080}'

cvlc -vvv --no-audio v4l2:///dev/video0 --v4l2-width 640 --v4l2-height 480 --v4l2-chroma MJPG --v4l2-hflip 1 --v4l2-vflip 1 --sout '#transcode{vcodec=YUYV}:standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=:8554/}' -I dummy

cvlc -vvv v4l2:///dev/video0:chroma=mp2v --v4l2-width 320 --v4l2-height 240 --sout '#transcode{vcodec=mp2v,acodec=mpga,fps=30}:rtp{mux=ts,sdp=rtsp://:8888/live.sdp}'

vlc -vvv --no-audio v4l2:///dev/video0 --v4l2-width 640 --v4l2-height 480 --v4l2-chroma MJPG --v4l2-hflip 1 --v4l2-vflip 1 --sout '#rtp{dst=10.0.0.104,port=1234,sdp=rtsp://:8080/test.sdp}'

vlc -vvv v4l2:///dev/video0 --sout '#standard{access=http,mux=ogg,dst=:8080}'

vlc v4l2:///dev/video0 --sout ‘#std{access=http,mux=mpjpeg,dst=:8554}’

v4l2-ctl --stream-mmap --stream-to-host 10.0.0.102:8554

# flip (unflip) PS2 Eye camera
v4l2-ctl --set-ctrl vertical_flip=0

# List linux camera supported formats
sudo v4l2-ctl --list-formats-ext
sudo v4l2-ctl --all
sudo ffmpeg -f video4linux2 -list_formats all -i /dev/video0

v4l2-ctl --set-ctrl=rotate=270

# Logitech HD cam
[video4linux2,v4l2 @ 0xbc51c0] Raw       :     yuyv422 :           YUYV 4:2:2 : 640x480 160x120 176x144 320x176 320x240 352x288 432x240 544x288 640x360 752x416 800x448 800x600 864x480 960x544 960x720 1024x576 1184x656 1280x720 1280x960
[video4linux2,v4l2 @ 0xbc51c0] Compressed:       mjpeg :          Motion-JPEG : 640x480 160x120 176x144 320x176 320x240 352x288 432x240 544x288 640x360 752x416 800x448 800x600 864x480 960x544 960x720 1024x576 1184x656 1280x720 1280x960



# macos gstreamer sources and sinks
osxvideosink
osxaudiodeviceprovider
osxaudiosrc
osxaudiosink
avfvideosrc
avfassetsrc
avfdeviceprovider

# linux audio src
autoaudiosrc

Pi2 of 432Mi
Pi3 home_smart_camera uses 33% of 926Mi

# install gstreamer
sudo apt-get install -y gstreamer1.0-tools \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
  gstreamer1.0-opencv gstreamer1.0-pocketsphinx \
  libgstreamer1.0-0 libgstreamer1.0-0-dbg libgstreamer1.0-dev \
  gstreamer1.0-plugins-rtp \
  gstreamer1.0-rtsp gstreamer1.0-rtsp-dbg \
  gstreamer1.0-omx gstreamer1.0-omx-generic gstreamer1.0-omx-generic-confi \
  gstreamer1.0-omx-rpi gstreamer1.0-omx-rpi-config gstreamer1.0-omx-rpi-dbgsym \
  gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-x \
  gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-pulseaudio

# https://gist.github.com/esrever10/7d39fe2d4163c5b2d7006495c3c911bb
gst-launch-1.0 -v v4l2src ! "video/x-raw,width=640,height=480,framerate=30/1" ! videoscale ! videoconvert ! omxh264enc ! rtph264pay ! udpsink host=10.0.0.60 port=5000

#webrtc
gst-launch-1.0 -v v4l2src ! queue ! vp8enc ! rtpvp8pay ! application/x-rtp,media=video,encoding-name=VP8,payload=96 ! webrtcbin name=sendrecv

gst-launch-1.0 -v v4l2src ! video/x-raw,width=640,height=480,framerate=30/1 ! queue ! omxh264enc ! rtph264pay ! application/x-rtp,media=video,encoding-name=H264,payload=96 ! webrtcbin name=sendrecv

# Pi cams
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-h264,stream-format=byte-stream ! udpsink host=10.0.0.60 port=5000

raspivid -t 999999 -h 720 -w 1080 -fps 25 -hf -b 2000000 -o - | gst-launch-1.0 -v fdsrc ! h264parse !  rtph264pay config-interval=1 pt=96 ! gdppay ! tcpserversink host=10.0.0.100 port=5000

raspivid -t 999999 -h 720 -w 1080 -fps 25 -hf -b 2000000 -o - | gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay ! udpsink host=10.0.0.60 port=5000

raspivid -o - -t 0 -n -w 600 -h 400 -fps 12 | cvlc -vvv stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/}' :demux=h264
rtsp://10.0.0.28:8554

# pi zero with pi cam
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=1024,height=768,framerate=30/1 ! videoconvert ! omxh264enc ! rtph264pay ! udpsink host=10.0.0.60 port=5000


# mjpeg only (image/jpeg)
gst-launch-1.0 -v v4l2src ! image/jpeg,framerate=15/1,width=640,height=480 ! rtpjpegpay ! udpsink host=10.0.0.60 port=5000

gst-launch-1.0 -v udpsrc port=5000 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! decodebin ! videoconvert ! osxvideosink


# send
# linux
gst-launch-1.0 rtpbin name=rtpbin \
         v4l2src ! videoconvert ! x264enc ! rtph264pay ! rtpbin.send_rtp_sink_0 \
                   rtpbin.send_rtp_src_0 ! udpsink port=5000                            \
                   rtpbin.send_rtcp_src_0 ! udpsink port=5001 sync=false async=false    \
                   udpsrc port=5005 ! rtpbin.recv_rtcp_sink_0                           \
         audiotestsrc ! amrnbenc ! rtpamrpay ! rtpbin.send_rtp_sink_1                   \
                   rtpbin.send_rtp_src_1 ! udpsink port=5002                            \
                   rtpbin.send_rtcp_src_1 ! udpsink port=5003 sync=false async=false    \
                   udpsrc port=5007 ! rtpbin.recv_rtcp_sink_1

# with rpi graphics encoder
gst-launch-1.0 -v rtpbin name=rtpbin \
         v4l2src ! videoconvert ! omxh264enc ! rtph264pay ! rtpbin.send_rtp_sink_0 \
                   rtpbin.send_rtp_src_0 ! udpsink port=5000                            \
                   rtpbin.send_rtcp_src_0 ! udpsink port=5001 sync=false async=false    \
                   udpsrc port=5005 ! rtpbin.recv_rtcp_sink_0

gst-launch-1.0 rtpbin name=rtpbin \
         v4l2src ! video/x-raw,framerate=30/1 ! videoscale ! videoconvert ! omxh264enc ! rtph264pay ! rtpbin.send_rtp_sink_0 \
                   rtpbin.send_rtp_src_0 ! udpsink port=5000                            \
                   rtpbin.send_rtcp_src_0 ! udpsink port=5001 sync=false async=false    \
                   udpsrc port=5005 ! rtpbin.recv_rtcp_sink_0                           \
         audiotestsrc ! amrnbenc ! rtpamrpay ! rtpbin.send_rtp_sink_1                   \
                   rtpbin.send_rtp_src_1 ! udpsink port=5002                            \
                   rtpbin.send_rtcp_src_1 ! udpsink port=5003 sync=false async=false    \
                   udpsrc port=5007 ! rtpbin.recv_rtcp_sink_1


## install nginx and rtmp module (for the HLS stream)
sudo apt-get install -y nginx-light libnginx-mod-rtmp

## HLS stream
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=640,height=480,framerate=30/1 ! videoconvert ! omxh264enc ! h264parse config-interval=-1 ! mpegtsmux ! hlssink

gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=640,height=480,framerate=30/1 ! videoconvert ! omxh264enc ! h264parse config-interval=-1 ! mpegtsmux ! hlssink location=/tmp/hls/segment%05d.ts,playlist-location=/tmp/hls/playlist.m3u8,target-duration=5

# macos
gst-launch-1.0 rtpbin name=rtpbin \
         avfvideosrc ! "video/x-raw,width=320,height=240,framerate=30/1" ! videoconvert ! x264enc ! rtph264pay ! rtpbin.send_rtp_sink_0 \
                   rtpbin.send_rtp_src_0 ! udpsink port=5000                            \
                   rtpbin.send_rtcp_src_0 ! udpsink port=5001 sync=false async=false    \
                   udpsrc port=5005 ! rtpbin.recv_rtcp_sink_0                           \
         audiotestsrc ! amrnbenc ! rtpamrpay ! rtpbin.send_rtp_sink_1                   \
                   rtpbin.send_rtp_src_1 ! udpsink port=5002                            \
                   rtpbin.send_rtcp_src_1 ! udpsink port=5003 sync=false async=false    \
                   udpsrc port=5007 ! rtpbin.recv_rtcp_sink_1

# receive
./gst-launch-1.0 -v rtpbin name=rtpbin                                          \
     udpsrc caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264" \
             uri=udp://10.0.0.104:5000 ! port=5000 ! rtpbin.recv_rtp_sink_0                                \
         rtpbin. ! rtph264depay ! openh264dec ! videoconvert ! osxvideosink

gst-launch.exe -v gstrtpbin name 
=rtpbin udpsrc caps="application/x-rtp, media=\(string\)video, clock-rate=\(int\ 
)90000, encoding-name=\(string\)JPEG, ssrc=\(guint\)469657143, payload=\(int\)96 
, clock-base=\(guint\)2841649723, seqnum-base=\(guint\)39869" port=9996 ! rtpbin 
.recv_rtp_sink_1  rtpbin. ! rtpjpegdepay ! multifilesink location="test%05d.jpg" 


# record usb cam into files of max length
gst-launch-1.0 -e v4l2src num-buffers=500 ! video/x-raw,width=320,height=240,format=YV12 ! videoconvert ! queue ! timeoverlay ! x264enc key-int-max=10 ! h264parse ! splitmuxsink location=/var/www/home_smart/home_smart/tmp/video_0_%02d.mp4 max-size-time=10000000000 max-size-bytes=1000000

gst-launch-1.0 gst-launch-1.0 v4l2src num-buffers=50 ! video/x-raw,width=320,height=240 ! videoconvert ! queue ! x264enc ! qtmux ! filesink location=/var/www/home_smart/home_smart/tmp/video_0_%02d.mp4

# save frames
sudo gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=640,height=480,framerate=25/1 ! videoconvert ! multifilesink max-files=108000 post-messages=true location="/tmp/jpg/frame-%08d.jpg"


# linux
# gcc basic-tutorial-1.c -o basic-tutorial-1 `pkg-config --cflags --libs gstreamer-1.0`
# macOS
# gcc basic-tutorial-1.c -o basic-tutorial-1 -I/Library/Frameworks/GStreamer.framework/Headers

GMainLoop *main_loop;
# after state set to playing
main_loop = g_main_loop_new (NULL, FALSE);
g_main_loop_run (main_loop);

# gstreamer test commands
# play linux webcam locally
./GStreamer.framework/Versions/1.0/bin/gst-launch-1.0 v4l2src device="/dev/video0" ! video/x-raw,width=640,height=480 ! autovideosink
# play macOS webcam locally
./GStreamer.framework/Versions/1.0/bin/gst-launch-1.0 avfvideosrc device-index=0 ! "video/x-raw",width=320,height=240 ! osxvideosink
./GStreamer.framework/Versions/1.0/bin/gst-launch-1.0 avfvideosrc device-index=0 ! video/x-raw,width=352,height=288,aspect-ratio=1/1 ! videoscale add-borders=1 ! video/x-raw,width=640,height=360,pixel-aspect-ratio=1/1  ! osxvideosink

# server
./GStreamer.framework/Versions/1.0/bin/gst-launch-1.0 -v \
    avfvideosrc device-index=0 ! \
    queue max-size-buffers=1 ! \
    videoconvert ! \
    videoscale ! \
    video/mpeg,width=640,height=480,framerate=20/1 ! \
    avenc_mpeg4 ! \
    rtpmp4vpay ! \
    udpsink host=127.0.0.1 port=5000

# client
./GStreamer.framework/Versions/1.0/bin/gst-launch-1.0 -v \
    udpsrc port=5000 caps='application/x-rtp' ! \
    rtpmp4vdepay ! \
    video/mpeg,width=640,height=480,framerate=20/1 ! \
    avdec_mpeg4 ! \
    videoconvert ! \
    osxvideosink

./GStreamer.framework/Versions/1.0/bin/gst-launch-1.0 avfvideosrc device-index=0 ! video/x-h264,width=640,height=360,framerate=15/1,profile=high ! h264parse ! flvmux ! rtmpsink location='rtmp://localhost/rtmp/live live=1'

./GStreamer.framework/Versions/1.0/bin/gst-launch-1.0 videotestsrc ! "video/x-raw,format=I420,width=352,height=288,framerate=30/1" ! videoparse width=352 height=288 framerate=30/1 ! x264enc bitrate=1024 ref=4 key-int-max=20 ! video/x-h264,stream-format=byte-stream,profile=main ! filesink location=v1

./GStreamer.framework/Versions/1.0/bin/gst-launch-1.0 avfvideosrc device-index=0 ! "video/x-raw,format=I420,width=352,height=288,framerate=30/1" ! videoparse width=352 height=288 framerate=30/1 ! x264enc bitrate=1024 ref=4 key-int-max=20 ! video/x-h264,stream-format=byte-stream,profile=main ! rtmpsink location='rtmp://localhost/rtmp/live live=1'




# build docker container 
# debian
# install gcc and g++?
# install gstreamer and gstreamer-dev
sudo apt-get update

sudo apt-get install -y gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    gstreamer1.0-opencv gstreamer1.0-pocketsphinx \
    libgstreamer1.0-0 libgstreamer1.0-0-dbg libgstreamer1.0-dev \
    gstreamer1.0-plugins-rtp \
    gstreamer1.0-rtsp gstreamer1.0-rtsp-dbg \
    gstreamer1.0-omx-rpi gstreamer1.0-omx-rpi-config gstreamer1.0-omx-rpi-dbgsym \
    gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-x \
    gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-pulseaudio \
    nginx-light libnginx-mod-rtmp \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# https://stackoverflow.com/questions/28612284/undefined-reference-to-gstreamer-functions-c-ubuntu
g++ \
    -I/usr/include/gstreamer-1.0 \
    -I/usr/include/glib-2.0 \
    -I/usr/include/libxml2 \
    -I/usr/lib/x86_64-linux-gnu/glib-2.0/include \
    -O0 -g3 -Wall -c -fmessage-length=0  \
    `pkg-config  --cflags --libs gstreamer-1.0` \
    -MMD -MP -MF"main.d" -MT"main.d" -o "main.o" "main.cpp"




    g++ \
    -I/usr/include/gstreamer-1.0 \
    -I/usr/include/glib-2.0 \
    -I/usr/include/libxml2 \
    -O0 -g3 -Wall -c -fmessage-length=0  \
    `pkg-config  --cflags --libs gstreamer-1.0` \
    -MMD -MP -MF"main.d" -MT"main.d" -o "main.o" "main.cpp"

# Makefile:
g++ -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/include/libxml2 -O0 -g3 -Wall -c -fmessage-length=0 `pkg-config --cflags --libs gstreamer-1.0 gobject-2.0 glib-2.0` -o main main.o camera.o
# Above
g++ -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/include/libxml2 -O0 -g3 -Wall -c -fmessage-length=0 `pkg-config --cflags --libs gstreamer-1.0` -MMD -MP -MF"main.d" -MT"main.d" -o "main.o" "main.cpp"




sudo gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=640,height=480,framerate=30/1! videoconvert ! clockoverlay halignment=right valignment=bottom xpad=40 ypad=40 time-format="%m/%d/%Y %I:%M:%S %p" font-desc="Helvetica Normal Regular 15 @wght=200" ! omxh264enc ! h264parse config-interval=-1 ! mpegtsmux ! hlssink target-duration=1

# build steps
# on build machine
rm -Rf ~/home_smart_device/*.o; rm -Rf ~/home_smart_device/home_smart_camera
# on dev machine
rsync -av -e ssh ./ pi@10.0.0.104:/home/pi/home_smart_device/
# on build machine
cd ~/home_smart_device/
make
./home_smart_camera &
# on dev machine
rsync -av -e ssh pi@10.0.0.104:/home/pi/home_smart_device/home_smart_camera ./
rsync -av -e ssh ./home_smart_camera pi@10.0.0.105:/home/pi/home_smart_device/


# logging and debugging
vim ~/.bashrc
export GST_DEBUG=3
export GST_DEBUG_DUMP_DOT_DIR=/home/pi/home_smart_device/logs
export GST_DEBUG_FILE=/home/pi/home_smart_device/logs/gst.log
export GST_DEBUG_NO_COLOR=1
source ~/.bashrc

# generate image from pipeline dot file
sudo apt-get install graphviz
dot -Tpng -o/home/pi/home_smart_device/logs/pipeline.png /home/pi/home_smart_device/logs/pipeline.dot
rsync -av -e ssh pi@10.0.0.104:/home/pi/home_smart_device/logs/pipeline.png ./logs/



uwsgi --ini /var/www/home_smart/home_smart/home_smart.ini &

rsync -av -e ssh ~/home_smart_device/home_smart_camera pi@10.0.0.105:/home/pi/home_smart_device/

