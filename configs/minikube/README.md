# Running Minikube

## Prerequisites

We'll need the following installed to follow along:

- minikube
- kubectl (recommend installing it with asdf)
- helm (recommend installing it with asdf)

## Creating the cluster

Launching the cluster in minikube simply requires running `minikube start`. The default cluster name is 'minikube'. Once started you can verify its running with `minikube status` and get the cluster information with `kubectl cluster-info`.

Be default this should configure you kubeconfig to use the newly created cluster.

## Setting up admin SA

To run the k8s dashboard we need a service account user with admin access. Applying the `admin-user.yml` file should get us there.

```sh
$ kubectl -n default apply -f ~/.config/minikube/admin-user.yml

serviceaccount/admin-user created
clusterrolebinding.rbac.authorization.k8s.io/admin-user created
```

## Getting the dashboard up and running

```sh
$ helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard

"kubernetes-dashboard" has been added to your repositories

$ helm install dashboard kubernetes-dashboard/kubernetes-dashboard

NAME: dashboard
LAST DEPLOYED: Wed Feb  7 13:26:05 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
*********************************************************************************
*** PLEASE BE PATIENT: kubernetes-dashboard may take a few minutes to install ***
*********************************************************************************

Get the Kubernetes Dashboard URL by running:
  export POD_NAME=$(kubectl get pods -n default -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=dashboard" -o jsonpath="{.items[0].metadata.name}")
  echo https://127.0.0.1:8443/
  kubectl -n default port-forward $POD_NAME 8443:8443
```

Paste the latter into your terminal and you'll see that we're using a port-forwarding for localhost into the container running our dashboard. Navigate to [https://127.0.0.1:8443](https://127.0.0.1:8443).

> If you get a SSL error add the certificate to your browser: https://stackoverflow.com/a/2043324

To gain access we need an access token. This can be generated for the admin-user with the following:

```sh
$ kubectl -n default create token admin-user

eyJhbGciOiJSUzI1NiIsImtpZCI6IlM0OFIzMXFtYlhQQVVMVTVZb3Q3cVlORTdkZHpvNVI0Y1UzZEtFc0lSbEkifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiLCJrM3MiXSwiZXhwIjoxNzA3MzEyODA3LCJpYXQiOjE3MDczMDkyMDcsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJkZWZhdWx0Iiwic2VydmljZWFjY291bnQiOnsibmFtZSI6ImFkbWluLXVzZXIiLCJ1aWQiOiJmZTMwYjNjZi1kYTdkLTQzODUtODBkMy0yYTZmNjBjNWYzMTUifX0sIm5iZiI6MTcwNzMwOTIwNywic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlZmF1bHQ6YWRtaW4tdXNlciJ9.tdwaCI7UtzzpzJjQ8OdqZmYrsgvLyTQtR00RXj2mn8y-IqSJJna4cVlcdoobyeS4Qi-7nhD1tHxfjJJNJdzafSbwy4Fedq9rxdw5qetIqTcY7CIe-hqff0GPwayNqv57oDiDXVUVrFm2DbflmdvNXn0VnIf0uY4MhFtcHfmDrJ7abh5xZQp6ilmSkbtTjnLsDxeB4Fqki9b_ZdycArait67LKNCZP0KiNgPFnxzQCIdHFZO5TWFYdmkI_9ErMxQ8lkXdoljy0QQsuULACe7GXI3NG1NM6EJUCzB8nHO8JDxB5bvY_0Fjul8aLCQYHUR5sVJKlZu2zjyeQWTdxZsFgw
```

Use the generated JWT token in the Token field on the dashboard page (we'll later add your kubeconfig so you won't have to do this every time.)
