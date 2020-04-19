require 'bundler'
Bundler.require
Opal.append_path './app/'
require './app'
run Sinatra::Application
