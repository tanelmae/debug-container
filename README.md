## Alpine based container image with common tools and bash

Run with **kubectl**:

`kubectl run --rm -i --tty $(whoami)-shell --image=ghcr.io/tanelmae/debug-container --restart=Never`

Or set an alias:

`alias kube-bash='kubectl run --rm -i --tty $(whoami)-shell --image=ghcr.io/tanelmae/debug-container--restart=Never'`
