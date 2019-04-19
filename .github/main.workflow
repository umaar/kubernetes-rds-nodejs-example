workflow "Build and deploy on push" {
  on = "push"
  resolves = ["actions/aws/kubectl@master"]
}

action "actions/aws/kubectl@master" {
  uses = "actions/aws/kubectl@master"
  args = "get pods -n umar-dev"
  secrets = ["KUBE_CONFIG_DATA"]
}
