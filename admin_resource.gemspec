$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "admin_resource/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "admin_resource"
  s.version     = AdminResource::VERSION
  s.authors     = ["tzmfreedom"]
  s.email       = ["makoto_tajitsu@hotmail.co.jp"]
  s.homepage    = "https://github.com/tzmfreedom/admin_resource"
  s.summary     = "Summary of AdminResource."
  s.description = "Description of AdminResource."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "ransack"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
