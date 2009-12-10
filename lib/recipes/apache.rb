Capistrano::Configuration.instance.load do
  namespace :apache do
    set :apache_cmd, 'apachectl'

    desc "Restart Apache web service"
    task :restart, :roles => :app do
      sudo "#{apache_cmd} restart", :pty => true
    end

    desc "Start Apache web service"
    task :start, :roles => :app do
      sudo "#{apache_cmd} start", :pty => true
    end
  
    desc "Stop Apache web service"
    task :stop, :roles => :app do
      sudo "#{apache_cmd} stop", :pty => true
    end

    desc "Check status of Apache web service"
    task :status, :roles => :app do
      run "#{apache_cmd} status"
    end
  end
end