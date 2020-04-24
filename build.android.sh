#!/bin/bash 
SIGNALRCLIENT_BUILD_DIR=build.$AC_PLATFORM
if [[ ! -d ${SIGNALRCLIENT_BUILD_DIR} ]]; then
    mkdir ${SIGNALRCLIENT_BUILD_DIR}
fi
cd ${SIGNALRCLIENT_BUILD_DIR}
rm -rf *

ANDROID_NDK=$HOME/android-sdk/android-ndk-r18b
ROOT=$SIGNALR_ROOT/.build_${AC_PLATFORM}
OPENSSL_ROOT=${ROOT}/openssl-1.0.2l-${AC_PLATFORM}
CPPREST_ROOT=${ROOT}/accessapi-artifacts-android-ms/cpprest

build_signalr() {
    rm -rf lib/${AC_PLATFORM}/$1
    BOOST_ROOT=${ROOT}/boost-1.65-${AC_PLATFORM}/$2
    echo ${BOOST_ROOT}/include
    COMMAND="/snap/bin/cmake .. \
    -DBUILD_TESTING=false -DBUILD_SAMPLES=false
    -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
    -DANDROID_NDK="${ANDROID_NDK}" \
    -DANDROID_TOOLCHAIN=clang \
    -DANDROID_ABI=$2 \
    -DANDROID_PLATFORM=android-$4 \
    -DANDROID_NATIVE_API_LEVEL=$4 \



    -DACPLATFORM:STRING=${AC_PLATFORM} \

    -DCPPREST_INCLUDE_DIR=${CPPREST_ROOT}/include \
    -DCPPREST_STATIC_LIBRARY_DIR=${CPPREST_ROOT}/lib/$2 \
    -DUSE_CPPRESTSDK=true \
    
    -DBOOST_ROOT=${BOOST_ROOT}  \
    -DBOOST_INCLUDEDIR=${BOOST_ROOT}/include  \
    -DBoost_INCLUDE_DIR=${BOOST_ROOT}/include  \
    -DBOOST_LIBRARYDIR=${BOOST_ROOT}/lib  \
    -DBoost_SYSTEM_LIBRARY=${BOOST_ROOT}/lib  \
    -DBoost_SYSTEM_LIBRARY=${BOOST_ROOT}/lib/libboost_system-clang-mt-1_65_1.a  \
    -DBoost_THREAD_LIBRARY=${BOOST_ROOT}/lib/libboost_thread-clang-mt-1_65_1.a  \
    -DBoost_ATOMIC_LIBRARY=${BOOST_ROOT}/lib/libboost_atomic-clang-mt-1_65_1.a  \
    -DBoost_CHRONO_LIBRARY=${BOOST_ROOT}/lib/libboost_chrono-clang-mt-1_65_1.a  \
    -DBoost_DATE_TIME_LIBRARY=${BOOST_ROOT}/lib/libboost_date_time-clang-mt-1_65_1.a  \
    
    -DOPENSSL_ROOT_DIR=${OPENSSL_ROOT}  \
    -DOPENSSL_INCLUDE_DIR=${OPENSSL_ROOT}/include  \
    -DOPENSSL_CRYPTO_LIBRARY=${OPENSSL_ROOT}/lib/$2/libcrypto.a  \
    -DOPENSSL_SSL_LIBRARY=${OPENSSL_ROOT}/lib/$2/libssl.a \
    -DCMAKE_BUILD_TYPE=$3 \
    -B $1"
    # echo $COMMAND
    $COMMAND
    # find Number of CPU from /etc/proc cpu ..
    MAKE_COMMAND="make -j$NCPU -C $1"
    # echo $MAKE_COMMAND
    $MAKE_COMMAND
}

# Build the signalrclient for each target configuration

# build_signalr build.armv7.debug armeabi-v7a Debug 18
build_signalr armeabi-v7a armeabi-v7a Release 18

# build_signalr build.armv8.debug arm64-v8a Debug 23
build_signalr arm64-v8a arm64-v8a Release 23