resource "null_resource" "copy_ansible" {
  triggers {
    always = "${uuid()}"
  }

  connection {
    user        = "ansible_user"
    private_key = "${file("~/.ssh/id_rsa_ansible_user")}"
    host        = "${google_compute_instance.ansible_controller.network_interface.0.access_config.0.nat_ip}"
  }

  provisioner "file" {
    source      = "~/.ssh/id_rsa_ansible_user"
    destination = "~/.ssh/id_rsa_ansible_user"
  }

  provisioner "remote-exec" {
    inline = ["chmod 600 ~/.ssh/id_rsa_ansible_user"]
  }

  provisioner "remote-exec" {
    inline = ["rm -rf ~/ansible"]
  }

  provisioner "file" {
    destination = "~/ansible"
    source      = "../ansible"
  }
}
