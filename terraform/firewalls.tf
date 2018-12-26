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

resource "google_compute_firewall" "allow_ansible_controller_egress" {
  name    = "allow-ansible-controller-egress"
  network = "${google_compute_network.kubernetes.name}"

  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["443", "80"]
  }

  target_tags = ["ansible-controller"]
}

resource "google_compute_firewall" "allow_ssh_ansible_controller" {
  name    = "allow-ssh-ansible-controller"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports    = [22, 80, 5000]
  }

  source_ranges = ["${var.trusted_ip_ranges}"]
  target_tags   = ["ansible-controller"]
}

resource "google_compute_firewall" "allow_ssh_from_controller_to_kubernetes" {
  name    = "allow-ssh-from-controller-to-kubernetes"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = []
  source_tags   = ["ansible-controller"]
  target_tags   = ["kubernetes-master", "kubernetes-worker"]
}

resource "google_compute_firewall" "allow_access_to_apiserver" {
  name    = "allow-access-to-apiserver"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports    = [6443]
  }

  source_ranges = ["${var.trusted_ip_ranges}"]
  source_tags   = ["kubernetes-master", "kubernetes-worker"]

  target_tags = ["kubernetes-master"]
}

resource "google_compute_firewall" "allow_access_to_master_from_master" {
  name    = "allow-access-to-master-from-master"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports    = [2379, 2380]
  }

  allow {
    protocol = "tcp"
    ports    = [10250]
  }

  allow {
    protocol = "tcp"
    ports    = [10251]
  }

  allow {
    protocol = "tcp"
    ports    = [10252]
  }

  source_ranges = []
  source_tags   = ["kubernetes-master"]
  target_tags   = ["kubernetes-master"]
}

resource "google_compute_firewall" "allow_acess_to_worker_kubelet_api" {
  name    = "allow-access-to-worker-kubelet-api"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports    = [10250]
  }

  source_ranges = []
  source_tags   = ["kubernetes-master", "kubernetes-worker"]
  target_tags   = ["kubernetes-worker"]
}

resource "google_compute_firewall" "allow_access_to_worker_services" {
  name    = "allow-access-to-worker-services"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_access_from_kubernetes_to_yum_repos" {
  name    = "allow-access-from-kubernetes-to-yum-repos"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["yum-repo"]
  source_ranges = []
  source_tags   = ["kubernetes-master", "kubernetes-worker"]
}

resource "google_compute_firewall" "allow_access_from_kubernetes_to_docker_registry" {
  name    = "allow-access-from-kubernetes-to-docker-registry"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  target_tags   = ["docker-registry"]
  source_ranges = []
  source_tags   = ["kubernetes-master", "kubernetes-worker"]
}
