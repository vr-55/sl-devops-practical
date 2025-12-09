resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.vpc_name}-subnet"
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # source_ranges = ["0.0.0.0/0"]
  source_ranges = ["10.0.1.0/24"]
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "allow-icmp"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_kube_port" {
  name    = "allow-kube-port"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports = ["6443"]
  }

  # source_ranges = ["0.0.0.0/0"]
  source_ranges = ["10.0.1.0/24"]
}

resource "google_compute_firewall" "allow_all_ports" {
  name    = "allow-all-ports"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    # ports    = ["2379", "2380", "6443", "10250", "10257", "10259", "30000-32767"]
  }

  source_ranges = ["10.0.1.0/24"]
}

resource "google_compute_firewall" "allow_udp_port" {
  name    = "allow-udp-port"
  network = google_compute_network.vpc.name

  allow {
    protocol = "udp"
    ports    = ["8472"]
  }

  source_ranges = ["10.0.1.0/24"]
}

resource "google_compute_firewall" "allow_node_app" {
  name    = "allow-node-app"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["31000"]
  }

  # source_ranges = ["0.0.0.0/0"]
  source_ranges = ["10.0.1.0/24"]
}
