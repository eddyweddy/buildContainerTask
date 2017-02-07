require 'chefspec'
require 'coveralls'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
end

Coveralls.wear!
at_exit { ChefSpec::Coverage.report! }
