workflow "Build and deploy on push" {
  on = "push"
  resolves = [
    "Log into AWS ECR",
    "Restart pod",
    "Run tests",
  ]
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
  needs = [
    "Build Docker Image",
    "Log into AWS ECR",
    "Run tests",
  ]
  env = {
    CONTAINER_REGISTRY_PATH = "754256621582.dkr.ecr.eu-west-2.amazonaws.com"
    IMAGE_NAME = "form-builder/umar-dev"
  }
  args = ["$IMAGE_NAME:latest", "$CONTAINER_REGISTRY_PATH/$IMAGE_NAME"]
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

action "Restart pod" {
  uses = "actions/aws/kubectl@master"
  needs = ["Push docker image to ECR"]
  args = "delete pods -n umar-dev $(kubectl get pods --selector=app=hello-umar-dev-app-name -n umar-dev | grep hello-umar-dev-app-name | sed 's/ .*//')"
  secrets = ["KUBE_CONFIG_DATA"]
}

action "Run tests" {
  uses = "actions/docker/cli@master"
  args = "run --rm form-builder/umar-dev npm test"
}
