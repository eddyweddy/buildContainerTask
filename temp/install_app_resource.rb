require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class InstallApp < Chef::Resource::LWRPBase
      resource_name :install_app

      attribute :app, String, required: true

      def initialize(name, run_context=nil)
        super(name, run_context)
        @allowed_actions.push(:create)
        @action = :create
      end

    end
  end
end