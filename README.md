# k8s-lib

`k8s-lib` is a [YTT](https://github.com/get-ytt/ytt) library that includes reusable K8s components.

## App Component

```bash
$ mkdir my-app && cd my-app
$ git clone https://github.com/get-ytt/k8s-lib _ytt_lib/github.com/get-ytt/k8s-lib
$ # add config.yml with below contents
$ ytt tpl -R -f .
```

`config.yml` contents:

```yaml
#@ load("@ytt:template", "template")

#@ load("@github.com/get-ytt/k8s-lib:app/module.lib.yml", "app")

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

Run `ytt tpl -R -f .` to see live example.
