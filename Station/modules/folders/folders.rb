class Folders < StationModule

  def provision
    # Register All Of The Configured Shared Folders
    args.find?('folders', []).each do |folder|
      if folder.find?('type', nil) === 'nfs'
        config.vm.synced_folder folder["map"], folder["to"], create: folder["create"] ||= false, disabled: folder["disabled"] ||= false, mount_options: folder["mount_options"] ||= [], type: folder["type"] ||= nil
      else
        config.vm.synced_folder folder["map"], folder["to"], create: folder["create"] ||= false, disabled: folder["disabled"] ||= false, group: folder["group"] ||= 'vagrant', owner: folder["owner"] ||= 'vagrant', mount_options: folder["mount_options"] ||= [], type: folder["type"] ||= nil
      end
    end
  end

end