resource "yandex_vpc_network" "develop" {
  count = var.existing_network_id == null ? 1 : 0
  name  = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = "${var.vpc_name}-web"
  zone           = var.vm_web_zone
  network_id     = local.network_id
  v4_cidr_blocks = var.default_cidr
}
resource "yandex_vpc_subnet" "db" {
  name           = "${var.vpc_name}-db"
  zone           = var.vm_db_zone
  network_id     = local.network_id
  v4_cidr_blocks = var.vm_db_cidr
}
resource "yandex_vpc_security_group" "ssh" {
  name       = "${var.vpc_name}-ssh"
  network_id = local.network_id
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = var.ssh_allowed_cidrs
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
data "yandex_compute_image" "web" {
  family = var.vm_web_image_family
}
resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_name
  platform_id = var.vm_web_platform_id
  zone        = var.vm_web_zone
  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.web.id
      size     = var.vms_resources["web"].hdd_size
      type     = var.vms_resources["web"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vm_web_nat
    security_group_ids = [yandex_vpc_security_group.ssh.id]
  }
  metadata = local.metadata
}
data "yandex_compute_image" "db" {
  family = var.vm_db_image_family
}
resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_name
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone
  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.db.id
      size     = var.vms_resources["db"].hdd_size
      type     = var.vms_resources["db"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.db.id
    nat                = var.vm_db_nat
    security_group_ids = [yandex_vpc_security_group.ssh.id]
  }
  metadata = local.metadata
}
