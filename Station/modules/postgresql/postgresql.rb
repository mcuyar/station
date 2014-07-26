class Postgresql

    attr_accessor :config, :args, :scripts

    def initialize(config, args, module_path)
        @config = config
        @args = args
        @scripts = module_path + "/scripts"
    end

    def contrib(version)
        @config.vm.provision "shell" do |s|
            s.inline = "sudo apt-get -y install postgresql-contrib-#{version}"
        end
    end

    def createDb(name, user)
        @config.vm.provision "shell" do |s|
             s.inline = "bash #{@scripts}/db-create.sh $1 $2"
             s.args = [user, name]
        end
    end

    def createUser(username)
        @config.vm.provision "shell" do |s|
             s.inline = "bash #{@scripts}/user-create.sh $1"
             s.args = username
        end
    end

    def updateUserPassword(username, password)
        @config.vm.provision "shell" do |s|
             s.inline = "bash #{@scripts}/user-password.sh $1 $2"
             s.args = [username, password]
        end
    end

    def provision

        # Install postgresql contrib
        if (args.has_key?("contrib") && args['contrib']["install"] == true)
            contrib(args["contrib"]["version"] ||= 9.3)
        end

        # Install databases
        if (args.has_key?("databases") && !args["databases"].empty?)
            args["databases"].each do |db|

                #create user
                if (db.has_key?("user") && db.has_key?("password"))
                    createUser(db["user"])
                    updateUserPassword(db["user"], db["password"])
                end

                if (db.has_key?("name"))
                     #@user = db["user"] ||= 'homestead'
                     #createDb(db["name"], @user)
                end

            end
        end

    end
end