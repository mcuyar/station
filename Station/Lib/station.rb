class Station

    def Station.configure(config, settings)
        # Configure The Box
        config.vm.hostname = settings["hostname"] ||= "station"

        # Configure Port Forwarding To The Box
        config.vm.network "forwarded_port", guest: 80, host: settings["forwarded_ports"]["http"] ||= 8000
        config.vm.network "forwarded_port", guest: 3306, host: settings["forwarded_ports"]["mysql"] ||= 33060
        config.vm.network "forwarded_port", guest: 5432, host: settings["forwarded_ports"]["postgresql"] ||= 54320
    end

    def Station.provision(config, settings)

        # Install All The Configured Nginx Sites
        settings["sites"].each do |site|
          config.vm.provision "shell" do |s|
              s.inline = "bash /vagrant/Station/scripts/serve.sh $1 $2"
              s.args = [site["map"], site["to"]]
          end
        end

    end
end