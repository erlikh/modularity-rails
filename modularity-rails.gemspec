# -*- encoding: utf-8 -*-
require File.expand_path('../lib/modularity-rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "modularity-rails"
  s.version     = ModularityRails::VERSION
  s.authors     = ["Kevin Goslar"]
  s.email       = ["kevin.goslar@gmail.com"]
  s.homepage    = "http://github.com/kevgo/modularity-rails"
  s.summary     = "Summary of ModularityRails."
  s.description = "Description of ModularityRails."

  s.add_dependency "rails", ">= 3.1.0"
  s.add_development_dependency "capybara-webkit"
  s.add_development_dependency "evergreen"
  s.add_development_dependency "rb-fsevent" if RUBY_PLATFORM =~ /darwin/i
  s.add_development_dependency "guard-livereload"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end
