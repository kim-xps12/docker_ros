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
RUN apt-get install -y bash-completion
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

RUN apt-get install -y ros-noetic-rosserial-arduino ros-noetic-rosserial
RUN apt-get install -y ros-noetic-joy
RUN apt-get install -y ros-noetic-desktop-full
RUN apt-get install -y ros-noetic-jsk-visualization

# Install pip packages
RUN apt-get install -y python3-pip
RUN pip3 install feetech-servo-sdk
RUN pip3 install readchar

# Set Completion
RUN rm /etc/apt/apt.conf.d/docker-clean


# Create user and add to sudo group
RUN useradd --user-group --create-home --shell /bin/false ${USER}
RUN gpasswd -a ${USER} sudo
RUN echo "${USER}:${PASSWORD}" | chpasswd
RUN sed -i.bak "s#${HOME}:#${HOME}:${SHELL}#" /etc/passwd
RUN gpasswd -a ${USER} dialout
RUN chown -R ${USER}:${USER} ${HOME}


# Set defalut user
USER ${USER}
WORKDIR ${HOME}
RUN cd ${HOME}

# Set name color on terminal to Light Cyan
RUN touch .bashrc
RUN echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> .bashrc
RUN echo "alias ls='ls --color=auto'" >> .bashrc

# Set Completion
RUN ["/bin/bash", "-c", "source /etc/bash_completion"]

# Set 256 color at tmux
RUN touch ${HOME}/.tmux.conf
RUN echo "set-option -g default-command 'bash --init-file ~/.bashrc'">> ${HOME}/.tmux.conf
RUN echo "set-option -g default-terminal screen-256color">> ${HOME}/.tmux.conf
RUN echo "set -g terminal-overrides 'xterm:colors=256'">> ${HOME}/.tmux.conf

# Setup ROS
RUN echo "source /opt/ros/noetic/setup.bash" >> ${HOME}/.bashrc
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ${HOME}/.bashrc
