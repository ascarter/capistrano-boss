#require 'capistrano/recipes/deploy/scm/subversion'
require 'capistrano_boss/extensions/subversion'
require 'capistrano_boss/channel'
require 'capistrano_boss/log'

# Include extensions
include CapistranoBoss::Log, CapistranoBoss::Channel

Capistrano::Configuration.instance.load do
  Dir[File.join(File.dirname(__FILE__), "recipes", "*.rb")].each { |plugin| load(plugin) }
end
