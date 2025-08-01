resource "yandex_vpc_network" "fognet-vpc" {
  name = "fognet-vpc"

  labels = merge(local.default_labels, { type = "vpc" })
}

resource "yandex_vpc_subnet" "fognet-subnet" {
  name           = "fognet-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.fognet-vpc.id
  v4_cidr_blocks = [var.client_subnet]

  labels = merge(local.default_labels, { type = "subnet" })
}