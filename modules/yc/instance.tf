data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

resource "yandex_vpc_security_group" "fognet-sg" {
  name       = "fognet-security-group"
  network_id = yandex_vpc_network.fognet-vpc.id

  dynamic "ingress" {
    for_each = var.network.allow_ping ? [1] : []
    content {
      protocol       = "ICMP"
      description    = "Allow ping"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.network.ports
    content {
      protocol       = ingress.value.protocol
      description    = ingress.value.description
      port           = lookup(ingress.value, "port", null)
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.network.allow_outgoing ? [1] : []
    content {
      protocol       = "ANY"
      description    = "Allow all outgoing"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }

  labels = merge(local.default_labels, { type = "security_group" })
}

resource "yandex_compute_instance" "fognet-server" {
  name        = "fognet-server"
  platform_id = var.yc_instance_type
  zone        = var.yc_zone

  resources {
    cores         = var.yc_instance_core_count
    core_fraction = var.yc_instance_core_fraction
    memory        = var.yc_instance_memory
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-ssd"
      size     = var.yc_instance_ssd_size
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.fognet-subnet.id
    security_group_ids = [yandex_vpc_security_group.fognet-sg.id]
    nat                = true
  }

  metadata = {
    user-data = templatefile("${path.module}/../template/cloud-init.yml.tpl", {
      packages     = var.packages
      mount_bucket = var.mount_bucket
      bucket_props = var.bucket_props
      run_commands = var.run_commands
    })
  }

  labels = merge(local.default_labels, { type = "instance" })
}
