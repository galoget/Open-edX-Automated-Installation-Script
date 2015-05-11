#!/bin/bash

echo '*******************************************************************'
echo '*                                                                 *'
echo '*         _ __  __  This script allows you to install Open edX    *'
echo '*   _   _| |\ \/ /  in an easy and automated way!!  =D            *'
echo '* / -_) _` | >  <   This program is distributed in the hope that  *'
echo '* \___\__,_|/_/\_\  it will be useful, but WITHOUT ANY WARRANTY,  *'
echo '*                   please check the LICENSE for more details.    *'
echo '*                                                                 *'
echo '* The author do not take any responsibility for any damage        *'
echo '* (or loss of data) caused through use of this script, be it      *'
echo '* indirect, special, incidental or consequential damages          *'
echo '* (including but not limited to damages for loss of business,     *'
echo '* loss of profits, interruption or the like).                     *'
echo '*                                                                 *'
echo '* Open edX Automated Installation Script                          *'
echo '* Author: Galoget Latorre                                         *'
echo '* Organization: Hackem Research Group                             *'
echo '* Creation Date: April 25, 2015                                   *'
echo '* Last Release: May 11, 2015                                      *'
echo '* Version: 1.0.1                                                  *'
echo '*                                                                 *'
echo '*******************************************************************'


#Replace software sources from EC to US
sudo sed -i 's/ec.archive/us.archive/g' /etc/apt/sources.list

#Update & Upgrade the system
sudo apt-get update -y
sudo apt-get upgrade -y

####Installing Dev Tools####

#Install vim & curl
sudo apt-get install vim curl -y

#Install Google Chrome
sudo apt-get install libappindicator1 libdbusmenu-gtk4 libindicator7 libxss1 -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

#NO se utilizan los repos por tener versiones antiguas

#Install Virtualbox
wget http://dlc-cdn.sun.com/virtualbox/4.3.26/virtualbox-4.3_4.3.26-98988~Ubuntu~raring_amd64.deb
sudo dpkg -i virtualbox-4.3_4.3.26-98988~Ubuntu~raring_amd64.deb
rm virtualbox-4.3_4.3.26-98988~Ubuntu~raring_amd64.deb

#Install Vagrant
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
sudo dpkg -i vagrant_1.7.2_x86_64.deb
rm vagrant_1.7.2_x86_64.deb

#In some distributions you can use the following commands to install VirtualBox and Vagrant with apt-get:
#Installing VirtualBox, DKMS and Vagrant
#sudo apt-get install virtualbox-4.3 virtualbox-dkms -y  ##WARNING, Check the minimun version of the packages required for Open edX
#sudo apt-get install vagrant -y

#Set OPENEDX_RELEASE variable - Before installing the Vagrant box, you must set the value of the OPENEDX_RELEASE environment variable to the Git tag for the Birch release:
export OPENEDX_RELEASE="named-release/birch"

#Go to Dekstop and create fullstack folder, then go inside that folder
cd ~/Desktop/
mkdir fullstack
cd fullstack

#Download lastest Vagrantfile from github
curl -L https://raw.githubusercontent.com/edx/configuration/master/vagrant/release/fullstack/Vagrantfile > Vagrantfile

#Fix errors in Vagrantfile in order to use Birch
sed -i 's/kifli-fullstack/birch-fullstack/g' Vagrantfile
sed -i 's/20140826-kifli-fullstack.box/20150224-birch-fullstack.box/g' Vagrantfile

#You can download openEdx birch fullstack box from here:
# wget https://s3.amazonaws.com/edx-static/vagrant-images/20150224-birch-fullstack.box

#Downgrading the machine (It depends on the hardware)
sed -i 's/MEMORY = 4096/MEMORY = 2048/g' Vagrantfile
sed -i 's/CPU_COUNT = 2/CPU_COUNT = 1/g' Vagrantfile

#Enable VBox GUI
echo -e "\nVagrant.configure(VAGRANTFILE_API_VERSION) do |config|" >> Vagrantfile
echo -e "  config.vm.provider :virtualbox do |vb|" >> Vagrantfile
echo -e "    vb.gui = true" >> Vagrantfile
echo -e "  end" >> Vagrantfile
echo -e "end" >> Vagrantfile


#Required Libraries for Bundle Install (in some distros like Linux Mint Debian Edition)
#sudo apt-get install ruby2.1-dev zlib1g-dev -y
#More info: http://www.nokogiri.org/tutorials/installing_nokogiri.html

#Gems required:
#sudo gem install ffi -v '1.9.8'
#sudo gem install nokogiri -v '1.6.6.2'

#Install Vagrant plugin
vagrant plugin install vagrant-hostsupdater

#Starts Birch Machine
vagrant up

#To shutdown the machine use: vagrant halt

#Go to preview.localhost, which is an alias entry for 192.168.33.10 that was created in /etc/hosts file.
#Also you can use this IP address:
#192.168.33.10:18010
#192.168.33.10

#edx -> username & password
