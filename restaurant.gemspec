lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "restaurant/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = "restaurant"
  gem.version     = Restaurant::VERSION
  gem.authors     = ["Ryo Nakamura"]
  gem.email       = ["r7kamura@gmail.com"]
  gem.homepage    = "https://github.com/r7kamura/restaurant"
  gem.summary     = "Rails RESTful API server plugin"
  gem.description = "Restaurant serves RESTful API on Rails"

  gem.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  gem.add_dependency "rails", "~> 3.2.13"
  gem.add_dependency "rack-accept-default"
  gem.add_dependency "doorkeeper", "~> 0.6.7"
  gem.add_dependency "jquery-rails"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "rspec-rails", ">= 2.13.0"
  gem.add_development_dependency "rspec-json_matcher"
  gem.add_development_dependency "pry-rails"
  gem.add_development_dependency "factory_girl_rails", "~> 4.0"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "response_code_matchers"
end
