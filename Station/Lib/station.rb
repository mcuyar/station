class Station
    def Station.provision(config, settings)
        # Get the modules directory
        @modules = Dir.glob($path + '/Station/modules/*').select {|f| File.directory? f}

        @modules.each do |m|

            @basename = File.basename(m)

            # Load the config file
            @config = YAML::load(File.read( m + '/config.yaml'))
            @classname = @config["classname"]

            # Merge settings with default config
            if (settings.has_key?(@basename) && !settings[@basename].empty?)
                @config.deep_merge(settings[@basename])
            end

            # run the module provisioner
            require m + "/#{@basename}.rb"
            m.sub! $path, '/vagrant'
            Module.const_get(@classname).provision(config, settings, m)

        end

    end
end