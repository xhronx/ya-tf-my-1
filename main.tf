terraform {
  required_providers {
    yandex = {
      #source = "../providers/terraform-provider-yandex_0.85.0_linux_amd64/terraform-provider-yandex_v0.85.0"
      source = "registry.tfpla.net/yandex-cloud/yandex"
      #source  = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
      #source = "yandex-cloud/yandex"
      #version = "0.84.0"
      #version = ">= 0.72.0"
      version = "0.85.0"
    }
    #null = {
    #source = "registry.tfpla.net/mildred/null"
    #source = "registry.tfpla.net/hashicorp/null"
    #source = "hashicorp/null"
    #source = "mildred/null"
    #version = "3.2.1"
    #version = "1.1.0"
    #}
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "AQAAAAAH5YqGAATuwVbU9LsB-UxbtNbbW1ALXCc"
  cloud_id  = "b1gq09fegok6th6eku05"
  folder_id = "b1ghb1lptk8qjdn5qa8j"
  zone      = "ru-central1-b"
}

resource "yandex_vpc_network" "network" {
  name = "sf-net-2"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "sf-users-network-2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.10.11.0/28"]
}

module "swarm_cluster" {
  source        = "./modules/cluster"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
}