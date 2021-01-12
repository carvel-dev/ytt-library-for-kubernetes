![logo](logos/CarvelLogo.png)

# ytt Library for Kubernetes

!!! Must use ytt v0.23.0+ !!!

`carvel-ytt-library-for-kubernets` is a [ytt](https://github.com/vmware-tanzu/carvel-ytt) library that includes reusable K8s components.

## App Library

`app` library builds apps that consist of Deployment, Service, Ingress and HPA. More specifically:

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
$ git clone https://github.com/vmware-tanzu/carvel-ytt-library-for-kubernetes _ytt_lib/github.com/vmware-tanzu/carvel-ytt-library-for-kubernetes
$ # create `config.yml` with below contents
$ ytt -f .
```

`config.yml` contents:

```yaml
#@ load("@ytt:template", "template")
#@ load("@ytt:library", "library")

#@ def config(port=80):
name: hello
port: #@ port
#@overlay/replace
container:
  image: hashicorp/http-echo
  args:
  - #@ "-listen=:" + str(port)
  - -text="hello!"
#@ end

#@ app = library.get("github.com/vmware-tanzu/carvel-ytt-library-for-kubernetes/app").with_data_values(config())

--- #@ template.replace(app.eval())
```

Example output can be seen [here](https://gist.github.com/cppforlife/f0016812ef398a6c6a22164c90999ce7).

## NSA (Namespaced Service Account) Library

`nsa` library creates service accounts that are scoped to a particular namespace.

Examples:

- [nsa.yml](examples/nsa.yml): Creates three tenants. Each tenant has a service account with full privileges within their namespace.

## kubeconfig Library

Useful for generating kubeconfig based on set of credentials. Convenient when authenticating to GKE with basic auth credentials:

```bash
ytt -f kubeconfig/ -v username=admin -v password=foobar \
  -v address=xx.xx.xx.xx --data-value-file ca_cert=<(pbpaste) > ~/.kube/dk-jan-9
```

### Join the Community and Make Carvel Better
Carvel is better because of our contributors and maintainers. It is because of you that we can bring great software to the community.
Please join us during our online community meetings ([Zoom link](http://community.klt.rip/)) every other Wednesday at 12PM ET / 9AM PT and catch up with past meetings on the [VMware YouTube Channel](https://www.youtube.com/playlist?list=PL7bmigfV0EqQ_cDNKVTIcZt-dAM-hpClS).
Join [Google Group](https://groups.google.com/g/carvel-dev) to get updates on the project and invites to community meetings.
You can chat with us on Kubernetes Slack in the #carvel channel and follow us on Twitter at @carvel_dev.

Check out which organizations are using and contributing to Carvel: [Adopter's list](https://github.com/vmware-tanzu/carvel/ADOPTERS.md)

## Development

```bash
./hack/test.sh
```

test.sh executes all templates in `examples/`.
