class Sites

    attr_accessor :config, :args, :scripts, :path, :defaults

    def initialize(config, args, module_path)
        @config = config
        @args = args
        @scripts = module_path + "/scripts"
        @path = "#{File.dirname(__FILE__)}"
        @installing = ENV.has_key?('INSTALL')
    end

    def serve(site)

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
            # install configured nginx sites
            serve(site)

            # install/clone git repository


            # Run commands in installed site
            commandsExec(site["commands"] ||= [], site["git-clone"]["path"] ||= site["to"])
        end

    end
end