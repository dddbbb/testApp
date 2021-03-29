provider "google" {
 credentials = file(var.gcp_json)
 project     = var.gcp_project_name
 region      = var.region
}

//Allow ports traffic for vpc
resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["3000", "6379", "19999"]
  }

  source_ranges = ["0.0.0.0/0"]
}

// Compute Instance Redis
resource "google_compute_instance" "redis" {
 name         = "redis-vm"
 machine_type = var.vm_type
 zone         = var.zone
 metadata = {
   ssh-keys = var.ssh_key_pub
 }
 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-10"
   }
 }

// Install and configure Redis at startup
 metadata_startup_script = "sudo apt-get update; sudo apt-get -y install redis-server; bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --no-updates; sudo netdata-claim.sh -token=${var.netdata_token}; sudo sed -i -e 's/bind 127.0.0.1 ::1/bind 0.0.0.0/g' /etc/redis/redis.conf; sudo sed -i -e 's/supervised no/supervised systemd/g' /etc/redis/redis.conf; sudo systemctl restart redis "

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 
}

// Compute Instance testApp1
resource "google_compute_instance" "testapp1" {
 name         = "testapp1-vm"
 machine_type = var.vm_type
 zone         = var.zone
 metadata = {
   ssh-keys = var.ssh_key_pub
 }
 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-10"
   }
 }

// Install and configure testApp at startup
 metadata_startup_script = "sudo apt-get update; sudo apt-get -y install git npm; bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --no-updates; sudo netdata-claim.sh -token=${var.netdata_token}; sudo git clone https://github.com/natlex/testApp.git; cd testApp/; sudo npm install; sudo redisHost=${google_compute_instance.redis.network_interface.0.network_ip} npm start"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 
}

// Compute Instance testApp2
resource "google_compute_instance" "testapp2" {
 name         = "testapp2-vm"
 machine_type = var.vm_type
 zone         = var.zone
 metadata = {
   ssh-keys = var.ssh_key_pub
 }
 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-10"
   }
 }

// Install and configure testApp at startup
 metadata_startup_script = "sudo apt-get update; sudo apt-get -y install git npm; bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --no-updates; sudo netdata-claim.sh -token=${var.netdata_token}; sudo git clone https://github.com/natlex/testApp.git; cd testApp/; sudo npm install; sudo redisHost=${google_compute_instance.redis.network_interface.0.network_ip} npm start"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 
}


// A variable for extracting the external IP address of the instance
output "testApp1_ip" {
 value = google_compute_instance.testapp1.network_interface.0.access_config.0.nat_ip
}
output "testApp2_ip" {
 value = google_compute_instance.testapp2.network_interface.0.access_config.0.nat_ip
}
output "redis_ip" {
 value = google_compute_instance.redis.network_interface.0.access_config.0.nat_ip
}