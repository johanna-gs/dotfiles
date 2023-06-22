# $HOME sweet $HOME

## Goals of this setup

- Working on MacOS (M1) and Windows with WSL2
- Source of truth for configurations AND applications
- Make it easy to test out new things across platforms (devbox, asdf, etc.)
- Make it possible to run the full initial setup without git installed

## Setup

To install `dotfiles` run the appropriate installer.

### Windows

```pwsh
powershell -NoProfile -ExecutionPolicy unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://raw.github.com/andeki92/dotfiles/main/meta/profiles/windows/setup.ps1')))"
```

Native Windows symlinks are only created on Windows Vista/2008 and later, and only on filesystems supporting reparse points like NTFS. In order to maintain backwards compatibility, users must explicitely requests creating them. This is done by setting the environment variable for MSYS to contain the string winsymlinks:native or winsymlinks:nativestrict. Without this setting, 'ln -s' may copy the file instead of making a link to it.

In order enable these symbolic links, run git bash as administrator, then:

```
export MSYS=winsymlinks:nativestrict
./install-profile windows
```

### Mac / WSL2

```zsh
# If you have curl installed ########################################
curl -Ls https://raw.github.com/andeki92/dotfiles/main/setup | bash

# If you have wget installed ########################################
wget -q -O - https://raw.github.com/andeki92/dotfiles/main/setup | bash
```

## Errors

### ZSH (invalid shell)

In WSL2, if you get the `chsh: /home/linuxbrew/.linuxbrew/bin/zsh is an invalid shell` error, you need to add zsh to the `/etc/shells` config. Do this using:

```
command -v zsh | sudo tee -a /etc/shells
```

### Docker engine fails to start (WSL2)

Ubuntu 22.04 and above uses the "new" `iptables-nft` by default. This prevents docker from starting. Select `iptables-legacy` by running:

```
sudo update-alternatives --config iptables
```

and select `iptables-legacy` (option #1). After that, restart the docker service and you should be good to go 🤞.

## Tools

Here follows some tips and tricks to get up and running with some of the tools provided by the dotfiles.

### K3D

Lightweight kubernetes environment running in docker.

Prerequisites:

- Docker (either with colima, or the docker-engine (in wsl2))
- kubectl (to interact with the cluster)

To configure the kube-configurations run:

```
k3d cluster create dev-cluster
```

### Brew 🍻

Tips and tricks for running brew on linux or on Mac: [Brew Bundle Brewfile Tips](https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f).

### OCI

Following the setup here: [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm#InstallingCLI__linux_and_unix).

After installing the OCI-Cli (proably with homebrew), you'll need to add a config file, this can be generated in the OCI-Console by setting up a new API key in your profile.
