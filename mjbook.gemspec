$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mjbook/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mjbook"
  s.version     = Mjbook::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Mjbook."
  s.description = "TODO: Description of Mjbook."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.0"

  s.add_dependency  'pundit'
  s.add_dependency  'carrierwave'
  #s.add_dependency  'gruff'  
  s.add_development_dependency  'sass-rails', '~> 4.0.3'
  s.add_development_dependency  'coffee-rails', '~> 4.0.0'
  s.add_development_dependency  'tzinfo-data'
  s.add_development_dependency  'jquery-rails'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'rails_best_practices'
  s.add_development_dependency 'bullet'
  s.add_development_dependency 'sprig', '~> 0.1'   
end
