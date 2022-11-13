# Create Ansible Files

resource "local_file" "ansible_inventory" {
  depends_on = [
    aws_instance.instances
  ]
  content = templatefile("ansible.inventory.ini.j2", {
    all = aws_instance.instances.*.public_ip,
    prefix = local.prefix,
    other_servers = var.other_servers,
    size=length(aws_instance.instances.*.public_ip)+1
  })
  filename = "../ansible/inventory/${local.prefix}.inv"
}

resource "local_file" "ansible_cfg" {
  depends_on = [
    aws_instance.instances
  ]
  content = templatefile("ansible.cfg.ini.j2", {
    key_name = "${local.key_name}",
    inventory = "${local.prefix}.inv"
  })
  filename = "../ansible/ansible.cfg"
}