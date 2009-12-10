require File.join(File.dirname(__FILE__), 'capistrano/recipes/deploy/scm/subversion')

Capistrano::Configuration.instance.load do
  Dir[File.join(File.dirname(__FILE__), "recipes", "*.rb")].each { |plugin| load(plugin) }
end

