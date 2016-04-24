#  Buildtool: An IdP-Installer Shibboleth v3 Test Environment

Using the latest [IdP-Installer](https://github.com/canariecaf/idp-installer-CAF/tree/3.0.0-CAF-RC6) this build tool allows you to rapidly deploy a fully functional self contained Shibboleth IdP connecting to it's own local LDAP server and also installs a test SP.

Installation consists of:
- A local private network 172.16.80.0/24 for our hosts
- Automatic updates to your /etc/hosts for:
  - ldap.example.com (172.16.80.2) - LDAP server using openLDAP port 389,636
  - sp.example.com (172.16.80.3)   - Apache2 port 80,443 with mod_shib
  - idp.example.com (172.16.80.4)  - Shibboleth IdP v3, port 443 and connects to LDAP over port 636


URL to invoke to test sign on in your browser (after installation):
- https://sp.example.com/secure-all

Example users / passwords to use: 
  - alice / wonderland
  - bob / wonderland 

## How this works
There are three main steps:
1. Prepare you host system (mac/pc/linux) to have the right Vagrant components.
2. Bootstrap some preliminary config for said components.
3. Provision the machines.

Once machines are provisioned you can tweak things by ssh'ing into them (vagrant ssh [ldap|idp|sp]) or even manually destroying and reprovisioning one. The script ``provision.sh`` does this work if you would like to peek under the hood.


# Preparing your system
## Required Software Tools

Common to Mac and Windows:

1. Install Vagrant: https://www.vagrantup.com/downloads.html
1. Install VirtualBox: https://www.virtualbox.org/
1. Install Git client: https://desktop.github.com/

Windows Specific:

1. Install cygwin: https://cygwin.com

:exclamation:

``` 
Note that in the default cygwin installation does not install certain packages by default. 
Please make sure these are available (use search for each to find them):
 
- git - git client 
- curl - http client
- unzip - client to unzip items
```

# Getting Started

## Fetch this repository
Git clone this repository to your machine:
```
git clone https://github.com/canariecaf/idp-installer-buildtools
```

## Preparing Your Environment 

**RUN ONCE PER HOST:** 

Execute script to install vagrant hostmanager plugin which also modifies the `sudoers` file of your host to grant vagrant/hostmanager access to dynamically manipulate the `hosts` file on your host.

```
    $ ./install-vagrant-plugins.sh
````

 **RUN ONCE PER CLEAN PROJECT:** 

Execute bootstrap script to stage sources needed in the SP and IdP build.

```
    $ ./bootstrap.sh
```

## Performing the Provisioning step

Run script to provision all machines - ldap, sp, idp, in that order.

```
    $ ./provision.sh
```

## Verify the installation completed 
You can verify things by checking the idp status page here in your browser. Accept the self signed certificate for these hosts.

```
https://idp.example.com/idp/status
```

