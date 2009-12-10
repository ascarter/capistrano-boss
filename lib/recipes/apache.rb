Capistrano::Configuration.instance.load do
  namespace :apache do
    set :apachectl, 'apachectl'

    desc "Restart Apache web service"
    task :restart, :roles => :app do
      sudo "#{apachectl} restart", :pty => true
    end

    desc "Start Apache web service"
    task :start, :roles => :app do
      sudo "#{apachectl} start", :pty => true
    end
  
    desc "Stop Apache web service"
    task :stop, :roles => :app do
      sudo "#{apachectl} stop", :pty => true
    end

    desc "Check status of Apache web service"
    task :status, :roles => :app do
      run "#{apachectl} status"
    end
  end
end