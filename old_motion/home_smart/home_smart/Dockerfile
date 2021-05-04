##
# Usage
#
# docker build -t motion_play_audio .
#
# use the -d option to run as a daemon 
# in the background
# docker run -d -p 4000:80 motion_play_audio


# Use an official Debian image
FROM debian_alsa_fest:latest

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV LANG en_US.utf8

# Run motion_play_audio.py when the container launches
CMD ["python3", "motion_play_audio.py"]