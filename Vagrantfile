Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.network "forwarded_port", guest: 443, host: 3443 

  config.vm.provider :virtualbox do |vb|
    # suggested fix for slow network performance
    # see https://github.com/mitchellh/vagrant/issues/1807
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	vb.memory = 2200 
  end


  config.vm.synced_folder ENV['IDPInstallerBase'] , "/installer"

  config.vm.provision "shell", path: "doProvisioning.sh"
end
