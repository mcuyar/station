class Postgresql

    def Postgresql.contrib(config, version)
        config.vm.provision "shell" do |s|
            s.inline = "sudo apt-get -y install postgresql-contrib-#{version}"
        end
    end

    def Postgresql.provision(config, args, module_path)

        # Install postgresql contrib
        if (args.has_key?("contrib") && args['contrib']["install"] == true)
            contrib(config, args["contrib"]["version"] ||= 9.3)
        end

    end
end