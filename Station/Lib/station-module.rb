class StationModule

  attr_accessor :config, :args, :scripts

  def initialize(config, args, module_path)
    @config = config
    @args = args
    @scripts = module_path + "/scripts"
  end

end