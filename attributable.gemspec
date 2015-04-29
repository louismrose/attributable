# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attributable/version'

Gem::Specification.new do |spec|
  spec.name          = "attributable"
  spec.version       = Attributable::VERSION
  spec.authors       = ["Louis Rose"]
  spec.email         = ["louis.rose@york.ac.uk"]
  spec.description   = %q{Provides a Ruby module that can be extended by a class in order to provide class methods for defining attributes. Attributable automatically generates accessor, equality, hash and inspect methods.}
  spec.summary       = %q{A tiny library that makes it easy to create value objects}
  spec.homepage      = "https://github.com/mutiny/attributable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9.0"
  spec.add_development_dependency "rake", "~> 10.4.2"
  spec.add_development_dependency "rspec", "~> 3.2.0"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4.6"
  spec.add_development_dependency "rubocop", "~> 0.30.0"
end
