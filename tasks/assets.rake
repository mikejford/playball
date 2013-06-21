@generated_file_cleanup_dirs[:clean] << ".sass-cache"
@generated_file_cleanup_dirs[:clobber] << "public"

namespace :assets do
  desc "Asset compilation from assets to public"
  multitask :compile => ["js:compile", "css:compile"]
end

namespace :css do
  desc "Compile sass files using Compass configuration"
  task :compile => ["images:copy"] do
    require 'compass'
    require 'sass/plugin'
    Compass.add_project_configuration(File.join(@path, 'config', 'compass.rb'))
    Compass.compiler.run
  end
end

namespace :js do
  coffeescript_asset_path = File.join(@path, 'assets', 'coffeescripts')
  javascript_asset_path = File.join(@path, 'assets', 'javascripts')
  javascript_path = File.join(@path, 'public', 'javascripts')

  desc "Compile coffeescripts from #{coffeescript_asset_path} to #{javascript_path}"
  task :compile => [:copy, :prep_js_dir] do
    require 'coffee-script'
    Dir.foreach(coffeescript_asset_path) do |cf|
      if File.extname(cf) == '.coffee'
        js = CoffeeScript.compile File.read(File.join(coffeescript_asset_path, cf))
        open File.join(javascript_path, cf.gsub('.coffee', '.js')), 'w' do |f|
          f.puts js
        end
      end
    end
  end

  task :copy do
    process_assets ({:create_path => true, :public_path => javascript_path, :asset_path => javascript_asset_path, :asset_match => [/.*\.js/] })
  end

  task :prep_js_dir do
    setup_dir javascript_path
  end
end

namespace :images do
  image_asset_path = File.join(@path, 'assets', 'images')
  image_path = File.join(@path, 'public', 'images')

  task :copy do
    process_assets ({:create_path => true, :public_path => image_path, :asset_path => image_asset_path, :asset_match => [/.*\.png/] })
  end
end

def process_assets (task_options)
  options = { :create_path => false, :asset_match => [/^(^.).*/], :asset_path => nil }
  options.merge!(task_options)

  setup_dir options[:public_path] if options[:create_path]

  unless options[:asset_path].nil?
    Dir.foreach(options[:asset_path]) do |asset|
      options[:asset_match].each do |p|
        copy File.join(options[:asset_path], asset), File.join(options[:public_path], asset) if p.match asset
      end
    end
  end
end

def setup_dir path
  FileUtils.mkdir_p path
end
