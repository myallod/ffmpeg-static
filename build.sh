#!/bin/sh

set -e
set -u

echo "\nNow run script [ $0 $@ ]\n";

jflag=
jval=2
rebuild=0
download_only=0
uname -mpi | grep -qE 'x86|i386|i686' && is_x86=1 || is_x86=0

while getopts 'j:Bd' OPTION
do
  case $OPTION in
  j)
      jflag=1
      jval="$OPTARG"
      ;;
  B)
      rebuild=1
      ;;
  d)
      download_only=1
      ;;
  ?)
      printf "Usage: %s: [-j concurrency_level] (hint: your cores + 20%%) [-B] [-d]\n" $(basename $0) >&2
      exit 2
      ;;
  esac
done
shift $(($OPTIND - 1))

if [ "$jflag" ]
then
  if [ "$jval" ]
  then
    printf "Option -j specified (%d)\n" $jval
  fi
fi

[ "$rebuild" -eq 1 ] && echo "Reconfiguring existing packages..."
[ $is_x86 -ne 1 ] && echo "Not using yasm or nasm on non-x86 platform..."

cd `dirname $0`
ENV_ROOT=`pwd`
. ./env.source

# check operating system
OS=`uname`
platform="unknown"

case $OS in
  'Darwin')
    platform='darwin'
    ;;
  'Linux')
    platform='linux'
    ;;
esac

#if you want a rebuild
#rm -rf "$BUILD_DIR" "$TARGET_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR"

#download and extract package
download(){
  filename="$1"
  if [ ! -z "$2" ];then
    filename="$2"
  fi
  ../download.pl "$DOWNLOAD_DIR" "$1" "$filename" "$3" "$4"
  #disable uncompress
  REPLACE="$rebuild" CACHE_DIR="$DOWNLOAD_DIR" ../fetchurl "http://cache/$filename"
}

echo "#### FFmpeg static build at date: $(date -I'seconds') ####"

#this is our working directory
cd $BUILD_DIR

[ $is_x86 -eq 1 ] && download \
  "yasm-1.3.0.tar.gz" "" "fc9e586751ff789b34b1f21d572d96af" "https://www.tortall.net/projects/yasm/releases/"

[ $is_x86 -eq 1 ] && download \
  "nasm-2.15.05.tar.gz" "" "4ab99e8e777c249f32d5c10e82c658f1" "https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/"
  #18.09.2020 "nasm-2.15.02.tar.gz" "" "b9bc8da69e86ef30c6ec1c0d5b62b185" "https://www.nasm.us/pub/nasm/releasebuilds/2.15.02/"


download \
  "OpenSSL_1_1_1f.tar.gz" "openssl-1.1.1f.tar.gz" "39502a8c91204173150f9a3ff9774f05" "https://github.com/openssl/openssl/archive/"
  #"OpenSSL_1_1_1-stable.tar.gz" "" "ca5c434578054a5b2768b2b1c56bd359" "https://github.com/openssl/openssl/archive/"
  #"OpenSSL_1_1_1g.tar.gz" "" "dd32f35dd5d543c571bc9ebb90ebe54e" "https://github.com/openssl/openssl/archive/"
  #"OpenSSL_1_1_1-stable.tar.gz" "" "22a80a4558aee0bd64f6fca34c6bcc47" "https://github.com/openssl/openssl/archive/"
  #"OpenSSL_1_1_0-stable.tar.gz" "" "d3cdee428d9c2ebddb7ebaeda2a4cd0c" "https://github.com/openssl/openssl/archive/"

download \
  "v1.2.11.tar.gz" "zlib-1.2.11.tar.gz" "0095d2d2d1f3442ce1318336637b695f" "https://github.com/madler/zlib/archive/"


download \
  "x264-stable.tar.gz" "" "nil" "https://code.videolan.org/videolan/x264/-/archive/stable"

download \
  "3.4.tar.gz" "x265_3.4.tar.gz" "d867c3a7e19852974cf402c6f6aeaaf3" "https://github.com/videolan/x265/archive/"

download \
  "v2.0.1.tar.gz" "fdk-aac.tar.gz" "nil" "https://github.com/mstorsjo/fdk-aac/archive"

