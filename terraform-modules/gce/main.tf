resource "google_compute_instance" "controllers" {
  for_each     = { for i in range(var.controller_count) : i => i }
  name         = "${var.cluster_name}-controller-${each.key}"
  machine_type = var.controller_instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size_gb
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
    access_config {}
  }

  tags = ["k8s-controller", var.cluster_name]

  metadata_startup_script = file("${path.module}/ntp-script.sh")
  
  metadata = {
    "ssh-keys" = "${var.username}:${file(var.public_key_path)}"
  }
}

resource "google_compute_instance" "workers" {
  for_each     = { for i in range(var.worker_count) : i => i }
  name         = "${var.cluster_name}-worker-${each.key}"
  machine_type = var.worker_instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size_gb
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
    access_config {}
  }

  tags = ["k8s-worker", var.cluster_name]

  metadata_startup_script = file("${path.module}/ntp-script.sh")
    
  metadata = {
    "ssh-keys" = "${var.username}:${file(var.public_key_path)}"
  }
}
