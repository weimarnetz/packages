#!/bin/sh
#
# 2020 Andreas Bräu

# configure imagebuilder for weimarnetz images 

### inputs
# target architecture
# openwrt base version

set -e

TARGET=
OPENWRT=
OPENWRT_BASE_URL="http://buildbot.weimarnetz.de/builds/openwrt-base"
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

# DEST_DIR needs to be an absolute path, otherwise it got broken
# because the imagebuilder is two levels deeper.
to_absolute_path() {
	input="$1"
	if [ "$(echo "$1" | cut -c 1)" = "/" ] ; then
		# abs path already given
		echo $1
	else
		# we append the $pwd to it
		echo $(pwd)/$1
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

info "Download and extract image builder"
wget -qO "$TEMP_DIR/ib.tar.xz"  "$OPENWRT_BASE_URL/$OPENWRT/$MAINTARGET/$CUSTOMTARGET/ffweimar-openwrt-imagebuilder-$MAINTARGET-${SUBTARGET}.Linux-x86_64.tar.xz" 
mkdir "$TEMP_DIR/ib"
tar -xf "$TEMP_DIR/ib.tar.xz" --strip-components=1 -C "$TEMP_DIR/ib"

echo "src custom file://$(to_absolute_path packages_weimar)" >> $TEMP_DIR/ib/repositories.conf 
cat $TEMP_DIR/ib/repositories.conf

cp -r $TEMP_DIR/ib ./

mkdir -p ./EMBEDDED_FILES/etc
echo "WEIMARNETZ_PACKAGES_DESCRIPTION=$(git describe --always --dirty --tags)" > ./EMBEDDED_FILES/etc/weimarnetz_release
echo "WEIMARNETZ_PACKAGES_BRANCH=$(git branch --show-current)" >> ./EMBEDDED_FILES/etc/weimarnetz_release
echo "WEIMARNETZ_PACKAGES_REV=$(git rev-parse $(git branch --show-current))" >> ./EMBEDDED_FILES/etc/weimarnetz_release
