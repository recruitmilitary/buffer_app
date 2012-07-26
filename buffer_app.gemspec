# -*- encoding: utf-8 -*-
require File.expand_path('../lib/buffer_app/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Guterl"]
  gem.email         = ["michael@diminishing.org"]
  gem.description   = %q{API wrapper for BufferApp}
  gem.summary       = %q{API wrapper for BufferApp http://bufferapp.com}
  gem.homepage      = "http://github.com/recruitmilitary/buffer_app"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "buffer_app"
  gem.require_paths = ["lib"]
  gem.version       = BufferApp::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'json'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'fakeweb'

  gem.add_dependency 'httparty'
end
