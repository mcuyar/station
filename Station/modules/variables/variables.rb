class Variables < StationModule

  def env_var(key, value = nil)
    if key.is_a?(Array)
      key.each do |var|
        shell_provision(
            "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf",
            [var["key"], var["value"]]
        )
      end
    elsif key.is_a?(Hash)
      key.each do |k,v|
        shell_provision(
            "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf",
            [k, v]
        )
      end
    end
    shell_provision("service php5-fpm restart")
  end

  def provision
    # Configure All Of The Server Environment Variables
    if args.find?('variables', false)
      env_var(args["variables"])
    end
  end

end