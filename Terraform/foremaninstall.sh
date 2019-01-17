#!/usr/bin/env bash 

sudo apt-get -y install ca-certificates
cd /tmp && wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
sudo dpkg -i /tmp/puppet5-release-xenial.deb

echo "deb http://deb.theforeman.org/ xenial 1.20" | sudo tee /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 1.20" | sudo tee -a /etc/apt/sources.list.d/foreman.list
sudo apt-get -y install ca-certificates
wget -q https://deb.theforeman.org/pubkey.gpg -O- | sudo apt-key add -

sudo apt-get update && sudo apt-get -y install foreman-installer

sudo foreman-installer