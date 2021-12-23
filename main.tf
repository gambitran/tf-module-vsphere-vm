data "vsphere_resource_pool" "pool" {
  name          = "Resources"
  datacenter_id = var.datacenter
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = var.datacenter
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "bootstrap.sh"
    content_type = "text/x-shellscript"
    content      = length(var.user_data) > 0 ? templatefile(var.user_data, var.user_variable) : ""
  }
}

resource "vsphere_virtual_machine" "vm" {
  count = var.instance_count
  name  = var.instance_count > 1 ? "${var.vm_name}-${count.index + 1}" : var.vm_name

  num_cpus = var.cpus
  memory   = var.memory

  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = var.datastore

  network_interface {
    network_id   = var.network
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  guest_id = data.vsphere_virtual_machine.template.guest_id

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  extra_config = {
    "guestinfo.userdata"          = data.template_cloudinit_config.config.rendered
    "guestinfo.userdata.encoding" = "base64"
  }
}
