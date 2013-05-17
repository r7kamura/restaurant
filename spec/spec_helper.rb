require "simplecov"
SimpleCov.start

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../dummy/config/environment", __FILE__)
require "rspec/rails"
require "rspec/autorun"

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_base_class_for_anonymous_controllers = true

  config.before do
    Mongoid.default_session.collections.select do |collection|
      collection.name !~ /system/
    end.each(&:drop)
  end

  config.include RSpec::JsonMatcher, :type => :request
end
