class KnownHosts

    attr_accessor :config, :args, :scripts

    def initialize(config, args, module_path)
        @config = config
        @args = args
        @scripts = module_path + "/scripts"
    end

    def addDomain(domain)
        @config.vm.provision "shell" do |s|
             s.inline = "bash #{@scripts}/add-domain.sh #{domain}"
        end
    end

    def provision

        # Add known hosts
        if (args.has_key?("domains") && !args["domains"].empty?)
            args["domains"].each do |domain|
                addDomain(domain)
            end
        end

    end
end