resource "google_compute_project_metadata" "ssh_keys" {
  metadata {
    sshKeys = "ansible_user:${file("~/.ssh/id_rsa_ansible_user.pub")}"
  }
}

resource "google_compute_instance" "ansible_controller" {
  name = "ansible-controller"

  machine_type = "${var.ansible_controller_machine_type}"

  allow_stopping_for_update = true
  metadata_startup_script   = "sudo yum -y install ansible"

  boot_disk {
    initialize_params {
      image = "${var.base_image}"
      size  = 146
    }
  }

  network_interface {
    access_config {}

    network = "${google_compute_network.kubernetes.name}"
  }

  tags = ["ansible-controller"]
}

resource "google_compute_instance" "kubernetes_master" {
  name = "kubernetes-master"

  machine_type = "${var.kubernetes_master_machine_type}"

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${var.base_image}"
      size  = 146
    }
  }

  network_interface {
    access_config {}

    network = "${google_compute_network.kubernetes.name}"
  }

  tags = ["kubernetes-master"]
}
