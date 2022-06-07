FROM ubuntu:18.04
ARG VERSION=master
ARG TARGET=esp32

ARG DEBIAN_FRONTEND=noninteractive

ENV AMPY_PORT=/dev/ttyUSB0
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV IDF_PATH=/${TARGET}/ESP-IDF

RUN apt-get update
RUN apt install -y nano git libncurses-dev gperf python-pip python-serial python-dev grep automake texinfo help2man libtool libtool-bin cmake ruby python3.7
RUN apt-get install -y gcc wget zip make libncurses-dev flex bison libffi-dev python3-venv python3-pip python3-pyparsing python3-setuptools mc libtool-bin esptool usbutils cmake
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 10 && alias pip=pip3
RUN pip3 install pyparsing==2.3.1 pyelftools virtualenv==16.7.10 adafruit-ampy

# Avoid ascii errors when reading files in Python
RUN apt-get install -y locales && locale-gen en_US.UTF-8

WORKDIR /${TARGET}/ESP-IDF
RUN git clone --progress --verbose https://github.com/espressif/esp-idf.git .
RUN git checkout v4.4
RUN git submodule update --init --recursive
RUN ./install.sh
RUN . ./export.sh

WORKDIR /${TARGET}/mruby
RUN git clone --recursive https://github.com/mruby-esp32/mruby-esp32.git .
RUN cd /${TARGET}/mruby/components/mruby_component/mruby && git pull origin master && git checkout 5233865c477925f5d01b3800da8b7e090c6a7862

