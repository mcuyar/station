class GitConfig
    def GitConfig.provision(config, args, module_path)
        # Git config setup
        config.vm.provision "shell" do |s|
            s.inline = "bash #{module_path}/scripts/git-config.sh \"$1\" $2 $3 $4"
            s.args = [args["name"], args["email"], args["colors"], args["push_default"]]
        end
    end
end