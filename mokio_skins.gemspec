$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mokio_skins/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mokio_skins"
  s.version     = MokioSkins::VERSION
  s.authors     = ["versoft"]
  s.email       = ["info@mokio.org"]
  s.homepage    = "http://www.mokio.org"
  s.summary     = "Mokio - skins"
  s.description = "Mokio skin module."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  # s.add_dependency "rails", "~> 4.1.5"

  s.add_dependency 'sass-rails'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'carrierwave'
  s.add_dependency 'rubyzip'
end