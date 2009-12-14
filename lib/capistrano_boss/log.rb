module CapistranoBoss
  module Log
    # Download log from shared/logs to destination/<timestamp>
    def self.fetch(destination = ".")
      target = File.join(destination, "#{Time.now.strftime("%Y%m%d%H%M")}")
      FileUtils.mkdir_p(target)
      download "#{shared_path}/log", "#{target}/{$CAPISTRANO:HOST$}", :recursive => true
    end
    
    # Tail log and output by channel
    def self.tail(path, options = nil)
      nlines = ENV['lines'].nil? ? "" : "-n #{ENV['lines']}"
      puts nlines
      run "tail #{nlines} #{path} #{options unless options.nil?}" do |channel, stream, data|
        puts  
        puts "--- #{channel[:host]} ---"
        puts " #{data}"
        break if stream == :err
      end
    end

    # Watch log and stream by channel
    def def.watch(path, options = nil)
      run "tail -f #{path} #{options unless options.nil?}" do |channel, stream, data|
        puts  
        puts "--- #{channel[:host]} ---"
        puts " #{data}"
        break if stream == :err    
      end
    end

    # Pretty print a stats hash.
    # Expects::
    #  { "host" => { "key1" => value, "key2" => value } }
    def self.dump_stats(stats)
      stats.each do |host, values|
        puts "-" * 40
        puts "#{host}"
        puts "-" * 40
        values.sort.each {|k,v| puts "  #{k} => #{v}" }
      end
    end    
  end
end
