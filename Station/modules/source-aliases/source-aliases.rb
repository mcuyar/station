class SourceAliases < StationModule

  attr_accessor :path

  def initialize(config, args, module_path)
    super
    @path = "#{File.dirname(__FILE__)}"
  end

  def set_aliases(aliases)

    # Create the template
    template = File.read(path + "/templates/shellalias.erb")
    result = ERB.new(template).result(binding)

    # Add template to vagrant home directory
    script = %{
      echo '#{result}' > "$(sudo -u vagrant pwd)/shellalias";
    }

    shell_provision(script)

  end

  def provision

      shell_provision("bash #{@scripts}/check-rcfiles.sh")

      default_aliases = args["defaults"] ||= {}
      args.delete('defaults')

      set_aliases(default_aliases.merge(args))

  end

end