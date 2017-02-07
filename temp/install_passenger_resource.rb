require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class InstallApp < Chef::Resource::LWRPBase
      resource_name :install_passenger

      attribute :ruby_version, Integer, required: true
      attribute :rvm, String
      attribute :passenger_root, String
      attribute :passenger, String
      attribute :nginx, String

      def initialize(name, run_context=nil)
        super(name, run_context)
        @allowed_actions.push(:create)
        @action = :create
      end

    end
  end
end