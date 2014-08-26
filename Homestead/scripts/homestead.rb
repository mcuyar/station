class Homestead
  def Homestead.configure(config, settings)

    # Copy The Bash Aliases
    # config.vm.provision "shell" do |s|
    #   s.inline = "cp /vagrant/aliases /home/vagrant/.bash_aliases"
    # end

    # Configure All Of The Server Environment Variables
    if settings.has_key?("variables")
      settings["variables"].each do |var|
        config.vm.provision "shell" do |s|
            s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf && service php5-fpm restart"
            s.args = [var["key"], var["value"]]
        end
      end
    end
  end
end
