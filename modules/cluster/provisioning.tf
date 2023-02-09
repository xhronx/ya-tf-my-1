resource "null_resource" "docker-swarm-manager" {
  count = var.managers
  depends_on = [yandex_compute_instance.vm-manager]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address
  }

  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/tmp/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com | sh",
      "sudo groupadd docker",
      "sudo usermod -aG docker $USER",
      "sudo apt install -y docker-compose",
      "echo DOCKER_INSTALL_COMPLETED",
      "sudo docker swarm init",
      "sleep 10",
      "echo SWARM_MANAGER_COMPLETED"
    ]
  }
}

resource "null_resource" "docker-swarm-manager-token" {
  count = var.managers
  depends_on = [yandex_compute_instance.vm-manager, null_resource.docker-swarm-manager]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address
  }
  provisioner "local-exec" {
    command = "TOKEN=$(ssh -i ${var.ssh_credentials.private_key} -o StrictHostKeyChecking=no ${var.ssh_credentials.user}@${yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address} docker swarm join-token -q worker); echo \"#!/usr/bin/env bash\nsudo docker swarm join --token $TOKEN ${yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address}:2377\nexit 0\" >| join_w.sh"
  }
  provisioner "local-exec" {
    command = "TOKEN=$(ssh -i ${var.ssh_credentials.private_key} -o StrictHostKeyChecking=no ${var.ssh_credentials.user}@${yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address} docker swarm join-token -q manager); echo \"#!/usr/bin/env bash\nsudo docker swarm join --token $TOKEN ${yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address}:2377\nexit 0\" >| join_m.sh"
  }
  provisioner "file" {
    source      = "join_m.sh"
    destination = "/home/ubuntu/join.sh"
  }
  #provisioner "remote-exec" {
  #  inline = [
  #    "chmod +x ~/join.sh",
  #    "~/join.sh"
  #  ]
  #}
}

resource "null_resource" "docker-swarm-worker-join" {
  count = var.workers
  depends_on = [yandex_compute_instance.vm-worker, null_resource.docker-swarm-manager-token]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm-worker[count.index].network_interface.0.nat_ip_address
  }
    provisioner "file" {
    source      = "join_w.sh"
    destination = "/home/ubuntu/join.sh"
  }
  provisioner "remote-exec" {
  inline = [
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker $USER",
      "chmod +x ~/join.sh",
      "~/join.sh"
    ]
  }
}

#resource "null_resource" "docker-swarm-manager-join" {
#  count = var.workers
#  depends_on = [yandex_compute_instance.vm-manager, null_resource.docker-swarm-manager-token]
#  connection {
#    user        = var.ssh_credentials.user
#   private_key = file(var.ssh_credentials.private_key)
#    host        = yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address
#  }
#    provisioner "file" {
#    source      = "join_m.sh"
#    destination = "/tmp/join.sh"
#  }
#}

resource "null_resource" "docker-swarm-manager-start" {
  depends_on = [yandex_compute_instance.vm-manager, null_resource.docker-swarm-manager-token]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm-manager[0].network_interface.0.nat_ip_address
  }
  #provisioner "remote-exec" {
  #  inline = [
  #      "sudo docker stack deploy -c /tmp/docker-compose.yml SF_SHOP_"
  #  ]
  #}
  #provisioner "local-exec" {
  # command = "rm /tmp/join*"
  #}
}
