terraform {
  backend "local" {
    path = "/var/lib/jenkins/terraform-states/weather-service.tfstate"
  }
}