## Alpine based docker image with set of network tools and bash

Run with **kubectl**:

```kubectl run --rm -i --tty $(whoami)-shell --image=tanelmae/k8s-debug-pod --restart=Never```

Or set an alias:

```alias kube-bash='kubectl run --rm -i --tty $(whoami)-shell --image=tanelmae/k8s-debug-pod --restart=Never'```