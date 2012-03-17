# -*- encoding: utf-8 -*-
require File.expand_path('../lib/modularity-rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kevin Goslar"]
  gem.email         = ["kevin.goslar@gmail.com"]
  gem.description   = %q{Provides the Modularity CoffeeScript library to Rails applications.}
  gem.summary       = %q{Makes the Modularity CoffeeScript library available to the Asset Pipeline in modern Rails projects.}
  gem.homepage      = "http://github.com/kevgo/modularity-rails"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "modularity-rails"
  gem.require_paths = ["lib"]
  gem.version       = Modularity::Rails::VERSION
end
