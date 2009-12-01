Capistrano::Configuration.instance.load do
  # database.yml configuration params
  set :rails_db_adapter, "mysql"
  set :rails_db_database, user
  set :rails_db_username, user
  
  # Optional supported parameters
  # Initially not set
  # :rails_db_password
  # :rails_db_host
  # :rails_db_port
  # :rails_db_socket
  # :rails_db_encoding
  # :rails_db_sslkey
  # :rails_db_sslcert
  # :rails_db_sslcapath
  # :rails_db_sslcipher
  # :rails_db_pool

  namespace :rails do
    after "deploy:update_code", "rails:deploy_config"
    
    desc "Create a database.yml file in shared configuration"
    task :config_database, :roles => :app do
      require 'yaml'
      
      unless exists?(:rails_db_password)
        set(:rails_db_password) { Capistrano::CLI.password_prompt("#{rails_env} #{rails_db_adapter} password: ") }
      end

      # Required fields
      set(:rails_db_username, user) unless exists?(:rails_db_username)
      set(:rails_db_database, "#{user}_#{rails_env}") unless exists?(:rails_db_database)

      # Create database config
      db_config = {
        "#{rails_env}" => {
          "adapter" => rails_db_adapter,
          "database" => rails_db_database,
          "username" => rails_db_username,
          "password" => rails_db_password
        }
      }

      # Supported optional overrides
      %w[host port socket encoding sslkey sslcert sslcapath sslcipher pool].each do |attribute|
        varname = "rails_db_#{attribute}".to_sym
        if exists?(varname)
          db_config["#{rails_env}"][attribute] = fetch(varname)
        end
      end

      # Write config file to shared/config/database.yml
      run "mkdir -p #{shared_path}/config"
      put(db_config.to_yaml, "#{shared_path}/config/database.yml")
    end
      
    task :deploy_config, :roles => :app do
      source = "#{shared_path}/config/database.yml"
      dest = "#{release_path}/config/database.yml"
      run "if [ -e \"#{source}\" ]; cp #{source} #{dest}; fi"
    end
  end
end

