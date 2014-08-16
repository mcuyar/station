require 'yaml'
require 'erb'
require $path + '/Homestead/scripts/homestead.rb'
require $path + '/Station/Lib/station.rb'
require $path + '/Station/Lib/Hash.rb'
require $path + '/Station/Lib/station-module.rb'

# Merge config files
default = YAML::load(File.read($path+'/Station/config.yaml'))
if File.exist?($path+'/config.yaml')
    local = YAML::load(File.read($path+'/config.yaml'))
    $station_config = default.deep_merge(local)
else
    $station_config = default
end