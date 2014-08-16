class Sites < StationModule

    attr_accessor :path, :installing

    def initialize(config, args, module_path)
      super
      @path = "#{File.dirname(__FILE__)}"
      @installing = ENV.has_key?('INSTALL')
    end

    def sites_available(site)

      # compile fastcgi params
      fastcgi = args["defaults"]["fastcgi"]
      if site.has_key?("fastcgi") && !site["fastcgi"].empty?
          fastcgi = fastcgi.deep_merge(site["fastcgi"])
      end

      # compile php value overrides
      php_values = args["defaults"]["php-values"] ||= {}
      if site.has_key?("php-values") && !site["php-values"].empty?
          php_values = php_values.deep_merge(site["php-values"])
      end

      # Create the server template
      template = File.read(path + "/templates/server.erb")
      result = ERB.new(template).result(binding)

      # Add site to nginx
      config.vm.provision "shell" do |s|
          s.inline = "bash #{scripts}/server.sh $1 $2 \"$3\""
          s.args = [site["map"], site["to"], result]
      end

    end

    def git_clone(name, url, path)

      # Set installing var as true
      @installing = true if Dir.exists?(path)

      # Clone the site
      config.vm.provision "shell" do |s|
          s.inline = "bash #{scripts}/clone.sh $1 $2 \"$3\""
          s.args = [name, url, path]
      end

    end

    # @param [Object] vars
    def dot_env(vars, path)

      env_path = path + '/.env'

      config.vm.provision 'shell' do |s|
          s.inline = "if [ ! -f #{env_path} ]; then touch #{env_path} ; else echo '' > #{env_path} ; fi"
      end

      unless vars.empty?
        vars.each do |key, value|
          config.vm.provision "shell" do |s|
            s.inline = "echo \"$1 = '$2'\" >> #{env_path}"
            s.args = [key, value]
          end
        end
      end
    end

  def commands_exec(commands, path)

    # install commands
    install = commands["install"] ||= []
    # update commands
    update = commands["update"] ||= []
    # always commands
    always = commands["always"] ||= []
    # override commands var
    commands = $station.module('Commands')

    if installing && !install.empty?
      install.each do |cmd|
        commands.execute(cmd, path)
      end
    elsif !update.empty?
      update.each do |cmd|
        commands.execute(cmd, path)
      end
    elsif !always.empty?
      always.each do |cmd|
        commands.execute(cmd, path)
      end
    end

  end

  def provision

    args["sites"].each do |site|

      if site["git-clone"] && site["git-clone"]["path"]
        base_path = site["git-clone"]["path"]
      else
        base_path = site["to"]
      end

      # install configured nginx sites
      sites_available(site)

      # install/clone git repository
      if site["git-clone"] && site["git-clone"]["url"]
          git_clone(name ||= "", site["git-clone"]["url"], base_path)
      end

      # Add php environment variables
      dot_env(site['env-vars'] ||= [], base_path)

      # Run commands in installed site
      commands_exec(site["commands"] ||= {}, base_path)

    end

  end
end