require 'rubygems'
require 'bundler'

Bundler.setup(:default, ENV['RACK_ENV'])

require './playball'
run Sinatra::Application