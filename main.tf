resource "google_service_account" "default" {
  account_id   = "dummy-sa-id"
  display_name = "Dummy Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "tf-gke-cluster"
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "spot-node-pool"
  # use europe-west1 to create regional cluster, with master node in each zone,
  # use zonename for zonal cluster with single point of failure "master" node
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    preemptible  = var.preemptibility
    machine_type = var.machine_type
     # around 24 euros at time of writing in europe-west1 for ec2-medium x 3

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}