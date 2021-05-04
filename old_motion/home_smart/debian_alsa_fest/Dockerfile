##
# Usage
#
# docker build -t debian_alsa_fest .
#
# use the -d option to run as a daemon 
# in the background
# docker run -d -p 4000:80 debian_alsa_fest


# Use an official Debian image
FROM debian:jessie

# Install any needed packages
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y alsa-utils
RUN apt-get install -y festival

WORKDIR /root/

ADD . /root

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV LANG en_US.utf8

##TODO: configure audio device