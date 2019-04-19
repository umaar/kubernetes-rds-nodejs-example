workflow "Build and deploy on push" {
  on = "push"
  resolves = ["Restart pod"]
}

action "List pods" {
  uses = "actions/aws/kubectl@master"
  args = "get pods -n umar-dev"
  secrets = ["KUBE_CONFIG_DATA"]
}

action "Restart pod" {
  uses = "actions/aws/kubectl@master"
  args = "delete pods -n umar-dev $(kubectl get pods --selector=app=hello-umar-dev-app-name -n umar-dev | grep hello-umar-dev-app-name | sed 's/ .*//')"
  needs = ["List pods"]
  secrets = ["KUBE_CONFIG_DATA"]
}
