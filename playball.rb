require 'sinatra'
require 'sinatra/reloader' if development?
require 'compass'

require './lib/sphero'
require 'pry' if development?

SPHERO = SpheroRobot.new(:connections => {:sphero => {:port => '127.0.0.1:4560'}})
SPHERO.connections[:sphero].connect if !SPHERO.connections[:sphero].connected?

SHAPES = {
  :circle =>
  {
    :sides => 36,
    :rolltime => 0.25,
    :stoptime => 0.1
  },
  
  :square =>
  {
    :sides => 4,
  },
  
  :triangle =>
  {
    :sides => 3,
  },
  
  :pentagon =>
  {
    :sides => 5,
    :rolltime => 1.8
  }
}

configure do
  set :asset_path, Proc.new { (settings.environment == :production) ? 'public' : 'assets' }

  if development?
    disable :static
    Compass.add_project_configuration(File.join(settings.root, 'config', 'compass.rb'))
  end
end

get '/control-box' do
  if params[:shape]
    SPHERO.set_shape(SHAPES[params[:shape].to_sym])
    SPHERO.make_polygon
    
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