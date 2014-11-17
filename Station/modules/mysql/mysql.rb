class Mysql < StationModule

  def create_db(name, user, drop = false)

    unless drop === true
      drop = %{
        sudo mysql -uroot -psecret -e "
        DROP DATABASE IF EXISTS #{name};
      "}

      shell_provision(drop)
    end

    script = %{
      sudo mysql -uroot -psecret -e "
        CREATE DATABASE IF NOT EXISTS #{name};
        USE #{name};
        GRANT ALL ON #{name} TO '#{user}'@'localhost';
      "}

    shell_provision(script)

  end

  def create_user(username, password)

    script = %{
      sudo mysql -uroot -psecret -e "
        GRANT USAGE ON *.* TO '#{username}'@'localhost';
        DROP USER '#{username}'@'localhost';
        CREATE USER '#{username}'@'localhost' IDENTIFIED BY '#{password}';
      "}

    shell_provision(script)

  end

  def create(db)
    #create user
    if db.has_key?("user") && db.has_key?("password")
      create_user(db["user"], db["password"])
    end

    if db.has_key?("name")
      create_db(db["name"], db.find?('user', 'homestead'), db.find?(db["drop"], false))
    end
  end

  def provision

    # Install databases
      args.find?('databases', []).each do |db|
        create(db)
      end

  end

end