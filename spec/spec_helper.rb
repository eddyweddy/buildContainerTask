require 'chefspec'
require 'coveralls'
require 'chefspec/berkshelf'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end

RSpec.configure do |config|
  config.color = true
end

at_exit { ChefSpec::Coverage.report! }
