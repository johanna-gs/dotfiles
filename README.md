# $HOME sweet $HOME

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
