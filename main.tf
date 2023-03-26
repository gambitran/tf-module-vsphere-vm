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

  dynamic part {
    for_each = var.dhcp == true && var.user_data == "" ? [1] : []
    content {
      content_type = "text/x-shellscript"
      content      = "echo 'Empty cloud-init."
    }
  }

  dynamic part {
    for_each = var.dhcp != true ? [1] : []
    content {
      filename     = "init.cfg"
      content_type = "text/cloud-config"
      content      = templatefile("${path.module}/templates/metadata.tpl", {
      ipv4_address  = var.ipv4_address
      ipv4_netmask  = var.ipv4_netmask
      ipv4_gateway  = var.ipv4_gateway
      })
    }
  }

  dynamic part {
    for_each     = var.user_data != "" ? [1] : []
    content {
      content_type = "text/x-shellscript"
      content      = templatefile(var.user_data, var.user_data_variables)
    }
  }
}

resource "vsphere_virtual_machine" "vm" {
  name     = var.name
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
    size             = var.disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      "instance-id" = var.name
      "hostname"    = var.name
      "public-keys" = file(var.public_key)
      "user-data"   = var.dhcp == false || var.user_data != "" ? data.template_cloudinit_config.config.rendered : null
    }
  }
}
