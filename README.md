#  Buildtool: An IdP-Installer Shibboleth v3 Test Environment

Using the latest [IdP-Installer](https://github.com/canariecaf/idp-installer-CAF/tree/3.0.0-CAF-RC6) this build tool allows you to rapidly deploy a fully functional Shibboleth IdP connecting to it's own local LDAP server along with a test SP.

Installation consists of:
A local private network for 3 hosts on 172.16.80.2, .3, and .4
Automatic updates to your /etc/hosts for these

ldap.example.com (172.16.80.2) - LDAP server using openLDAP port 389,636
sp.example.com (172.16.80.3)   - Apache2 port 80,443 with mod_shib
idp.example.com (172.16.80.4)  - Shibboleth IdP v3, port 443 and connects to LDAP over port 636

Once the software tools and setup process has been done, open this in your browser:

https://sp.example.com/secureall

The example  users / password: 
	alice / wonderland
	bob / wonderland 

# Getting Started
## Required Software Tools

Common to Mac and Windows:
1. Install Vagrant: https://www.vagrantup.com/downloads.html
1. Install VirtualBox: https://www.virtualbox.org/
1. Install Git client: https://desktop.github.com/

Windows Specific:
1. Install cygwin: https://cygwin.com


## Launching the image
1. git clone this repository to your machine:
```
git clone 

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
