class GitConfig
    attr_accessor :config, :args, :scripts

    def initialize(config, args, module_path)
        @config = config
        @args = args
        @scripts = module_path + "/scripts"
    end

    def provision

        # Git config setup
        @config.vm.provision "shell" do |s|
            s.inline = "bash #{@scripts}/git-config.sh \"$1\" $2 $3 $4"
            s.args = [@args["name"], @args["email"], @args["colors"], @args["push_default"]]
        end
    end
end