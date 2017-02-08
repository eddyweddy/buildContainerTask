
default['nginx']['user'] = 'www-data'
default['nginx']['app']['base'] = '/var/www'
default['nginx']['app']['name'] = 'simpleSinatra'
default['nginx']['app']['subdirectories'] = %w(public tmp)
default['nginx']['app']['files'] = %w(config.ru helloworld.rb)

