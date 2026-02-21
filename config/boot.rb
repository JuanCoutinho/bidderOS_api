ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
# require "bootsnap/setup" # Speed up boot time by caching expensive operations.

require "logger"
require "mutex_m"
require "base64"

# Patch for Ruby 3.4 removing BigDecimal.new
require 'bigdecimal'
class BigDecimal
  def self.new(*args, **kwargs)
    BigDecimal(*args, **kwargs)
  end
end
