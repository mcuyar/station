class ElasticBeanstalk < StationModule

  def provision
    if args["install"]
      shell_provision(
        "bash #{@scripts}/elasticbeanstalk.sh $1 $2 $3",
        [args["version"], args["access"]["key"], args["access"]["secret"]]
      )
    end
  end

end