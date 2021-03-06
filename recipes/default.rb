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

apt_package %w(nginx libnginx-mod-http-passenger net-tools ufw) do
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

bash 'Ensure passenger config files are linked' do
  code <<-EOF
  if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then
    sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ;
  fi
  EOF
  user 'root'
  action :run
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

execute 'Start UFW' do
  command "service ufw start"
  user 'root'
end
