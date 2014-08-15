class Commands

    attr_accessor :config, :args, :scripts

    def initialize(config, args, module_path)
        @config = config
        @args = args
        @scripts = module_path + "/scripts"
    end

    def execute(command, path)
        config.vm.provision "shell" do |s|
            s.inline = "bash #{@scripts}/commands.sh $1 \"$2\""
            s.args = [path, command]
        end
    end

    def provision
        if (@args.has_key?("commands") && !@args["commands"].empty?)
            @args["commands"].each do |cmd|
                execute(cmd, "~/")
            end
        end
    end
end