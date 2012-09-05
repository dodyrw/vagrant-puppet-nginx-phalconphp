Vagrant + Puppet + nginx example
================================

Prerequisites
-------------

* [VirtualBox](http://www.virtualbox.org)
* [Vagrant](http://www.vagrantup.com). The [vagrant-vbguest plugin](http://blog.carlossanchez.eu/2012/05/03/automatically-download-and-install-virtualbox-guest-additions-in-vagrant/) is also nice to have

Usage
-----

1. Clone this repo into some directory and cd into it
2. Edit the Vagrantfile. The only thing that might need changing is the shared source folder. Have it point to some folder on your host machine that contains an index.php file.
3. vagrant up
4. Visit http://localhost:8080
5. SSH to localhost:2222 (or just do "vagrant ssh" if you have a decent host machine like Linux)

Troubleshooting
---------------

Windows host machines can have some problems. It is always a good idea to enable GUI booting in the Vagrantfile for troubleshooting.

* VirtualBox fails to start the guest VM and complains about "host incompatibility". This has to do with some virtualization feature of your processor ("Vt-x" or something like that). VirtualBox needs this feature to be enabled in BIOS so go ahead and reboot now...
* Puppet provisioning fails because the Internet cannot be accessed from within the guest VM. Actually the Internet CAN be accessed but DNS lookups fail. The following trick is needed to get things working:
  1. Stop the guest VM using "vagrant halt"
  2. Open VirtualBox. You should see a VM with a long name such as "vagrant-puppet-nginx_1234245435". Open the settings for the VM and copy the VM name to the clipboard.
  3. Run the following command on the Windows command line, substituting the VM name with yours:
  <pre>
  C:\>"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm "vagrant-puppet-nginx_1234245435" --natdnshostresolver1 on
  </pre>
  4. Start the VM again using "vagrant up"

Hints
-----

* Use "vagrant provision" to re-provision the VM anytime you make a change to the Puppet manifest or module files. Do not change anything manually in the VM!