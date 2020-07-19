cmake_minimum_required (VERSION 3.5)

if(DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
endif()

project (signalrclient)

include(CTest)

# set(WERROR true CACHE BOOL "Enable warnings as errors.")
set(WALL true CACHE BOOL "Enable all warnings.")

if (ANDROID OR IOS)
  set(EXTRA_FLAGS "-std=c++11 -fPIC -DNO_SIGNALRCLIENT_EXPORTS")
elseif(NOT WIN32)
  set(EXTRA_FLAGS "-std=c++11 -fPIC -DNO_SIGNALRCLIENT_EXPORTS -ldl")
else()
  set(EXTRA_FLAGS "-DSIGNALRCLIENT_EXPORTS")
endif()

if(ANDROID)
set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -llog")
else()
  if(NOT IOS)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -s")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s")
  endif()
  if(NOT SERCOMMSYSTEM)
    set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-gc-section")
  endif()
endif()

if(IOS)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/Binaries)
else()
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib/${ACPLATFORM}/${ANDROID_ABI}")
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib/${ACPLATFORM}/${ANDROID_ABI}")
endif()

if(USE_CPPRESTSDK)
  string(APPEND EXTRA_FLAGS " -DUSE_CPPRESTSDK")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${EXTRA_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_LDFLAGS}")

if(USE_CPPRESTSDK)
  add_library(cpprest_static STATIC IMPORTED)
  set_property(TARGET cpprest_static PROPERTY IMPORTED_LOCATION
      "${CPPREST_STATIC_LIBRARY_DIR}/libcpprest.a"
  )
  set(CPPREST_LIB "cpprest_static")
endif()

include_directories (include ${CPPREST_INCLUDE_DIR})

# TODO: We shouldn't use this, it makes the dll/lib export all symbols
# We need this for testing, but we might just add all the files to the test project manually
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

if(USE_CPPRESTSDK)
  if(NOT WIN32)
    if(IOS)
      include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpprest_find_boost.cmake)
      include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpprest_find_openssl.cmake)
      cpprest_find_boost()
      cpprest_find_openssl()
    else()
      if(APPLE)
        file(GLOB OPENSSL_ROOT_DIR /usr/local/Cellar/openssl/*)
        list(REVERSE OPENSSL_ROOT_DIR)
      endif()

      find_package(OpenSSL 1.0.0 REQUIRED)
      set(Boost_USE_STATIC_LIBS ON)
      find_package(Boost REQUIRED COMPONENTS system thread chrono)
    endif()

  endif()
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)

add_subdirectory(src/signalrclient)

if(BUILD_TESTING)
  enable_testing()
  add_subdirectory(test)
endif()

if(BUILD_SAMPLES)
  add_subdirectory(samples/HubConnectionSample)
endif()

install(DIRECTORY include/ DESTINATION include/)
