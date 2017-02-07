require 'serverspec'
require 'net/ssh'

set :backend, :exec

#
# RSpec.configure do |c|
#   c.before :all do
#     c.path = '/sbin:/usr/sbin'
#   end
# end