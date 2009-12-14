module CapistranoBoss
  module Channel
    # Execute command using sudo and collect output in hash
    # keyed by channel
    def self.sudo_by_channel(command)
      exec_by_channel(command, :sudo)
    end
    
    # Execute command using run and collect output in hash
    # keyed by channel
    def self.run_by_channel(command)
      exec_by_channel(command, :run)
    end
    
    # Execute command on each channel and collect output in hash
    # keyed by channel
    #
    # Execution contexts:
    # run::
    #   Using run method
    # sudo::
    #   Using sudo method
    #
    # File::
    #   Any valid stream object to capture output
    def self.exec_by_channel(command, context = :run, file = $stdout)
      output = {}

      # Run command on each channel and collect the results
      send(context, command, :pty => true) do |channel, stream, data|
        key = channel[:server].to_s
        output[key] = "" unless output.has_key?(key)
        output[key] << data
        break if stream == :err
      end

      # Output each channel separately
      output.sort.each do |channel, data|
        unless file == $stdout
          file.puts "Method:  #{context.to_s}"
          file.puts "Command: #{command}"
        end
        file.puts
        file.puts "--- #{channel} ---"
        file.puts " #{data}"
        file.puts
      end
    end  
  end
end
