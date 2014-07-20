VAGRANTFILE_API_VERSION = "2"

$path = "#{File.dirname(__FILE__)}"
require $path + '/bootstrap.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Homestead.configure(config, $station_config)
  #Station.configure(config, $station_config)
end