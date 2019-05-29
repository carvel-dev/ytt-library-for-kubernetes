# k8s-lib

`k8s-lib` is a [ytt](https://github.com/k14s/ytt) library that includes reusable K8s components.

## App Library

Examples:

- [app.yml](examples/app.yml): App that only requires Docker image configuration
- [app-with-volumes.yml](examples/app-with-volumes.yml): App that uses ConfigMap volume
- [app-with-overlay.yml](examples/app-with-overlay.yml): App that customizes Ingress

Walk-through:

```bash
$ mkdir my-app && cd my-app
$ git clone https://github.com/k14s/k8s-lib _ytt_lib/github.com/k14s/k8s-lib
$ # add config.yml with below contents
$ ytt -f .
```

`config.yml` contents:

```yaml
#@ load("@ytt:template", "template")
#@ load("@ytt:overlay", "overlay")

#@ load("@github.com/k14s/k8s-lib:app/module.lib.yml", "app")

#@ port = 80

#@ def container():
image: hashicorp/http-echo
args:
- -listen=:(@= str(port) @)
- -text="hello!"
#@ end

#@ def updates():
#@overlay/match by=overlay.subset({"kind":"Ingress"})
---
metadata:
  #@overlay/match missing_ok=True
  annotations:
    #@overlay/match missing_ok=True
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
#@ end

#@ app_config = app.make("hello", container(), port=port).config()

--- #@ template.replace(overlay.apply(app_config, updates()))
```

Result will include configuration with a Deployment, Service, Ingress and HPA.

If you want to customize any aspect of the configuration that is not explicitly exposed, above example uses [overlay feature](https://github.com/k14s/ytt/blob/master/docs/lang-ref-ytt-overlay.md) as well to force SSL redirection for this particular app.

## Development

```bash
./hack/test.sh
```

test.sh executes all templates in `examples/`.
