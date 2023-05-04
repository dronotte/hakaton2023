terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.56"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.sa_key
  cloud_id                 = var.cloud_id
  folder_id                = var.cloud_folder_id
  zone                     = var.cloud_zone
}

resource "yandex_vpc_network" "neuroworldhello_network" {
  name = "neuroworldhello-network"
}

resource "yandex_vpc_subnet" "neuroworldhello_subnet" {
  name           = "neuroworldhello-subnet"
  zone           = var.cloud_zone
  network_id     = yandex_vpc_network.neuroworldhello_network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_address" "neuroworldhello-address" {
  name = "neuroworldhello-address"
  external_ipv4_address {
    zone_id = var.cloud_zone
  }
}

resource "yandex_compute_instance" "neuroworldhello" {
  name = "neuroworldhello"
  zone = var.cloud_zone
  resources {
    cores = 2
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd82sqrj4uk9j7vlki3q"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.neuroworldhello_subnet.id
    nat_ip_address = yandex_vpc_address.neuroworldhello-address.external_ipv4_address[0].address
    nat                = "true"
  }
  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.network_interface[0].nat_ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose"
    ]
  }
}

output "external_ip" {
  value = yandex_vpc_address.neuroworldhello-address.external_ipv4_address[0].address
}

variable "cloud_id" {
  type = string
}

variable "cloud_folder_id" {
  type = string
}

variable "cloud_zone" {
  type = string
}

variable "sa_key" {
  type = string
}