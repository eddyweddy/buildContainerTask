app_user = 'www-data'
app_path = '/var/www/simpleSinatra'


bash 'updating nginx keys' do
  code <<-EOF
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
  sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
  apt-get update
  EOF
  user 'root'
  action :run
  # only_if { ::File.open('/etc/apt/sources.list.d/passenger.list').grep(%r{oss-binaries.phusionpassenger.com/apt/passenger xenial main}).empty? }
end

apt_package %w(nginx net-tools ufw) do
  action :install
end

execute 'enable basic firewalling' do
  command "ufw allow 'Nginx Full'"
  user 'root'
end

template 'sites default config' do
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

%W(#{app_path} #{app_path}/public #{app_path}/tmp).each do |dir|
  directory "#{dir}" do
    owner app_user
    group app_user
    mode '0755'
    action :create
  end
end

cookbook_file "#{app_path}/config.ru" do
  source 'config.ru'
  owner app_user
  group app_user
  mode '0644'
  action :create
end

cookbook_file "#{app_path}/helloworld.rb" do
  source 'helloworld.rb'
  owner app_user
  group app_user
  mode '0644'
  action :create
end

gem_package 'sinatra' do
  action :install
end

execute 'restart nginx' do
  command "service nginx restart"
  user 'root'
end
