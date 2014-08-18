class Station

  @@modules = Hash.new

  def self.configure(config, settings, path)

    Homestead.configure(config, settings)

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
        settings[basename].kind_of?(Array) ?
            args = args.deep_merge({basename => settings[basename]}) :
            args = args.deep_merge(settings[basename])
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