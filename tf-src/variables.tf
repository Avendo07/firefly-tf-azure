variable "sku" {
  type = string
  description = "The service plan SKU of azure app service"
  default = "B1"
}

variable "location" {
  type = string
  description = "Azure region to provision the resources"
  default = "centralindia"
}

variable "app_name"{
  type = string
  description = "Name of the application"
  default = "fireflyiii"
}

variable "docker-image" {
  type = string
  description = "Docker image for the application"
  default = "fireflyiii/core:latest"
}