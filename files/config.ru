# require File.absolute_path('helloworld.rb')
require File.expand_path('helloworld', File.dirname(__FILE__))
run Sinatra::Application
	
