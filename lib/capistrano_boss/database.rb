require 'capistrano_boss/database/mysql.rb'
# require 'capistrano_boss/database/sqlite.rb'
# require 'capistrano_boss/database/postgresql.rb'

require 'yaml'

module CapistranoBoss
  module Database
    # Load adapter module
    def self.load_adapter(config)
      case config['adapter']
      when "mysql"
        adapter = MySQL.new(config)
      else
        abort "Unsupported database adapter: #{config['adapter']}"
      end
      
      return adapter
    end

    # Load database.yml and return configuration for current Rails environment
    # Optional overrides hash to modify any options at run time
    def read_database_yml(overrides = {})
      database_yml = {}
      run "cat #{current_path}/config/database.yml" do |channel, stream, data|
        database_yml = YAML.load(data)
      end

      unless database_yml.has_key?(rails_env)
        abort "Missing configuration for #{rails_env}"
      end
      
      # Override options
      overrides.each { |k,v| database_yml[rails_env][k] = v }

      # Return config for current environment
      database_yml[rails_env]
    end

    # Run query and stream results back
    def query(sql)
      config = read_database_yml
      adapter = CapistranoBoss::Database.load_adapter(config)
      run "#{adapter.query(sql)}"
    end

    # Create a snapshot of database to remote path
    def dump(db_path)
      overrides = {}
      puts "#{db_host_dump}"
      overrides['host'] = db_host_dump if exists?(:db_host_dump)
      config = read_database_yml(overrides)
      adapter = CapistranoBoss::Database.load_adapter(config)
      snapshot_file = "#{adapter.option(:database)}_#{CapistranoBoss.timestamp}.sql.gz"
      run "mkdir -p #{db_path}; #{adapter.dump} | gzip > #{db_path}/#{snapshot_file}"
    end

  end
end

