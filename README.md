# Setup

This vagrant harness allows you to rapidly test your IdP-Installer build from your host machine with a centos/7 guest host.

## Onetime Setup steps

1. Install Vagrant: https://www.vagrantup.com/downloads.html
1. Install VirtualBox: https://www.virtualbox.org/

## Preconditions

1. You have done a download or git clone of the IdP Installer
1. You have set an environment variable for the 'share' into the VM:

```
export IDPInstallerBase=/Users/yourname/Documents/idp-installer-CAF
```
:exclamation:
```
If you do not have the export above, you will see an error like this on vagrant up:
Bringing machine 'default' up with 'virtualbox' provider...
/opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/kernel_v2/config/vm.rb:621:in `initialize': no implicit conversion of nil into String (TypeError)
	from /opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/kernel_v2/config/vm.rb:621:in `new'
	from /opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/kernel_v2/config/vm.rb:621:in `block in validate'
	from /opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/kernel_v2/config/vm.rb:616:in `each'
. . snip . .
```
 
1. You have created an IdP-Installer 'config' file per the instructions and placed it in the above folder
1. You have reviewed the Vagrantfile for the appropriate remapped ports to know what to invoke for testing

## Launching the image
1. OPTIONAL: if you want to capture the output of everything to review at a later time, use the script command (unix/mac):
```
script run.txt
```
(type exit to end the script capturing all output)

1. Start the container (first time may require good bandwidth to download the initial image)
``` 
vagrant up --provider=virtualbox
```
1. verify the installation completed by checking the idp status page:
```
https://localhost:3443/idp/status
```

1. ssh into the host post installation and adjust as necessary 
```
vagrant ssh
```

## Iterative adjustments

1. If you are iterating over a particular change, the easiest way is to destroy the container and let the test doProvision.sh script do the work
```
vagrant destroy
```
answer 'Y'

1. repeat the vagrant up step with your adjustment to the code base or configuration
```
vagrant up
```
(this is abreviated since the provider is implied after the provisioning step )
