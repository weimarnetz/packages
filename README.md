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

Currently we build images for OpenWrt 21.02 and OpenWrt 22.03.

## Cross-Repository Builds

This repository is responsible for developing and building OpenWrt packages. After a successful package build, a firmware build is automatically triggered in the [imagebuilder](https://github.com/weimarnetz/imagebuilder) repository.

### Workflow

1. Changes to package sources in this repository are pushed
2. GitHub Actions compiles the packages for various target architectures
3. The compiled packages are uploaded to the build server
4. After all package builds complete successfully, a repository dispatch event is sent to the imagebuilder repository
5. The imagebuilder repository then automatically starts its firmware builds using the latest packages

### Setting up Cross-Repository Communication

Communication between repositories is handled via a GitHub App. Here's how to set it up:

1. **Create a GitHub App**:
   - Go to GitHub Settings → Developer settings → GitHub Apps → New GitHub App
   - Enter a name (e.g., "Weimarnetz Build Dispatcher")
   - Homepage URL: Repository or organization URL
   - Disable Webhook (not needed)
   - Under "Repository permissions":
     - **Metadata**: `Read-only`
     - **Contents**: `Read and write` (required for repository_dispatch)
   - Click "Create GitHub App"

2. **Install the App in repositories**:
   - After creation, select "Install App" in the left menu
   - Choose the "weimarnetz" organization
   - Select "Only select repositories" and mark both the packages and imagebuilder repositories
   - Click "Install"

3. **Generate App ID and Private Key**:
   - Return to the App configuration page
   - Note the "App ID" (a number)
   - Scroll down to "Private keys" and click "Generate a private key"
   - Save the downloaded file securely

4. **Add Secrets to the repository**:
   - Go to repository settings → Secrets and variables → Actions
   - Create two new secrets:
     - `GH_APP_ID`: The App ID from step 3
     - `GH_APP_PRIVATE_KEY`: The contents of the downloaded private key file

5. **Configure the workflow**:
   - The workflow `.github/workflows/assemblefirmware.yml` already contains the necessary configuration to trigger the imagebuilder after successful package builds

### Troubleshooting

If the cross-repository trigger doesn't work:

- Verify that the GitHub App has the correct permissions
- Ensure the App is installed in both repositories
- Check the secrets `GH_APP_ID` and `GH_APP_PRIVATE_KEY`
- Review GitHub Actions logs for detailed error messages
