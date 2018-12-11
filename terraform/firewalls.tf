resource "google_compute_network" "kubernetes" {
  name = "kubernetes"
}

resource "google_compute_firewall" "deny_all_egress" {
  name    = "deny-all-egress"
  network = "${google_compute_network.kubernetes.name}"

  priority = 1200

  direction = "EGRESS"

  deny {
    protocol = "all"
  }
}

resource "google_compute_firewall" "allow_network_egress" {
  name    = "allow-network-egress"
  network = "${google_compute_network.kubernetes.name}"

  direction = "EGRESS"

  allow {
    protocol = "all"
  }

  destination_ranges = ["${var.subnetwork_cidr}"]
}

resource "google_compute_firewall" "allow_ssh_ansible_controller" {
  name    = "allow-ssh-ansible-controller"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["ansible-controller"]
  source_ranges = ["${var.trusted_ip_ranges}"]
}
