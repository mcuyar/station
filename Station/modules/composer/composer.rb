class Composer < StationModule

  attr_accessor :path

  def initialize(config, args, module_path)
    super
    @path = "#{File.dirname(__FILE__)}"
  end

  def install

  end

  def update
    shell_provision("sudo composer self-update")
  end

  def set_auth(token)

    # Create the template
    template = File.read(path + "/templates/auth.erb")
    result = ERB.new(template).result(binding)

    # Add template to php-fpm directory
    script = %{
      echo '#{result}' > "$(sudo -u vagrant pwd)/.composer/auth.json";
    }

    shell_provision(script)

  end

  def provision

    # todo: install composer composer command

    # update composer
    update if args['update']

    if args.find?('token', false)
      shell_provision("bash #{@scripts}/check-auth.sh")
      set_auth(args["token"])
    end
  end
end