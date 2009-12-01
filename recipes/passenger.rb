Capistrano::Configuration.instance.load do
  namespace :passenger do
    desc "Restart Rails application"
    task :restart, :roles => :app do
      run "touch #{current_release}/tmp/restart.txt"
    end
  end
end

