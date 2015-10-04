class SSL < StationModule

  attr_accessor :ssl_config, :path

  def initialize(config, args, module_path, station)
    super
    @ssl_config = {}
    @path = "#{File.dirname(__FILE__)}"
  end

  def set_config
    default = args["defaults"]["config"]
    @ssl_config = default.merge(args.find?('config', {}))
  end

  def generate(domain, config)

    set_config

    config = @ssl_config.merge(config || {})
    config["domain"] = domain

    template = File.read(path + "/templates/subj.erb")
    result = ERB.new(template, nil, '>').result(binding)

    # Generate the SSL Cert
    shell_provision(
      "bash #{scripts}/generate.sh \"$1\" \"$2\"",
      [domain, result]
    )

  end

  def provision

      # Create our SSL directory in case it doesn't exist
      shell_provision('sudo mkdir -p "/etc/ssl"')

  end

end