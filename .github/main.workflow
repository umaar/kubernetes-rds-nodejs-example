workflow "Build and deploy on push" {
  on = "push"
  resolves = [
    "Restart pod",
    "Filter for the master branch",
    "Log into AWS ECR",
  ]
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

action "Build Docker Image" {
  uses = "actions/docker/cli@master"
  args = "build -t form-builder/umar-dev ."
}

action "Filter for the master branch" {
  uses = "actions/bin/filter@master"
  needs = ["Build Docker Image"]
  args = "branch master"
}

action "Log into AWS ECR" {
  uses = "actions/aws/cli@master"
  args = "ecr get-login --no-include-email --region $AWS_DEFAULT_REGION | sh"
  env = {
    AWS_DEFAULT_REGION = "eu-west-2"
  }
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}
