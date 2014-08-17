class Postgresql < StationModule

  def contrib(version)
    shell_provision("sudo apt-get -y install postgresql-contrib-#{version}")
  end

  def create_db(name, user)
    shell_provision(
      "bash #{@scripts}/db-create.sh $1 $2",
      [user, name]
    )
  end

  def create_user(username)
    shell_provision(
      "bash #{@scripts}/user-create.sh $1",
      username
    )
  end

  def create_password(username, password)
    shell_provision(
      "bash #{@scripts}/user-password.sh $1 $2",
      [username, password]
    )
  end

  def provision

    # Install postgresql contrib
    if args.find?('contrib.install', false)
      contrib(args.find?('contrib.version', '9.3') )
    end

    # Install databases
      args.find?('databases', []).each do |db|

        #create user
        if db.has_key?("user") && db.has_key?("password")
          create_user(db["user"])
          create_password(db["user"], db["password"])
        end

        if db.has_key?("name")
          create_db(db["name"], db.find?('user', 'homestead'))
        end

      end

  end

end