class SSH < StationModule

  def authorize
    if args.find?('authorize', false)
      shell_provision(
          "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys",
          [File.read(File.expand_path(args["authorize"]))]
      )
    end
  end

  def keys
    args.find?('keys', []).each do |key|
      shell_provision(
        "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2",
        [File.read(File.expand_path(key)), key.split('/').last],
        false
      )
    end
  end

  def provision
    # Configure The Public Key For SSH Access
    authorize
    # Copy The SSH Private Keys To The Box
    keys
  end

end