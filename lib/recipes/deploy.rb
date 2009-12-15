namespace :deploy do
  desc  "Upload authorized_keys file. Specify file by setting keys=<path>"
  task :authorized_keys do
    keyfile = ENV['keys'] || "authorized_keys"
    unless File.exist?(keyfile)
      abort "Missing authorized_keys file at #{keyfile}"
    end
    run "mkdir -p -m 700 .ssh"
    run "if [ -e .ssh/authorized_keys ]; then cp .ssh/authorized_keys .ssh/authorized_keys.#{CapistranoBoss::Log.timestamp}; fi;"
    put File.new(keyfile).read, ".ssh/authorized_keys", :mode => 0600
  end
end

