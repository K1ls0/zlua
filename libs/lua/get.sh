#!/usr/bin/bash

LUA_VERSION=5.4.6

curl -L -R -O https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz

tar -zxf lua-${LUA_VERSION}.tar.gz
#cd lua-${LUA_VERSION}
#make all test
