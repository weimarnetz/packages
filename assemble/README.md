# Weimarnetz Package Assembly

This directory contains scripts for building OpenWrt packages and assembling firmware images.

## SDK Download Configuration

The scripts use a fallback mechanism for downloading OpenWrt SDKs. If the primary source (builds.weimarnetz.de) is unavailable, the system will try alternative sources defined in `sdk_sources.conf`.

### How it works

1. The script first attempts to download the SDK from the primary URL.
2. If that fails, it searches for matching entries in `sdk_sources.conf`.
3. The file contains entries in the format: `OPENWRT_VERSION|TARGET|URL`
4. Wildcard patterns (e.g., `23.05.*`) are supported for version and target matching.
5. URLs can contain placeholders like `%OPENWRT%`, `%MAINTARGET%`, `%SUBTARGET%`, and `%EXTENSION%`.

### Customizing SDK Sources

You can add or modify alternative SDK download sources by editing `sdk_sources.conf`. Example entries:

```
# Specific version and target
23.05.5|ath79_generic|https://downloads.openwrt.org/releases/23.05.5/targets/ath79/generic/openwrt-sdk-23.05.5-ath79-generic_gcc-12.3.0_musl.Linux-x86_64.tar.xz

# All 23.05.x versions for a specific target
23.05.*|ramips_mt7621|https://downloads.openwrt.org/releases/23.05.5/targets/ramips/mt7621/openwrt-sdk-23.05.5-ramips-mt7621_gcc-12.3.0_musl.Linux-x86_64.tar.xz
```

### Important Notes

- While wildcards (`*`) can be used in version and target patterns, they cannot be used within URLs.
- Always specify complete URLs with exact filenames - wildcards in URLs will not be expanded by the web server.
- Each URL should point to a specific SDK version with the exact compiler version in the filename.

### Placeholders in URLs

The following placeholders can be used in URLs and will be replaced with actual values:

- `%OPENWRT%`: The OpenWrt version (e.g., `23.05.5`)
- `%MAINTARGET%`: The main target architecture (e.g., `ath79`)
- `%SUBTARGET%`: The subtarget (e.g., `generic`)
- `%EXTENSION%`: The file extension (`xz` or `zst`) 