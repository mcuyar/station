class Commands < StationModule

  def execute(command, path)
    shell_provision(
        "bash #{scripts}/commands.sh $1 \"$2\"",
        [path, command]
    )
  end

  def provision
    args.find?('commands', []).each do |cmd|
      execute(cmd, "~/")
    end
  end
end