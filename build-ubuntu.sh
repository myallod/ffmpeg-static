#!/bin/bash

sudo apt update && \
sudo apt -y install \
  autoconf automake build-essential ccache clang cmake curl frei0r-plugins-dev gawk gcc git libass-dev libva-dev libvdpau-dev libvo-amrwbenc-dev libvorbis-dev libwebp-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev libxvidcore-dev zlib1g-dev texi2html libfreetype6-dev libsdl1.2-dev libspeex-dev libssl-dev libtheora-dev libtheora-dev libvorbis-dev libopencore-amrnb-dev libopencore-amrwb-dev libtool pkg-config sendxmpp tar gettext gettext-base  && \
echo 'export PATH=/usr/lib/ccache:$PATH' >> ~/.bashrc && \
. ~/.bashrc

if [ -d "ffmpeg-statis" ]; then
	git pull
else
	git clone https://github.com/myallod/ffmpeg-static .
fi
#cd ffmpeg-static


#  libva-dev \
#  libvdpau-dev \ 
#  libvo-amrwbenc-dev \
#  libvorbis-dev \
#  libwebp-dev \
#  libxcb1-dev \
#  libxcb-shm0-dev \
#  libxcb-xfixes0-dev \
#  libxvidcore-dev \
#  texi2html \
#  zlib1g-dev

# For 12.04
# libx265 requires cmake version >= 2.8.8
# 12.04 only have 2.8.7
ubuntu_version=`lsb_release -rs`
./build.sh "$@"

