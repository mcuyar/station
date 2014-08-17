class RubyGems < StationModule

  def install_ruby_dev
    shell_provision("sudo apt-get -y install ruby-dev")
  end

  def install_bundler
    shell_provision("gem install bundler")
  end

  def install_gem(gem)
    shell_provision("sudo gem install #{gem}")
  end

  def provision

    # Install ruby-dev
    if args.find?('install.ruby-dev')
      install_ruby_dev
    end

    # Install bundler
    if args.find?('install.bundler')
      install_bundler
    end

    # install ruby gems
    args.find?('gems', []).each do |gem|
      install_gem(gem)
    end

  end

end