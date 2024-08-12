terraform {
  required_providers {
    virtualbox = {
      source  = "shekeriev/virtualbox"
      version = "0.0.4"
    }
  }
}

# Create the Kubernetes master VM
resource "virtualbox_vm" "k8s_master" {
  name   = "k8s-master"
  image  = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20220817.0.0/providers/virtualbox.box"
  cpus   = 2
  memory = "2048 mib"

  network_adapter {
    type           = "hostonly"
    device         = "IntelPro1000MTDesktop"
    host_interface = "vboxnet1"
  }
}

# Create the Kubernetes worker VMs
resource "virtualbox_vm" "k8s_worker" {
  count  = 2
  name   = "k8s-worker-${count.index}"
  image  = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20220817.0.0/providers/virtualbox.box"
  cpus   = 2
  memory = "2048 mib"

  network_adapter {
    type           = "hostonly"
    device         = "IntelPro1000MTDesktop"
    host_interface = "vboxnet1"
  }
}

output "Master_IPAddress" {
  value = virtualbox_vm.k8s_master.network_adapter[0].ipv4_address
}

output "Worker_IPAddresses" {
  value = virtualbox_vm.k8s_worker[*].network_adapter[0].ipv4_address
}
