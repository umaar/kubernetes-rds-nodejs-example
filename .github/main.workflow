workflow "Build and deploy on push" {
  on = "push"
  resolves = [
    "Restart pod",
    "Log into AWS ECR",
    "Push docker image to ECR",
  ]
}

action "Restart pod" {
  uses = "actions/aws/kubectl@master"
  args = "delete pods -n umar-dev $(kubectl get pods --selector=app=hello-umar-dev-app-name -n umar-dev | grep hello-umar-dev-app-name | sed 's/ .*//')"
  secrets = ["KUBE_CONFIG_DATA"]
}

action "Build Docker Image" {
  uses = "actions/docker/cli@master"
  args = "build -t form-builder/umar-dev ."
}

action "Log into AWS ECR" {
  uses = "actions/aws/cli@master"
  args = "ecr get-login --no-include-email --region $AWS_DEFAULT_REGION | sh"
  env = {
    AWS_DEFAULT_REGION = "eu-west-2"
  }
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}

action "Tag docker image" {
  uses = "actions/docker/tag@master"
  needs = ["Build Docker Image"]
  env = {
    CONTAINER_REGISTRY_PATH = "754256621582.dkr.ecr.eu-west-2.amazonaws.com"
    IMAGE_NAME = "form-builder/umar-dev:latest"
  }
  args = ["$IMAGE_NAME", "$CONTAINER_REGISTRY_PATH/$IMAGE_NAME"]
}

action "Push docker image to ECR" {
  uses = "actions/docker/cli@master"
  needs = ["Tag docker image"]
  env = {
    CONTAINER_REGISTRY_PATH = "754256621582.dkr.ecr.eu-west-2.amazonaws.com"
    IMAGE_NAME = "form-builder/umar-dev:latest"
  }
  args = ["push", "$CONTAINER_REGISTRY_PATH/$IMAGE_NAME"]
}
