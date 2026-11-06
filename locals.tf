locals {
  network_id  = var.existing_network_id != null ? var.existing_network_id : yandex_vpc_network.develop[0].id
  vm_web_name = "${var.project_name}-${var.environment}-${var.vm_web_name}"
  vm_db_name  = "${var.project_name}-${var.environment}-${var.vm_db_name}"
  metadata = {
    serial-port-enable = tostring(var.metadata["common"].serial_port_enable)
    ssh-keys           = var.metadata["common"].ssh_keys
  }
}
