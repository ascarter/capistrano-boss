# Recipes to manage delayed job daemons
#
# Recommend adding callbacks to have delayed job daemons restart
# when server state changes:
#
#   after "deploy:stop",   "delayed_job:stop"
#   after "deploy:start",  "delayed_job:start"
#   after "deploy:restar", "delayed_job:restart"
#
# Expects to have a custom worker role defined.
# This allows control over which nodes participate as
# delayed job clients.
#
# Override :delayed_job_script if the execution environment
# needs to be altered.
#
namespace :delayed_job do
  set :delayed_job_script, "script/delayed_job"

  desc "Stop the delayed job daemon"
  task :stop, :roles => :worker do
    delayed_job_command("stop")
  end

  desc "Start the delayed job daemon"
  task :start, :roles => :worker do
    # Build args
    args = []
    if exists?(:delayed_job_workers)
      args << "--number_of_workers=#{delayed_job_workers}"
    end

    if exists?(:delayed_job_min_priority)
      args << "--min-priority #{delayed_job_min_priority}"
    end

    if exists?(:delayed_job_max_priority)
      args << "--max-priority #{delayed_job_max_priority}"
    end

    delayed_job_command("start", args)
  end

  desc "Restart the delayed job daemon"
  task :restart, :roles => :worker do
    delayed_job_command("restart")
  end

  desc "Status of the delayed_job daemon"
  task :status, :roles => :worker do
    delayed_job_command("status")
  end

  desc "Clear delayed job queue"
  task :clear, :roles => :worker do
    run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} jobs:clear"
  end

  namespace(:log) do
    desc "Watch logs"
    task :watch, :roles => :worker do
      watch_log("#{shared_path}/log/delayed_job.log")
    end
    
    desc "Tail logs"
    task :tail, :roles => :worker do
      tail_log("#{shared_path}/log/delayed_job.log")
    end
  end

  # Helper methods

  def delayed_job_command(action, args = [])
    run "cd #{current_path}; RAILS_ENV=#{rails_env} #{delayed_job_script} #{action} #{args.join(" ")}"
  end
end
