# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant-berkshelf'
require 'vagrant-omnibus'
require 'vagrant-cachier'

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "vagrant-drupal-cookbook"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "raring64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: "33.33.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.

  # config.vm.network :public_network

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
   config.vm.synced_folder "~/Public", "/Public"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider :virtualbox do |vb|
     # Don't boot with headless mode
     #vb.gui = true
  
     vb.name= "drupal-cookbook"
     # Use VBoxManage to customize the VM. For example to change memory:
     #vb.customize ["modifyvm", :id, "--memory", "256"]
   end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  #config.ssh.max_tries = 40
  #config.ssh.timeout   = 120
   if Vagrant.has_plugin?("vagrant-cachier")
     # Configure cached packages to be shared between instances of the same base box.
     # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
     config.cache.scope = :box

     # If you are using VirtualBox, you might want to use that to enable NFS for
     # shared folders. This is also very useful for vagrant-libvirt if you want
     # bi-directional sync
     config.cache.synced_folder_opts = {
       type: :nfs,
       # The nolock option can be useful for an NFSv3 client that wants to avoid the
       # NLM sideband protocol. Without this option, apt-get might hang if it tries
       # to lock files needed for /var/cache/* operations. All of this can be avoided
       # by using NFSv4 everywhere. Please note that the tcp option is not the default.
       mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
     }
     # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
   end

   # Setup locales
   config.vm.provision "shell",
     inline: "sudo locale-gen en_US.UTF-8"

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.data_bags_path = "data_bags"
    chef.roles_path = "roles"
    chef.cookbooks_path = ["site-cookbooks"]

    chef.json = {
      :drupal => {
        :user => "vagrant"
      },
      :mysql => {
        :server_root_password => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password => 'replpass'
      }
    }

    chef.run_list = [
      "recipe[drupal::default]",
      "recipe[drupal::drush]",
      "recipe[drupal::buildbot]"

      ## The varnish recipe needs a drupal site attribute.
      #"recipe[drupal::varnish]",

      # Add role with low specs customization.
      #"role[spec-low]"
    ]
  end

end

