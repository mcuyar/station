class Docker < StationModule

  def install
    shell_provision("bash #{scripts}/install.sh")
  end

  def provision
    if args.find?('install', false)
      install
    end
  end

end