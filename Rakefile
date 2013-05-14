require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

require File.expand_path("../spec/dummy/config/application", __FILE__)
Dummy::Application.load_tasks
