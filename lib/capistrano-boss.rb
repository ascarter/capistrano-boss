require File.join(File.dirname(__FILE__), 'capistrano/recipes/deploy/scm/subversion')
Dir[File.join(File.dirname(__FILE__), '../recipes/*.rb')].each { |plugin| load(plugin) }

def symlink_path(source, dest)
  run "if [ -e \"#{source}\" ]; then ln -nsf #{source} #{dest}; fi"
end

# Symlink shared/config/#{file} if it is there
# Otherwise, copy config/#{file}.example to config/#{file}
def set_config(file)
  source = "#{shared_path}/config/#{file}"
  dest = "#{current_path}/config/#{file}"
  symlink_path(source, dest)
end

