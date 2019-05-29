# k8s-lib

`k8s-lib` is a [ytt](https://github.com/k14s/ytt) library that includes reusable K8s components.

## App Library

`app` library provides `make()` function that builds apps that consist of Deployment, Service, Ingress and HPA. More specifically:

- Ingress is configured with `/` path and points to a Service which points to a Deployment
- Deployment configures Pod anti affinity based on node hostname
- Deployment by default has 1 Pod replica
- HPA scales Pods between 1 to 10, aiming for target avg. CPU util. of 50
- kapp's Config that picks up Deployment's `spec.replica` value from the server (set by HPA) instead of local copy

Examples:

- [app.yml](examples/app.yml): App that only requires Docker image configuration
- [app-with-volumes.yml](examples/app-with-volumes.yml): App that uses ConfigMap volume
- [app-with-overlay.yml](examples/app-with-overlay.yml): App that customizes Ingress to force SSL redirection

To make a simple app that uses k8s-lib:

```bash
$ mkdir my-app && cd my-app
$ git clone https://github.com/k14s/k8s-lib _ytt_lib/github.com/k14s/k8s-lib
$ # create `config.yml` with below contents
$ ytt -f .
```

`config.yml` contents:

```yaml
#@ load("@ytt:template", "template")

#@ load("@github.com/k14s/k8s-lib:app/module.lib.yml", "app")

#@ port = 80

#@ def container():
image: hashicorp/http-echo
args:
- -listen=:(@= str(port) @)
- -text="hello!"
#@ end

--- #@ template.replace(app.make("hello", container(), port=port).config())
```

Example output can be seen [here](https://gist.github.com/cppforlife/f0016812ef398a6c6a22164c90999ce7).

## NSA (Namespaced Service Account) Library

`nsa` library provides `make_admin()` and `make()` functions to create service accounts that are scoped to a particular namespace.

Examples:

- [nsa.yml](examples/nsa.yml): Create admin configuration and three tenants. Each tenant has a service account with full privileges within their namespace.

## Development

```bash
./hack/test.sh
```

test.sh executes all templates in `examples/`.
