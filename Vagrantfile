# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision "shell",privileged: false, inline: <<-SHELL
  sudo apt update
  sudo apt upgrade
  sudo apt install -y nginx lynx vim git
  SHELL
end
