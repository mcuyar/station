class AmazonWebServices < StationModule

  attr_accessor :path

  def initialize(config, args, module_path, station)
    super
    @path = "#{File.dirname(__FILE__)}"
  end

  def generate_template(profiles, template_file)

    # Create the template
    template = File.read(path + "/templates/#{template_file}.erb")
    result = ERB.new(template).result(binding)

    # Add template to vagrant home directory
    shell_provision(
      "bash #{@scripts}/awsconfig.sh \"$1\" $2",
      [result, template_file]
    )

  end

  def provision

    if args["install"]

      shell_provision("bash #{@scripts}/awscli.sh")

      default_profile = args["defaults"]["profile"]
      profiles = args.find?('profiles', []).map { |profile| default_profile.clone.merge(profile) }

      generate_template(profiles, "credentials")
      generate_template(profiles, "config")

    end

  end

end