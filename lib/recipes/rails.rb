namespace :rails do
  after "deploy:setup", "rails:config"
  after "deploy:update_code", "rails:deploy:config"

  desc "About Rails environment"
  task :about do
    run "RAILS_ENV=#{rails_env} #{current_path}/script/about "
  end

  namespace :config do
    desc "Generate Rails configuration"
    task :default, :roles => :app do
      run "mkdir -p #{shared_path}/config"
      rails::config::database unless disabled?(:database)
    end

    desc "Create a database.yml file in shared configuration"
    task :database, :roles => :app do

      # Set required fields
      set(:db_adapter, "mysql") unless exists?(:db_adapter)
      set(:db_username, user) unless exists?(:db_username)
      set(:db_database, "#{user}_#{rails_env}") unless exists?(:db_database)
      unless exists?(:db_password)
        set(:db_password) { Capistrano::CLI.password_prompt("#{rails_env} #{db_adapter} password: ") }
      end

      # Create database config
      db_config = {
        "#{rails_env}" => {
          "adapter" => db_adapter,
          "database" => db_database,
          "username" => db_username,
          "password" => db_password
        }
      }

      # Add any optional overrides
      %w[host port socket encoding sslkey sslcert sslcapath sslcipher pool reconnect].each do |attribute|
        varname = "db_#{attribute}".to_sym
        if exists?(varname)
          db_config["#{rails_env}"][attribute] = fetch(varname)
        end
      end

      # Write config file to shared/config/database.yml
      put(db_config.to_yaml, "#{shared_path}/config/database.yml")
    end
  end

  namespace :deploy do
    desc "Deploy Rails configuration files"
    task :config, :roles => :app do
      run "for file in #{shared_path}/config/*.yml; do cp ${file} #{latest_release}/config/; done"
    end

    desc "Snapshot database. Snapshot location specified by dbpath=<path>"
    task :snapshot_database, :roles => :db do
      db_path = ENV['dbpath'] || "#{shared_path}/backup/db"
      dump(db_path)
    end
  end

  namespace :log do
    desc "Download Rails application log"
    task :fetch, :roles => :app do
      source = "#{shared_path}/log/#{rails_env}.log"
      dest = ENV['destination'] || File.join('log', 'deploy')
      fetch_log source, dest
    end

    desc "Tail Rails application log"
    task :tail, :roles => :app do
      tail_log "#{shared_path}/log/#{rails_env}.log"
    end

    desc "Watch Rails application log"
    task :watch, :roles => :app do
      watch_log "#{shared_path}/log/#{rails_env}.log"
    end
  end

  #
  # Helper methods
  #

  def disabled?(key)
    exists?(:rails_disable) ? rails_disable.include?(key.to_sym) : false
  end

end
