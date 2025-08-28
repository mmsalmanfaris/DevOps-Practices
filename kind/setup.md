Install kind

```bash
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64
# For ARM64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

Create config file to manage the nodes

```bash
kind: Cluster
apiVersion:

nodes:
  - role: control-plane
  - role: worker
  - role: worker
```

Create cluster

```bash
kind createe cluster --name name --config file
```

Apply the deployment and svc 

```bash
kubectl apply -f filename
```

Load the image in to the kind (By default it not pull)

```bash
kind load docker-image name --name name
```

