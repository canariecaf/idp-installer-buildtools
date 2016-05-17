Vagrant.configure(2) do |config|

# load our specific settings 
require 'yaml'
globalconfig = YAML.load_file 'globalconfig.yml'
current_dir    = File.dirname(File.expand_path(__FILE__))
mybase = globalconfig['myglobals']['IDPInstallerBase']
fqinstallerpath = "#{current_dir}#{mybase}"

 puts "[buildtools] vagrant portion starting" 
 puts "[buildtools] Vagrant current_dir: #{current_dir}" 
 puts "[buildtools] Fully Qualified Installer Path: #{fqinstallerpath}" 
 

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false
  

#  config.vm.box = "centos/7"
  config.vm.box = "kaorimatz/debian-8.3-amd64"
  config.vm.provision "base",    type: "shell", path: "common/base.sh"


 
 config.vm.define "ldap" do |config|
    config.vm.hostname = "ldap.example.com"
    config.vm.network "private_network", ip: "172.16.80.2"
    config.vm.synced_folder "#{current_dir}" , "/vagrant"
    config.vm.provision "install",   type: "shell", path: "ldap/install.sh"
#    config.vm.provision "debug",     type: "shell", path: "ldap/debug.sh"
    config.vm.provider :virtualbox do |vb|
       vb.customize ["modifyvm", :id, "--memory", "512"]
    end
 end


config.vm.define "sp" do |config|
    config.vm.hostname = "sp.example.com"
    config.vm.network "private_network", ip: "172.16.80.3"
    config.vm.synced_folder "#{current_dir}" , "/vagrant"

 #   config.vm.provision "dev",           type: "shell", path: "sp/dev.sh"
    config.vm.provision "install",       type: "shell", path: "sp/install.sh"
    config.vm.provision "config",        type: "shell", path: "sp/config.sh"
    config.vm.provision "eds",           type: "shell", path: "sp/eds.sh"
    config.vm.provision "sso",           type: "shell", path: "sp/sso.sh",      args: "#{ENV['SSO']}"
    config.vm.provision "metadata-idp", type: "shell", path: "sp/metadata.sh", args: "+ idp https://idp.example.com/idp/shibboleth"
    # specifics for this box are:
    config.vm.provider :virtualbox do |vb|
       vb.customize ["modifyvm", :id, "--memory", "512"]
    end

  end

config.vm.define "idp" do |config|
      config.vm.hostname = "idp.example.com"
      config.vm.network "private_network", ip: "172.16.80.4"
      config.vm.synced_folder "#{fqinstallerpath}" , "/installer"
      config.vm.provision "install",   type: "shell", path: "idp/provision.sh"
      config.vm.provision "metadata", type: "shell", path: "idp/metadata.sh"
      # specifics for this box are:
      config.vm.provider :virtualbox do |vb|
         vb.customize ["modifyvm", :id, "--memory", "2200"]
      end

   end


end
