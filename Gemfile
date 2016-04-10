# A sample Gemfile
source "https://rubygems.org"

# this wasn't working before when somehow had cucmber 2.3.3 installed on my
# computer when the latest repo version was 2.3.2.  My computer would write it
# into Gemfile.lock, and then the docker image couldn't find it.  Fixing it at
# 2.3.2 in this file worked in the docker container, but not locally.  Finally
# I just uninstalled my local cucumber version and started all over.

# There are no version numbers in this file.  We are relying on Gemfile.lock

gem 'cucumber'
gem 'rspec-expectations'
gem 'service_manager'
