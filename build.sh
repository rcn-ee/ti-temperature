#!/bin/bash

ARCH=$(uname -m)
branch="master"
platform="DRA7xx_PLATFORM"

if [ -f .builddir ] ; then
	if [ -d ./src ] ; then
		rm -rf ./src || true
	fi

	git clone -b ${branch} https://github.com/rcn-ee/dsptop ./src --depth=1
	cd ./src/
	patch -p1 < ../../0001-debian-fno-PIE.patch
	cd ../

	x86_dir="/opt/github/bb.org/ti-4.4/normal"
	x86_compiler="gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-"

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		make_options="CROSS_COMPILE= KERNEL_SRC=/build/buildd/linux-src PLATFORM=${platform}"
	else
		make_options="CROSS_COMPILE=/home/voodoo/dl/gcc/${x86_compiler} KERNEL_SRC=${x86_dir}/KERNEL PLATFORM=${platform}"
	fi

	cd ./src/temperature_module/temperature-mod/

	make ARCH=arm ${make_options} clean
	echo "make ARCH=arm ${make_options}"
	make ARCH=arm ${make_options}
fi
#
