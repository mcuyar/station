class Composer < StationModule

  def install

  end

  def update
    shell_provision("sudo composer self-update")
  end

  def provision

    # todo: install composer composer command

    # update composer
    update if args['update']
  end
end