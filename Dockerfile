FROM osrf/ros:noetic-desktop-full

MAINTAINER B-SKY Lab

ARG DEBIAN_FRONTEND=noninteractive
# Set values
ENV USER docker
ENV PASSWORD docker
ENV HOME /home/${USER}
ENV SHELL /bin/bash

# Install basic tools
RUN apt update && apt upgrade -y
RUN apt install -y vim-gtk
RUN apt install -y git
RUN apt install -y tmux
RUN apt install -y sudo
RUN apt install -y mesa-utils
RUN apt install -y x11-apps 

# Install ROS tools
RUN apt install -y python3-osrf-pycommon
RUN apt install -y python3-catkin-tools
RUN apt install -y python3-rosdep
RUN apt install -y python3-rosinstall
RUN apt install -y python3-rosinstall-generator
RUN apt install -y python3-wstool 
RUN apt install -y build-essential

# Create user and add to sudo group
RUN useradd --user-group --create-home --shell /bin/false ${USER}
RUN gpasswd -a ${USER} sudo
RUN echo "${USER}:${PASSWORD}" | chpasswd
RUN sed -i.bak "s#${HOME}:#${HOME}:${SHELL}#" /etc/passwd

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
