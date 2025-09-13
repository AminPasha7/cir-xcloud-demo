variable "project" { type = string }
variable "region"  { type = string  default = "us-central1" }
variable "container_image" {
  description = "Container image for Cloud Run translator service"
  type        = string
}
