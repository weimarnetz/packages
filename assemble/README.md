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

## Feed Configuration

The script supports configuring additional OpenWrt package feeds via the `feeds.conf` file. This allows you to add external package repositories without modifying the main script.

### How it works

1. The script checks for a `feeds.conf` file in the same directory.
2. If found, it reads feed definitions in the format: `FEED_NAME|FEED_TYPE|FEED_URL`
3. Each feed is added to the OpenWrt SDK's feeds configuration.
4. If the file doesn't exist, a default freifunk_packages feed is used.

### Customizing Feeds

You can add or modify feed sources by editing `feeds.conf`. Example entries:

```
# Use a specific git commit
freifunk_packages|src-git|https://github.com/freifunk/openwrt-packages.git^7e460f78f0461a6c692dd28fa86a6b0646fc938f

# Use the master branch
custom_feed|src-git|https://github.com/example/custom-packages.git

# Link to a local directory
local_packages|src-link|/path/to/local/packages
```

### Available Feed Types

- `src-git`: Clone a git repository
- `src-link`: Link to a local directory
- `src-svn`: Checkout a Subversion repository
- `src-hg`: Clone a Mercurial repository
- `src-bzr`: Checkout a Bazaar repository

### Tips and Best Practices

- **Commit Pinning**: For stable builds, always pin git feeds to specific commits or tags using the `^commit_hash` syntax
- **Version Compatibility**: Ensure that the feed packages are compatible with your OpenWrt version
- **Feed Ordering**: Feeds are processed in the order they appear in the file - this can be important if packages have dependencies across feeds
- **Transitive Dependencies**: Be aware that adding a feed may pull in dependencies from its own feeds.conf
- **Branch Selection**: You can select a specific branch by adding a branch name after the URL, e.g., `https://github.com/repo/name.git;branch`
- **Testing**: When changing feeds, test with a single target first before running a full matrix build

## Package Structure and Upload

The script compiles and uploads packages from multiple feeds. Each feed's packages are organized in a structured way for server upload.

### Package Organization

Packages are organized in the following structure:

```
packages/
├── packages_weimar/        # Weimarnetz packages
│   └── packages/
│       ├── ath79/
│       │   └── generic/     
│       ├── x86/
│       │   └── 64/
│       └── ...
├── freifunk_packages/      # Freifunk packages
│   └── packages/
│       ├── ath79/
│       │   └── generic/
│       └── ...
└── other_feeds/            # Any additional feeds
    └── ...
```

### Upload Paths

Feed packages are uploaded to the following server paths:

- **packages_weimar**: `/brauhaus/packages/ath79/generic/` (and other targets)
- **freifunk_packages**: `/brauhaus/freifunk_packages/packages/ath79/generic/` (and other targets)
- **Other feeds**: `/brauhaus/[feed_name]/packages/[target]/[subtarget]/`

### Build Information

Each target directory also contains a `package_build.json` file with metadata about the build:

```json
{
  "branch": "brauhaus-19.07",
  "version": "v1.2.3-4-g5678abc",
  "target": "ath79_generic",
  "openwrt": "24.10.0",
  "trigger_event": "push",
  "build_timestamp": "2025-04-07 12:34:56 UTC",
  "builder": "github-actions"
}
```

This information helps track the origin of package builds and provides context for firmware generation. 