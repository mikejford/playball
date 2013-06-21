require 'rubygems'
require 'bundler'

Bundler.setup(:default, :assets)

@path = File.dirname(__FILE__)

# Add relative paths to cleanup here or in rake subtask files
@generated_file_cleanup_dirs = {
  # :clean lists relative paths that are not used in production operation
  :clean => [],

  # :clobber lists relative paths that are use in production operation
  :clobber => []
}

Dir.glob('tasks/*.rake').each { |r| import r }

desc "Removes unused generated files"
task :clean do
  cleanup_dir :clean
end

desc "Removes all generated files"
task :clobber => [:clean] do
  cleanup_dir :clobber
end

def cleanup_dir target
  @generated_file_cleanup_dirs[target].each do |path|
    FileUtils.remove_dir path, true
  end
end

