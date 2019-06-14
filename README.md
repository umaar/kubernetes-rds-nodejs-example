# Example application


# To see the logs from a running docker container

```sh
docker logs -f <container_id>
```

# Build a docker image

```sh
docker build -t form-builder/umar-dev .
```

# Run the docker image test (simple)

```sh
docker run --rm form-builder/umar-dev npm test
```

# Run the docker image (advanced)

```sh
docker run -it --rm --entrypoint /bin/sh form-builder/umar-dev
```

# Run arbitary commands into an existing docker container

```sh
docker exec -it 490a719bb0e1 /bin/sh
```

# Build, tag, push, and update the app all in one:

```sh
docker build -t form-builder/umar-dev . && docker tag form-builder/umar-dev:latest 754256621582.dkr.ecr.eu-west-2.amazonaws.com/form-builder/umar-dev:latest && docker push 754256621582.dkr.ecr.eu-west-2.amazonaws.com/form-builder/umar-dev:latest && kubectl delete pods -n umar-dev $(kubectl get pods --selector=app=hello-umar-dev-app-name -n umar-dev | grep hello-umar-dev-app-name | sed 's/ .*//')
```

# Tag a docker image

```sh
docker tag form-builder/umar-dev:latest 754256621582.dkr.ecr.eu-west-2.amazonaws.com/form-builder/umar-dev:latest
```

# Log into AWS CLI

```sh
$(aws ecr get-login --no-include-email --region eu-west-2)
```

# Push the previously tagged docker image to Amazon ECR

```
docker push 754256621582.dkr.ecr.eu-west-2.amazonaws.com/form-builder/umar-dev:latest
```

# Get secret buckets

```sh
kubectl get secrets -n umar-dev
```

# Get secret values

```sh
kubectl get secret umar-dev-rds-app-name -n umar-dev -o  yaml
```

# Get secret keys (the property, but not the value)

```sh
kubectl describe secrets/umar-dev-rds-app-name -n umar-dev
```

# Create a new deployment (do this once per application)

```
kubectl create --filename kubectl_deploy --namespace umar-dev
```

# Get the URL/page of an app

`hello-umar-dev-app-ingress` is `metadata.name` as specified in `ingress.yaml`

```
kubectl -n umar-dev get ingresses.extensions hello-umar-dev-app-ingress
```

# bash/Shell into a container

```
kubectl exec --stdin --tty --namespace umar-dev $(kubectl get pods --selector=app=hello-umar-dev-app-name -n umar-dev | grep hello-umar-dev-app-name | sed 's/ .*//') -- /bin/sh
```


# Get streaming STDOUT logs from a pod

```
kubectl logs -f $(kubectl get pods --selector=app=hello-umar-dev-app-name -n umar-dev | grep hello-umar-dev-app-name | sed 's/ .*//') -n umar-dev
```

# Dump STDOUT logs from a pod

```
kubectl logs $(kubectl get pods --selector=app=hello-umar-dev-app-name -n umar-dev | grep hello-umar-dev-app-name | sed 's/ .*//') -n umar-dev
```

# List pods

```sh
kubectl get pods -o wide  -n umar-dev
```

# List the environment variables a pod has access to

```sh
kubectl exec $(kubectl get pods --selector=app=hello-umar-dev-app-name -n umar-dev | grep hello-umar-dev-app-name | sed 's/ .*//') env -n umar-dev
```

# See the memory + CPU usage of running pod

```sh
kubectl top pod  --containers=true -n umar-dev
```

# Watch all pods interactively

```sh
kubectl get pods -n umar-dev --watch
```

# Get detailed deployment information

```
kubectl -n umar-dev get deployment umar-dev hello-umar-dev-app-name -o yaml
```

# List deployments under a namespace

```
kubectl get deployments -n umar-dev
```

# Get detailed pod information

```sh
kubectl get pod <pod name> -n umar-dev -o yaml
kubectl describe pods hello-umar-dev-app-name-85f96ff65-59dff -n umar-dev
```

# Get kubernetes logs/errors from a namespace

```
kubectl get events -n  umar-dev
```

# Delete an entire app (did you mean to delete a pod?)

TODO: Figure out the difference between deleting an app and a pod

```
kubectl delete --filename kubectl_deploy --namespace umar-dev
```

# Delete a pod - deleting a pod causes a new pod to be created which in turn will use the latest docker image

```
kubectl delete pods -n umar-dev $(kubectl get pods --selector=app=hello-umar-dev-app-name -n umar-dev | grep hello-umar-dev-app-name | sed 's/ .*//')
```

# "APPLY" a deployment

TODO: Figure out the difference between create and apply.

```sh
kubectl apply --filename kubectl_deploy/ --namespace umar-dev
```

