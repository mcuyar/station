class StationModule

  attr_accessor :config, :args, :scripts

  def initialize(config, args, module_path, station)
    @classname = args.is_a?(Hash) ? args.delete('classname') : self.class
    @config = config
    @args = args
    @scripts = module_path + "/scripts"

    if defined? provision_complete
      station.add_observer(self, 'provision_complete')
    end

  end

  def shell_provision(inline, args=nil, privileged=true)
    @config.vm.provision "shell" do |s|
      s.inline = inline
      s.args = args
      s.privileged = privileged
    end
  end
end