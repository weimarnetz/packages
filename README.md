[![Weimarnetz Firmware Assembly](https://github.com/weimarnetz/packages/actions/workflows/assemblefirmware.yml/badge.svg)](https://github.com/weimarnetz/packages/actions/workflows/assemblefirmware.yml)

# Weimarnetz Package Feed 

    # feeds.conf
    src-git packages_weimar https://github.com/weimarnetz/packages.git

## Weimarnetz Image Builds

We use github actions to build images for router here. Everything regarding images is in the `assemble directory`.

The builds are based on OpenWrt ImageBuilder and OpenWrt SDK. Both things we build in our firmware repository at https://github.com/weimarnetz/firmware and upload those to our image server. So we can support multiple OpenWrt builds or versions.

Routers we want to build images for are defined in the `profiles` directory. It is possible to add a specific suffix (e.g. 4MB) or add device specific packages. The following format must be used: `<profile_name>:<suffix>;<device packages>`.

Device packages must be space separated, prepend a `-` if you don't want a package to be installed.

In the `packagelist` repository you can configure packages that are globally installed. The suffixes after `_` correspond to the suffixes in the `profiles` directory. It is possible to define packages for every OpenWrt Build we support.

Currently we build packages for OpenWrt 24.10 and OpenWrt 25.12.

## Package Versioning

Every package must define `PKG_VERSION` and `PKG_RELEASE` in its Makefile:

```makefile
PKG_VERSION:=1.2.0
PKG_RELEASE:=1
```

- `PKG_VERSION` is the semantic version of the package. Bump it when the package content changes.
- `PKG_RELEASE` is the packaging release counter. Bump it for packaging-only changes (e.g. dependency adjustments) and reset it to `1` when `PKG_VERSION` is incremented.

A CI check on pull requests verifies that at least one of these values was incremented when package files are modified. The check must pass before the PR can be merged.

## Releases and Feeds

The `weimarnetz-tng` branch is the **stable** branch. All development happens in feature branches and is merged via pull requests.

- **Stable feed**: Packages are built and uploaded automatically when a PR is merged into `weimarnetz-tng`.
- **Testing feed**: Any branch can be built into the testing feed by manually triggering the build workflow via *Actions → Weimarnetz Package Build → Run workflow*.

Devices can subscribe to either feed:

```
# Stable (default)
src/gz weimarnetz_stable https://buildbot.weimarnetz.de/brauhaus/packages/stable/<openwrt_release>/<target>/<subtarget>/weimarnetz

# Testing
src/gz weimarnetz_testing https://buildbot.weimarnetz.de/brauhaus/packages/testing/<openwrt_release>/<target>/<subtarget>/weimarnetz
```
