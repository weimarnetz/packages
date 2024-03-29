#!/bin/bash
#
# 2020 - 2022 Andreas Bräu

# build weimarnetz packages

### inputs
# target architecture
# openwrt base version

set -e

TARGET=
OPENWRT=
OPENWRT_BASE_URL="https://builds.weimarnetz.de/openwrt-base"
DEBUG=""

signal_handler() {
	# only remove directory when not in debug mode
	if [ -z "$DEBUG" ] ; then
		rm -Rf "$TEMP_DIR"
	else
		info "Not removing temp dir $TEMP_DIR"
	fi
}

info() {
	echo "$@"
}

error() {
	echo "$@" >&2
}

download() {
  URL=$1

  HTTP_CODE=$(curl -s -L -o "$TEMP_DIR/sdk.tar.xz" --write-out "%{http_code}" $URL)
  if [[ "${HTTP_CODE}" -lt 200 || "${HTTP_CODE}" -gt 399 ]]; then
    info "no sdk found ${HTTP_CODE}"
    exit 0
  fi
}

usage() {
	echo "
$0 -t <target> -o <openwrt>

-d enable debug
-t <target> name of the target we want to build packages for
-o <openwrt> name of the openwrt base verion, we use its sdk
"
}

while getopts "dt:o:" option; do
	case "$option" in
		d)
			DEBUG=y
			;;
		t)
		  TARGET="$OPTARG"
			;;
		o)
			OPENWRT="$OPTARG"
			;;
		*)
			echo "Invalid argument '-$OPTARG'."
			usage
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

if [ -z "$TEMP_DIR" ] ; then
	TEMP_DIR=$(mktemp -d imgXXXXXX)
fi

if [ -z "$TARGET" ] ; then
	error "No target given"
	exit 1
fi

if [ -z "$OPENWRT" ] ; then
	error "No openwrt base version given"
	exit 1
fi

mkdir -p "$TEMP_DIR"
trap signal_handler 0 1 2 3 15

# get main- and subtarget name from TARGET
MAINTARGET="$(echo $TARGET|cut -d '_' -f 1)"
CUSTOMTARGET="$(echo $TARGET|cut -d '_' -f 2)"
SUBTARGET="$(echo $CUSTOMTARGET|cut -d '-' -f 1)"

info "Download and extract sdk"
download  "$OPENWRT_BASE_URL/$OPENWRT/$MAINTARGET/$CUSTOMTARGET/ffweimar-openwrt-sdk-$MAINTARGET-${SUBTARGET}.Linux-x86_64.tar.xz" 
mkdir "$TEMP_DIR/sdk"
tar -xf "$TEMP_DIR/sdk.tar.xz" --strip-components=1 -C "$TEMP_DIR/sdk"
cp keys/key-build* "$TEMP_DIR/sdk"

cd "$TEMP_DIR/sdk"
cat << EOF >> feeds.conf
src-link base ../../ib/packages
src-link packages_weimar ../../../../
EOF

./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
if [[ ! -f "key-build" ]]; then
  rm key-build*
  ./staging_dir/host/bin/usign -G -s ./key-build -p ./key-build.pub -c "Local build key"
  cp key-build* ../../keys
fi
for package in $(cat feeds/packages_weimar.index|grep Source-Makefile:|cut -d '/' -f 4); do
  make package/$package/compile;
done
make package/index

cp -r bin/packages/*/packages_weimar ../../
