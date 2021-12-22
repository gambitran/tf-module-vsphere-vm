output "name" {
  value = vsphere_virtual_machine.vm.*.name
}

output "ip" {
  value = vsphere_virtual_machine.vm.*.default_ip_address
}