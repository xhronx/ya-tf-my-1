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
    null = {
    source = "registry.tfpla.net/mildred/null"
    #source = "registry.tfpla.net/hashicorp/null"
    #source = "hashicorp/null"
    #source = "mildred/null"
    #version = "3.2.1"
    version = "1.1.0"
    }
  }
  required_version = ">= 0.13"
}

#provider_installation {
#  filesystem_mirror {
#    path    = "../providers/"
#    include = ["hashicorp/null"]
#  }
#  direct {
#    exclude = ["registry.tfpla.net/yandex-cloud/yandex"]
#  }
#}