require 'rubygems'
require 'bundler/setup'
require 'service_manager'

#the php mock SOAP server can be started with the testing language in two ways:
#-fire up a cgi server in the testing language and serve /mock-server/index.php
#-make a system call to php's test server

#went with the second one

ServiceManager.define_service "soap-service" do |s|
  s.start_cmd = "php -S localhost:#{ENV['MOCK_SERVER_PORT']} mock-server/index.php"
  s.loaded_cue = /Press Ctrl-C to quit./
  s.cwd = Dir.pwd
  s.color = 33
  s.pid_file = 'soap-server.pid'
end
