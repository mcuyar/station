class Sites

    attr_accessor :config, :args, :scripts, :path, :defaults

    def initialize(config, args, module_path)
        @config = config
        @args = args
        @scripts = module_path + "/scripts"
        @path = "#{File.dirname(__FILE__)}"
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

    def provision
        # install configured nginx sites
        @args["sites"].each do |site|
            serve(site)
        end
    end
end