class Variables < StationModule

  def env_var(key, value)
    shell_provision(
        "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf && service php5-fpm restart",
        [key, value]
    )
  end

  def provision
    # Configure All Of The Server Environment Variables
    args.find?('variables', []).each do |var|
      env_var(var["key"], var["value"])
    end
  end

end