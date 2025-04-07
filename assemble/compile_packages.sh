#!/bin/bash
#
# 2020 - 2025 Andreas Bräu

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
  PRIMARY_URL=$1
  EXTENSION=$2
  
  # Try the primary URL first
  info "Trying primary URL: $PRIMARY_URL"
  HTTP_CODE=$(curl -s -L -o "$TEMP_DIR/sdk.tar.$EXTENSION" --write-out "%{http_code}" "$PRIMARY_URL")
  
  # If successful, end the function
  if [[ "${HTTP_CODE}" -ge 200 && "${HTTP_CODE}" -lt 400 ]]; then
    info "Successfully downloaded SDK from primary URL"
    return 0
  fi
  
  # If not successful, look for alternatives in the configuration file
  info "Primary download failed with code ${HTTP_CODE}, trying alternatives..."
  
  local config_file="$(dirname "$0")/sdk_sources.conf"
  if [ -f "$config_file" ]; then
    while IFS="|" read -r version_pattern target_pattern url || [ -n "$url" ]; do
      # Ignore comments and empty lines
      [[ "$version_pattern" == \#* || -z "$version_pattern" ]] && continue
      
      # Check if version and target match (with wildcard support)
      if [[ "$OPENWRT" == $version_pattern && "$TARGET" == $target_pattern ]]; then
        # Replace placeholders in the URL
        alt_url="${url//%OPENWRT%/$OPENWRT}"
        alt_url="${alt_url//%MAINTARGET%/$MAINTARGET}"
        alt_url="${alt_url//%SUBTARGET%/$SUBTARGET}"
        alt_url="${alt_url//%EXTENSION%/$EXTENSION}"
        
        info "Trying alternative URL: $alt_url"
        HTTP_CODE=$(curl -s -L -o "$TEMP_DIR/sdk.tar.$EXTENSION" --write-out "%{http_code}" "$alt_url")
        
        if [[ "${HTTP_CODE}" -ge 200 && "${HTTP_CODE}" -lt 400 ]]; then
          info "Successfully downloaded SDK from alternative URL"
          return 0
        else
          info "Alternative download failed with code ${HTTP_CODE}"
        fi
      fi
    done < "$config_file"
  fi
  
  # If no matching alternative was found or no download attempts were successful
  error "Failed to download SDK from all sources"
  return 1
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
EXTENSION="zst"
if [[ "$OPENWRT" == 23* ]]; then
  EXTENSION="xz"
fi

info "Download and extract sdk"
if ! download "$OPENWRT_BASE_URL/$OPENWRT/$MAINTARGET/$CUSTOMTARGET/ffweimar-openwrt-sdk-$MAINTARGET-${SUBTARGET}.Linux-x86_64.tar.$EXTENSION" "$EXTENSION"; then
  error "Could not download SDK from any source"
  exit 1
fi

mkdir -p "$TEMP_DIR/sdk"
if [ "$EXTENSION" = "xz" ]; then
  tar -xf "$TEMP_DIR/sdk.tar.xz" --strip-components=1 -C "$TEMP_DIR/sdk"
elif [ "$EXTENSION" = "zst" ]; then
  tar --use-compress-program=unzstd -xf "$TEMP_DIR/sdk.tar.zst" --strip-components=1 -C "$TEMP_DIR/sdk"
fi
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
