
class InstallPassenger < chef::Provider::LWRPBase
  use_inline_resources
  provides :InstallPassenger

  def whyrun_supported?
    true
  end

  action :create do

    template "/etc/nginx/sites-available/#{new_resource.app}" do
      mode 0744
    end


  end
end