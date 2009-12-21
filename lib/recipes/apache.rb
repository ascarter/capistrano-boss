namespace :apache do
  set :apachectl, 'apachectl'
  set :apachectl_options, '-k'
  set :apache_logs, ['/var/log/httpd/error_log', '/var/log/httpd/access_log']

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

  namespace :log do
    desc "Download Apache httpd logs"
    task :fetch, :roles => :app do
      dest = ENV['destination'] || File.join('log', 'deploy')
      fetch_log(apache_log_files, dest)
    end

    desc "Tail Apache httpd logs"
    task :tail, :roles => :app do
      tail_log(apache_logs, :sudo)
    end

    desc "Watch Apache httpd logs"
    task :watch, :roles => :app do
      watch_log(apache_logs, :sudo)
    end
  end

  # Helpers

  def apachectl_cmd(action)
    sudo "#{apachectl} #{apachectl_options} #{action}", :pty => true
  end
end