#libass dependency
download \
  "harfbuzz-2.6.7.tar.xz" "" "3b884586a09328c5fae76d8c200b0e1c" "https://www.freedesktop.org/software/harfbuzz/release/"
  #"2.7.2.tar.gz" "harfbuzz-2.7.2.tar.gz" "2b6dfaf7b3a601c0e2461fcb7fc58736" "https://github.com/harfbuzz/harfbuzz/archive/"

download \
  "v1.0.9.tar.gz" "fribidi-1.0.9.tar.gz" "c7fe906e2aebc87e674fd450b80c2317" "https://github.com/fribidi/fribidi/archive/"
  #"v1.0.10.tar.gz" "fribidi-1.0.10.tar.gz" "3a6129633ae97a2cec57a6ca53d50599" "https://github.com/fribidi/fribidi/archive/"
  #v1.0.8.tar.gz" "fribidi-1.0.8.tar.gz" "b279aba7683620c411b16b050cb8f979" "https://github.com/fribidi/fribidi/archive/"

download \
  "0.14.0.tar.gz" "libass-0.14.0.tar.gz" "3c84884aa0589486bded10f71829bf39" "https://github.com/libass/libass/archive/"

download \
  "lame-3.100.tar.gz" "" "83e260acbe4389b54fe08e0bdbf7cddb" "https://downloads.sourceforge.net/project/lame/lame/3.100"

download \
  "opus-1.3.1.tar.gz" "" "d7c07db796d21c9cf1861e0c2b0c0617" "https://github.com/xiph/opus/releases/download/v1.3.1"

download \
  "v1.9.0.tar.gz" "vpx-1.9.0.tar.gz" "e5fab59896984392124d0bfaffc36e14" "https://github.com/webmproject/libvpx/archive"

download \
  "soxr-0.1.3-Source.tar.xz" "" "3f16f4dcb35b471682d4321eda6f6c08" "https://sourceforge.net/projects/soxr/files/"

download \
  "v1.1.0.tar.gz" "vid.stab-1.1.0.tar.gz" "633af54b7e2fd5734265ac7488ac263a" "https://github.com/georgmartius/vid.stab/archive/"

download \
  "release-3.0.1.tar.gz" "zimg-release-3.0.1.tar.gz" "b14d551f13819314e9733a400da04121" "https://github.com/sekrit-twc/zimg/archive/"

download \
  "v2.3.1.tar.gz" "openjpeg-2.3.1.tar.gz" "3b9941dc7a52f0376694adb15a72903f" "https://github.com/uclouvain/openjpeg/archive/"

download \
  "v1.1.0.tar.gz" "libwebp-1.1.0.tar.gz" "35831dd0f8d42119691eb36f2b9d23b7" "https://github.com/webmproject/libwebp/archive/"

download \
  "v1.3.7.tar.gz" "vorbis-1.3.7.tar.gz" "689dc495b22c5f08246c00dab35f1dc7" "https://github.com/xiph/vorbis/archive/"

download \
  "v1.3.4.tar.gz" "ogg-1.3.4.tar.gz" "df1a9a95251a289aa5515b869db4b15f" "https://github.com/xiph/ogg/archive/"

download \
  "Speex-1.2.0.tar.gz" "Speex-1.2.0.tar.gz" "4bec86331abef56129f9d1c994823f03" "https://github.com/xiph/speex/archive/"

download \
  "4.3.tar.gz" "ffmpeg4.3.tar.gz" "99623e156d69f6eea71844dd2308357c" "https://github.com/FFmpeg/FFmpeg/archive/release/"
  #"n4.3.1.tar.gz" "ffmpeg4.3.1.tar.gz" "426ca412ca61634a248c787e29507206" "https://github.com/FFmpeg/FFmpeg/archive/"

[ $download_only -eq 1 ] && exit 0

TARGET_DIR_SED=$(echo $TARGET_DIR | awk '{gsub(/\//, "\\/"); print}')

echo "*** Building yasm ***"
cd $BUILD_DIR/yasm*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR
make -j $jval
make install

echo "*** Building nasm ***"
cd $BUILD_DIR/nasm*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR --disable-docs --disable-man --disable-html
make -j $jval
make install

