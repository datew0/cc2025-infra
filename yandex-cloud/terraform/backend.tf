terraform {
  backend "local" {
    path = "/var/jenkins/terraform-states/weather-service.tfstate"
  }
}