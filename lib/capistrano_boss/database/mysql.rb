module CapistranoBoss
  module Database
    class MySQL
      def initialize(options = {})
        self.options = options
      end
      
      def options
        @options
      end

      def option(key)
        self.options[key.to_s]
      end

      def options=(options)
        @options = options
      end

      def set(option, value)
        self.options[option.to_s] = value
      end

      def query(sql)
        command_line("mysql") << " -e \"#{sql}\""
      end
      
      def dump
        command_line("mysqldump --no-create-db ")
      end

      private
      
      def command_line(command)
        args = []
        args << "-u #{options['username']}" if options.has_key?('username')
        args << "-p#{options['password']}" if options.has_key?('password')
        args << "-h #{options['host']}" if options.has_key?('host')
        args << "--default-character-set=#{options['encoding']}" if options.has_key?('encoding')
        args << "-P #{options['port']}" if options.has_key?('port')
        args << "-S #{options['socket']}" if options.has_key?('socket')
        args << "--ssl-key=#{options['sslkey']}" if options.has_key?('sslkey')
        args << "--ssl-cert=#{options['sslcert']}" if options.has_key?('sslcert')
        args << "--ssl-capath=#{options['sslpath']}" if options.has_key?('sslpath')
        args << "--ssl-cipher=#{options['sslcipher']}" if options.has_key?('sslcipher')
        args << "--unbuffered" if options.has_key?('unbuffered')
        args << "#{options['database']}" if options.has_key?('database')

        "#{command} #{args.join(' ')}"
      end
    end    
  end
end

