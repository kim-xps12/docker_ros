FROM arm64v8/ros:noetic-perception-focal

MAINTAINER B-SKY Lab

ARG DEBIAN_FRONTEND=noninteractive
# Set values
ENV USER docker
ENV PASSWORD docker
ENV HOME /home/${USER}
ENV SHELL /bin/bash

# Install basic tools
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y vim-gtk
RUN apt-get install -y git
RUN apt-get install -y tmux
RUN apt-get install -y sudo
RUN apt-get install -y mesa-utils
RUN apt-get install -y x11-apps 

# Install ROS tools
RUN apt-get install -y python3-osrf-pycommon
RUN apt-get install -y python3-catkin-tools
RUN apt-get install -y python3-rosdep
RUN apt-get install -y python3-rosinstall
RUN apt-get install -y python3-rosinstall-generator
RUN apt-get install -y python3-wstool 
RUN apt-get install -y build-essential
RUN apt-get install -y ros-noetic-desktop-full

# Install pip3
RUN apt-get install -y python3-pip

# Create user and add to sudo group
RUN useradd --user-group --create-home --shell /bin/false ${USER}
RUN gpasswd -a ${USER} sudo
RUN echo "${USER}:${PASSWORD}" | chpasswd
RUN sed -i.bak "s#${HOME}:#${HOME}:${SHELL}#" /etc/passwd
RUN gpasswd -a ${USER} dialout

# Set defalut user
USER ${USER}
WORKDIR ${HOME}

# Change name color at terminal
# Green (default) --> Light Cyan
RUN cd ~
RUN sed s/"01;32"/"01;36"/ .bashrc > .bashrc_tmp
RUN mv .bashrc_tmp .bashrc

# Set 256 color at tmux
RUN touch ~/.tmux.conf
RUN echo "set-option -g default-terminal screen-256color">> ~/.tmux.conf 
RUN echo "set -g terminal-overrides 'xterm:colors=256'">> ~/.tmux.conf

# Install pip packages
RUN pip3 install feetech-servo-sdk
RUN pip3 install readchar

# Setup bashrc
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/docker/.bashrc
RUN echo "cd /home/docker/catkin_ws; catkin build" >> /home/docker/.bashrc
RUN echo "source /home/docker/catkin_ws/devel/setup.bash" >> /home/docker/.bashrc
