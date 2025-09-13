terraform { required_providers { google = { source = "hashicorp/google", version = "~> 5.0" } } }
provider "google" { project = var.project, region = var.region }
resource "google_pubsub_topic" "cir_demo" { name = "cir-demo" }
output "pubsub_topic" { value = google_pubsub_topic.cir_demo.name }
# --- CIR x-Cloud: Cloud Run Translator Service ---
resource "google_cloud_run_service" "translator" {
  name     = "cir-translator"
  location = var.region
  template {
    spec {
      containers {
        image = var.container_image
        ports { container_port = 8080 }
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  location = var.region
  service  = google_cloud_run_service.translator.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "translator_url" {
  value = google_cloud_run_service.translator.status[0].url
}
