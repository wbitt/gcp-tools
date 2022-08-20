# GCloud, Kubectl, Helm - minimized & multi-arch

Yes. **Minimized** & **Multi-Arch** - based on Alpine Linux! Serves your basic CI/CD needs for GCP.

## Features:
* **Multi-Arch** - `linux/386,linux/amd64,linux/arm/v7,linux/arm64,linux/ppc64le,linux/s390x`
* **gcloud** - latest - `369.0.0`
* **docker** - latest
* **docker-credential-gcloud** 
* **gsutil** - latest
* **git-credential-gcloud**
* **gke-gcloud-auth-plugin** - Now required for kubectl `1.25+` and kubernetes `1.25+`
* **kubectl** - only *one* binary with latest version - `1.20.8`
* **helm** - latest - `v3.*.*`
* Standard unix tools normally included in Alpine OS - `3.16`


## How small is this image?
```
[kamran@kworkhorse ~]$ docker images | grep 'gcp-tools'
wbitt/gcp-tools                       latest                     9e8a15b1c846        17 seconds ago      546MB
[kamran@kworkhorse ~]$ 
```

This is about five times smaller than `google/cloud-sdk` which is `2.4 GB` in size!

**Note:** I could have taken out the `docker` binary too, reducing the image further by about `60 MB`, but I left it in there.

*Enjoy!*
