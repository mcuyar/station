class OhMyZsh < StationModule

  def install_zsh
    shell_provision("sudo apt-get -y install zsh")
  end

  def install_oh_my_zsh
    shell_provision("bash #{scripts}/install-oh-my-zsh.sh")
  end

  def provision

    # Install Oh My Zsh
    if args.find?('install.oh-my-zsh', false)
      args['install']['zsh'] = false
      install_zsh
      install_oh_my_zsh
    end

    # Install zsh
    if args.find?('install.zsh', false)
      install_zsh
    end

  end

end