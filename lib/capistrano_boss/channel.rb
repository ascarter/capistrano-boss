module CapistranoBoss
  module Channel
    # Execute command using sudo and collect output in hash
    # keyed by channel
    def sudo_by_channel(command)
      exec_by_channel(command, :sudo)
    end
    
    # Execute command using run and collect output in hash
    # keyed by channel
    def run_by_channel(command)
      exec_by_channel(command, :run)
    end
    
    # Print channel output data to destination file stream
    def print_channel(channel, data, file = $stdout)
      file.puts
      file.puts "--- #{channel[:host]} | #{Time.now.to_s} ---"
      file.puts "#{data}"
      file.puts
    end

    def print_buffered_channel(output, file = $stdout)
      output.sort.each do |channel, data|
        unless file == $stdout
          file.puts "Method:  #{context.to_s}"
          file.puts "Command: #{command}"
        end
        file.puts
        file.puts "--- #{channel} ---"
        file.puts "#{data}"
        file.puts
      end
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
    # Stream::
    #   Stream results back immediately (true)
    #   Buffer results and print on completion (false)
    #
    # File::
    #   Any valid stream object to capture output
    def exec_by_channel(command, context = :run, stream = false, file = $stdout)
      output = {}

      # Run command on each channel and collect the results
      send(context, command, :pty => true) do |channel, stream, data|
        if stream
          print_channel(channel, data, file)
        else
          key = channel[:host].to_s
          output[key] = "" unless output.has_key?(key)
          output[key] << data
        end
        break if stream == :err
      end

      print_buffered_channel(output, file) unless stream
    end
  end
end
