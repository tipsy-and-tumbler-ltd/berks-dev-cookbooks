# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # ================================================
  # Universal configuration items.
  # IMPORTANT: Change these.
  # ================================================

  # What extension to use. Should be initials.dsdev.
  developer_initials = 'dp'

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.synced_folder ".", "/var/www/",
    id: "vagrant-root",
    :nfs => {
      # Guest OS NFS Options:
      # The first option ignores file access time writes
      # to speed up NFS. The second forces NFS to refresh
      # its cache of files on every read, preventing an
      # issue where the files sometimes get "stuck" on an
      # old version compared to the Host's copy.
      :mount_options   => ['noatime', 'cto']
    }

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  #config.vm.box_url = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"

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
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

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

  # Standard development machine, linux, apache2, php5.4
  config.vm.define :dsdev do |dsdev|

    server_extension = 'dsdev'
    dsdev.vm.hostname = server_extension

    # Every Vagrant virtual environment requires a box to build off of.
    #config.vm.box = "Berkshelf-CentOS-6.3-x86_64-minimal"
    dsdev.vm.box = "quantal64-current"

    # Assign this VM to a host-only network IP, allowing you to access it
    # via the IP. Host-only networks can talk to the host machine as well as
    # any other machines on the same network, but cannot be accessed (through this
    # network interface) by any external networks.
    dsdev.vm.network :private_network,
      ip: "33.33.33.11",
      nic_type: 'virtio',
      auto_config: true

    # Workaround for above nic setting not working in Vagrant <1.3.0
    # dsdev.vm.provider "virtualbox" do |v|
    #   v.customize ['modifyvm', :id, '--nictype1', 'virtio']
    #   v.customize ['modifyvm', :id, '--nictype2', 'virtio']
    # end

    dsdev.vm.provision :chef_solo do |chef|

      # Additional last-minute configuration
      chef.json = {
        :'dynamic-vhosts' => {
          :server_extension => developer_initials + '.' + server_extension
        }
      }

      # Run jobs to make this into a web server.
      chef.add_recipe "chef-dsdev-recipes::dsdev_standard_server"

    end

  end

  # Global dev mysql server, so we can destroy
  # the web servers without losing dbs, and so
  # we can share the same dbs across different
  # web servers (eg for testing on nginx or
  # different versions of php)
  config.vm.define :dbdev do |dbdev|

    server_extension = 'dbdev'
    dbdev.vm.hostname = server_extension
    dbdev_ip = '33.33.33.41'

    # Every Vagrant virtual environment requires a box to build off of.
    #config.vm.box = "Berkshelf-CentOS-6.3-x86_64-minimal"
    dbdev.vm.box = "quantal64-current"

    # Assign this VM to a host-only network IP, allowing you to access it
    # via the IP. Host-only networks can talk to the host machine as well as
    # any other machines on the same network, but cannot be accessed (through this
    # network interface) by any external networks.
    dbdev.vm.network :private_network,
      ip: dbdev_ip,
      nic_type: 'virtio',
      auto_config: true

    # Workaround for above nic setting not working in Vagrant <1.3.0
    # dsdev.vm.provider "virtualbox" do |v|
    #   v.customize ['modifyvm', :id, '--nictype1', 'virtio']
    #   v.customize ['modifyvm', :id, '--nictype2', 'virtio']
    # end

    # Choose a different password. Use https://www.grc.com/passwords.htm
    # and select from the alpha-numeric category (mysql doesn't always
    # play well with non-alpha-numeric passwords)
    db_password = 'blahblahblah'

    dbdev.vm.provision :chef_solo do |chef|

      # Data bag for configuring attributes for this node.
      chef.json = {
        :mysql => {
          :server_root_password => db_password,
          :server_repl_password => db_password,
          :server_debian_password => db_password,
          :bind_address => dbdev_ip
        },
        :postgresql => {
          :password => {
            :postgres => db_password
          }
        },
        :'chef-dsdev-database' => {
          :db_address => dbdev_ip,
          :host_range => '33.33.33.%'
        }
      }

      chef.add_recipe "chef-dsdev-recipes::dsdev_database_server"

    end

  end

end
