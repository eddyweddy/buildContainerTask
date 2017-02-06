rvm_file = '/usr/local/rvm/bin/rvm'

execute 'Install RVM gpg key' do
  command 'curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -'
  user 'root'
  not_if { File.exist? rvm_file }
end

execute 'Install RVM' do
  command 'curl -sSL https://get.rvm.io | bash -s stable --ruby'
  user 'root'
  not_if { File.exist? rvm_file }
end

execute 'add nginx user to rvm group' do
  command "adduser #{node['passenger-nginx']['nginx']['user']} rvm"
  user 'root'
end

bash 'installing ruby' do
  code "source #{node['passenger-nginx']['rvm']['rvm_shell']} && rvm install #{node['passenger-nginx']['ruby_version']}"
  user 'root'
end

bash 'setting installed ruby to default' do
  code "source #{node['passenger-nginx']['rvm']['rvm_shell']} && rvm --default use #{node['passenger-nginx']['ruby_version']}"
end

bash 'installing passenger gem' do
  code <<-EOF
  source #{node['passenger-nginx']['rvm']['rvm_shell']}
  gem install passenger -v #{node['passenger-nginx']['passenger']['version']}
  EOF
  user 'root'
end


