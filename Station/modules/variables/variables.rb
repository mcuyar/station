class Variables < StationModule

  attr_accessor :path

    def initialize(config, args, module_path, station)
      super
      @path = "#{File.dirname(__FILE__)}"
    end

  def env_var(key, value = nil)
    key.each do |k,v|
      shell_provision(
          "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf",
          [k, v]
      )
    end
    shell_provision("service php5-fpm restart")
  end

  def format_vars(vars)

    if(vars.is_a?(Hash))
      return vars
    end

    new = {}
    vars.each do |var|
      new[var["key"]] = var["value"]
    end
    new

  end

  def set_variables(variables)

    # Create the template
    template = File.read(path + "/templates/variables.erb")
    result = ERB.new(template, nil, '>').result(binding)

    # Add template to php-fpm directory
    script = %{
      echo '#{result}' > "/etc/php5/fpm/station.conf";
    }

    shell_provision(script)

  end

  def get_exports(variables)
    # Create the template
    template = File.read(path + "/templates/export.erb")
    result = ERB.new(template, nil, '>').result(binding)
  end

  def set_shell_variables(variables)

    shell_provision("bash #{@scripts}/export.sh")

    # Add template to vagrant home directory
    script = %{
      echo '#{get_exports(variables)}' > "$(sudo -u vagrant pwd)/envars";
    }

    shell_provision(script)

  end

  def provision

    # Configure All Of The Server Environment Variables
    shell_provision("bash #{@scripts}/variables.sh")

    defaults = format_vars(args["defaults"] ||= {})
    args.delete('defaults')

    set_variables(
      defaults.merge(format_vars(args))
    )

    set_shell_variables(
       defaults.merge(format_vars(args))
    )

  end

end