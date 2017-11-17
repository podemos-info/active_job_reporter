# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require "active_job_reporter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "active_job_reporter"
  s.version = ActiveJobReporter::VERSION
  s.authors = ["Leonardo Diez"]
  s.email = ["leiodd@gmail.com"]
  s.homepage = "https://github.com/podemos-info/active_job_reporter"
  s.summary = "Monitoring and reporting for ActiveJob."
  s.description = "Minimalistic approach to ActiveJob monitoring, database based to avoid additional dependencies."
  s.license = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1"

  s.add_development_dependency "codecov", "~> 0.1"
  s.add_development_dependency "generator_spec", "~> 0.9.3"
  s.add_development_dependency "rspec-rails", "~> 3.6"
  s.add_development_dependency "rubocop", "~> 0.50"
  s.add_development_dependency "sqlite3", "~> 1.3"
end
