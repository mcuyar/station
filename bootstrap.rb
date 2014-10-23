require 'yaml'
require 'erb'
require @path + '/Station/Lib/station.rb'
require @path + '/Station/Lib/Hash.rb'
require @path + '/Station/Lib/station-module.rb'

# Merge config files
default = YAML::load(File.read(@path+'/Station/config.yaml'))
@station_config = File.exist?(@path+'/config.yaml') ?
  default.deep_merge(YAML::load(File.read(@path+'/config.yaml'))) :
  default