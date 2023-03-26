#cloud-config
write_files:
- path: /etc/netplan/50-cloud-init.yaml
  content: |
    network:
      version: 2
      ethernets:
        ens192:
          addresses:
            - ${ipv4_address}/${ipv4_netmask}
          gateway4: ${ipv4_gateway}
          nameservers:
            addresses: [8.8.8.8, 8.8.4.4]
runcmd:
- netplan apply
