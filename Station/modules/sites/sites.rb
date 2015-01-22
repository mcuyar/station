class Sites < StationModule

    attr_accessor :path, :installing

    def initialize(config, args, module_path)
      super
      @path = "#{File.dirname(__FILE__)}"
      @installing = ENV.has_key?('INSTALL')
    end

    def sites_available(site)

      # compile fastcgi params
      hhvm_restart = ''
      if site.find?('hhvm', false) && site['hhvm'] === true
        hhvm_restart = 'service hhvm restart;'
        fastcgi = args["defaults"]["fastcgi-hhvm"]
      else
        fastcgi = args["defaults"]["fastcgi-server"]
      end

      if site.has_key?("fastcgi") && !site["fastcgi"].empty?
          fastcgi = fastcgi.deep_merge(site["fastcgi"])
      end

      # compile php value overrides
      php_values = args["defaults"]["php-values"] ||= {}
      if site.has_key?("php-values") && !site["php-values"].empty?
          php_values = php_values.deep_merge(site["php-values"])
      end

      # add xdebug values
      site.find?('xdebug', []).each do |key, value|
        php_values["xdebug.#{key}"] = value
      end

      # add environment variables
      variables = args["defaults"]["variables"] ||= {}
      if site.has_key?("variables") && !site["variables"].empty?
        variables = variables.deep_merge(site["variables"])
      end

      # Create the server template
      template = File.read(path + "/templates/server.erb")
      result = ERB.new(template).result(binding)

      # Add site to nginx
      script = %{
        echo "#{result}" > "/etc/nginx/sites-available/#{site["map"]}";
        ln -fs "/etc/nginx/sites-available/#{site["map"]}" "/etc/nginx/sites-enabled/#{site["map"]}";
        service nginx restart;
        service php5-fpm restart;
        #{hhvm_restart}
      }

      shell_provision(script)

    end

    def git_clone(name, url, path)

      # Set installing var as true
      @installing = true if Dir.exists?(path)

      # Clone the site
      shell_provision(
          "bash #{scripts}/clone.sh $1 \"$2\" $3",
          [name, url, path]
      )

    end

    # @param [Object] vars
    def env_vars(vars)

      config.vm.provision 'shell' do |s|
          s.inline = "if [ ! -f #{env_path} ]; then touch #{env_path} ; else echo '' > #{env_path} ; fi"
      end

      shell_provision(
          "if [ ! -f #{env_path} ]; then touch #{env_path} ; else echo '' > #{env_path} ; fi"
      )

      unless vars.empty?
        vars.each do |key, value|
          shell_provision(
              "echo \"$1 = '$2'\" >> #{env_path}",
              [key, value]
          )
        end
      end
    end

  def commands_exec(commands, path)

    if installing
      # install commands
      commands.find?('install', []).each do |cmd|
        Station.module('commands').execute(cmd, path)
      end
    else
      # update commands
      commands.find?('update', []).each do |cmd|
        Station.module('commands').execute(cmd, path)
      end
    end

    # always commands
    commands.find?('always', []).each do |cmd|
      Station.module('commands').execute(cmd, path)
    end

  end

  def create_db(db)
    case db.find?('type', '')
      when "mysql"
        Station.module('mysql').create(db)
      when "postgresql"
        Station.module('postgresql').create(db)
      else
        Station.module('mysql').create(db)
        Station.module('postgresql').create(db)
    end
  end

  def provision

    args.find?('sites', []).each do |site|

      base_path = site.find?('git-clone.path', site["to"])

      # install configured nginx sites
      sites_available(site)

      # install/clone git repository
      url = site.find?('git-clone.url')
      if url
          git_clone(site.find?('git-clone.name', ''), url, base_path)
      end

      # Add site db
      db = site.find?('db')
      if db
        create_db(db)
      end

      # Run commands in installed site
      commands_exec(site.find?('commands', {}), base_path)

      # Add git config variables
      Station.module('git-config').fill(site.find?('git-config', {},), false, base_path)

    end

  end
end