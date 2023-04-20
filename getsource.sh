#!/bin/sh
for i in \
	5.4:164c7849653b80ae67bec4b7473b884bf5cc8d2dca05653475ec2ed27b9ebf61 \
	5.3:fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60 \
	5.2:b9e2e4aad6789b3b63a056d442f7b39f0ecfca3ae0f1fc0ae4e9614401b69f4b \
	5.1:2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333
do
	tarball=lua-$(./patchlevel ${i%:*}).tar.gz
	if [ ! -f "$tarball" ]; then
		curl -LSso "$tarball" "https://www.lua.org/ftp/$tarball" || exit
	fi
	echo "${i#*:} *$tarball" | sha256sum -c || exit
	tar -xzf "$tarball"
done
