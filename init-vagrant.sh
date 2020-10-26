#!/bin/bash
SSH_CONFIG_PATH=~/.ssh/config
VAGRANT_CMD=vagrant
VAGRANT_FILE=Vagrantfile
mkdir ubuntu
cd ubuntu
mkdir shared
${VAGRANT_CMD} box add ubuntu/trusty64
${VAGRANT_CMD} init ubuntu/trusty64
${VAGRANT_CMD} up
cp ${VAGRANT_FILE} ${VAGRANT_FILE}-backup
rm ${VAGRANT_FILE}
touch ${VAGRANT_FILE}
cat >> ${VAGRANT_FILE} << EOF
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "shared/", "/home/vagrant/shared"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "4096"
    vb.cpus = "4"
  end
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update
    sudo apt install -y openssh-server
    sudo apt install -y curl apt-transport-https ca-certificates software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce
    sudo apt install -y docker-compose
    sudo usermod -aG docker vagrant
    sudo hostname vagrant
    sudo cp /etc/hostname /etc/hostname.bk
    sudo sed -i 's/vagrant-ubuntu-trusty-64/vagrant/' /etc/hostname
    sudo cp /etc/hosts /etc/hosts.bk
    sudo sed -i 's/localhost/vagrant/' /etc/hosts
  SHELL
end
EOF
${VAGRANT_CMD} reload
echo >> ${SSH_CONFIG_PATH}
${VAGRANT_CMD} ssh-config >> ${SSH_CONFIG_PATH}
echo "Vagrant ssh-config has been added to ${SSH_CONFIG_PATH}"
echo "Please run ${VAGRANT_CMD} ssh to ssh into your VM!"
