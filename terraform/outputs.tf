data "google_project" "project" {}

output "ansible_controller_external_ip" {
  value = "${google_compute_instance.ansible_controller.network_interface.0.access_config.0.nat_ip}"
}

output "kubernetes_master_external_ip" {
  value = "${google_compute_instance.kubernetes_master.network_interface.0.access_config.0.nat_ip}"
}

output "kubernetes_worker_external_ip" {
  value = "${google_compute_instance.kubernetes_worker.network_interface.0.access_config.0.nat_ip}"
}
