#!/bin/bash

sudo apt update \
sudo apt -y --force-yes install \
  git build-essential curl tar libass-dev libtheora-dev libvorbis-dev libtool cmake automake autoconf ccache \
echo 'export PATH=/usr/lib/ccache:$PATH' >> .bashrc \
. ~/.bashrc \
git clone https://github.com/myallod/ffmpeg-static
cd ffmpeg-static



#  autoconf \
#  automake \
#  build-essential \
#  cmake \
#  frei0r-plugins-dev \
#  gawk \
#  libass-dev \
#  libfreetype6-dev \
#  libopencore-amrnb-dev \
#  libopencore-amrwb-dev \
#  libsdl1.2-dev \
#  libspeex-dev \
#  libssl-dev \
# libtheora-dev \
#  libtool \
#  libva-dev \
#  libvdpau-dev \
#  libvo-amrwbenc-dev \
#  libvorbis-dev \
#  libwebp-dev \
#  libxcb1-dev \
#  libxcb-shm0-dev \
#  libxcb-xfixes0-dev \
#  libxvidcore-dev \
#  pkg-config \
#  texi2html \
#  zlib1g-dev

# For 12.04
# libx265 requires cmake version >= 2.8.8
# 12.04 only have 2.8.7
ubuntu_version=`lsb_release -rs`
./build.sh "$@"

