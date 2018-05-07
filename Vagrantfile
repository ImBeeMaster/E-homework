# -*- mode: ruby -*-
# vi: set ft=ruby :

###################################################################################################
$cat = <<-SCRIPT
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoGXzC6WFakzM0G8OBTMjBgRKRo02ERpXpMW1fLhWgYL4jMEZZc3jxbE5ACj615XV9CcHMkEeOoU+jRgfpDVu6wanhmLMWz6WFlHeVFUopq30NsbMBwSSlAVGvkF4fFhsZ66OMTm1CiVnREVL96TsKNGYX2StmKB+f2m2N4SZu9gT82jg8I41du5wDhCF7drK3AMy6wLmfhqpxJZwuwZifvWyetpAtkrHwoIqj01LmfbmleGcybVlXF03cTOXG0OgulDug3k14kmQhWZq/ur+/Ir2KipJxXKxLkDfl/3JRASy8EQifIYy/4uFEcz/6PAzfEDv7ZG7vEPEPMsQsAWPp vagrant@master.example.edu" \
>> /home/vagrant/.ssh/authorized_keys
sudo systemctl restart sshd
SCRIPT

Vagrant.configure("2") do |config|

 config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.customize ["modifyvm", :id, "--memory", "512", "--cpus", "1"]
  end

 config.vm.define "master" do |m|
    m.vm.box = "centos/7"
    m.vm.hostname = "master.example.edu"
    m.vm.network :private_network, ip: "192.168.10.2", netmask: "255.255.255.0"
    m.vm.provision "file", source: "private_key", destination: "~/.ssh/id_rsa"
    m.vm.provision "shell", inline: "sudo chmod 0400 ./.ssh/id_rsa"
    m.vm.provision "shell", inline: "sudo yum install vim -y"
    m.vm.provision "shell", inline: "sudo yum install ansible -y"
    m.vm.provision "shell", inline: "sudo yum install lynx -y"
  end

 config.vm.define "front" do |f|
   f.vm.box = "centos/7"
   f.vm.hostname = "front.example.edu"
   f.vm.network :private_network, ip: "192.168.10.3", netmask: "255.255.255.0"
   f.vm.provision "shell", inline: $cat
   
 
 end

 config.vm.define "back" do |b|
   b.vm.box = "centos/7"
   b.vm.hostname = "back.example.edu"
   b.vm.network :private_network, ip: "192.168.10.4", netmask: "255.255.255.0"
   b.vm.provision "shell", inline: $cat
 end

 config.vm.define "back2" do |b|
  b.vm.box = "centos/7"
  b.vm.hostname = "back2.example.edu"
  b.vm.network :private_network, ip: "192.168.10.5", netmask: "255.255.255.0"
  b.vm.provision "shell", inline: $cat
  
end
 config.vm.define "db" do |db|
   db.vm.box = "centos/7"
   db.vm.hostname = "back.example.edu"
   db.vm.network :private_network, ip: "192.168.10.6", netmask: "255.255.255.0"
   db.vm.provision "shell", inline: $sed
   end
  
end
