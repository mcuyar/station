class Commands < StationModule

  def execute(command, path, variables={})

    variables = Station.module('variables').get_exports(variables)

    shell_provision(
        "bash #{scripts}/commands.sh $1 \"$2\" \"$3\"",
        [path, command, variables]
    )
  end

  def provision
    args.find?('commands', []).each do |cmd|
      execute(cmd, "~/")
    end
  end
end