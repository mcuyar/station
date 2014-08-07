class ElasticBeanstalk

    attr_accessor :config, :args, :scripts

    def initialize(config, args, module_path)
        @config = config
        @args = args
        @scripts = module_path + "/scripts"
    end

    def provision
        if (args["install"] == true)
            config.vm.provision "shell" do |s|
                s.inline = "bash #{@scripts}/elasticbeanstalk.sh $1 $2 $3"
                s.args = [args["version"], args["access"]["key"], args["access"]["secret"]]
            end
        end
    end
end