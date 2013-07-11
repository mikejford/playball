require 'sinatra'
require 'sinatra/reloader' if development?
require 'compass'

require './lib/sphero'
require 'pry' if development?

SPHERO = SpheroRobot.new(:connections => {:sphero => {:port => '127.0.0.1:4560'}})
SPHERO.connections[:sphero].connect if !SPHERO.connections[:sphero].connected?

configure do
  set :asset_path, Proc.new { (settings.environment == :production) ? 'public' : 'assets' }

  if development?
    disable :static
    Compass.add_project_configuration(File.join(settings.root, 'config', 'compass.rb'))
  end
end

get '/control-box' do
  
  if params[:shape]
    params[:shape]
  else
    m = /rgb\((?<r>\d+),\s*(?<g>\d+),\s*(?<b>\d+)\)/.match(params[:color])
    color = [m[:r].to_i, m[:g].to_i, m[:b].to_i]
    SPHERO.change_color(color)
    color.inspect
  end
end

get '/' do
  @colors = ["red", "green", "blue", "purple"]
  @shapes = ["triangle", "square", "pentagon", "circle"]
	erb :index
end

# These routes should only be reachable in development mode, public will override them in production
get '/javascripts/playball.js' do
  coffee :playball, :views => File.join(settings.root, 'assets', 'coffeescripts')
end

get '/javascripts/*' do
  filename = params[:splat].first
  File.open( File.join(settings.root, settings.asset_path, 'javascripts', filename) )
end

get '/stylesheets/*.css' do
  content_type 'text/css', :charset => 'utf-8'
  filename = params[:splat].first
  scss filename.to_sym, Compass.sass_engine_options.merge(:views => File.join(settings.root, 'assets', 'sass'))
end

get '/images/*' do
  filename = params[:splat].first
  File.open( File.join(settings.root, settings.asset_path, 'images', filename) )
end