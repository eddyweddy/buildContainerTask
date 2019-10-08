app_name = "#{node['nginx']['app']['name']}"
app_user = "#{node['nginx']['user']}"
app_path = "#{node['nginx']['app']['base']}/#{node['nginx']['app']['name']}"
app_dirs = [app_path]
node['nginx']['app']['subdirectories'].each do |subdir|
  app_dirs << "#{app_path}/#{subdir}"
end
app_files = []
node['nginx']['app']['files'].each do |file|
  app_files << file
end

apt_package %w(gnupg2) do
  action :install
end

bash 'updating nginx keys' do
  code <<-EOF
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
  apt-get install -y apt-transport-https ca-certificates
  sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
  apt-get update
  EOF
  user 'root'
  action :run
  not_if { ::File.exist?('/etc/apt/sources.list.d/passenger.list') }
end

apt_package %w(nginx net-tools ufw) do
  action :install
end

execute 'enable basic firewalling' do
  command "ufw allow 'Nginx Full'"
  user 'root'
end

template 'app config' do
  path '/etc/nginx/sites-available/default'
  source 'default.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

ruby_block 'enable include passenger config in nginx conf file' do
  block do
    file = Chef::Util::FileEdit.new('/etc/nginx/nginx.conf')
    file.search_file_replace_line('# include /etc/nginx/passenger.conf;', 'include /etc/nginx/passenger.conf;')
    file.write_file
  end
end

ruby_block 'replace ruby in passenger conf file' do
  block do
    file = Chef::Util::FileEdit.new('etc/nginx/passenger.conf')
    file.search_file_replace_line('passenger_ruby /usr/bin/passenger_free_ruby;','passenger_ruby /usr/bin/ruby;')
    file.write_file
  end
end

app_dirs.each do |dir|
  directory "#{dir}" do
    owner app_user
    group app_user
    mode '0755'
    action :create
  end
end

app_files.each do |file|
  cookbook_file "#{app_path}/#{file}" do
    source "#{file}"
    owner app_user
    group app_user
    mode '0644'
    action :create
  end
end

gem_package 'sinatra' do
  action :install
end

execute 'restart nginx' do
  command "service nginx restart"
  user 'root'
end
