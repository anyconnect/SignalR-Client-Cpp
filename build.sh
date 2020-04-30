#!/bin/bash

# Usage example 
# bash build.sh <Platforms (iOS|ubuntu|RPi|android)> <signalrclient's build tools absolute path>
# bash build.sh RPi /home/signalrclient

if [ "$#" -ne 2 ]; then
    echo "You must enter exactly 2 command line arguments"
fi



AC_PLATFORM=$1
SIGNALR_ROOT=$2

case $AC_PLATFORM in
    iOS|ubuntu|RPi|android) echo "Platfrom found: $AC_PLATFORM";;
    *)             echo "Invlaid Platform name. Try iOS/ubuntu/RPi/android" ;;
esac

export AC_PLATFORM=$AC_PLATFORM

SIGNALR_ROOT=$(echo $SIGNALR_ROOT | sed 's:/*$::')
export SIGNALR_ROOT=$SIGNALR_ROOT
# signalrclient directory should contian include files and  
# all the libraries (boost, openssl etc) for all platform
# are present With a dir structure as below

# signalrclient/.build_RPi
# ├── boost-1.61-RPi
# │   ├── include
# │   └── stage
# ├── openssl-1.0.2l-RPi
# │   ├── include
# │   └── lib
# signalrclient/.build_ubuntu/
# ├── boost-1.61-ubuntu
# │   ├── include
# │   └── stage
# ├── cpprest
# │   ├── include
# │   ├── lib
# signalrclient/.build_android/
# ├── boost-1.65-android
# │   ├── arm64-v8a
# │   │   ├── include
# │   │   └── lib
# │   ├── armeabi-v7a
# │   │   ├── include
# │   │   └── lib
# ├── openssl-1.0.2l-android
# │   ├── include
# │   │   └── openssl
# │   └── lib
# │       ├── arm64-v8a
# │       ├── armeabi-v7a
# ├── cpprest
# │   ├── include
# │   ├── lib

if [ -z "$NCPU" ]; then
    NCPU=4
    if uname -s | grep -i "linux" > /dev/null ; then
        NCPU=`cat /proc/cpuinfo | grep -c -i processor`
        export NCPU=$(($NCPU-1))
        echo "Number of core: $NCPU"
    fi
fi

source build.$AC_PLATFORM.sh