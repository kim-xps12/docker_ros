FROM osrf/ros:melodic-desktop-full

MAINTAINER B-SKY Lab

# Set values
ENV USER docker
ENV PASSWORD docker
ENV HOME /home/${USER}
ENV SHELL /bin/bash

# Install basic tools
RUN apt update && apt upgrade -y
RUN apt install -y vim-gtk \
                   git \
                   tmux 

# Install ROS tools
RUN apt install -y python-catkin-tools \
                   python-rosdep \
                   python-rosinstall \
                   python-rosinstall-generator \
                   python-wstool build-essential

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

