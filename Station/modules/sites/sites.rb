class Sites

    attr_accessor :config, :args, :scripts, :path, :defaults

    def initialize(config, args, module_path)
        @config = config
        @args = args
        @scripts = module_path + "/scripts"
        @path = "#{File.dirname(__FILE__)}"
        @installing = ENV.has_key?('INSTALL')
    end

    def sitesAvailable(site)

        # compile fastcgi params
        fastcgi = @args["defaults"]["fastcgi"]
        if (site.has_key?("fastcgi") && !site["fastcgi"].empty?)
            fastcgi = fastcgi.deep_merge(site["fastcgi"])
        end

        # compile php value overrides
        php_values = @args["defaults"]["php-values"] ||= {}
        if (site.has_key?("php-values") && !site["php-values"].empty?)
            php_values = php_values.deep_merge(site["php-values"])
        end

        # Create the server template
        template = File.read(@path + "/templates/server.erb")
        result = ERB.new(template).result(binding)

        # Add site to nginx
        config.vm.provision "shell" do |s|
            s.inline = "bash #{@scripts}/server.sh $1 $2 \"$3\""
            s.args = [site["map"], site["to"], result]
        end

    end

    def gitClone(name, url, path)
        if (clone)

            # Set installing var as true
            if (Dir.exists?(clone["path"]))
                @installing = true
            end

            # Clone the site
            config.vm.provision "shell" do |s|
                s.inline = "bash #{@scripts}/clone.sh $1 $2 \"$3\""
                s.args = [name, url, path]
            end

        end
    end

    def dotEnv(vars, path)

        @env_path = path + "/.env"

        config.vm.provision "shell" do |s|
            s.inline = "if [ ! -f #{@env_path} ]; then touch #{@env_path} ; else echo '' > #{@env_path} ; fi"
        end

        if (!vars.empty?)
            vars.each do |key, value|
                config.vm.provision "shell" do |s|
                    s.inline = "echo \"$1 = '$2'\" >> #{@env_path}"
                    s.args = [key, value]
                end
            end
        end
    end

    def commandsExec(commands, path)

        @commands = $station.module('Commands')
        @install = commands["install"] ||= []
        @update = commands["update"] ||= []
        @always = commands["always"] ||= []

        # Run install commands
        if (@installing && !@install.empty?)
            @install.each do |cmd|
                @commands.execute(cmd, path)
            end
        end

        # Run update commands
        if (!@installing && !@update.empty?)
            @update.each do |cmd|
                @commands.execute(cmd, path)
            end
        end

        # Run always commands
        if (@always && !@always.empty?)
            @always.each do |cmd|
                @commands.execute(cmd, path)
            end
        end

    end

    def provision

        @args["sites"].each do |site|

            @base_path = site["git-clone"]["path"] ||= site["to"]

            # install configured nginx sites
            sitesAvailable(site)

            # install/clone git repository
            if(site["git-clone"]["url"])
                gitClone(name ||= "", site["git-clone"]["url"], @base_path)
            end

            # Add php environment variables
            dotEnv(site['env-vars'] ||= [], @base_path)

            # Run commands in installed site
            commandsExec(site["commands"] ||= [], @base_path)

        end

    end
end