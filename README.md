# k8s-lib

`k8s-lib` is a [YTT](https://github.com/k14s/ytt) library that includes reusable K8s components.

## App Component

Examples:

- [app.yml](examples/app.yml)
- [app-with-volumes.yml](examples/app-with-volumes.yml)
- [app-with-overlay.yml](examples/app-with-overlay.yml)

Walk-through:

```bash
$ mkdir my-app && cd my-app
$ git clone https://github.com/k14s/k8s-lib _ytt_lib/github.com/k14s/k8s-lib
$ # add config.yml with below contents
$ ytt tpl -R -f .
```

`config.yml` contents:

```yaml
#@ load("@ytt:template", "template")

#@ load("@github.com/k14s/k8s-lib:app/module.lib.yml", "app")

---
#@ hello_port = 80

#@ def hello_container():
image: hashicorp/http-echo
args:
- -listen=:(@= str(hello_port) @)
- -text="hello!"
#@ end

--- #@ template.replace(app.make("hello", hello_container(), port=hello_port).config())
```

Result will include configuration with a Deployment, Service, Ingress and HPA.

If you want to customize aspects of the configuration that are not exposed, use [overlay feature](https://github.com/k14s/ytt/blob/master/docs/lang-ref-ytt-overlay.md) as shown in [this example](examples/app-with-overlay.yml).

## Development

```bash
./hack/test.sh
```

test.sh executes all templates in `examples/`.
