namespace :apache do
  set(:apachectl, 'apachectl')

  desc "Start Apache web service"
  task :start, :roles => :app do
    apachectl_cmd("start")
  end

  desc "Stop Apache web service"
  task :stop, :roles => :app do
    apachectl_cmd("stop")
  end
  
  desc "Restart Apache web service"
  task :restart, :roles => :app do
    apachectl_cmd("restart")
  end
  
  desc "Graceful Apache web service"
  task :graceful, :roles => :app do
    apachectl_cmd("graceful")
  end
  
  desc "Graceful-stop Apache web service"
  task :graceful_stop, :roles => :app do
    apachectl_cmd("graceful-stop")
  end
  
  # Helpers
  
  def apachectl_cmd(action)
    sudo "#{apachectl} -k #{action}", :pty => true
  end
end

