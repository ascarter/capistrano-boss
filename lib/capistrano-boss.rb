#require 'capistrano/recipes/deploy/scm/subversion'
require 'capistrano_boss/extensions'
require 'capistrano_boss/database'
require 'capistrano_boss/channel'
require 'capistrano_boss/log'

# Include extensions
include CapistranoBoss::Log, CapistranoBoss::Channel, CapistranoBoss::Database

Capistrano::Configuration.instance.load do
  Dir[File.join(File.dirname(__FILE__), "recipes", "*.rb")].each { |plugin| load(plugin) }
end

module CapistranoBoss
  # Standardized timestamp
  # Example:
  #   200912241432
  def self.timestamp
    Time.now.strftime("%Y%m%d%H%M")
  end
end
