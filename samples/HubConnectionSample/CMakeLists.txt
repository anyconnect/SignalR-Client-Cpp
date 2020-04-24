set (SOURCES
  HubConnectionSample.cpp
)

include_directories(
    ../../include/signalrclient
  ../../third_party_code/cpprestsdk
  ../../third_party_code/jsoncpp
  ${CPPREST_INCLUDE_DIR}
)
  
link_directories(
    ${CPPREST_LIBRARY_DIR}
)    

add_executable (HubConnectionSample ${SOURCES})

target_link_libraries(HubConnectionSample
                    ${CPPREST_LIB} 
                    OpenSSL::SSL
                    OpenSSL::Crypto
                    Boost::boost
                    Boost::system
                    Boost::chrono
                    Boost::thread
)
message(${EXTRA_FLAGS})

# add_library(signalrclient_static STATIC IMPORTED)
# set_property(TARGET signalrclient_static PROPERTY IMPORTED_LOCATION
#     "/home/anyconnect/projects/signalr/build.debug/bin/libsignalrclient.a"
# )
# target_link_libraries(HubConnectionSample signalrclient_static)

target_link_libraries(HubConnectionSample signalrclient)
