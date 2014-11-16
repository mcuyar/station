class StationModule

  attr_accessor :config, :args, :scripts

  def initialize(config, args, module_path)
    @classname = args.is_a?(Hash) ? args.delete('classname') : self.class
    @config = config
    @args = args
    @scripts = module_path + "/scripts"
  end

  def shell_provision(inline, args=nil, privileged=true)
    @config.vm.provision "shell" do |s|
      s.inline = inline
      s.args = args
      s.privileged = privileged
    end
  end
end