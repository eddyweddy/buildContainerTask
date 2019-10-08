require 'spec_helper'

describe 'verify Nginx service' do
  it 'is installed' do
    expect(package('nginx')).to be_installed
  end
  it 'nginx service is running' do
    expect(service('nginx')).to be_running
  end

  # it 'creates nginx config for default site' do
  #   expect(chef_run).to create_template('/etc/nginx/sites-available/default').with(
  #       source: 'default.erb',
  #       owner: 'root',
  #       group: 'root',
  #       mode: '0644'
  #   )
  # end


  it 'is listening on port 80' do
    expect(port(80)).to be_listening
  end
end

describe file('/etc/nginx/nginx.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
  its(:content) { should match (%r{^include \/etc\/nginx\/modules-enabled\/\*.conf;}) }
end

describe file('/etc/nginx/conf.d/mod-http-passenger.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
end

describe file('/etc/nginx/sites-available/default') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should contain(%r{root   /var/www/simpleSinatra/public;}).before(%r{passenger_enabled on;})}
  it { should contain 'listen 80' }
end

describe file('/var/www/simpleSinatra') do
  it { should be_directory }
  it { should be_owned_by 'www-data' }
  it { should be_readable.by('owner')}
end

describe file('/var/www/simpleSinatra/public') do
  it { should be_directory }
  it { should be_owned_by 'www-data' }
  it { should be_readable.by('owner')}
end

describe file('/var/www/simpleSinatra/tmp') do
  it { should be_directory }
  it { should be_owned_by 'www-data' }
  it { should be_readable.by('owner')}
end

describe file('/var/www/simpleSinatra/config.ru') do
  it { should be_file }
  it { should be_owned_by 'www-data' }
  it { should be_readable.by('owner')}
end

describe file('/var/www/simpleSinatra/helloworld.rb') do
  it { should be_file }
  it { should be_owned_by 'www-data' }
  it { should be_readable.by('owner')}
end