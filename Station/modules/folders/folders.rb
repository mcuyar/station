class Folders < StationModule

  def provision
    # Register All Of The Configured Shared Folders
    args.find?('folders', []).each do |folder|
      config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil
    end
  end

end