class KnownHosts < StationModule

  def add_domain(domain)
    shell_provision("bash #{@scripts}/add-domain.sh #{domain}")
  end

  def provision
    # Add known hosts
    args.find?('domains', []).each do |domain|
      add_domain(domain)
    end
  end

end