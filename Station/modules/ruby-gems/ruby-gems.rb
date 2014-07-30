class RubyGems

    attr_accessor :config, :args, :scripts

    def initialize(config, args, module_path)
        @config = config
        @args = args
        @scripts = module_path + "/scripts"
    end

    def installRubyDev
        @config.vm.provision "shell" do |s|
            s.inline = "sudo apt-get -y install ruby-dev"
        end
    end

    def installBundler

    end

    def installGem(gem)
        config.vm.provision "shell" do |s|
            s.inline = "sudo gem install #{gem}"
        end
    end

    def installGem(gem)
        @config.vm.provision "shell" do |s|
            s.inline = "sudo gem install #{gem}"
        end
    end

    def provision

        # Install ruby-dev & bundler
        if (args.has_key?("install"))
            @install = args["install"]

            if(@install["ruby-dev"] == true)
                installRubyDev
            end

            if(@install["bundler"] == true)
                installBundler
            end
        end

        # install ruby gems
        if (args.has_key?("gems") !args["gems"].empty?)
            args["gems"].each do |gem|
                installGem
            end
        end
    end
end