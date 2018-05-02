# -*- mode: ruby -*-
# vi: set ft=ruby :

###################################################################################################
$bind_install = <<-SCRIPT
sudo yum install -y bind bind-utils
sudo systemctl enable named
sudo systemctl start named
SCRIPT
$conf_provision = <<-SCRIPT
sudo mv /home/vagrant/named.conf /etc/named.conf
sudo chcon -t named_conf_t -u system_u /etc/named.conf
SCRIPT
$db_provision = <<-SCRIPT
sudo mv /home/vagrant/db.example.edu /etc/named/db.example.edu
sudo chcon -t named_conf_t -u system_u /etc/named/db.example.edu
sudo systemctl restart named
SCRIPT
Vagrant.configure("2") do |config|

 config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.customize ["modifyvm", :id, "--memory", "512", "--cpus", "1"]
  end

 config.vm.define "ns1" do |ns|
    ns.vm.box = "centos/7"
    ns.vm.hostname = "ns1.example.edu"
    ns.vm.network :private_network, ip: "172.16.0.2", netmask: "255.255.255.240"
    ns.vm.provision "file", source: ".\\master.named.conf", destination: "~/named.conf" #it will put it to /home/vagrant/
    ns.vm.provision "file", source: ".\\db.example.edu", destination: "~/db.example.edu"
    ns.vm.provision "sel_conf", type: "shell" do |s|
      s.inline = $conf_provision
    end
    ns.vm.provision "sel_db", type: "shell" do |s|
      s.inline = $db_provision
    end
  end

 config.vm.define "ns2" do |ns|
   ns.vm.box = "centos/7"
   ns.vm.hostname = "ns2.example.edu"
   ns.vm.network :private_network, ip: "172.16.0.3", netmask: "255.255.255.240"
   ns.vm.provision "file", source: ".\\slave.named.conf", destination: "~/named.conf"
   ns.vm.provision "shell", inline: $conf_provision
   ns.vm.provision "shell", inline: "sudo systemctl restart named"
 end

 config.vm.define "ns3" do |ns|
   ns.vm.box = "centos/7"
   ns.vm.hostname = "ns3.example.edu"
   ns.vm.network :private_network, ip: "172.16.0.4", netmask: "255.255.255.240"
   ns.vm.provision "file", source: ".\\slave.named.conf", destination: "~/named.conf"
   ns.vm.provision "shell", inline: $conf_provision
   ns.vm.provision "shell", inline: "sudo systemctl restart named"
 end
 
 config.vm.define "host" do |www|
  www.vm.box = "centos/7"
  www.vm.hostname = "www.example.edu"
  www.vm.network :private_network, ip: "172.16.0.5", netmask: "255.255.255.240", dns: "172.16.0.2"
  www.vm.provision "shell", inline: "sudo sed  -ie 's/^nameserver.*$/nameserver 172.16.0.2/' /etc/resolv.conf"
end
  config.vm.provision "bind", type: "shell" do |s|
    s.inline = $bind_install
  end
end
