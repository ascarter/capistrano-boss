Capistrano::Configuration.instance.load do
  namespace :rails do
    after "deploy:setup", "rails:config"
    after "deploy:update_code", "rails:deploy_config"

    task :about do
      run "RAILS_ENV=#{rails_env} #{current_path}/script/about "
    task :config, :roles => :app do
      rails::config_database
    end

    desc "Create a database.yml file in shared configuration"
    task :config_database, :roles => :app do
      require 'yaml'
      
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
      %w[host port socket encoding sslkey sslcert sslcapath sslcipher pool].each do |attribute|
        varname = "db_#{attribute}".to_sym
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
      run "if [ -e \"#{source}\" ]; then cp #{source} #{dest}; fi"
    end
  end
end

