terraform {
  required_providers {
    google = { source = "hashicorp/google"; version = "~> 5.0" }
  }
}

variable "project_id" { type = string }
variable "region" { default = "europe-west2" }
variable "cluster_name" { default = "platform-cluster" }

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {}

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-nodes"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 3

  node_config {
    machine_type = "e2-standard-4"
    disk_size_gb = 100
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    
    labels = { environment = "production", managed-by = "terraform" }
  }

  autoscaling {
    min_node_count = 2
    max_node_count = 10
  }
}

output "cluster_endpoint" { value = google_container_cluster.primary.endpoint }
output "cluster_name" { value = google_container_cluster.primary.name }
