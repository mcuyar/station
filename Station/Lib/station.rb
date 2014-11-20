class Station

  @@modules = Hash.new

  def self.configure(config, settings, path)

    # Configure The Box
    config.vm.box = settings["box"] ||= "laravel/homestead"
    config.vm.hostname = settings["hostname"] ||= "station"

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Configure Port Forwarding To The Box
    config.vm.network "forwarded_port", guest: 80, host: settings["forwarded_ports"]["http"] ||= 8000
    config.vm.network "forwarded_port", guest: 3306, host: settings["forwarded_ports"]["mysql"] ||= 33060
    config.vm.network "forwarded_port", guest: 5432, host: settings["forwarded_ports"]["postgresql"] ||= 54320

    # Get the modules directory
    modules = Dir.glob(path + '/Station/modules/*').select { |f| File.directory? f }

    # loop through and initialize the modules
    modules.each do |m|

      basename = File.basename(m)

      # Load the config file
      args = YAML::load(File.read(m + '/config.yaml'))
      classname = args["classname"]

      # Merge settings with default config
      if settings.find?(basename)
        if settings[basename].kind_of?(Array)
          args = args.deep_merge({basename => settings[basename]})
        elsif settings[basename].kind_of?(Hash)
          args = args.deep_merge(settings[basename])
        elsif settings[basename].kind_of?(String)
          args = settings[basename];
        end
      end

      # run the module provisioner
      require m + "/#{basename}.rb"
      m.sub! path, '/vagrant'
      @@modules[basename] = Kernel.const_get(classname).new(config, args, m)

    end

  end

  def self.modules
    @@modules
  end

  def self.module(classname)
    @@modules.find?(classname)
  end

  def self.provision
    if ENV.has_key?('MODULE') && @@modules.has_key?(ENV['MODULE'])
      @@modules[ENV['MODULE']].provision
    else
      @@modules.each do |name, object|
        object.provision
      end
    end
  end

end