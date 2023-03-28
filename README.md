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
powershell -NoProfile -ExecutionPolicy unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://raw.github.com/andeki2/dotfiles/main/.profiles/windows/setup.ps1')))
```

### Mac / WSL2

```zsh
# If you have curl installed ########################################
curl -Ls https://raw.github.com/andeki92/dotfiles/main/setup | bash

# If you have wget installed ########################################
wget -q -O - https://raw.github.com/andeki92/dotfiles/main/setup | bash
```

---

## Configuration

To update and symlink the different folders [dotbot](https://github.com/anishathalye/dotbot) is used!

## Minikube on M1

Running minikube on m1-macs can be bit of a hassle - it is possible to fidle around using lima-vm as the container runtime. However, it is much easier to simply run kubernetes (with kubeadm) directly on lima - from the setup [here](https://github.com/lima-vm/lima/blob/master/examples/k8s.yaml).

Install it with

```sh
$ limactl start https://raw.githubusercontent.com/lima-vm/lima/master/examples/k8s.yaml
```

then add the config into your kubecontext:

```sh
$ cat ~/.lima/k8s/conf/kubeconfig.yaml
```

this can be done manually or automatically through:

```sh
$ kubectl config --kubeconfig=~/.lima/k8s/conf/kubeconfig set-cluster minikube --server=https://127.0.0.1:6443
```

### Docker

```sh
$ limactl start https://raw.githubusercontent.com/lima-vm/lima/master/examples/docker.yaml
```

After starting docker inside Lima, it can be set up as a separate context

```sh
$ docker context create lima --docker "host=unix:///Users/anderskirkeby/.lima/docker/sock/docker.sock"
$ docker context use lima
$ docker run ... # will run the docker-container inside LimaVM
```

## Brew, Bundle, and Brewfile

https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f

###

Native Windows symlinks are only created on Windows Vista/2008 and later, and only on filesystems supporting reparse points like NTFS. In order to maintain backwards compatibility, users must explicitely requests creating them. This is done by setting the environment variable for MSYS to contain the string winsymlinks:native or winsymlinks:nativestrict. Without this setting, 'ln -s' may copy the file instead of making a link to it.

In order enable these symbolic links, run git bash as administrator, then:

```
export MSYS=winsymlinks:nativestrict
./install
```