#echo "*** Building OpenSSL ***"
#cd $BUILD_DIR/openssl*
#[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
#PATH="$BIN_DIR:$PATH" ./config --prefix=$TARGET_DIR
#PATH="$BIN_DIR:$PATH" make -j $jval
#make install_sw

echo "*** Building zlib ***"
cd $BUILD_DIR/zlib*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building x264 ***"
cd $BUILD_DIR/x264*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --enable-static --disable-opencl --enable-pic
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building x265 ***"
cd $BUILD_DIR/x265*
cd build/linux
[ $rebuild -eq 1 ] && find . -mindepth 1 ! -name 'make-Makefiles.bash' -and ! -name 'multilib.sh' -exec rm -r {} +
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:BOOL=OFF -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
sed -i 's/-lgcc_s/-lgcc_eh/g' x265.pc
make -j $jval
make install

echo "*** Building fdk-aac ***"
cd $BUILD_DIR/fdk-aac*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
autoreconf -fiv
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --disable-shared --disable-docs --disable-man --disable-html
make -j $jval
make install

echo "*** Building harfbuzz ***"
cd $BUILD_DIR/harfbuzz-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static --disable-docs --disable-man --disable-html
make -j $jval
make install

echo "*** Building fribidi ***"
cd $BUILD_DIR/fribidi-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh --prefix=$TARGET_DIR --disable-shared --enable-static --disable-docs --disable-man --disable-html
./configure --prefix=$TARGET_DIR --disable-shared --enable-static --disable-docs --disable-man --disable-html
make
make install

echo "*** Building libass ***"
cd $BUILD_DIR/libass-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared --disable-docs --disable-man --disable-html
make -j $jval
make install

echo "*** Building mp3lame ***"
cd $BUILD_DIR/lame*
# The lame build script does not recognize aarch64, so need to set it manually
uname -a | grep -q 'aarch64' && lame_build_target="--build=arm-linux" || lame_build_target=''
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --enable-nasm --disable-shared $lame_build_target --disable-docs --disable-man --disable-html
make
make install

echo "*** Building opus ***"
cd $BUILD_DIR/opus*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --disable-shared
make
make install

echo "*** Building libvpx ***"
cd $BUILD_DIR/libvpx*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --disable-examples --disable-unit-tests --enable-pic
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building libsoxr ***"
cd $BUILD_DIR/soxr-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off
make -j $jval
make install

echo "*** Building libvidstab ***"
cd $BUILD_DIR/vid.stab*
[ $rebuild -eq 1 -a -f Makefile ] && make clean || true
if [ "$platform" = "linux" ]; then
  sed -i "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt
elif [ "$platform" = "darwin" ]; then
  sed -i "" "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt
fi
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off -DBUILD_STATIC_LIBS:bool=on
make -j $jval
make install

echo "*** Building openjpeg ***"
cd $BUILD_DIR/openjpeg-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off
make -j $jval
make install

echo "*** Building zimg ***"
cd $BUILD_DIR/zimg-release-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --enable-static  --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libwebp ***"
cd $BUILD_DIR/libwebp*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libvorbis ***"
cd $BUILD_DIR/vorbis*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libogg ***"
cd $BUILD_DIR/ogg*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libspeex ***"
cd $BUILD_DIR/speex*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

# FFMpeg
echo "*** Building FFmpeg ***"
cd $BUILD_DIR/FFmpeg*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true

[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" \
PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig" ./configure \
    --prefix="$TARGET_DIR" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$TARGET_DIR/include" \
    --extra-ldflags="-L$TARGET_DIR/lib" \
    --extra-libs="-lpthread -lm -lz -ldl" \
    --extra-ldexeflags="-static" \
    --bindir="$BIN_DIR" \
    --enable-pic \
    --enable-ffplay \
    --enable-fontconfig \
    --enable-frei0r \
    --enable-gpl \
    --enable-version3 \
    --enable-libass \
    --enable-libfribidi \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --disable-librtmp \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libtheora \
    --enable-libvidstab \
    --enable-libvo-amrwbenc \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libzimg \
    --enable-nonfree \
    --enable-openssl

PATH="$BIN_DIR:$PATH" make -j $jval
make install
make distclean
sudo install -D -o root -g root -p ${BIN_DIR}/* /usr/local/bin/
hash -r
