class Xdebug < StationModule

  attr_accessor :path

  def initialize(config, args, module_path)
    super
    @path = "#{File.dirname(__FILE__)}"
  end

  def xdebug_ini(params)
    params = params
    ERB.new(File.read(path + "/templates/xdebug_ini.erb")).result(binding)
  end

  def provision

    ini = xdebug_ini(args.find?('xdebug', []))

    script = %{
      echo "Editing xdebug config"
      sudo echo "#{ini}" > #{args["path"]}
      sudo service php5-fpm restart
    }

    shell_provision(script)

  end

end