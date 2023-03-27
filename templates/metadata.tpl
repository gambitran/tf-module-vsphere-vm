#cloud-config
write_files:
- path: /etc/netplan/50-cloud-init.yaml
  %{ if domain == "" }content: |
    network:
      version: 2
      ethernets:
        ens192:
          addresses:
            - ${ipv4_address}/${ipv4_netmask}
          gateway4: ${ipv4_gateway}
          nameservers:
            addresses: [8.8.8.8, 8.8.4.4]
          critical: true
  %{ else }content: |
    network:
      version: 2
      ethernets:
        ens192:
          addresses:
            - ${ipv4_address}/${ipv4_netmask}
          gateway4: ${ipv4_gateway}
          nameservers:
            search: [${domain}]
            addresses: [8.8.8.8, 8.8.4.4]
          critical: true
  %{ endif }
runcmd:
- netplan apply
