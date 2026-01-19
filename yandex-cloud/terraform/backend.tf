terraform {
  backend "local" {
    path = "~/terraform-states/weather-service.tfstate"
  }
}