class Station

    attr_accessor :config, :settings

    @@modules = Hash.new

    def initialize(config, args)
        @config = config
        @settings = args

        # Get the modules directory
        @modules = Dir.glob($path + '/Station/modules/*').select {|f| File.directory? f}

        @modules.each do |m|

            @basename = File.basename(m)

            # Load the config file
            @args = YAML::load(File.read( m + '/config.yaml'))
            @classname = @args["classname"]

            # Merge settings with default config
            if (@settings.has_key?(@basename) && !@settings[@basename].empty?)
                @args = @args.deep_merge(@settings[@basename])
            end

            # run the module provisioner
            require m + "/#{@basename}.rb"
            m.sub! $path, '/vagrant'
            @class = Kernel.const_get(@classname).new(config, @args, m)
            @@modules[@classname] = @class

        end

    end

    def modules
        return @@modules
    end

    def module(classname)
        return @@modules[classname]
    end

    def provision
        @@modules.each do |name, object|
            object.provision
        end
    end
end