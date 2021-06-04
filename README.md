# Weimarnetz Package Feed 

    # feeds.conf
    src-git packages_weimar https://github.com/weimarnetz/packages.git

## Weimarnetz Image Builds

We use github actions to build images for router here. Everything regarding images is in the `assemble directory`.

The builds are based on OpenWrt ImageBuilder and OpenWrt SDK. Both things we build in our firmware repository at https://github.com/weimarnetz/firmware and upload those to our image server. So we can support multiple OpenWrt builds or versions.

Routers we want to build images for are defined in the `profiles` directory. It is possible to add a specific suffix (e.g. 4MB) or add device specific packages. The following format must be used: `<profile_name>:<suffix>;<device packages>`.

Device packages must be space separated, prepend a `-` if you don't want a package to be installed.

In the `packagelist` repository you can configure packages that are globally installed. The suffixes after `_` correspond to the suffixes in the `profiles` directory. It is possible to define packages for every OpenWrt Build we support.
