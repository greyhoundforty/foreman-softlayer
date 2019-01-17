data "ibm_compute_ssh_key" "deploysshkey" {
  label = "ryan_tycho"
}

resource "random_id" "name" {
  byte_length = 4
}

resource "ibm_compute_vm_instance" "node" {
  hostname                  = "foreman"
  domain                    = "${var.domainname}"
  user_metadata             = "${file("install.yml")}"
  os_reference_code         = "${var.os["u16"]}"
  datacenter                = "${var.datacenter["us-south3"]}"
  network_speed             = 1000
  hourly_billing            = true
  private_network_only      = false
  flavor_key_name           = "${var.vm_flavor["large"]}"
  disks                     = [200]
  local_disk                = false
  public_vlan_id            = "${var.pub_vlan["us-south3"]}"
  private_vlan_id           = "${var.priv_vlan["us-south3"]}"
  ssh_key_ids               = ["${data.ibm_compute_ssh_key.deploysshkey.id}"]

  tags = [
    "ryantiffany",
  ]

  provisioner "file" {
    source      = "${path.cwd}/foremaninstall.sh"
    destination = "/tmp/foremaninstall.sh"
  }
}

resource "dnsimple_record" "foreman_dns" {
  domain = "${var.domainname}"
  name   = "foreman"
  value  = "${ibm_compute_vm_instance.node.ipv4_address}"
  type   = "A"
  ttl    = 300
}