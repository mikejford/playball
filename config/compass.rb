require 'compass'
require 'bootstrap-sass'

if defined?(Sinatra)
  project_path = Sinatra::Application.root
  environment = :development
else
  project_path = File.join File.dirname(__FILE__), '..'
  css_dir = File.join 'public', 'stylesheets'
  environment = :production
end

asset_path = (environment == :production) ? 'public' : 'assets'

http_path = "/"
sass_dir = File.join 'assets', 'sass'
images_dir = File.join asset_path, 'images'
javascripts_dir = File.join asset_path, 'javascripts'

output_style = (environment == :production) ? :compressed : :expanded
line_comments = false
