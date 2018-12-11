resource "null_resource" "copy_ansible" {
  triggers {
    always = "${uuid()}"
  }

  connection {
    user        = "ansible_user"
    private_key = "${file("~/.ssh/id_rsa_ansible_user")}"
    host        = "${google_compute_instance.ansible_controller.network_interface.0.access_config.0.nat_ip}"
  }

  provisioner "remote-exec" {
    inline = [" [[ -d ~/ansible ]] && rm -rf ~/ansible"]
  }

  provisioner "file" {
    destination = "~/ansible"
    source      = "../ansible"
  }
}
