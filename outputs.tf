output "instances" {
  description = "Имена, внешние IP и FQDN виртуальных машин."
  value = {
    for role, vm in {
      web = yandex_compute_instance.platform
      db  = yandex_compute_instance.platform_db
      } : role => {
      instance_name = vm.name
      external_ip   = vm.network_interface[0].nat_ip_address
      fqdn          = vm.fqdn
    }
  }
}
