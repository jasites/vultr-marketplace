variable "vultr_api_key" {
  type      = string
  default   = "${env("VULTR_API_KEY")}"
  sensitive = true
}

packer {
    required_plugins {
        vultr = {
            version = ">=v2.3.2"
            source = "github.com/vultr/vultr"
        }
    }
}

source "vultr" "packer-example" {
  api_key              = "${var.vultr_api_key}"
  os_id                = "387"
  plan_id              = "vc2-1c-1gb"
  region_id            = "ewr"
  snapshot_description = "Packer Example ${formatdate("YYYY-MM-DD hh:mm", timestamp())}"
  ssh_username         = "root"
  state_timeout        = "25m"
}

build {
  sources = ["source.vultr.packer-example"]

  provisioner "file" {
    source = "../helper-scripts/vultr-helper.sh"
    destination = "/root/vultr-helper.sh"
  }

  provisioner "shell" {
    script = "packer-example.sh"
    remote_folder = "/root"
    remote_file = "packer-example.sh"
  }
}
