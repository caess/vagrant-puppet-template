# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :box do |box|
    box.vm.box = "box"
    box.vm.host_name = 'box.example.com'
    box.vm.network :hostonly, "192.168.0.2"
    
    box.vm.provision :puppet, :options => '--verbose --environment development' do |puppet|
      puppet.module_path = ["puppet-repo/modules"]
      puppet.manifests_path = "puppet-repo/manifests"
      puppet.manifest_file = "site.pp"
    end
  end
end
