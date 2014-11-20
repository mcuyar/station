# todo: add option for mapping local .git-config file
class GitConfig < StationModule

  def set(key, value, global = false, path = '~/')

    Station.module('commands').execute(
        "git config #{global ? '--global' : ''} #{key} \"#{value}\"",
        path
    )

  end

  def fill(hash, global = false, path = '~/')
    hash.each do |key, value|
      set(key, value, global, path)
    end
  end

  def provision

    # Delete existing global .gitconfig file
    shell_provision('
        echo "Setting git config"
        home=$(sudo -u vagrant pwd)

        if [ -f $home/.gitconfig ]; then
          rm -f $home/.gitconfig
        fi
    ')

    if args.is_a? String
      shell_provision(
          "echo \"$1\" > .gitconfig",
          [File.read(File.expand_path(args))],
          false
      )
    elsif args.is_a? Hash
      fill(args, true)
    end
  end

end