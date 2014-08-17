class StationModule

  attr_accessor :config, :args, :scripts

  def initialize(config, args, module_path)
    @config = config
    @args = args
    @scripts = module_path + "/scripts"
  end

  def shell_provision(inline, args=nil)
    config.vm.provision "shell" do |s|
      s.inline = inline
      unless args.kind_of?(Array) then s.args = args end
    end
  end
end